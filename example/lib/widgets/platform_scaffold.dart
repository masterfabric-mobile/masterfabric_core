import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Platform-aware Scaffold that enables iOS native drag back gesture.
///
/// Content is edge-to-edge: bottom safe area is left open so backgrounds
/// reach the home indicator. Pad scrollable bodies with
/// `MediaQuery.paddingOf(context).bottom` instead.
class PlatformScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  const PlatformScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        backgroundColor: bg,
        navigationBar: appBar != null
            ? _convertAppBarToCupertinoNavBar(context, appBar!)
            : null,
        child: Material(
          color: bg,
          child: Column(
            children: [
              Expanded(
                child: SafeArea(
                  top: appBar == null,
                  bottom: false,
                  child: body ?? const SizedBox.shrink(),
                ),
              ),
              if (bottomNavigationBar != null) bottomNavigationBar!,
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: bg,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }

  /// Convert Material AppBar to CupertinoNavigationBar for iOS
  ObstructingPreferredSizeWidget _convertAppBarToCupertinoNavBar(
    BuildContext context,
    PreferredSizeWidget appBar,
  ) {
    if (appBar is AppBar) {
      Widget? leadingWidget;
      if (appBar.leading != null) {
        final originalLeading = appBar.leading!;
        if (originalLeading is IconButton &&
            originalLeading.onPressed != null) {
          leadingWidget = CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (GoRouter.of(context).canPop()) {
                GoRouter.of(context).pop();
              }
            },
            child: originalLeading.icon,
          );
        } else {
          leadingWidget = originalLeading;
        }
      } else if (GoRouter.of(context).canPop()) {
        leadingWidget = CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            }
          },
          child: const Icon(
            CupertinoIcons.back,
            color: CupertinoColors.activeBlue,
          ),
        );
      }

      Widget? trailingWidget;
      if (appBar.actions != null && appBar.actions!.isNotEmpty) {
        if (appBar.actions!.length == 1) {
          trailingWidget = appBar.actions!.first;
        } else {
          trailingWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: appBar.actions!,
          );
        }
      }

      return CupertinoNavigationBar(
        backgroundColor:
            appBar.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        middle: appBar.title,
        leading: leadingWidget,
        trailing: trailingWidget,
      );
    }
    return CupertinoNavigationBar(
      middle: Text(
        appBar.toString(),
        style: const TextStyle(fontSize: 17),
      ),
    );
  }
}
