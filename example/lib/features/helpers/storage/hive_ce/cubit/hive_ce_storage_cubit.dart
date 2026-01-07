import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_example/features/helpers/storage/hive_ce/cubit/hive_ce_storage_state.dart';

/// HiveCE Storage Cubit
class HiveCeStorageCubit extends BaseViewModelCubit<HiveCeStorageState> {
  HiveCeStorageCubit() : super(const HiveCeStorageState.initial()) {
    _loadStoredValues();
  }

  Future<void> _loadStoredValues() async {
    final allItems = await LocalStorageHelper.getAllItems();
    stateChanger(HiveCeStorageState(
      storedString: LocalStorageHelper.getString('hivece_demo_string'),
      storedInt: LocalStorageHelper.getInt('hivece_demo_int'),
      storedBool: LocalStorageHelper.getBool('hivece_demo_bool'),
      storedDouble: LocalStorageHelper.getDouble('hivece_demo_double'),
      storedStringList: LocalStorageHelper.getStringList('hivece_demo_string_list'),
      allItems: allItems,
    ));
  }

  Future<void> loadAllItems() async {
    await _loadStoredValues();
  }

  Future<void> saveString(String key, String value) async {
    await LocalStorageHelper.setString(key, value);
    await _loadStoredValues();
  }

  Future<void> saveInt(String key, int value) async {
    await LocalStorageHelper.setInt(key, value);
    await _loadStoredValues();
  }

  Future<void> saveBool(String key, bool value) async {
    await LocalStorageHelper.setBool(key, value);
    await _loadStoredValues();
  }

  Future<void> saveDouble(String key, double value) async {
    await LocalStorageHelper.setDouble(key, value);
    await _loadStoredValues();
  }

  Future<void> saveStringList(String key, List<String> value) async {
    await LocalStorageHelper.setStringList(key, value);
    await _loadStoredValues();
  }

  Future<void> clearStorage() async {
    await LocalStorageHelper.remove('hivece_demo_string');
    await LocalStorageHelper.remove('hivece_demo_int');
    await LocalStorageHelper.remove('hivece_demo_bool');
    await LocalStorageHelper.remove('hivece_demo_double');
    await LocalStorageHelper.remove('hivece_demo_string_list');
    await _loadStoredValues();
  }
}

