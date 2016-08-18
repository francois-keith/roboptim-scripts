REM Compile and test roboptim's packages one by one.
REM We assume the packages are already cloned

REM Customizable variables
set src_path=c:\code\software\roboptim
set INSTALL_PATH=C:\code\install\roboptim_bat
set BOOST_ROOT=C:\code\install\boost_1_59_0


REM 
set github_path="C:\Program Files (x86)"
set PATH=%PATH%;"C:\Program Files (x86)\CMake\bin"
REM set PATH=%PATH%;%BOOST_ROOT%\lib
set PATH=%PATH%;C:\code\pkg-config_0.23-3_win32\bin\
set PATH=%PATH%;%INSTALL_PATH%\bin
set PKG_CONFIG_PATH=%PKG_CONFIG_PATH%;%INSTALL_PATH%\lib\pkgconfig
set PKG_CONFIG_PATH=%PKG_CONFIG_PATH%;C:\code\install\eigen\lib\pkgconfig


call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64



:: log4cxxWin32
cd %src_path%
mkdir _r_l4c
cd _r_l4c
del CMakeCache.txt
cmake ../log4cxxWin32/cmake -DCMAKE_INSTALL_PREFIX=%INSTALL_PATH% -G"Visual Studio 14 Win64" -DGIT_EXECUTABLE="C:\Program Files (x86)\Git\bin\git.exe"
msbuild INSTALL.vcxproj /p:Configuration=Release


:: ltdl-win32
cd %src_path%
mkdir _r_ltdl
cd _r_ltdl
del CMakeCache.txt
cmake ../ltdl-win32 -DCMAKE_INSTALL_PREFIX=%INSTALL_PATH% -G"Visual Studio 14 Win64" -DGIT_EXECUTABLE="C:\Program Files (x86)\Git\bin\git.exe"
msbuild INSTALL.vcxproj /p:Configuration=Release

:: roboptim-core
cd %src_path%
mkdir _r_rc
cd _r_rc
del CMakeCache.txt
cmake ../roboptim-core -DCMAKE_INSTALL_PREFIX=%INSTALL_PATH% -G"Visual Studio 14 Win64" -DGIT="C:\Program Files (x86)\Git\bin\git.exe"
devenv /build Release /project ALL_BUILD roboptim-core.sln
ctest -C Release
devenv /build Release /project INSTALL roboptim-core.sln



:: roboptim-core-plugin-eigen
cd %src_path%
mkdir _r_rce
cd _r_rce
del CMakeCache.txt
cmake ../roboptim-core-plugin-eigen -DCMAKE_INSTALL_PREFIX=%INSTALL_PATH% -G"Visual Studio 14 Win64" -DGIT_EXECUTABLE="C:\Program Files (x86)\Git\bin\git.exe"
devenv /build Release /project ALL_BUILD roboptim-core-plugin-eigen.sln
ctest -C Release
pause
REM devenv /build Release /project INSTALL roboptim-core-plugin-eigen.sln

REM pause
