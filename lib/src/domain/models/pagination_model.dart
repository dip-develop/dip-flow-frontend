import 'models.dart';

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

part 'pagination_model.g.dart';

abstract class PaginationModel<T extends BaseModel>
    implements Built<PaginationModel<T>, PaginationModelBuilder<T>> {
  int get count;
  int get offset;
  int get limit;
  BuiltList<T> get items;

  PaginationModel._();

  factory PaginationModel([void Function(PaginationModelBuilder<T>) updates]) =
      _$PaginationModel<T>;

  factory PaginationModel.empty({int offset = 0, int limit = 0}) =>
      PaginationModel<T>((b) => b
        ..count = 0
        ..offset = offset
        ..limit = limit
        ..items = ListBuilder<T>());

  PaginationModel<T> from(PaginationModel<T> pagination) =>
      PaginationModel<T>((p0) => p0
        ..count = pagination.count
        ..offset = pagination.offset
        ..limit = pagination.limit
        ..items = offset != pagination.offset
            ? (p0.items..addAll(pagination.items))
            : pagination.items.toBuilder());

  PaginationModel<T> update(T item) {
    final index = items.indexWhere((element) => element.id == item.id);
    final updatedItems = List<T>.from(items);

    if (index >= 0) {
      updatedItems[index] = item;
    } else {
      updatedItems.add(item);
    }

    return rebuild((b) => b..items = BuiltList<T>(updatedItems).toBuilder());
  }

  PaginationModel<T> delete(T item) {
    final updatedItems = List<T>.from(items)
      ..removeWhere((element) => element.id == item.id);

    return rebuild((b) => b..items = BuiltList<T>(updatedItems).toBuilder());
  }
}

/* class PaginationModel<T extends BaseModel> extends Equatable {
  final int count;
  final int offset;
  final int limit;
  final List<T> items;

  const PaginationModel(
      {required this.count,
      required this.offset,
      required this.limit,
      required this.items});

  factory PaginationModel.empty({int offset = 0, int limit = 0}) =>
      PaginationModel(
          count: 0,
          offset: offset,
          limit: limit,
          items: List<T>.empty(growable: true));

  PaginationModel<T> from(PaginationModel<T> pagination) => PaginationModel<T>(
      count: pagination.count,
      offset: pagination.offset,
      limit: pagination.limit,
      items: offset != pagination.offset
          ? (items..addAll(pagination.items))
          : pagination.items);

  PaginationModel<T> update(T item) {
    final items = List<T>.from(this.items);
    final index = items.indexWhere((element) => element.id == item.id);
    if (index >= 0 && item != items[index]) {
      items[index] = item;
    } else {
      items.add(item);
    }
    return PaginationModel<T>(
        count: count, offset: offset, limit: limit, items: items);
  }

  PaginationModel<T> delete(T item) {
    final items = List<T>.from(this.items);
    final index = items.indexWhere((element) => element.id == item.id);
    if (index >= 0 && item != items[index]) {
      items.removeAt(index);
      this.items.clear();
      this.items.addAll(items);
    }
    return PaginationModel<T>(
        count: count, offset: offset, limit: limit, items: items);
  }

  @override
  List<Object?> get props => [count, offset, limit, items];
} */
