@echo off

cmd /c flutter "pub" "get"
cmd /c flutter "pub" "upgrade"
cmd /c flutter "pub" "global" "activate" "protoc_plugin"
mkdir "lib\src\data\entities\generated"
cmd /c protoc "--proto_path=protos/" "--dart_out=grpc:lib/src/data/entities/generated" "-Iprotos" "base_models.proto" "gate_models.proto" "gate_service.proto" "auth_models.proto" "user_models.proto" "project_models.proto" "task_models.proto" "time_tracking_models.proto" "google/protobuf/empty.proto" "google/protobuf/timestamp.proto"
cmd /c dart "run" "build_runner" "build" "-d"