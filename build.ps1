param(
  # Path to the compiler
  [string]$OSPC = "${Env:OSP}\Osprey\bin\Release\Osprey.exe",
  # Path to the library folder
  [string]$LIB = "${Env:OSP}\lib"
)

function shouldRebuild {
  param(
    [string]$source,
    [string]$target
  )

  if (-not (Test-Path $target)) {
    return True
  }

  $sourceTime = (Get-Item $source).LastWriteTime
  $targetTime = (Get-Item $target).LastWriteTime
  return $targetTime -lt $sourceTime
}

if (shouldRebuild -source "osprey.compiler/res/messages.txt" -target "osprey.compiler/src/errors/ErrorCode.osp") {
  # Generate error codes
  Push-Location "osprey.compiler"

  Write-Output "[!] Generating error code list..."
  & python scripts\generate_error_codes.py `
    --messages="res/messages.txt" `
    --template="src/errors/ErrorCode.base.osp" `
    --output="src/errors/ErrorCode.osp"

  Write-Output ""

  Pop-Location
}

Write-Output "[!] Compiling osprey.compiler..."

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
  Write-Output ""
  Write-Output "[!] Compiling ospc..."
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
