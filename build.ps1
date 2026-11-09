<#
.SYNOPSIS
Builds srep.exe on Windows using the repository Makefile and g++.

.DESCRIPTION
This script prefers the MSYS2 toolchain because the Makefile is written for a
Unix-like build environment. It prepends the MSYS2 binary directory to PATH when
present, runs "make clean" and "make", and verifies that bin\srep.exe was built.
#>

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $RepoRoot

# Prefer MSYS2's make/g++ when available. MSYS2 provides the Unix headers and
# tools expected by the Makefile while still producing a Windows executable.
$msysBin = 'C:\msys64\usr\bin'
if (Test-Path $msysBin) {
    $env:PATH = "$msysBin;$env:PATH"
}

$make = Get-Command make -ErrorAction SilentlyContinue
if (-not $make) {
    throw "make was not found. Install MSYS2 or another make/g++ toolchain and rerun this script."
}

$gpp = Get-Command g++ -ErrorAction SilentlyContinue
if (-not $gpp) {
    throw "g++ was not found. Install MSYS2 or another g++ toolchain and rerun this script."
}

Write-Host "Using make: $($make.Source)"
Write-Host "Using g++:  $($gpp.Source)"

& $make.Source clean
if ($LASTEXITCODE -ne 0) {
    throw "make clean failed with exit code $LASTEXITCODE."
}

& $make.Source
if ($LASTEXITCODE -ne 0) {
    throw "make failed with exit code $LASTEXITCODE."
}

$exe = Join-Path $RepoRoot 'bin\srep.exe'
if (-not (Test-Path $exe)) {
    throw "Build completed but $exe was not found."
}

Write-Host "Build succeeded: $exe"