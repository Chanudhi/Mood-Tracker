# Create assets directory structure
New-Item -ItemType Directory -Force -Path "assets"
New-Item -ItemType Directory -Force -Path "assets\images"
New-Item -ItemType Directory -Force -Path "assets\icons"
New-Item -ItemType Directory -Force -Path "assets\fonts"

# Download Nunito fonts
$fontUrls = @{
    "Nunito-Regular.ttf" = "https://github.com/google/fonts/raw/main/ofl/nunito/static/Nunito-Regular.ttf"
    "Nunito-Bold.ttf" = "https://github.com/google/fonts/raw/main/ofl/nunito/static/Nunito-Bold.ttf"
    "Nunito-Light.ttf" = "https://github.com/google/fonts/raw/main/ofl/nunito/static/Nunito-Light.ttf"
}

foreach ($font in $fontUrls.GetEnumerator()) {
    $outputPath = "assets\fonts\$($font.Key)"
    Write-Host "Downloading $($font.Key)..."
    Invoke-WebRequest -Uri $font.Value -OutFile $outputPath
}

Write-Host "Asset directory structure and fonts have been set up successfully!" 