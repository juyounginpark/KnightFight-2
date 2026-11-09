param(
    [string] $Tool = 'List'
)

$ToolArgs = @($args)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$settingsFile = Join-Path $PSScriptRoot '.local-tools.json'
$settings = if (Test-Path -LiteralPath $settingsFile) {
    Get-Content -Raw -LiteralPath $settingsFile | ConvertFrom-Json
} else { $null }

function Require-File([string] $Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Missing tool file: $Path. See docs/OPEN_SOURCE_TOOLS.ko.md for installation."
    }
    return $Path
}

function Get-Godot {
    if ($settings -and $settings.godot -and (Test-Path -LiteralPath $settings.godot)) { return $settings.godot }
    $command = Get-Command godot -ErrorAction SilentlyContinue
    if ($command) { return $command.Source }
    throw 'Set the Godot executable path in tools/.local-tools.json (godot), or add godot to PATH.'
}

Push-Location -LiteralPath $projectRoot
try {
    switch ($Tool) {
        'List' {
            Write-Output 'LDtk, Ogmo: map editors | Platformer: Godot demo | Gaea: project editor'
            Write-Output 'SpriteKiln <args> | Pixelbolt <args> (default: studio) | PixelFX <effect> --sheet'
            Write-Output 'PixelFXGallery (http://localhost:8080/gallery/) | Guide'
        }
        'Guide' { Invoke-Item -LiteralPath (Require-File (Join-Path $projectRoot 'docs/OPEN_SOURCE_TOOLS.ko.md')) }
        'LDtk' {
            $exe = Require-File (Join-Path $env:LOCALAPPDATA 'Programs/LDtk/LDtk.exe')
            Start-Process -FilePath $exe
        }
        'Ogmo' {
            $exe = Require-File (Join-Path $PSScriptRoot 'ogmo/Ogmo Editor/Ogmo Editor.exe')
            Start-Process -FilePath $exe
        }
        'Platformer' {
            $exe = Get-Godot
            Start-Process -FilePath $exe -ArgumentList '--editor --path tools/godot-demo-projects/2d/platformer' -WorkingDirectory $projectRoot
        }
        'Gaea' {
            $exe = Get-Godot
            Start-Process -FilePath $exe -ArgumentList '--editor --path .' -WorkingDirectory $projectRoot
        }
        'SpriteKiln' {
            $exe = Require-File (Join-Path $PSScriptRoot 'spritekiln-venv/Scripts/python.exe')
            & $exe -m spritekiln @ToolArgs
            if ($LASTEXITCODE -ne 0) { throw "SpriteKiln exited with code $LASTEXITCODE" }
        }
        'Pixelbolt' {
            $entry = Require-File (Join-Path $PSScriptRoot 'pixelbolt/bin/pixelbolt.js')
            if (-not $ToolArgs) { $ToolArgs = @('preview') }
            & node $entry @ToolArgs
            if ($LASTEXITCODE -ne 0) { throw "Pixelbolt exited with code $LASTEXITCODE" }
        }
        'PixelFX' {
            $entry = Require-File (Join-Path $PSScriptRoot 'pixelfx/tools/render.mjs')
            & node $entry @ToolArgs
            if ($LASTEXITCODE -ne 0) { throw "pixelfx exited with code $LASTEXITCODE" }
        }
        'PixelFXGallery' {
            $entry = Require-File (Join-Path $PSScriptRoot 'pixelfx/tools/serve.mjs')
            & node $entry @ToolArgs
            if ($LASTEXITCODE -ne 0) { throw "pixelfx gallery exited with code $LASTEXITCODE" }
        }
        default { throw "Unknown tool: $Tool. Run this script with List for supported tools." }
    }
} finally {
    Pop-Location
}
