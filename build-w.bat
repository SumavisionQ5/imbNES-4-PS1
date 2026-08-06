bin\psxpad.exe -i".\out\nes.exe" -o".\out\nespad.exe"
del .\out\nes.exe
cd out
rename nespad.exe nes.exe
pause