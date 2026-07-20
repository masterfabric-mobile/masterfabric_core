import 'package:masterfabric_core/src/base/base_view_model_cubit.dart';
import 'package:masterfabric_core/src/views/image_detail/cubit/image_detail_state.dart';
import 'package:injectable/injectable.dart';

/// Image Detail Cubit — content set from the view via [setImage].
@injectable
class ImageDetailCubit extends BaseViewModelCubit<ImageDetailState> {
  ImageDetailCubit() : super(const ImageDetailState(imageUrl: ''));

  void setImage({required String imageUrl, String? title}) {
    stateChanger(ImageDetailState(imageUrl: imageUrl, title: title));
  }
}
