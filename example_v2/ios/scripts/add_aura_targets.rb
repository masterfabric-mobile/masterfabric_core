#!/usr/bin/env ruby
# Adds AuraWidget (WidgetKit + Live Activity) and AuraWatch targets.
require 'xcodeproj'
require 'fileutils'

ROOT = File.expand_path('..', __dir__)
PROJECT_PATH = File.join(ROOT, 'Runner.xcodeproj')
project = Xcodeproj::Project.open(PROJECT_PATH)

def ensure_group(project, path_components)
  group = project.main_group
  path_components.each do |name|
    group = group[name] || group.new_group(name, name)
  end
  group
end

def add_files_to_group(group, dir, extensions)
  files = []
  Dir.glob(File.join(dir, '**', '*')).sort.each do |path|
    next unless File.file?(path)
    next unless extensions.include?(File.extname(path))
    rel = path.sub(%r{.*/ios/}, '')
    # Prefer nesting under given group root
    ref = group.new_file(path)
    files << ref
  end
  files
end

runner = project.targets.find { |t| t.name == 'Runner' }
raise 'Runner target missing' unless runner

# --- Shared sources as file refs on Runner ---
shared_group = ensure_group(project, ['Shared'])
shared_files = []
%w[AuraSnapshot.swift AuraLiveActivityAttributes.swift AuraWatchSync.swift].each do |name|
  path = File.join(ROOT, 'Shared', name)
  ref = shared_group.files.find { |f| f.path&.end_with?(name) } || shared_group.new_file(path)
  shared_files << ref
  unless runner.source_build_phase.files_references.include?(ref)
    runner.add_file_references([ref])
  end
end

# AuraBridge on Runner
runner_group = project.main_group['Runner'] || ensure_group(project, ['Runner'])
bridge_path = File.join(ROOT, 'Runner', 'AuraBridge.swift')
bridge_ref = runner_group.files.find { |f| f.path&.end_with?('AuraBridge.swift') } || runner_group.new_file(bridge_path)
unless runner.source_build_phase.files_references.include?(bridge_ref)
  runner.add_file_references([bridge_ref])
end

# Entitlements for Runner
runner.build_configurations.each do |config|
  config.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'Runner/Runner.entitlements'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
end

# --- Widget Extension ---
widget_name = 'AuraWidget'
widget = project.targets.find { |t| t.name == widget_name }
unless widget
  widget = project.new_target(:app_extension, widget_name, :ios, '16.2')
  widget.product_type = 'com.apple.product-type.app-extension'
end

widget_group = ensure_group(project, [widget_name])
widget_sources = []
Dir.glob(File.join(ROOT, widget_name, '*.swift')).sort.each do |path|
  ref = widget_group.files.find { |f| f.path == File.basename(path) } || widget_group.new_file(path)
  widget_sources << ref
end
shared_files.each do |ref|
  widget_sources << ref unless widget_sources.include?(ref)
end

# Clear and re-add sources carefully
existing = widget.source_build_phase.files.map(&:file_ref)
widget_sources.uniq.each do |ref|
  widget.add_file_references([ref]) unless existing.include?(ref)
end

# Info.plist + entitlements resources not needed as compile; set build settings
widget.build_configurations.each do |config|
  config.build_settings['INFOPLIST_FILE'] = 'AuraWidget/Info.plist'
  config.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'AuraWidget/AuraWidget.entitlements'
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.masterfabric.aura.AuraWidget'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.2'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2'
  config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = ['$(inherited)', '@executable_path/Frameworks', '@executable_path/../../Frameworks']
  config.build_settings['SKIP_INSTALL'] = 'YES'
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'NO'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['CURRENT_PROJECT_VERSION'] = '1'
  config.build_settings['MARKETING_VERSION'] = '1.0.0'
end

# Embed widget into Runner
embed = runner.copy_files_build_phases.find { |p| p.name == 'Embed Foundation Extensions' }
unless embed
  embed = project.new(Xcodeproj::Project::Object::PBXCopyFilesBuildPhase)
  embed.name = 'Embed Foundation Extensions'
  embed.symbol_dst_subfolder_spec = :plug_ins
  runner.build_phases << embed
end
unless embed.files.any? { |f| f.file_ref&.path&.include?(widget_name) || f.display_name&.include?(widget_name) }
  embed.add_file_reference(widget.product_reference)
  embed.files.each do |bf|
    if bf.file_ref == widget.product_reference
      bf.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }
    end
  end
end
runner.add_dependency(widget) unless runner.dependencies.any? { |d| d.target == widget }

# --- Watch App ---
watch_name = 'AuraWatch'
watch = project.targets.find { |t| t.name == watch_name }
unless watch
  watch = project.new_target(:application, watch_name, :watchos, '9.0')
  watch.product_type = 'com.apple.product-type.application'
end

watch_group = ensure_group(project, [watch_name])
watch_sources = []
Dir.glob(File.join(ROOT, watch_name, '*.swift')).sort.each do |path|
  ref = watch_group.files.find { |f| f.path == File.basename(path) } || watch_group.new_file(path)
  watch_sources << ref
end
# Watch: snapshot + WCSession receiver (no ActivityKit)
%w[AuraSnapshot.swift AuraWatchSync.swift].each do |name|
  ref = shared_files.find { |f| f.path&.end_with?(name) }
  watch_sources << ref if ref
end

existing_w = watch.source_build_phase.files.map(&:file_ref)
watch_sources.compact.uniq.each do |ref|
  watch.add_file_references([ref]) unless existing_w.include?(ref)
end

watch.build_configurations.each do |config|
  config.build_settings['INFOPLIST_FILE'] = 'AuraWatch/Info.plist'
  config.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'AuraWatch/AuraWatch.entitlements'
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.masterfabric.aura.watchkitapp'
  config.build_settings['SDKROOT'] = 'watchos'
  config.build_settings['WATCHOS_DEPLOYMENT_TARGET'] = '9.0'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '4'
  config.build_settings['SKIP_INSTALL'] = 'YES'
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'NO'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['CURRENT_PROJECT_VERSION'] = '1'
  config.build_settings['MARKETING_VERSION'] = '1.0.0'
  config.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = ''
end

# Embed watch app
watch_embed = runner.copy_files_build_phases.find { |p| p.name == 'Embed Watch Content' }
unless watch_embed
  watch_embed = project.new(Xcodeproj::Project::Object::PBXCopyFilesBuildPhase)
  watch_embed.name = 'Embed Watch Content'
  watch_embed.dst_path = '$(CONTENTS_FOLDER_PATH)/Watch'
  watch_embed.symbol_dst_subfolder_spec = :products_directory
  runner.build_phases << watch_embed
end
unless watch_embed.files.any? { |f| f.file_ref == watch.product_reference }
  watch_embed.add_file_reference(watch.product_reference)
  watch_embed.files.each do |bf|
    if bf.file_ref == watch.product_reference
      bf.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }
    end
  end
end
runner.add_dependency(watch) unless runner.dependencies.any? { |d| d.target == watch }

project.save
puts "Updated #{PROJECT_PATH}"
puts "Targets: #{project.targets.map(&:name).join(', ')}"
