@echo off
title SpotUp
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

:: ╔══════════════╗
:: ║   Websites   ║
:: ╚══════════════╝
::   Spotify: https://www.spotify.com/download | https://cutt.ly/8EH6NuH
:: Spicetify: https://github.com/spicetify/spicetify-cli | https://spicetify.app
::     SpotX: https://github.com/SpotX-Official/SpotX | https://github.com/SpotX-Official/SpotX/discussions/60
::    SpotUp: https://github.com/b12robot/SpotUp

:: ╔═══════════════╗
:: ║ SpotUp Config ║
:: ╚═══════════════╝
:: Spotify'ı kaldır ve yükle.
:: Seçenekler: "true", "false"
set spotify_uninstall=true
set spotify_install=true

:: SpotX'ı kaldır ve yükle.
:: Seçenekler: "true", "false"
set spotx_uninstall=true
set spotx_install=true

:: Spicetify'ı kaldır, yükle ve güncelle.
:: Seçenekler: "true", "false"
set spicetify_uninstall=true
set spicetify_install=true
set spicetify_update=false

:: ╔════════════════╗
:: ║  SpotX Config  ║
:: ╚════════════════╝
:: SpotX'ın Spotify'ı güncelleme modu:
:: (Kurulum sırasında bir kez etkili olur.)
:: "overwrite" -> Üzerine yazarak güncelle.
:: "reinstall" -> Yeniden yükleyerek güncelle.
:: "prompt"    -> Kullanıcıya kurulum sırasında sor.
set spotx_update_mode=overwrite

:: Spotify ana sayfa içerik modu:
:: "remove" -> Podcastleri, bölümleri ve sesli kitapları kaldır.
:: "keep"   -> Podcastleri, bölümleri ve sesli kitapları tut.
:: "prompt" -> Kullanıcıya kurulum sırasında sor.
set spotx_homepage_content=remove

:: Spotify otomatik güncelleme modu:
:: "block"  -> Güncellemeleri engelle.
:: "allow"  -> Güncellemelere izin ver.
:: "prompt" -> Kullanıcıya kurulum sırasında sor.
set spotx_auto_updates=block

set "backup=true"
set "debug=false"
set "time=1"
set "retry=1"

if "%spicetify_install%" EQU "true" (
	if "%spicetify_update%" EQU "true" (
		if exist "%localappdata%\spicetify\spicetify.exe" (
			set "spicetify_install=false" & set "spicetify_update=true"
		) else (
			set "spicetify_install=true" & set "spicetify_update=false"
		)
	)
)

if "%spotify_uninstall%" EQU "true" (
	cls & echo ╔═══════════════════╗ & echo ║ Spotify Uninstall ║ & echo ╚═══════════════════╝
	if not exist "%appdata%\Spotify\Spotify.exe" (
		echo [31mSpotify yüklü değil, kaldırılamaz.[0m
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		call :spo_stp
		if "%backup%" EQU "true" (
			if exist "%appdata%\Spotify\prefs." (
				echo Spotify yedekleniyor...
				xcopy "%appdata%\Spotify\prefs." "%temp%" /y >nul 2>&1
				if exist "%temp%\prefs." (
					echo [32mSpotify başarıyla yedeklendi.[0m
					timeout /t %time% /nobreak >nul 2>&1
				) else (
					echo [31mSpotify yedeklenemedi.[0m
					echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
				)
			) else (
				echo [31mYedeklenecek Spotify dosyası bulunamadı.[0m
				echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
			)
		)
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
			echo [32mSpotify başarıyla kaldırıldı.[0m
			timeout /t %time% /nobreak >nul 2>&1
		) else (
			echo [31mSpotify kaldırılamadı.[0m
			echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
		)
	)
)

if "%spotx_uninstall%" EQU "true" (
	cls & echo ╔═════════════════╗ & echo ║ SpotX Uninstall ║ & echo ╚═════════════════╝
	if not exist "%appdata%\Spotify\Spotify.bak" (
		echo [31mSpotX yüklü değil, kaldırılamaz.[0m
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
			echo [32mSpotX başarıyla kaldırıldı.[0m
			timeout /t %time% /nobreak >nul 2>&1
		) else (
			echo [31mSpotX kaldırılamadı.[0m
			echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
		)
	)
)

if "%spicetify_uninstall%" EQU "true" (
	cls & echo ╔═════════════════════╗ & echo ║ Spicetify Uninstall ║ & echo ╚═════════════════════╝
	if not exist "%localappdata%\spicetify\spicetify.exe" (
		echo [31mSpicetify yüklü değil, kaldırılamaz.[0m
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
			echo [32mSpicetify başarıyla kaldırıldı.[0m
			timeout /t %time% /nobreak >nul 2>&1
		) else (
			echo [31mSpicetify kaldırılamadı.[0m
			echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
		)
	)
)

if "%spotify_install%" EQU "true" (
	cls & echo ╔═════════════════╗ & echo ║ Spotify Install ║ & echo ╚═════════════════╝
	if exist "%appdata%\Spotify\Spotify.exe" (
		echo [32mSpotify zaten yüklü.[0m
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		call :spo_stp
		echo Spotify indiriliyor...
		if exist "%temp%\SpotifySetup.exe" (
			del /q "%temp%\SpotifySetup.exe" >nul 2>&1
		)
		powershell -ExecutionPolicy RemoteSigned -Command "Invoke-WebRequest -Uri 'https://download.scdn.co/SpotifySetup.exe' -OutFile '%temp%\SpotifySetup.exe' -UseBasicParsing"
		if exist "%temp%\SpotifySetup.exe" (
			echo [32mSpotify başarıyla indirildi.[0m
			timeout /t %time% /nobreak >nul 2>&1
			echo Spotify yükleniyor...
			start /b /w "SpotifyInstall" "%temp%\SpotifySetup.exe" /silent >nul 2>&1
			timeout /t 2 /nobreak >nul 2>&1
			if exist "%appdata%\Spotify\Spotify.exe" (
				echo [32mSpotify başarıyla yüklendi.[0m
				timeout /t %time% /nobreak >nul 2>&1
				if "%backup%" EQU "true" (
					if exist "%temp%\prefs." (
						echo Spotify yedeği geri yükleniyor...
						move /y "%appdata%\Spotify\prefs." "%appdata%\Spotify\prefs.backup" >nul 2>&1
						xcopy "%temp%\prefs." "%appdata%\Spotify" /y >nul 2>&1
						if exist "%appdata%\Spotify\prefs." (
							echo [32mSpotify yedeği başarıyla geri yüklendi.[0m
							del /q "%temp%\prefs." >nul 2>&1
							del /q "%appdata%\Spotify\prefs.backup" >nul 2>&1
							timeout /t %time% /nobreak >nul 2>&1
						) else (
							echo [31mSpotify yedeği geri yüklenemedi.[0m
							move /y "%appdata%\Spotify\prefs.backup" "%appdata%\Spotify\prefs." >nul 2>&1
							echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
						)
					) else (
						echo [31mSpotify yedeği bulunamadı.[0m
						echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
					)
				)
			) else (
				echo [31mSpotify yüklenemedi.[0m
				echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
			)
			if exist "%temp%\SpotifySetup.exe" (
				del /q "%temp%\SpotifySetup.exe" >nul 2>&1
			)
		) else (
			echo [31mSpotify indirilemedi.[0m
			echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
		)
	)
)

if "%spotx_install%" EQU "true" (
	cls & echo ╔═══════════════╗ & echo ║ SpotX Install ║ & echo ╚═══════════════╝
	if "%debug%" EQU "true" (echo [45;97m Debug [0m spotx_update_mode:%spotx_update_mode%)
	if "%spotx_update_mode%" EQU "overwrite" (
		set "spotx_update_mode= -confirm_spoti_recomended_over"
	) else if "%spotx_update_mode%" EQU "reinstall" (
		set "spotx_update_mode= -confirm_spoti_recomended_uninstall"
	) else (
		set "spotx_update_mode="
	)
	if "%debug%" EQU "true" (echo [45;97m Debug [0m spotx_homepage_content:%spotx_homepage_content%)
	if "%spotx_homepage_content%" EQU "remove" (
		set "spotx_homepage_content= -podcasts_off"
	) else if "%spotx_homepage_content%" EQU "keep" (
		set "spotx_homepage_content= -podcasts_on"
	) else (
		set "spotx_homepage_content="
	)
	if "%debug%" EQU "true" (echo [45;97m Debug [0m spotx_auto_updates:%spotx_auto_updates%)
	if "%spotx_auto_updates%" EQU "block" (
		set "spotx_auto_updates= -block_update_on"
	) else if "%spotx_auto_updates%" EQU "allow" (
		set "spotx_auto_updates= -block_update_off"
	) else (
		set "spotx_auto_updates="
	)
	set "param=!spotx_update_mode!!spotx_homepage_content!!spotx_auto_updates! -confirm_uninstall_ms_spoti -start_spoti"
	if "%debug%" EQU "true" (echo [45;97m Debug [0m param:!param! & pause)
	if not exist "%appdata%\Spotify\Spotify.exe" (
		echo [31mSpotify yüklü değil, SpotX yüklenemez.[0m
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		if exist "%appdata%\Spotify\Spotify.bak" (
			echo [32mSpotX zaten yüklü.[0m
			timeout /t %time% /nobreak >nul 2>&1
		) else (
			call :spo_stp
			echo SpotX yükleniyor... 
			powershell -ExecutionPolicy RemoteSigned -Command "Invoke-Expression ""& { $(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1' -UseBasicParsing) } !param!"""
			if exist "%appdata%\Spotify\Spotify.bak" (
				echo [32mSpotX başarıyla yüklendi.[0m
				timeout /t %time% /nobreak >nul 2>&1
			) else (
				echo [31mSpotX yüklenemedi.[0m
				echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
			)
		)
	)
)

if "%spicetify_install%" EQU "true" (
	cls & echo ╔═══════════════════╗ & echo ║ Spicetify Install ║ & echo ╚═══════════════════╝
	if not exist "%appdata%\Spotify\Spotify.exe" (
		echo [31mSpotify yüklü değil, Spicetify yüklenemez.[0m
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		if exist "%localappdata%\spicetify\spicetify.exe" (
			echo [32mSpicetify zaten yüklü.[0m
			timeout /t %time% /nobreak >nul 2>&1
		) else (
			call :spo_stp
			echo Spicetify yükleniyor... 
			powershell -ExecutionPolicy RemoteSigned -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/spicetify/cli/main/install.ps1' -UseBasicParsing | Invoke-Expression"
			if exist "%localappdata%\spicetify\spicetify.exe" (
				echo [32mSpicetify başarıyla yüklendi.[0m
				timeout /t %time% /nobreak >nul 2>&1
			) else (
				echo [31mSpicetify yüklenemedi.[0m
				echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
			)
		)
	)
)

if "%spicetify_update%" EQU "true" (
	cls & echo ╔═══════════════════╗ & echo ║ Spicetify Update ║ & echo ╚═══════════════════╝
	if not exist "%appdata%\Spotify\Spotify.exe" (
		echo [31mSpotify yüklü değil, Spicetify güncellenemez.[0m
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		if not exist "%localappdata%\spicetify\spicetify.exe" (
			echo [31mSpicetify yüklü değil, Güncellenemez.[0m
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
	echo [31mSpotify bulunamadı, durdurulamaz.[0m
	timeout /t %time% /nobreak >nul 2>&1
) else (
	tasklist | findstr "Spotify.exe" >nul 2>&1
	if "%debug%" EQU "true" (echo [45;97m Debug [0m tasklist_1:!errorlevel!)
	if "!errorlevel!" EQU "1" (
		echo [32mSpotify zaten durdurulmuş.[0m
		timeout /t %time% /nobreak >nul 2>&1
	) else (
		echo Spotify durduruluyor...
		taskkill /f /im "Spotify.exe" >nul 2>&1
		timeout /t 2 /nobreak >nul 2>&1
		tasklist | findstr "Spotify.exe" >nul 2>&1
		if "%debug%" EQU "true" (echo [45;97m Debug [0m tasklist_2:!errorlevel!)
		if "!errorlevel!" EQU "1" (
			echo [32mSpotify başarıyla durduruldu.[0m
			timeout /t %time% /nobreak >nul 2>&1
		) else (
			if "%debug%" EQU "true" (echo [45;97m Debug [0m retry:%retry%)
			if "%retry%" GEQ "3" (
				echo Spotify %retry% kez denemenin ardından durdurulamadı, Spotify'ı manuel olarak kapatmayı deneyin.
				echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
			)
			echo [31mSpotify durdurulamadı, tekrar deneniyor...[0m
			timeout /t %time% /nobreak >nul 2>&1
			set /a "retry+=1"
			goto :spo_stp
		)
	)
)
exit /b
