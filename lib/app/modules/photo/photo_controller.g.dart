// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PhotoController on _PhotoControllerBase, Store {
  final _$initializeControllerFutureAtom =
      Atom(name: '_PhotoControllerBase.initializeControllerFuture');

  @override
  ObservableFuture<void> get initializeControllerFuture {
    _$initializeControllerFutureAtom.context
        .enforceReadPolicy(_$initializeControllerFutureAtom);
    _$initializeControllerFutureAtom.reportObserved();
    return super.initializeControllerFuture;
  }

  @override
  set initializeControllerFuture(ObservableFuture<void> value) {
    _$initializeControllerFutureAtom.context.conditionallyRunInAction(() {
      super.initializeControllerFuture = value;
      _$initializeControllerFutureAtom.reportChanged();
    }, _$initializeControllerFutureAtom,
        name: '${_$initializeControllerFutureAtom.name}_set');
  }

  final _$initAsyncAction = AsyncAction('init');

  @override
  Future init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$takeShotAsyncAction = AsyncAction('takeShot');

  @override
  Future takeShot() {
    return _$takeShotAsyncAction.run(() => super.takeShot());
  }

  final _$_PhotoControllerBaseActionController =
      ActionController(name: '_PhotoControllerBase');

  @override
  void dispose() {
    final _$actionInfo = _$_PhotoControllerBaseActionController.startAction();
    try {
      return super.dispose();
    } finally {
      _$_PhotoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'initializeControllerFuture: ${initializeControllerFuture.toString()}';
    return '{$string}';
  }
}
