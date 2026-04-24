Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$sourcePath = Join-Path $root 'remotion-avatar\public\cat-avatar-transparent.png'
$outputDir = Join-Path $root 'testapp\assets\animations\myo_wave_frames'

if (-not (Test-Path $outputDir)) {
  New-Item -ItemType Directory -Path $outputDir | Out-Null
}

$source = [System.Drawing.Bitmap]::FromFile($sourcePath)

try {
  $frameCount = 10
  $cropRect = New-Object System.Drawing.Rectangle(740, 500, 300, 280)
  $pivot = New-Object System.Drawing.PointF(784, 618)
  $eraseRect = New-Object System.Drawing.Rectangle(748, 496, 312, 294)

  $pawLayer = New-Object System.Drawing.Bitmap($cropRect.Width, $cropRect.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $pawGraphics = [System.Drawing.Graphics]::FromImage($pawLayer)
  $pawGraphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
  $pawGraphics.Clear([System.Drawing.Color]::Transparent)
  $pawGraphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceOver
  $pawGraphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $pawGraphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $pawGraphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $pawGraphics.DrawImage(
    $source,
    (New-Object System.Drawing.Rectangle(0, 0, $cropRect.Width, $cropRect.Height)),
    $cropRect,
    [System.Drawing.GraphicsUnit]::Pixel
  )
  $pawGraphics.Dispose()

  $angles = @(-11, -6, -1, 5, 9, 5, 0, -5, -10, -6)
  $offsetYs = @(2, 1, 0, -1, -2, -1, 0, 1, 2, 1)

  for ($i = 0; $i -lt $frameCount; $i++) {
    $frame = New-Object System.Drawing.Bitmap($source.Width, $source.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($frame)
    $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
    $graphics.Clear([System.Drawing.Color]::Transparent)
    $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceOver
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

    $graphics.DrawImage($source, 0, 0, $source.Width, $source.Height)

    $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
    $graphics.FillEllipse([System.Drawing.Brushes]::Transparent, $eraseRect)
    $graphics.FillRectangle([System.Drawing.Brushes]::Transparent, 1018, 432, 140, 160)
    $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceOver

    $state = $graphics.Save()
    $graphics.TranslateTransform($pivot.X, $pivot.Y + $offsetYs[$i])
    $graphics.RotateTransform($angles[$i])
    $graphics.TranslateTransform(-($pivot.X - $cropRect.X), -($pivot.Y - $cropRect.Y))
    $graphics.DrawImage($pawLayer, 0, 0, $cropRect.Width, $cropRect.Height)
    $graphics.Restore($state)

    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 5, 5, 5), 18)
    $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round

    $waveShift = [Math]::Sin(($i / $frameCount) * [Math]::PI * 2) * 8
    $lineOneStart = New-Object System.Drawing.PointF(([float](1036 + $waveShift)), ([float]470))
    $lineOneEnd = New-Object System.Drawing.PointF(([float](1084 + $waveShift)), ([float]430))
    $lineTwoStart = New-Object System.Drawing.PointF(([float](1096 + $waveShift)), ([float]522))
    $lineTwoEnd = New-Object System.Drawing.PointF(([float](1152 + $waveShift)), ([float]484))
    $graphics.DrawLine($pen, $lineOneStart, $lineOneEnd)
    $graphics.DrawLine($pen, $lineTwoStart, $lineTwoEnd)
    $pen.Dispose()

    $fileName = ('frame_{0:D2}.png' -f $i)
    $frame.Save((Join-Path $outputDir $fileName), [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $frame.Dispose()
  }
}
finally {
  $pawLayer.Dispose()
  $source.Dispose()
}
