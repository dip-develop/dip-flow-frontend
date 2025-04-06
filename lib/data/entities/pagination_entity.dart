import '../../domain/models/models.dart';
import 'entities.dart';
import 'generated/time_tracking_models.pb.dart';

class PaginationEntity {
  final int count;
  final int offset;
  final int limit;
  final List<TimeTrackingEntity> items;

  PaginationEntity(
      {required this.count,
      required this.offset,
      required this.limit,
      required this.items});

  factory PaginationEntity.fromGrpc(TimeTrackingsReply timeTraks) =>
      PaginationEntity(
          count: timeTraks.count,
          limit: timeTraks.limit,
          offset: timeTraks.offset,
          items: timeTraks.timeTracks
              .map((e) => TimeTrackingEntity.fromGrpc(e))
              .toList());

  PaginationModel<TimeTrackingModel> toModel() => PaginationModel(
      count: count,
      limit: limit,
      offset: offset,
      items: items.map((e) => e.toModel()).toList());
}
