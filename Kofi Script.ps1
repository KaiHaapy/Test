# Handle mapped drives
$drives = Get-SMBMapping
foreach ($drive in $drives){

    $confirmDelete = Read-Host "Would you like to remove ($($drive.LocalPath)) $($drive.RemotePath) (Y/N)"
    if ($confirmDelete -eq 'Y') {
        Remove-SmbMapping -LocalPath $drive.LocalPath -Force
    }
}

# Remove OneDrive from startup
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /f /v "OneDrive"

# Sign out of OneDrive
Remove-Item -Path HKCU:\Software\Microsoft\OneDrive\Accounts\* -Recurse

# Remove OneDrive name spaces
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace" /f /v "OneDrive"

# Update Office with default landing page
$confirmSPSiteName = Read-Host "Please enter the SharePoint site name:"
$pathExists = Test-Path -Path 'HKCU:\Software\Microsoft\Office\16.0\Common\LandingPage'
if ($pathExists -eq $false) {
    New-Item -Path 'HKCU:\Software\Microsoft\Office\16.0\Common\LandingPage'
    New-Itemproperty -path 'HKCU:\Software\Microsoft\Office\16.0\Common\LandingPage' -Name 'DefaultLocation' -value "Service|https://livelifecentralptyltd.sharepoint.com/sites/$($confirmSPSiteName)/Shared%20Documents/General/"
} else {
    Set-Itemproperty -path 'HKCU:\Software\Microsoft\Office\16.0\Common\LandingPage' -Name 'DefaultLocation' -value "Service|https://livelifecentralptyltd.sharepoint.com/sites/$($confirmSPSiteName)/Shared%20Documents/General/"
}


# Disable Windows Hello for HTTP Auth
$pathExists = Test-Path -Path 'HKCU:\Software\Policies\Microsoft\Edge'
if ($pathExists -eq $false) {
    New-Item -Path 'HKCU:\Software\Policies\Microsoft\Edge'
    New-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Edge -Name WindowsHelloForHTTPAuthEnabled -Value 0 -Force
} else {
    Set-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Edge -Name WindowsHelloForHTTPAuthEnabled -Value 0 -Force
}

# Force PDF opening externally
$pathExists = Test-Path -Path 'HKCU:\Software\Policies\Microsoft\Edge'
if ($pathExists -eq $false) {
    New-Item -Path 'HKCU:\Software\Policies\Microsoft\Edge'
    New-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Edge -Name AlwaysOpenPdfExternally -Value 1 -Force
} else {
    Set-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Edge -Name AlwaysOpenPdfExternally -Value 1 -Force
}