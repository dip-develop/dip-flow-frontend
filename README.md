# TheTeam Frontend

A TheTeam Frontend Flutter project.

## Getting Started

```bash
flutter pub global activate protoc_plugin
flutter pub get
```

#### Generate files
```bash
protoc --dart_out=grpc:lib/data/entities/generated -Iprotos \
    protos/base_models.proto \
    protos/gate_models.proto \
    protos/gate_service.proto \
    protos/auth_models.proto \
    protos/time_tracking_models.proto \
    protos/google/api/annotations.proto \
    protos/google/api/http.proto \
    protos/google/protobuf/struct.proto \
    protos/google/protobuf/descriptor.proto \
    protos/google/protobuf/empty.proto \
    protos/google/protobuf/timestamp.proto
flutter pub run build_runner build -d
flutter gen-l10n
```

## Build MSIX package for Windows Store
```bash
flutter pub run msix:publish
```

## Build Snap package for Snap Store
```bash
snapcraft --use-lxd
snapcraft upload --release=stable theteam_...._amd64.snap
```

```bash
snap connect theteam:password-manager-service :password-manager-service
```