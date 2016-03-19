@echo off

rem Path to the compiler
set OSPC="%OSP%\Osprey\bin\Release\Osprey.exe"
rem Path to the library folder
set LIB=%OSP%\lib

%OSPC% /libpath "%LIB%" /import osprey.compiler /import testing.unit /main osprey.compiler.tests.main /out osprey.compiler.tests.ovm /verbose /r *.osp
