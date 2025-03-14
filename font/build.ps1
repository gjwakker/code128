# Define settings for each file in a list of hashtables

$files = @(
    @{ 
        TargetFile = "src\Code128_crs.sfd"; 
        OutputFile = "temp\gjwakker\Code128_crs.sfd";  
        Replacements = @(
            @{ TargetLine = "FontName: Code128"; NewLine = "FontName: Code128_gjwakker" },
            @{ TargetLine = "FullName: Code128"; NewLine = "FullName: Code128_gjwakker" },
            @{ TargetLine = "FamilyName: Code128"; NewLine = "FamilyName: Code128_gjwakker" },
            @{ TargetLine = "Version: 2.00 July 25, 2006"; NewLine = "Version: 3.00 2025" },
            @{ TargetLine = 
                'LangName: 1033 "" "" "Regular" "Code128:Version 2.00" "" "Version 2.00 July 25, 2006" "" "" "" "Aleksandras Novikovas" "Font for creating barcodes of type Code 128." "" "" "BSD license"'
                ; NewLine = 
                'LangName: 1033 "" "" "Regular" "Code128:Version 3.00" "" "Version 3.00 2025" "" "" "" "gjwakker" "Font for creating barcodes of type Code 128." "" "" "BSD license"'
            }
            
        )
    },
    @{ 
        TargetFile = "src\Code128_crs.sfd"; 
        OutputFile = "temp\Aleksandras-Novikovas\Code128_crs.sfd";  
        Replacements = @(
            @{ TargetLine = "FontName: Code128"; NewLine = "FontName: Code128_Aleksandras-Novikovas" },
            @{ TargetLine = "FullName: Code128"; NewLine = "FullName: Code128_Aleksandras-Novikovas" },
            @{ TargetLine = "FamilyName: Code128"; NewLine = "FamilyName: Code128_Aleksandras-Novikovas" },
            @{ TargetLine = "Version: 2.00 July 25, 2006"; NewLine = "Version: 3.00 2025" },
            @{ TargetLine = 
                'LangName: 1033 "" "" "Regular" "Code128:Version 2.00" "" "Version 2.00 July 25, 2006" "" "" "" "Aleksandras Novikovas" "Font for creating barcodes of type Code 128." "" "" "BSD license"'
                ; NewLine = 
                'LangName: 1033 "" "" "Regular" "Code128:Version 3.00" "" "Version 3.00 2025" "" "" "" "Aleksandras Novikovas" "Font for creating barcodes of type Code 128." "" "" "BSD license"'
            }
        )
    },
    @{ 
        TargetFile = "src\export_font.py"; 
        OutputFile = "temp\gjwakker\export_font.py";  
        Replacements = @()
    },
    @{ 
        TargetFile = "src\export_font.py"; 
        OutputFile = "temp\Aleksandras-Novikovas\export_font.py";  
        Replacements = @()
    }
)


$files2 = @(
    @{ 
        TargetFile = "temp\gjwakker\Code128_out2.ttf"; 
        OutputFile = "build\Code128_gjwakker.ttf";  
        Replacements = @()
    },
    @{  
        TargetFile = "temp\Aleksandras-Novikovas\Code128_out2.ttf";  
        OutputFile = "build\Code128_Aleksandras-Novikovas.ttf";
        Replacements = @()
    }
)

function Modify-Files {
    param (
        [Parameter(Mandatory=$true)]
        [array]$Files
    )

    foreach ($file in $Files) {
        $inputFile = $file.TargetFile
        $outputFile = $file.OutputFile
        $replacements = $file.Replacements
        
        # Ensure the output directory exists
        $directory = Split-Path -Path $outputFile -Parent
        if (!(Test-Path -Path $directory)) {
            New-Item -ItemType Directory -Path $directory | Out-Null
        }
        
        # Read the content of the file
        if (Test-Path -Path $inputFile) {
            $content = Get-Content -Path $inputFile
            
            # Apply all replacements
            foreach ($replacement in $replacements) {
                $targetLine = $replacement.TargetLine
                $newLine = $replacement.NewLine
                $content = $content -replace [regex]::Escape($targetLine), $newLine
            }
            
            # Write the modified content to the output file
            $content | Set-Content -Path $outputFile
            
            Write-Host "✅ Modified and saved: $outputFile"
        }
        else {
            Write-Host "❌ File not found: $inputFile"
        }
    }
}

function copy-Files {
    param (
        [Parameter(Mandatory=$true)]
        [array]$Files
    )

    foreach ($file in $Files) {
        $inputFile = $file.TargetFile
        $outputFile = $file.OutputFile
        $replacements = $file.Replacements
        
        # Ensure the output directory exists
        $directory = Split-Path -Path $outputFile -Parent
        if (!(Test-Path -Path $directory)) {
            New-Item -ItemType Directory -Path $directory | Out-Null
        }

        if (Test-Path -Path $inputFile) {
            # Copy file to preserve metadata
            Copy-Item -Path $inputFile -Destination $outputFile -Force


            Write-Host "✅ Modified and saved: $outputFile"
        }
        else {
            Write-Host "❌ File not found: $inputFile"
        }
    }
}

# Check if FontForge is installed
$fontForgePath = "C:\Program Files (x86)\FontForgeBuilds\bin\fontforge.exe"
if (-Not (Test-Path $fontForgePath)) {
    Write-Host "FontForge not found! Install from https://fontforge.org/en-US/downloads/"
    exit 1
}

# Save Python script temporarily
$scriptPath = "export_font.py"

# main :: start
$fontDirectory = Get-Location #procume the full path to the font directory : example "C:\git-repos\code128\font"

# Call the function
Set-Location $fontDirectory
Modify-Files -Files $files

# Run the script using FontForge
Set-Location $fontDirectory
Set-Location .\temp\gjwakker
& "$fontForgePath" -script $scriptPath

# Run the script using FontForge
Set-Location $fontDirectory
Set-Location .\temp\Aleksandras-Novikovas
& "$fontForgePath" -script $scriptPath

# Call the function
Set-Location $fontDirectory
copy-Files -Files $files2


Write-Host "✅ All files processed!"