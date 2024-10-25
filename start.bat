@echo off
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" > out.txt 2>&1
net config server /srvcomment:"Windows Server 2019 By Network Slutter" > out.txt 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F > out.txt 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v Wallpaper /t REG_SZ /d D:\a\wallpaper.bat
net user administrator @Netslutter /add >nul
net localgroup administrators administrator /add >nul
net user administrator /active:yes >nul
net user installer /delete
diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul
ICACLS C:\Windows\Temp /grant administrator:F >nul
ICACLS C:\Windows\installer /grant administrator:F >nul
echo Successfully Installed !, If the RDP is Dead, Please Rebuild Again!
echo IP:
@echo off

:: Cek apakah ngrok.exe sedang berjalan
tasklist | find /i "ngrok.exe" > Nul
if %errorlevel%==0 (
    echo Ngrok is running.
    
    :: Ambil data tunnel dari API lokal ngrok
    curl -s http://localhost:4040/api/tunnels > ngrok_output.txt
    echo Tunnel data retrieved:
    type ngrok_output.txt

    :: Cek apakah data JSON dari curl ada dan valid
    for /f "delims=" %%A in ('jq -r .tunnels[0].public_url ngrok_output.txt') do set "tunnel_url=%%A"
    
    if defined tunnel_url (
        echo Tunnel URL: %tunnel_url%
    ) else (
        echo "Failed to parse the tunnel URL. Ensure jq is installed and ngrok is configured correctly."
    )
) else (
    echo "Unable to get the NGROK tunnel, make sure NGROK_AUTH_TOKEN is correct in Settings> Secrets> Repository secret."
    echo "Maybe your previous VM is still running: https://dashboard.ngrok.com/status/tunnels"
)


echo Username: administrator
echo Password: @Netslutter
echo Please Login To Your RDP!!
ping -n 10 127.0.0.1 >nul
