import 'dart:async';

import 'package:inner_bloom_app/core/models/therapist.dart';
import 'package:inner_bloom_app/core/services/therapist_service.dart';

class TherapistRepository {
  final TherapistService _service;
  final StreamController<List<Therapist>> _controller =
      StreamController<List<Therapist>>.broadcast();

  Stream<List<Therapist>> get stream => _controller.stream;

  TherapistRepository(this._service);

  Future<void> init() async {
    final List<Therapist> initialData = await _service.getTherapists();
    _controller.add(initialData);

    print('initial data: ${initialData[0].name}');

    _service.watchTherapists().listen((data) {
      _controller.add(data);
    });
  }

  void dispose() {
    _controller.close();
  }
}
