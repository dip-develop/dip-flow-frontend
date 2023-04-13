# TheTeam Frontend

## Stores

[![Snap Store](docs/snap_store.png)](https://snapcraft.io/theteam)
[![Microsoft Store](docs/microsoft_store.png)](https://www.microsoft.com/store/apps/9PHQZF2D9ZSW)
[![App Store](docs/app_store.png)](https://itunes.apple.com/app/id1639115836)
[![Google Play](docs/google_play.png)](https://play.google.com/store/apps/details?id=run.theteam.app)

**TheTeam** is the ultimate solution for team management. Whether you are a freelancer, a developer, an HR manager, or a headhunter, you can benefit from our powerful and user-friendly application that lets you track time, create reports, manage projects, and more. You can access our service from any device and any operating system, and enjoy our beautiful graphs that visualize your progress and performance. Plus, if you are an individual user or a small team, you can use our service for free forever. No hidden fees, no strings attached. Join **TheTeam** today and take your team to the next level.

## Getting Started

```bash
flutter pub get
```

#### Generate files

###### Generate protos
```bash
git submodule update --init --recursive --remote --force 
flutter pub global activate protoc_plugin
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
```

###### Generate other flutter files
```bash
flutter pub run build_runner build -d
flutter gen-l10n
```

###### Run project
```bash
flutter run
```

###### Add flavors to VSCode
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Frontend PROD-Flavor",
            "request": "launch",
            "type": "dart"
        },
        {
            "name": "Frontend DEV-Flavor",
            "program": "lib/main_dev.dart",
            "request": "launch",
            "type": "dart"
        }
}
```

## Create builds

#### Build AppBundle package for Play Store
```bash
flutter build appbundle
```

#### Build Arhive package for App Store
```bash
flutter build ios
flutter build ipa
```

#### Build MSIX package for Windows Store
```bash
flutter pub run msix:publish
```

#### Build Snap package for Snap Store
```bash
snapcraft
snapcraft upload --release=stable theteam_...._amd64.snap
```
###### For linux - connect password-manager-service
```bash
snap connect theteam:password-manager-service :password-manager-service
```