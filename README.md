# TheTeam Frontend

**TheTeam** is the ultimate solution for team management. Whether you are a freelancer, a developer, an HR manager, or a headhunter, you can benefit from our powerful and user-friendly application that lets you track time, create reports, manage projects, and more. You can access our service from any device and any operating system, and enjoy our beautiful graphs that visualize your progress and performance. Plus, if you are an individual user or a small team, you can use our service for free forever. No hidden fees, no strings attached. Join **TheTeam** today and take your team to the next level.

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
snapcraft
snapcraft upload --release=latest/beta theteam_...._amd64.snap
snapcraft upload --release=stable theteam_...._amd64.snap
```

```bash
snap connect theteam:password-manager-service :password-manager-service
```