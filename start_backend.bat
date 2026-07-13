@echo off
cd /d D:\projectone\projectone\backend
echo Starting Teaching Platform Backend on port 8080...
start "TeachingPlatformBackend" javaw -jar target\teaching-platform-1.0.0.jar
echo Backend started!
