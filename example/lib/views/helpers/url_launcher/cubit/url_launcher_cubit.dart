import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'url_launcher_state.dart';

/// URL Launcher Cubit
@injectable
class UrlLauncherCubit extends BaseViewModelCubit<UrlLauncherState> {
  UrlLauncherCubit() : super(const UrlLauncherState());

  Future<bool> launchUrl(String url) async {
    return await UrlLauncherHelper.launchUrl(url);
  }

  Future<bool> launchPhone(String phoneNumber) async {
    return await UrlLauncherHelper.launchPhone(phoneNumber);
  }

  Future<bool> launchEmail(String email, {String? subject, String? body}) async {
    return await UrlLauncherHelper.launchEmail(email, subject: subject, body: body);
  }

  Future<bool> launchSms(String phoneNumber, {String? body}) async {
    return await UrlLauncherHelper.launchSms(phoneNumber, body: body);
  }
}

