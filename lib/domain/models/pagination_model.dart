class PaginationModel<T> {
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
      items: items..addAll(pagination.items));
}
