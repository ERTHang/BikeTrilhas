// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PhotoController on _PhotoControllerBase, Store {
  final _$initializeControllerFutureAtom =
      Atom(name: '_PhotoControllerBase.initializeControllerFuture');

  @override
  ObservableFuture<void> get initializeControllerFuture {
    _$initializeControllerFutureAtom.reportRead();
    return super.initializeControllerFuture;
  }

  @override
  set initializeControllerFuture(ObservableFuture<void> value) {
    _$initializeControllerFutureAtom
        .reportWrite(value, super.initializeControllerFuture, () {
      super.initializeControllerFuture = value;
    });
  }

  final _$initAsyncAction = AsyncAction('_PhotoControllerBase.init');

  @override
  Future init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$takeShotAsyncAction = AsyncAction('_PhotoControllerBase.takeShot');

  @override
  Future takeShot() {
    return _$takeShotAsyncAction.run(() => super.takeShot());
  }

  final _$_PhotoControllerBaseActionController =
      ActionController(name: '_PhotoControllerBase');

  @override
  void dispose() {
    final _$actionInfo = _$_PhotoControllerBaseActionController.startAction(
        name: '_PhotoControllerBase.dispose');
    try {
      return super.dispose();
    } finally {
      _$_PhotoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
initializeControllerFuture: ${initializeControllerFuture}
    ''';
  }
}
