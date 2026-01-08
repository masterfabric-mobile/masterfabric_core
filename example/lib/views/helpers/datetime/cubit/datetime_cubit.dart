import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'datetime_state.dart';

/// DateTime Cubit
@injectable
class DateTimeCubit extends BaseViewModelCubit<DateTimeState> {
  DateTimeCubit() : super(const DateTimeState());
}
