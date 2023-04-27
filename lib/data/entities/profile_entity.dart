import 'package:built_collection/built_collection.dart';

import '../../domain/models/models.dart';
import 'generated/gate_models.pb.dart';

class ProfileEntity {
  final String? name;
  final double? price;
  final List<int> workDays;

  ProfileEntity({this.name, this.price, required this.workDays});

  factory ProfileEntity.fromGrpc(ProfileReply profile) => ProfileEntity(
      name: profile.hasName() ? profile.name : null,
      price: profile.hasPrice() ? profile.price : null,
      workDays: profile.workDays);

  ProfileModel toModel() => ProfileModel(
        (p0) => p0
          ..name = name
          ..price = price
          ..workDays = ListBuilder(workDays),
      );
}
