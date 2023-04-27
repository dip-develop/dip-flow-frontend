import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'profile_model.g.dart';

abstract class ProfileModel
    implements Built<ProfileModel, ProfileModelBuilder> {
  String? get name;
  double? get price;
  BuiltList<int> get workDays;

  ProfileModel._();
  factory ProfileModel([void Function(ProfileModelBuilder) updates]) =
      _$ProfileModel;
}
