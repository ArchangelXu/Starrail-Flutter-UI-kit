#!/bin/bash
echo 'generating icons...'
# move to dir of this script
cd "$(dirname "$0")" || exit
cd .. || exit
flutter pub get || exit
flutter pub run flutter_launcher_icons
