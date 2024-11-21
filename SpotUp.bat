@echo off
title SpotUp
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

:: ╔════════════════╗
:: ║    Websites    ║
:: ╚════════════════╝
::   Spotify: https://www.spotify.com/download | Spotify Versions: https://cutt.ly/8EH6NuH
:: Spicetify: https://github.com/spicetify/spicetify-cli | https://spicetify.app
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
:: 1 Spotify'ı önerilen versiyona üzerine yazarak güncelle.
:: 2 Spotify'ı önerilen versiyona tekrar kurarak güncelle.
:: 3 Spotify'ı önerilen versiyona güncellemeyi kurulum sırasında sor.
set spotx_recomend=1

:: 1 Ana sayfadan podcastleri, bölümleri ve sesli kitapları kaldır.
:: 2 Ana sayfadan podcastleri, bölümleri ve sesli kitapları kaldırma.
:: 3 Ana sayfadan podcastleri, bölümleri ve sesli kitapları kaldırmayı kurulum sırasında sor.
set spotx_podcast=1

:: 1 Spotify güncellemelerini engelle.
:: 2 Spotify güncellemelerini engelleme.
:: 3 Spotify güncellemelerini engellemeyi kurulum sırasında sor.
set spotx_update=1

set "debug=0"
set "time=1"
set "retry=0"

if "%spicetify_install%" EQU "1" (set "spicetify_upgrade=2")

if "%spotify_uninstall%" EQU "1" (
	cls & echo ╔═══════════════════╗ & echo ║ Spotify Uninstall ║ & echo ╚═══════════════════╝
	if not exist "%appdata%\Spotify\Spotify.exe" (
		echo Spotify yüklü değil, kaldırılamaz.
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		call :spo_stp
		echo Spotify kaldırılıyor...
		if exist "%localappdata%\Spotify\Update" (
			icacls "%localappdata%\Spotify\Update" /reset /t >nul 2>&1
		)
		if exist "%appdata%\Spotify\Spotify.exe" (
			start /b /w "SpotifyUninstall" "%appdata%\Spotify\Spotify.exe" /uninstall /silent
			timeout /t 2 /nobreak >nul 2>&1
		)
		if exist "%appdata%\Spotify" (
			rd /s /q "%appdata%\Spotify" >nul 2>&1
		)
		if exist "%localappdata%\Spotify" (
			rd /s /q "%localappdata%\Spotify" >nul 2>&1
		)
		if exist "%temp%\SpotifyUninstall.exe" (
			del /q  "%temp%\SpotifyUninstall.exe" >nul 2>&1
		)
		if exist "%userprofile%\Desktop\Spotify.lnk" (
			del /q "%userprofile%\Desktop\Spotify.lnk" >nul 2>&1
		)
		if not exist "%appdata%\Spotify\Spotify.exe" (
			echo Spotify başarıyla kaldırıldı.
			timeout /t %time% /nobreak >nul 2>&1
		) else (
			echo Spotify kaldırılamadı.
			echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
		)
	)
)

if "%spotx_uninstall%" EQU "1" (
	cls & echo ╔═════════════════╗ & echo ║ SpotX Uninstall ║ & echo ╚═════════════════╝
	if not exist "%appdata%\Spotify\Spotify.bak" (
		echo SpotX yüklü değil, kaldırılamaz.
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		call :spo_stp
		echo SpotX kaldırılıyor...
		if exist "%appdata%\spotify\dpapi.dll" (
			del /q "%appdata%\spotify\dpapi.dll" >nul 2>&1
		)
		if exist "%appdata%\spotify\spotify.bak" (
			del /q "%appdata%\spotify.exe" >nul 2>&1
			move "%appdata%\spotify\spotify.bak" "%appdata%\spotify\spotify.exe" >nul 2>&1
		)
		if exist "%appdata%\spotify\config.ini" (
			del /q "%appdata%\spotify\config.ini" >nul 2>&1
		)
		if exist "%appdata%\spotify\apps\xpui.bak" (
			del /q "%appdata%\spotify\apps\xpui.spa" >nul 2>&1
			move "%appdata%\spotify\apps\xpui.bak" "%appdata%\spotify\apps\xpui.spa" >nul 2>&1
		)
		if exist "%appdata%\spotify\blockthespot_log.txt" (
			del /q "%appdata%\spotify\blockthespot_log.txt" >nul 2>&1
		)
		if exist "%temp%\spotx_temp*" (
			for /d %%i in ("%temp%\spotx_temp*") do (
				rd /s /q "%%i" >nul 2>&1
			)
		)
		if not exist "%appdata%\Spotify\Spotify.bak" (
			echo SpotX başarıyla kaldırıldı.
			timeout /t %time% /nobreak >nul 2>&1
		) else (
			echo SpotX kaldırılamadı.
			echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
		)
	)
)

if "%spicetify_uninstall%" EQU "1" (
	cls & echo ╔═════════════════════╗ & echo ║ Spicetify Uninstall ║ & echo ╚═════════════════════╝
	if not exist "%localappdata%\spicetify\spicetify.exe" (
		echo Spicetify yüklü değil, kaldırılamaz.
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		call :spo_stp
		echo Spicetify kaldırılıyor...
		if exist "%appdata%\spicetify" (
			rd /s /q "%appdata%\spicetify" >nul 2>&1
		)
		if exist "%localappdata%\spicetify" (
			rd /s /q "%localappdata%\spicetify" >nul 2>&1
		)
		if not exist "%localappdata%\spicetify\spicetify.exe" (
			echo Spicetify başarıyla kaldırıldı.
			timeout /t %time% /nobreak >nul 2>&1
		) else (
			echo Spicetify kaldırılamadı.
			echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
		)
	)
)

if "%spotify_install%" EQU "1" (
	cls & echo ╔═════════════════╗ & echo ║ Spotify Install ║ & echo ╚═════════════════╝
	if exist "%appdata%\Spotify\Spotify.exe" (
		echo Spotify zaten yüklü.
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		call :spo_stp
		echo Spotify indiriliyor...
		if exist "%temp%\SpotifySetup.exe" (
			del /q "%temp%\SpotifySetup.exe" >nul 2>&1
		)
		powershell -ExecutionPolicy RemoteSigned -Command "Invoke-WebRequest -Uri 'https://download.scdn.co/SpotifySetup.exe' -OutFile '%temp%\SpotifySetup.exe' -UseBasicParsing"
		if exist "%temp%\SpotifySetup.exe" (
			echo Spotify başarıyla indirildi.
			timeout /t %time% /nobreak >nul 2>&1
			echo Spotify yükleniyor...
			start /b /w "SpotifyInstall" "%temp%\SpotifySetup.exe" /silent >nul 2>&1
			timeout /t 2 /nobreak >nul 2>&1
			if exist "%appdata%\Spotify\Spotify.exe" (
				echo Spotify başarıyla yüklendi.
				timeout /t %time% /nobreak >nul 2>&1
			) else (
				echo Spotify yüklenemedi.
				echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
			)
			if exist "%temp%\SpotifySetup.exe" (
				del /q "%temp%\SpotifySetup.exe" >nul 2>&1
			)
		) else (
			echo Spotify indirilemedi.
			echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
		)
	)
)

if "%spotx_install%" EQU "1" (
	cls & echo ╔═══════════════╗ & echo ║ SpotX Install ║ & echo ╚═══════════════╝
	if "%debug%" EQU "1" (echo spotx_recomend:%spotx_recomend%)
	if "%spotx_recomend%" EQU "1" (
		set "spotx_recomend= -confirm_spoti_recomended_over"
	) else if "%spotx_recomend%" EQU "2" (
		set "spotx_recomend= -confirm_spoti_recomended_uninstall"
	) else (
		set "spotx_recomend="
	)
	if "%debug%" EQU "1" (echo spotx_podcast:%spotx_podcast%)
	if "%spotx_podcast%" EQU "1" (
		set "spotx_podcast= -podcasts_off"
	) else if "%spotx_podcast%" EQU "2" (
		set "spotx_podcast= -podcasts_on"
	) else (
		set "spotx_podcast="
	)
	if "%debug%" EQU "1" (echo spotx_update:%spotx_update%)
	if "%spotx_update%" EQU "1" (
		set "spotx_update= -block_update_on"
	) else if "%spotx_update%" EQU "2" (
		set "spotx_update= -block_update_off"
	) else (
		set "spotx_update="
	)
	set "param=!spotx_recomend!!spotx_podcast!!spotx_update! -confirm_uninstall_ms_spoti -start_spoti"
	if "%debug%" EQU "1" (echo param:!param! & pause)
	if not exist "%appdata%\Spotify\Spotify.exe" (
		echo Spotify yüklü değil, SpotX yüklenemez.
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		if exist "%appdata%\Spotify\Spotify.bak" (
			echo SpotX zaten yüklü.
			timeout /t %time% /nobreak >nul 2>&1
		) else (
			call :spo_stp
			echo SpotX yükleniyor... 
			powershell -ExecutionPolicy RemoteSigned -Command "Invoke-Expression ""& { $(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1' -UseBasicParsing) } !param!"""
			if exist "%appdata%\Spotify\Spotify.bak" (
				echo SpotX başarıyla yüklendi.
				timeout /t %time% /nobreak >nul 2>&1
			) else (
				echo SpotX yüklenemedi.
				echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
			)
		)
	)
)

if "%spicetify_install%" EQU "1" (
	cls & echo ╔═══════════════════╗ & echo ║ Spicetify Install ║ & echo ╚═══════════════════╝
	if not exist "%appdata%\Spotify\Spotify.exe" (
		echo Spotify yüklü değil, Spicetify yüklenemez.
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		if exist "%localappdata%\spicetify\spicetify.exe" (
			echo Spicetify zaten yüklü.
			timeout /t %time% /nobreak >nul 2>&1
		) else (
			call :spo_stp
			echo Spicetify yükleniyor... 
			powershell -ExecutionPolicy RemoteSigned -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/spicetify/cli/main/install.ps1' -UseBasicParsing | Invoke-Expression"
			if exist "%localappdata%\spicetify\spicetify.exe" (
				echo Spicetify başarıyla yüklendi.
				timeout /t %time% /nobreak >nul 2>&1
			) else (
				echo Spicetify yüklenemedi.
				echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
			)
		)
	)
)

if "%spicetify_upgrade%" EQU "1" (
	cls & echo ╔═══════════════════╗ & echo ║ Spicetify Upgrade ║ & echo ╚═══════════════════╝
	if not exist "%appdata%\Spotify\Spotify.exe" (
		echo Spotify yüklü değil, Spicetify güncellenemez.
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		if not exist "%localappdata%\spicetify\spicetify.exe" (
			echo Spicetify yüklü değil, Güncellenemez.
			timeout /t %time% /nobreak >nul 2>&1
		) else (
			call :spo_stp
			echo Spicetify güncelleniyor...
			powershell -ExecutionPolicy RemoteSigned -Command "spicetify upgrade"
		)
	)
)

echo Çıkmak için herhangi bir tuşa basın... & pause >nul 2>&1 & endlocal & exit

:spo_stp
if not exist "%appdata%\Spotify\Spotify.exe" (
	echo Spotify bulunamadı, durdurulamaz.
	timeout /t %time% /nobreak >nul 2>&1
) else (
	tasklist | findstr "Spotify.exe" >nul 2>&1
	if "%debug%" EQU "1" (echo tasklist_1:!errorlevel!)
	if "!errorlevel!" EQU "1" (
		echo Spotify zaten durdurulmuş.
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		echo Spotify durduruluyor...
		taskkill /f /im "Spotify.exe" >nul 2>&1
		timeout /t 2 /nobreak >nul 2>&1
		tasklist | findstr "Spotify.exe" >nul 2>&1
		if "%debug%" EQU "1" (echo tasklist_2:!errorlevel!)
		if "!errorlevel!" EQU "1" (
			echo Spotify başarıyla durduruldu.
			timeout /t %time% /nobreak >nul 2>&1
		) else (
			if "%debug%" EQU "1" (echo retry:%retry%)
			if "%retry%" GEQ "2" (
				echo Spotify üç kez denemenin ardından durdurulamadı. Spotify'ı manuel olarak kapatmayı deneyin.
				echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
			)
			echo Spotify durdurulamadı, tekrar deneniyor...
			timeout /t %time% /nobreak >nul 2>&1
			set /a "retry+=1"
			goto :spo_stp
		)
	)
)
exit /b
