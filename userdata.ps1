<powershell>
Start-Transcript -Path "C:\UserData.log" -Append

#######################################
#install nvidia driver

#choco install -y nvidia-geforce-now
#nvidia-display-driver

curl https://us.download.nvidia.com/Windows/Quadro_Certified/335.35/335.35-grid-desktop-win8-win7-winserv2008r2-winserv2012-64bit-international.exe -outfile nvidia.exe
nvidia.exe /q /norestart

takeown /f C:\Windows\System32\Drivers\BasicDisplay.sys
cacls C:\Windows\System32\Drivers\BasicDisplay.sys /G Administrator:F
del C:\Windows\System32\Drivers\BasicDisplay.sys

#######################################
#install and join vpn

curl https://download.zerotier.com/dist/ZeroTier%20One.msi --outfile zerotier.msi
zerotier.msi /q /norestart

#######################################
# make logout-no-screenlock shortcut
$ShortcutFile = "$env:Public\Desktop\NoLockLogout.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = "C:\Windows\System32\tscon.exe"
$Shortcut.Arguments = "%sessionname% /dest:console"
$Shortcut.Save()

#######################################
# Turn off windows firewall

echo "Turn off Windows Firewall"
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False


#######################################
#install chocolatey

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

######################################
# Updated profile content to explicitly import Choco
$ChocoProfileValue = @'
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
'@

Set-Content -Path "$profile" -Value $ChocoProfileValue -Force

. $profile

######################################
#install vb-cable for sound

choco install -y vb-cable

#######################################
# install steam
choco install -y steam

#######################################
#disable Securty Ehanced IE
#
#$AdminKey = “HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}”
#$UserKey = “HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}”
#Set-ItemProperty -Path $AdminKey -Name “IsInstalled” -Value 0
#Set-ItemProperty -Path $UserKey -Name “IsInstalled” -Value 0
#Stop-Process -Name Explorer
#Write-Host “IE Enhanced Security Configuration (ESC) has been disabled.” -ForegroundColor Green

</powershell>