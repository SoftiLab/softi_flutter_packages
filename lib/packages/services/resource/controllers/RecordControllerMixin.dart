import 'package:get/get.dart';
import 'package:softi_packages/packages/core/controllers/BaseViewController.dart';
import 'package:softi_packages/packages/services/resource/interfaces/i_resource.dart';
import 'package:softi_packages/packages/services/resource/models/ResourceRecord.dart';

mixin RecordControllerMixin<T extends IBaseResourceData> on IBaseViewController {
  // @override
  // Future<void> loadView() async => initRecord();

  //! Parameters
  String get id;
  bool get reactive;
  ResourceRecord<T> get resourceRecord;

  //! Getters
  Rx<T?> get record => resourceRecord.data;

  void initRecord() {
    serviceTaskHandler(() async {
      resourceRecord.init(id, reactive: reactive);
    });
  }

  void disposeRecord() {
    resourceRecord.reset();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    initRecord();
  }

  @override
  Future<void> onClose() async => disposeRecord();
}
