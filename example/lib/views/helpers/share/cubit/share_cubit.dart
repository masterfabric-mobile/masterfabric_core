import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'share_state.dart';

/// Share Cubit
@injectable
class ShareCubit extends BaseViewModelCubit<ShareState> {
  ShareCubit() : super(const ShareState());

  Future<void> shareText(String text, {String? subject}) async {
    await ApplicationShareHelper.shareText(text, subject: subject);
  }
}

