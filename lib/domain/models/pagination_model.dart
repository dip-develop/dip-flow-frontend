import 'models.dart';

class PaginationModel<T extends BaseModel> {
  final int count;
  final int offset;
  final int limit;
  final List<T> items;

  PaginationModel(
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

  void update(T item) {
    final items = List<T>.from(this.items);
    final index = items.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      items[index] = item;
      this.items.clear();
      this.items.addAll(items);
    }
  }
}
