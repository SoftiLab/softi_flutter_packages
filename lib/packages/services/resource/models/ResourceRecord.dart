import 'dart:async';

import 'package:get/get.dart';
import 'package:softi_packages/packages/services/resource/interfaces/i_resource.dart';
import 'package:softi_packages/packages/services/resource/interfaces/i_resource_adapter.dart';

class ResourceRecord<T extends IResourceData> {
  final IResourceAdapter<T> adapter;
  ResourceRecord(this.adapter); // : data = adapter.resource.deserializer({}).obs;

  final Rxn<T?> data = Rxn<T?>();
  final RxInt fetchCount = 0.obs;
  late StreamSubscription<T?> _sub;
  late String _id;

  String get id => _id;

  void init(
    String recordId, {
    bool reactive = false,
    T? autoCreate,
  }) {
    _id = recordId;

    _sub = adapter.get(recordId, reactive: reactive).listen((event) async {
      T? _newValue = event;
      if (event == null && autoCreate != null) {
        _newValue = await adapter.save(autoCreate);
      }

      data(_newValue);
      fetchCount.value++;
    });
  }

  Future<T?> save() async {
    if (data() == null) return null;
    return adapter.save(data()!);
  }

  Future<void> update(Map<String, dynamic> values) async {
    return adapter.update(_id, values);
  }

  void dispose() {
    _sub.cancel();
    fetchCount(0);
  }

  T? call([T? newData]) {
    if (newData != null) data(newData);
    return data.value;
  }
}
