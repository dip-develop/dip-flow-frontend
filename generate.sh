#! /bin/bash

flutter pub get
flutter pub upgrade
flutter pub global activate protoc_plugin

mkdir -p lib/data/entities/generated
protoc --proto_path=../../protos/ --dart_out=grpc:lib/data/entities/generated -Iprotos \
    base_models.proto \
    gate_models.proto \
    gate_service.proto \
    auth_models.proto \
    user_models.proto \
    project_models.proto \
    task_models.proto \
    time_tracking_models.proto \  
    google/protobuf/empty.proto \
    google/protobuf/timestamp.proto
dart run build_runner build -d
