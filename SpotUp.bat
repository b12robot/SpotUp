@echo off
title SpotUp
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

:: ╔════════════════╗
:: ║    Websites    ║
:: ╚════════════════╝
::   Spotify: https://www.spotify.com/download & All Spotify Versions: https://cutt.ly/8EH6NuH
:: Spicetify: https://github.com/spicetify/spicetify-cli & https://spicetify.app
::     SpotX: https://github.com/SpotX-Official/SpotX
::    SpotUp: https://github.com/b12robot/SpotUp

:: ╔═══════════════╗
:: ║ SpotUp Config ║
:: ╚═══════════════╝
:: 1 Spotify'ı kaldırır.
:: 2 Spotify'ı kaldırmaz.
set spotify_uninstall=1

:: 1 Spotify'ı yükler.
:: 2 Spotify'ı yüklemez.
set spotify_install=1

:: 1 SpotX'ı kaldırır.
:: 2 SpotX'ı kaldırmaz.
set spotx_uninstall=1

:: 1 SpotX'ı yükler.
:: 2 SpotX'ı yüklemez.
set spotx_install=1

:: 1 Spicetify'ı kaldırır.
:: 2 Spicetify'ı kaldırmaz.
set spicetify_uninstall=1

:: 1 Spicetify'ı yükler.
:: 2 Spicetify'ı yüklemez.
set spicetify_install=1

:: 1 Spicetify'ı günceller.
:: 2 Spicetify'ı güncellemez.
set spicetify_upgrade=2

:: ╔════════════════╗
:: ║  SpotX Config  ║
:: ╚════════════════╝
:: 1 Spotify'ı önerilen versiyona güncellerken üzerine yaz.
:: 2 Spotify'ı önerilen versiyona güncellerken tekrar kur.
:: 3 Spotify'ı önerilen versiyona güncellemeyi kurulum sırasında sor.
set spotx_recomend=1

:: 1 Podcastleri kapat.
:: 2 Podcastleri aç.
:: 3 Podcastleri kapatmayı kurulum sırasında sor.
set spotx_podcast=1

:: 1 Spotify'ın otomatik güncellenmesini engelle.
:: 2 Spotify'ın otomatik güncellenmesini engelleme.
:: 3 Spotify'ın otomatik güncellenmesini engellemeyi kurulum sırasında sor.
set spotx_update=1

set "spo_dow_pth=%temp%\SpotifySetup.exe"
set "spo_ins_pth=%appdata%\Spotify\Spotify.exe"
set "spx_ins_pth=%appdata%\Spotify\Spotify.bak"
set "spi_ins_pth=%localappdata%\spicetify\spicetify.exe"
set "retry=0"
set "t=2"

if %spicetify_install% EQU "1" (set "spicetify_upgrade=2")
if "%spotify_uninstall%" EQU "1" (call :spo-del)
if "%spotx_uninstall%" EQU "1" (call :spx-del)
if "%spicetify_uninstall%" EQU "1" (call :spi-del)
if "%spotify_install%" EQU "1" (call :spo-ins)
if "%spotx_install%" EQU "1" (call :spx-ins)
if "%spicetify_install%" EQU "1" (call :spi-ins)
if "%spicetify_upgrade%" EQU "1" (call :spi-upg)

echo Çıkmak için herhangi bir tuşa basın... & pause >nul 2>&1 & endlocal & exit

:spo-del
cls & echo ╔═══════════════════╗ & echo ║ Spotify Uninstall ║ & echo ╚═══════════════════╝
if not exist "%spo_ins_pth%" (
	echo Spotify yüklü değil, kaldırılamaz.
	timeout /t %t% /nobreak >nul 2>&1
) else (
	call :spo_stp
	echo Spotify kaldırılıyor...
	if exist "%localappdata%\Spotify\Update" (icacls "%localappdata%\Spotify\Update" /reset /t >nul 2>&1)
	if exist "%spo_ins_pth%" (start /b /w "SpotifyUninstall" "%spo_ins_pth%" /uninstall /silent & timeout /t 2 /nobreak >nul 2>&1)
	if exist "%appdata%\Spotify" (rd /s /q "%appdata%\Spotify" >nul 2>&1)
	if exist "%localappdata%\Spotify" (rd /s /q "%localappdata%\Spotify" >nul 2>&1)
	if exist "%temp%\SpotifyUninstall.exe" (del /q  "%temp%\SpotifyUninstall.exe" >nul 2>&1)
	if exist "%userprofile%\Desktop\Spotify.lnk" (del /q "%userprofile%\Desktop\Spotify.lnk" >nul 2>&1)
	if not exist "%spo_ins_pth%" (
		echo Spotify başarıyla kaldırıldı.
		timeout /t %t% /nobreak >nul 2>&1
	) else (
		echo Spotify kaldırılamadı.
		echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
	)
)
exit /b

:spx-del
cls & echo ╔═════════════════╗ & echo ║ SpotX Uninstall ║ & echo ╚═════════════════╝
if not exist "%spx_ins_pth%" (
	echo SpotX yüklü değil, kaldırılamaz.
	timeout /t %t% /nobreak >nul 2>&1
) else (
	call :spo_stp
	echo SpotX kaldırılıyor...
	rem WIP
	if not exist "%spx_ins_pth%" (
		echo SpotX başarıyla kaldırıldı.
		timeout /t %t% /nobreak >nul 2>&1
	) else (
		echo SpotX kaldırılamadı.
		echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
	)
)
exit /b

:spi-del
cls & echo ╔═════════════════════╗ & echo ║ Spicetify Uninstall ║ & echo ╚═════════════════════╝
if not exist "%spi_ins_pth%" (
	echo Spicetify yüklü değil, kaldırılamaz.
	timeout /t %t% /nobreak >nul 2>&1
) else (
	call :spo_stp
	echo Spicetify kaldırılıyor...
	if exist "%appdata%\spicetify" (rd /s /q "%appdata%\spicetify" >nul 2>&1)
	if exist "%localappdata%\spicetify" (rd /s /q "%localappdata%\spicetify" >nul 2>&1)
	if not exist "%spi_ins_pth%" (
		echo Spicetify başarıyla kaldırıldı.
		timeout /t %t% /nobreak >nul 2>&1
	) else (
		echo Spicetify kaldırılamadı.
		echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
	)
)
exit /b

:spo-ins
cls & echo ╔═════════════════╗ & echo ║ Spotify Install ║ & echo ╚═════════════════╝
if exist "%spo_ins_pth%" (
	echo Spotify zaten yüklü.
	timeout /t %t% /nobreak >nul 2>&1
) else (
	call :spo_stp
	echo Spotify indiriliyor...
	if exist "%spo_dow_pth%" (del /q "%spo_dow_pth%" >nul 2>&1)
	powershell -ExecutionPolicy Bypass -Command "iwr https://download.scdn.co/SpotifySetup.exe -OutFile %spo_dow_pth%"
	if exist "%spo_dow_pth%" (
		echo Spotify başarıyla indirildi.
		timeout /t %t% /nobreak >nul 2>&1
		echo Spotify yükleniyor...
		start /b /w "SpotifyInstall" "%spo_dow_pth%" /silent >nul 2>&1 & timeout /t 2 /nobreak >nul 2>&1
		if exist "%spo_ins_pth%" (
			echo Spotify başarıyla yüklendi.
			timeout /t %t% /nobreak >nul 2>&1
		) else (
			echo Spotify yüklenemedi.
			echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
		)
		if exist "%spo_dow_pth%" (del /q "%spo_dow_pth%" >nul 2>&1)
	) else (
		echo Spotify indirilemedi.
		echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
	)
)
exit /b

:spx-ins
cls & echo ╔═══════════════╗ & echo ║ SpotX Install ║ & echo ╚═══════════════╝

if "%spotx_recomend%" EQU "1" (
    set "spotx_recomend= -sp-over"
) else if "%spotx_recomend%" EQU "2" (
    set "spotx_recomend= -sp-uninstall"
) else (
    set "spotx_recomend="
)

if "%spotx_podcast%" EQU "1" (
    set "spotx_podcast= -podcasts_off"
) else if "%spotx_podcast%" EQU "2" (
    set "spotx_podcast= -podcasts_on"
) else (
    set "spotx_podcast="
)

if "%spotx_update%" EQU "1" (
    set "spotx_update= -block_update_on"
) else if "%spotx_update%" EQU "2" (
    set "spotx_update= -block_update_off"
) else (
    set "spotx_update="
)

set "param=%spotx_recomend%%spotx_podcast%%spotx_update% -confirm_uninstall_ms_spoti -start_spoti"

if not exist "%spo_ins_pth%" (
	echo Spotify yüklü değil, SpotX yüklenemez.
	timeout /t %t% /nobreak >nul 2>&1
) else (
	if exist "%spx_ins_pth%" (
		echo SpotX zaten yüklü.
		timeout /t %t% /nobreak >nul 2>&1
	) else (
		call :spo_stp
		echo SpotX yükleniyor... 
		powershell -ExecutionPolicy Bypass -Command """ & {$(iwr https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1)} %param% """ ^| iex
		if exist "%spx_ins_pth%" (
			echo SpotX başarıyla yüklendi.
			timeout /t %t% /nobreak >nul 2>&1
		) else (
			echo SpotX yüklenemedi.
			echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
		)
	)
)
exit /b

:spi-ins
cls & echo ╔═══════════════════╗ & echo ║ Spicetify Install ║ & echo ╚═══════════════════╝
if not exist "%spo_ins_pth%" (
	echo Spotify yüklü değil, Spicetify yüklenemez.
	timeout /t %t% /nobreak >nul 2>&1
) else (
	if exist "%spi_ins_pth%" (
		echo Spicetify zaten yüklü.
		timeout /t %t% /nobreak >nul 2>&1
	) else (
		call :spo_stp
		echo Spicetify yükleniyor... 
		powershell -ExecutionPolicy Bypass -Command "iwr https://raw.githubusercontent.com/spicetify/cli/main/install.ps1 | iex"
		if exist "%spi_ins_pth%" (
			echo Spicetify başarıyla yüklendi.
			timeout /t %t% /nobreak >nul 2>&1
		) else (
			echo Spicetify yüklenemedi.
			echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
		)
	)
)
exit /b

:spi-upg
cls & echo ╔═══════════════════╗ & echo ║ Spicetify Upgrade ║ & echo ╚═══════════════════╝
if not exist "%spo_ins_pth%" (
	echo Spotify yüklü değil, Spicetify güncelenemez.
	timeout /t %t% /nobreak >nul 2>&1
) else (
	if not exist "%spi_ins_pth%" (
		echo Spicetify yüklü değil, Güncelenemez.
		timeout /t %t% /nobreak >nul 2>&1
	) else (
		call :spo_stp
		echo Spicetify güncelleniyor...
		powershell -ExecutionPolicy Bypass -Command "spicetify upgrade"
	)
)
exit /b

:spo_stp
if not exist "%spo_ins_pth%" (
	echo Spotify bulunamadı, durdurulamaz.
	timeout /t %t% /nobreak >nul 2>&1
) else (
	tasklist | findstr "Spotify.exe" >nul 2>&1
	if !errorlevel!% EQU 1 (
		echo Spotify zaten durdurulmuş.
		timeout /t %t% /nobreak >nul 2>&1
	) else (
		echo Spotify durduruluyor...
		taskkill /f /im "Spotify.exe" >nul 2>&1
		timeout /t 2 /nobreak >nul 2>&1
		tasklist | findstr "Spotify.exe" >nul 2>&1
		if !errorlevel! EQU 1 (
			echo Spotify başarıyla durduruldu.
			timeout /t %t% /nobreak >nul 2>&1
		) else (
			if %retry% GEQ 2 (
				echo Spotify 3 denemeden sonra durdurulamadı. Spotify'ı manuel olarak kapatmayı deneyin.
				echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
			)
			echo Spotify durdurulamadı, tekrar denenecek...
			timeout /t %t% /nobreak >nul 2>&1
			set /a retry+=1
			goto :spo_stp
		)
	)
)
exit /b
