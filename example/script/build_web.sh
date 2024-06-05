#!/bin/bash
echo 'building web version'
# move to dir of this script
cd "$(dirname "$0")"
cd .. || exit
#flutter build web --web-renderer canvaskit
flutter build web --wasm

open build/web/
start build\\web