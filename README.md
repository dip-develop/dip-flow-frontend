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