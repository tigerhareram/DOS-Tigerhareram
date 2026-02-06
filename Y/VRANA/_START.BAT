@echo off
copy start.ex_ c:\ > c:\vysl
copy foxuser.* c:\ > c:\vysl
rename c:\start.ex_ start.exe > c:\vysl
c:
cd \
start.exe
c:
cd \
ERASE START.EXE > vysl
erase foxuser.* > vysl
echo on
