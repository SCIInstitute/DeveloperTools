#!/bin/bash
if [ "$#" -ne 4 ]; then
  echo "Usage: ./create_dmg APP_DIR CLI_BINARY LICENSE_FILE DMG_LOGO"
  exit 1
fi
rm *.dmg
title=ShapeWorksStudio
finalDMGName=ShapeWorksStudio_2.2_osx.dmg
app_dir="$1"
license="$3"
image_splash="$4"
source="temp"
rm -rf temp
mkdir temp
cp -r "${app_dir}/${title}.app" "${source}"
cp "$2" "${source}/${title}.app/Contents/MacOS"
macdeployqt "${source}/${title}.app"
ln -s /Applications "${source}"/Applications
cp "${license}" "${source}"
size=80000
hdiutil create -srcfolder "${source}" -volname "${title}" -fs HFS+ \
      -fsargs "-c c=64,a=16,e=16" -format UDRW -size ${size}k pack.temp.dmg
device=$(hdiutil attach -readwrite -noverify -noautoopen "pack.temp.dmg" | \
         egrep '^/dev/' | sed 1q | awk '{print $1}')
sleep 1
mkdir /Volumes/${title}/.background
sleep 1
cp "${image_splash}" /Volumes/"${title}"/.background/logo.png
echo '
   tell application "Finder"
     tell disk "'${title}'"
           open
           set current view of container window to icon view
           set toolbar visible of container window to false
           set statusbar visible of container window to false
           set the bounds of container window to {400, 100, 880, 330}
           set theViewOptions to the icon view options of container window
           set arrangement of theViewOptions to not arranged
           set icon size of theViewOptions to 72
           set background picture of theViewOptions to file ".background:'logo.png'"
           delay 5
           close
           open
           set position of item "Applications" of container window to {150, 130}
           delay 5
           close
           open
           set position of item "'${title}'" of container window to {330, 130}
           delay 5
           close
           open
           set position of item "LICENSE.txt" of container window to {425, 130}
           delay 5
           close
           open
           update without registering applications
           delay 5
           close
     end tell
   end tell
' | osascript
chmod -Rf go-w /Volumes/"${title}"
sync
sync
hdiutil detach ${device}
hdiutil convert "pack.temp.dmg" -format UDZO -imagekey zlib-level=9 -o "${finalDMGName}"
rm -f pack.temp.dmg 
rm -rf "${source}"
exit 0
