@echo off

set OSPC="%OSP%\Osprey\bin\Release\Osprey.exe"
set LIB=%OSP%\lib

%OSPC% /libpath "%LIB%" /import osprey.compiler /verbose /main osprey.errorCodeGen.main errorCodeGen.osp
