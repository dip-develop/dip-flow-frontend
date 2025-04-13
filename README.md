# DIP Flow - Frontend

[![BuyMeACoffee][buy_me_a_coffee_badge]][buy_me_a_coffee]

## Stores

[![Snap Store](docs/snap_store.png)](https://snapcraft.io/todo)
[![Microsoft Store](docs/microsoft_store.png)](https://www.microsoft.com/store/apps/todo)
[![App Store](docs/app_store.png)](https://itunes.apple.com/app/todo)
[![Google Play](docs/google_play.png)](https://play.google.com/store/apps/details?id=todo)

**DIP Flow** is the ultimate solution for team management. Whether you are a freelancer, a developer, an HR manager, or a headhunter, you can benefit from our powerful and user-friendly application that lets you track time, create reports, manage projects, and more. You can access our service from any device and any operating system, and enjoy our beautiful graphs that visualize your progress and performance. Plus, if you are an individual user or a small team, you can use our service for free forever. No hidden fees, no strings attached. Join **DIP Flow** today and take your team to the next level.

## Links

#### [WIKI](https://github.com/dip-develop/dip-flow)

#### [Backend](https://github.com/dip-develop/dip-flow-backend)

#### [Protos](https://github.com/dip-develop/dip-flow-protos)

### Pre start

Install [Protocol Buffers](https://github.com/protocolbuffers/protobuf/releases) depends of your OS

```bash
dart pub global activate mono_repo
dart pub global activate melos
git submodule update --init --recursive
```

## Quick start

Linux and Mac

```bash
sh ./generate.sh
```

Windows

```bash
./generate.bat
```

### Generate other flutter files

```bash
flutter pub run build_runner build -d
flutter gen-l10n
```

## Run project

```bash
flutter run
```

#### VSCode config

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
  ]
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
snapcraft upload --release=stable ...._amd64.snap
```

###### For linux - connect password-manager-service

```bash
snap connect dip-flow:password-manager-service :password-manager-service
```

## Sponsoring

I'm working on my packages on my free-time, but I don't have as much time as I would. If this package or any other package I created is helping you, please consider to sponsor me so that I can take time to read the issues, fix bugs, merge pull requests and add features to these packages.

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue][issue].  
If you fixed a bug or implemented a feature, please send a [pull request][pr].

<!-- Links -->

[buy_me_a_coffee]: https://buymeacoffee.com/dip.dev
[buy_me_a_coffee_badge]: https://img.buymeacoffee.com/button-api/?text=Donate&emoji=&slug=dip.dev&button_colour=29b6f6&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=FFDD00
[issue]: https://github.com/dip-develop/dip-flow-frontend/issues
[pr]: https://github.com/dip-develop/dip-flow-frontend/pulls
