param(
  # Path to the compiler
  [string]$OSPC = "${Env:OSP}\Osprey\bin\Release\Osprey.exe",
  # Path to the library folder
  [string]$LIB = "${Env:OSP}\lib"
)

function ShouldBuildResource {
  param(
    [string[]]$sources,
    [string]$target
  )

  if (-not (Test-Path $target)) {
    return $True
  }

  $targetTime = (Get-Item $target).LastWriteTime
  ForEach ($source in $sources) {
    $sourceTime = (Get-Item $source).LastWriteTime
    if ($targetTime -lt $sourceTime) {
      return $True
    }
  }
  return $False
}

function BuildResource {
  param(
    [string[]]$sources,
    [string]$target,
    [scriptblock]$task
  )

  if (ShouldBuildResource -sources $sources -target $target) {
    &$task
  }
}

BuildResource `
  -sources "osprey.compiler/res/messages.txt", "osprey.compiler/src/errors/ErrorCode.base.osp" `
  -target "osprey.compiler/src/errors/ErrorCode.osp" `
{
  # Generate error codes
  Push-Location "osprey.compiler"

  Write-Host "[!] Generating error code list..." -ForegroundColor "Cyan"
  & python scripts\generate_error_codes.py `
    --messages="res/messages.txt" `
    --template="src/errors/ErrorCode.base.osp" `
    --output="src/errors/ErrorCode.osp"

  Write-Host ""

  Pop-Location
}

Write-Host "[!] Compiling osprey.compiler..." -ForegroundColor "Cyan"

& $OSPC "/verbose" `
  "/libpath" $LIB `
  "/type" module `
  "/out" "$LIB\osprey.compiler\osprey.compiler.ovm" `
  "/name" osprey.compiler `
  "/doc" "$LIB\osprey.compiler\osprey.compiler.ovm.json" `
  "/formatjson" `
  osprey.compiler\src\osprey.compiler.osp

if ($?) {
  Copy-Item osprey.compiler\res\messages.txt "$LIB\osprey.compiler"
}

if ($?) {
  Write-Host ""
  Write-Host "[!] Compiling ospc..." -ForegroundColor "Cyan"
  & $OSPC "/verbose" `
    "/libpath" $LIB `
    "/import" osprey.compiler `
    "/main" osprey.compiler.main `
    "/out" bin\ospc.ovm `
    "/name" ospc `
    "/doc" bin\ospc.ovm.json `
    "/formatjson" `
    ospc\src\ospc.osp
}
