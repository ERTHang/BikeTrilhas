// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MapController on _MapControllerBase, Store {
  final _$dataReadyAtom = Atom(name: '_MapControllerBase.dataReady');

  @override
  ObservableFuture<bool> get dataReady {
    _$dataReadyAtom.reportRead();
    return super.dataReady;
  }

  @override
  set dataReady(ObservableFuture<bool> value) {
    _$dataReadyAtom.reportWrite(value, super.dataReady, () {
      super.dataReady = value;
    });
  }

  final _$trilhasAtom = Atom(name: '_MapControllerBase.trilhas');

  @override
  ObservableFuture<List<TrilhaModel>> get trilhas {
    _$trilhasAtom.reportRead();
    return super.trilhas;
  }

  @override
  set trilhas(ObservableFuture<List<TrilhaModel>> value) {
    _$trilhasAtom.reportWrite(value, super.trilhas, () {
      super.trilhas = value;
    });
  }

  final _$positionAtom = Atom(name: '_MapControllerBase.position');

  @override
  ObservableFuture<CameraPosition> get position {
    _$positionAtom.reportRead();
    return super.position;
  }

  @override
  set position(ObservableFuture<CameraPosition> value) {
    _$positionAtom.reportWrite(value, super.position, () {
      super.position = value;
    });
  }

  final _$initAsyncAction = AsyncAction('_MapControllerBase.init');

  @override
  Future init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$getUserPosAsyncAction = AsyncAction('_MapControllerBase.getUserPos');

  @override
  Future<CameraPosition> getUserPos() {
    return _$getUserPosAsyncAction.run(() => super.getUserPos());
  }

  final _$_MapControllerBaseActionController =
      ActionController(name: '_MapControllerBase');

  @override
  dynamic getPolylines() {
    final _$actionInfo = _$_MapControllerBaseActionController.startAction(
        name: '_MapControllerBase.getPolylines');
    try {
      return super.getPolylines();
    } finally {
      _$_MapControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dataReady: ${dataReady},
trilhas: ${trilhas},
position: ${position}
    ''';
  }
}
