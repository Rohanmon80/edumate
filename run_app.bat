@echo off

cd /d C:\flutter_dev\flutter_projects\edumate

flutter build apk --debug

C:\Users\rohan\AppData\Local\Android\sdk\platform-tools\adb install -r android\app\build\outputs\apk\debug\app-debug.apk

pause