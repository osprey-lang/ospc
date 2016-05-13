@echo off

rem Path to the compiler
set OSPC="%OSP%\Osprey\bin\Release\Osprey.exe"
rem Path to the library folder
set LIB=%OSP%\lib

if [%1]==[full] (
	rem Generate error codes
	cd osprey.compiler

	echo [!] Generating error code list...
	python scripts\generate_error_codes.py ^
		--messages="res/messages.txt" ^
		--template="src/errors/ErrorCode.base.osp" ^
		--output="src/errors/ErrorCode.osp"
	echo.

	cd ..
)

echo [!] Compiling osprey.compiler...
%OSPC% /libpath "%LIB%" /verbose /type module /out "%LIB%\osprey.compiler\osprey.compiler.ovm" /name osprey.compiler /doc "%LIB%\osprey.compiler\osprey.compiler.ovm.json" /formatjson osprey.compiler\src\osprey.compiler.osp && ^
xcopy /Y /I osprey.compiler\res\messages.txt "%LIB%\osprey.compiler"

if %ERRORLEVEL%==0 (
	echo.
	echo [!] Compiling ospc...
	%OSPC% /libpath "%LIB%" /import osprey.compiler /verbose /main osprey.compiler.main /out bin\ospc.ovm /name ospc /doc bin\ospc.ovm.json /formatjson ospc\src\ospc.osp
)
