if(!(Test-Path "C:\Program Data\Chocolatey")){
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) | Out-Null
}

Start-Process -Wait -FilePath "C:\ProgramData\chocolatey\choco.exe" -ArgumentList "install adobereader.install -y"