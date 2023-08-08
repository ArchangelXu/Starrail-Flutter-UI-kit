#!/bin/bash
echo 'building web version using canvaskit renderer'
# move to dir of this script
cd "$(dirname "$0")"
cd .. || exit
flutter build web --web-renderer canvaskit
open build/web/