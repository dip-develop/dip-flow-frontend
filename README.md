# Musmula Frontend

A Musmula Frontend Flutter project.

## Getting Started

```bash
flutter pub global activate protoc_plugin
flutter pub get
```

#### Generate files
```bash
protoc --dart_out=grpc:lib/data/entities/generated -Iprotos protos/gate_service.proto protos/auth_models.proto
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
snapcraft upload --release=stable musmula_...._amd64.snap
```