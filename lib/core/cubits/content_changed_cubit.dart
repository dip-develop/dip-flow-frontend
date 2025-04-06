import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/models.dart';

part 'content_changed_state.dart';

@singleton
class ContentChangedCubit extends Cubit<ContentChangedState> {
  ContentChangedCubit() : super(ContentChangedInitial());

  void timeTrackingsChanged() => emit(TimeTracksChanged());
  void timeTrackChanged(TimeTrackingModel timeTrack) =>
      emit(TimeTrackChanged(timeTrack));
}
