@echo off
title SpotUp
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

:: ╔════════════╗
:: ║  Websites  ║
:: ╚════════════╝
::   Spotify: https://www.spotify.com/download | https://cutt.ly/8EH6NuH
:: Spicetify: https://github.com/spicetify/spicetify-cli | https://spicetify.app
::     SpotX: https://github.com/SpotX-Official/SpotX | https://github.com/SpotX-Official/SpotX/discussions/60
::    SpotUp: https://github.com/b12robot/SpotUp

:: ╔═══════════════╗
:: ║ SpotUp Config ║
:: ╚═══════════════╝
::   install -> Spotify, SpotX ve Spicetify kurulumu yapar.
:: uninstall -> Spotify, SpotX ve Spicetify'i kaldırır.
:: reinstall -> Spotify, SpotX ve Spicetify'i kaldırıp yeniden kurar.
::    update -> Spicetify'i günceller.
::    custom -> Aşağıdaki seçeneklere göre işlem yapar.
set preset=custom

:: Spotify: Dijital müzik ve podcast akış platformu.
:: Seçenekler: true/false
:: spotify_uninstall -> Spotify'ı kaldır.
::   spotify_install -> Spotify'ı kur.
set spotify_uninstall=true
set spotify_install=true

:: SpotX: Spotify için reklam engelleme ve güncelleme kontrol aracı.
:: Seçenekler: true/false
:: spotx_uninstall -> SpotX'i kaldır.
::   spotx_install -> SpotX'i kur.
set spotx_uninstall=true
set spotx_install=true

:: Spicetify: Spotify’ın arayüzünü ve işlevlerini özelleştirme aracı.
:: Seçenekler: true/false
:: spicetify_uninstall -> Spicetify'ı kaldır.
::   spicetify_install -> Spicetify'ı kur.
::    spicetify_update -> Spicetify'ı güncelle.
set spicetify_uninstall=false
set spicetify_install=false
set spicetify_update=false

:: ╔══════════════╗
:: ║ SpotX Config ║
:: ╚══════════════╝
:: SpotX'in Spotify güncelleme yöntemleri:
:: (Yalnızca SpotX kurulumu sırasında Spotify güncellemesi tespit edilirse geçerlidir.)
:: overwrite -> Mevcut sürümün üzerine yazarak günceller.
:: reinstall -> Mevcut sürümü kaldırıp baştan yükler.
::    prompt -> Kurulum sırasında kullanıcıya sorar. (Güncellemeyi reddetme seçeneği bulunur.)
set spotx_update_mode=overwrite

:: Spotify ana sayfa içeriği:
:: remove -> Ana sayfadan podcastleri, bölümleri ve sesli kitapları kaldırır.
::   keep -> Ana sayfada podcastleri, bölümleri ve sesli kitapları tutar. (Varsayılan)
:: prompt -> Kurulum sırasında kullanıcıya sorar.
set spotx_homepage_content=remove

:: Spotify otomatik güncelleme seçenekleri:
:: (Otomatik güncellemeler, SpotX'in yeniden yüklenmesini ve Spicetify'ı tekrar aktifleştirmek için "spicetify apply" komutunun çalıştırılmasını gerektirebilir.)
::  block -> Otomatik güncellemeleri engeller. (Önerilen)
::  allow -> Otomatik güncellemelere izin verir. (Varsayılan)
:: prompt -> Kurulum sırasında kullanıcıya sorar.
set spotx_auto_updates=block

set "backup=true"
set "pause=false"
set "debug=false"
set "delay=1"

if "%debug%" EQU "true" (echo [45;97m Debug [0m preset:%preset%)
if "%preset%" EQU "install" (
	set "spotify_uninstall=false" & set "spotify_install=true" & set "spotify_update=false"
	set "spotx_uninstall=false" & set "spotx_install=true" & set "spotx_update=false"
	set "spicetify_uninstall=false" & set "spicetify_install=true" & set "spicetify_update=false"
) else if "%preset%" EQU "uninstall" (
	set "spotify_uninstall=true" & set "spotify_install=false" & set "spotify_update=false"
	set "spotx_uninstall=true" & set "spotx_install=false" & set "spotx_update=false"
	set "spicetify_uninstall=true" & set "spicetify_install=false" & set "spicetify_update=false"
) else if "%preset%" EQU "reinstall" (
	set "spotify_uninstall=true" & set "spotify_install=true" & set "spotify_update=false"
	set "spotx_uninstall=true" & set "spotx_install=true" & set "spotx_update=false"
	set "spicetify_uninstall=true" & set "spicetify_install=true" & set "spicetify_update=false"
) else if "%preset%" EQU "update" (
	set "spotify_uninstall=false" & set "spotify_install=false" & set "spotify_update=true"
	set "spotx_uninstall=false" & set "spotx_install=false" & set "spotx_update=true"
	set "spicetify_uninstall=false" & set "spicetify_install=false" & set "spicetify_update=true"
)

if "%debug%" EQU "true" (echo [45;97m Debug [0m spotify_uninstall:%spotify_uninstall%)
if "%debug%" EQU "true" (echo [45;97m Debug [0m spotify_install:%spotify_install%)
if "%debug%" EQU "true" (echo [45;97m Debug [0m spotx_uninstall:%spotx_uninstall%)
if "%debug%" EQU "true" (echo [45;97m Debug [0m spotx_install:%spotx_install%)
if "%debug%" EQU "true" (echo [45;97m Debug [0m spicetify_uninstall:%spicetify_uninstall%)
if "%debug%" EQU "true" (echo [45;97m Debug [0m spicetify_install:%spicetify_install%)
if "%debug%" EQU "true" (echo [45;97m Debug [0m spicetify_update:%spicetify_update%)

set "change=0"
if "%spotify_uninstall%" NEQ "true" (set /a "change+=1")
if "%spotify_install%" NEQ "true" (set /a "change+=1")
if "%spotify_update%" NEQ "true" (set /a "change+=1")
if "%spotx_uninstall%" NEQ "true" (set /a "change+=1")
if "%spotx_install%" NEQ "true" (set /a "change+=1")
if "%spotx_update%" NEQ "true" (set /a "change+=1")
if "%spicetify_uninstall%" NEQ "true" (set /a "change+=1")
if "%spicetify_install%" NEQ "true" (set /a "change+=1")
if "%spicetify_update%" NEQ "true" (set /a "change+=1")
if "%debug%" EQU "true" (echo [45;97m Debug [0m change:%change%)
if "%change%" EQU "9" (
	echo Herhangi bir işlem seçilmedi lütfen dosyaya sağ tıklayıp not defteri ile yapılandırmayı düzenleyin.
	echo Çıkmak için herhangi bir tuşa basın... & endlocal & pause >nul 2>&1 & exit
)

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
		echo [33mSpotify yüklü değil, kaldırılamaz.[0m
		timeout /t %delay% /nobreak >nul 2>&1
	) else (
		call :spo_stp
		if exist "%userprofile%\Desktop\Spotify.lnk" (
			set "spotify_desktop_shortcut=true"
		) else (
			set "spotify_desktop_shortcut=false"
		)
		if "%backup%" EQU "true" (
			if exist "%appdata%\Spotify\prefs." (
				echo Spotify yedekleniyor...
				xcopy "%appdata%\Spotify\prefs." "%temp%\SpotifyBackup\" /i /y >nul 2>&1
				xcopy "%appdata%\Spotify\Users\prefs." "%temp%\SpotifyBackup\Users\" /s /e /i /y >nul 2>&1
				xcopy "%localappdata%\Spotify\Local State." "%temp%\SpotifyBackup\" /i /y >nul 2>&1
				if exist "%temp%\SpotifyBackup\prefs." (
					echo [32mSpotify başarıyla yedeklendi.[0m
					timeout /t %delay% /nobreak >nul 2>&1
				) else (
					echo [31mSpotify yedeklenemedi.[0m
					if "%pause%" EQU "true" (echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1) else (timeout /t %delay% /nobreak >nul 2>&1)
				)
			) else (
				echo [33mYedeklenecek Spotify dosyası bulunamadı.[0m
				if "%pause%" EQU "true" (echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1) else (timeout /t %delay% /nobreak >nul 2>&1)
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
			set "spotify_uninstall_status=true"
			echo [32mSpotify başarıyla kaldırıldı.[0m
			timeout /t %delay% /nobreak >nul 2>&1
		) else (
			set "spotify_uninstall_status=false"
			echo [31mSpotify kaldırılamadı.[0m
			if "%pause%" EQU "true" (echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1) else (timeout /t %delay% /nobreak >nul 2>&1)
		)
	)
)

if "%spotx_uninstall%" EQU "true" (
	cls & echo ╔═════════════════╗ & echo ║ SpotX Uninstall ║ & echo ╚═════════════════╝
	if not exist "%appdata%\Spotify" (
		set "spotx_uninstall_status=true"
		echo [33mSpotX zaten kaldırılmış.[0m
		timeout /t %delay% /nobreak >nul 2>&1
	) else (
		if not exist "%appdata%\Spotify\Spotify.bak" (
			echo [33mSpotX yüklü değil, kaldırılamaz.[0m
			timeout /t %delay% /nobreak >nul 2>&1
		) else (
			call :spo_stp
			echo SpotX kaldırılıyor...
			if exist "%appdata%\Spotify\dpapi.dll" (
				del /q "%appdata%\Spotify\dpapi.dll" >nul 2>&1
			)
			if exist "%appdata%\Spotify\Spotify.bak" (
				del /q "%appdata%\Spotify.exe" >nul 2>&1
				move "%appdata%\Spotify\Spotify.bak" "%appdata%\Spotify\Spotify.exe" >nul 2>&1
			)
			if exist "%appdata%\Spotify\config.ini" (
				del /q "%appdata%\Spotify\config.ini" >nul 2>&1
			)
			if exist "%appdata%\Spotify\apps\xpui.bak" (
				del /q "%appdata%\Spotify\apps\xpui.spa" >nul 2>&1
				move "%appdata%\Spotify\apps\xpui.bak" "%appdata%\Spotify\apps\xpui.spa" >nul 2>&1
			)
			if exist "%appdata%\Spotify\blockthespot_log.txt" (
				del /q "%appdata%\Spotify\blockthespot_log.txt" >nul 2>&1
			)
			if exist "%temp%\spotx_temp*" (
				for /d %%i in ("%temp%\spotx_temp*") do (
					rd /s /q "%%i" >nul 2>&1
				)
			)
			if not exist "%appdata%\Spotify\Spotify.bak" (
				set "spotx_uninstall_status=true"
				echo [32mSpotX başarıyla kaldırıldı.[0m
				timeout /t %delay% /nobreak >nul 2>&1
			) else (
				set "spotx_uninstall_status=false"
				echo [31mSpotX kaldırılamadı.[0m
				if "%pause%" EQU "true" (echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1) else (timeout /t %delay% /nobreak >nul 2>&1)
			)
		)
	)
)

if "%spicetify_uninstall%" EQU "true" (
	cls & echo ╔═════════════════════╗ & echo ║ Spicetify Uninstall ║ & echo ╚═════════════════════╝
	if not exist "%localappdata%\spicetify\spicetify.exe" (
		echo [33mSpicetify yüklü değil, kaldırılamaz.[0m
		timeout /t %delay% /nobreak >nul 2>&1
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
			set "spicetify_uninstall_status=true"
			echo [32mSpicetify başarıyla kaldırıldı.[0m
			timeout /t %delay% /nobreak >nul 2>&1
		) else (
			set "spicetify_uninstall_status=false"
			echo [31mSpicetify kaldırılamadı.[0m
			if "%pause%" EQU "true" (echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1) else (timeout /t %delay% /nobreak >nul 2>&1)
		)
	)
)

if "%spotify_install%" EQU "true" (
	cls & echo ╔═════════════════╗ & echo ║ Spotify Install ║ & echo ╚═════════════════╝
	if exist "%appdata%\Spotify\Spotify.exe" (
		echo [33mSpotify zaten yüklü.[0m
		timeout /t %delay% /nobreak >nul 2>&1
	) else (
		call :spo_stp
		echo Spotify indiriliyor...
		if exist "%temp%\SpotifySetup.exe" (
			del /q "%temp%\SpotifySetup.exe" >nul 2>&1
		)
		powershell -ExecutionPolicy RemoteSigned -Command "Invoke-WebRequest -Uri 'https://download.scdn.co/SpotifySetup.exe' -OutFile '%temp%\SpotifySetup.exe' -UseBasicParsing"
		if exist "%temp%\SpotifySetup.exe" (
			echo [32mSpotify başarıyla indirildi.[0m
			timeout /t %delay% /nobreak >nul 2>&1
			echo Spotify yükleniyor...
			start /b /w "SpotifyInstall" "%temp%\SpotifySetup.exe" /silent >nul 2>&1
			timeout /t 2 /nobreak >nul 2>&1
			if exist "%appdata%\Spotify\Spotify.exe" (
				set "spotify_install_status=true"
				echo [32mSpotify başarıyla yüklendi.[0m
				timeout /t %delay% /nobreak >nul 2>&1
			) else (
				set "spotify_install_status=false"
				echo [31mSpotify yüklenemedi.[0m
				if "%pause%" EQU "true" (echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1) else (timeout /t %delay% /nobreak >nul 2>&1)
			)
			if exist "%temp%\SpotifySetup.exe" (
				del /q "%temp%\SpotifySetup.exe" >nul 2>&1
			)
		) else (
			set "spotify_install_status=false"
			echo [31mSpotify indirilemedi.[0m
			if "%pause%" EQU "true" (echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1) else (timeout /t %delay% /nobreak >nul 2>&1)
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
		timeout /t %delay% /nobreak >nul 2>&1
	) else (
		if exist "%appdata%\Spotify\Spotify.bak" (
			echo [33mSpotX zaten yüklü.[0m
			timeout /t %delay% /nobreak >nul 2>&1
		) else (
			call :spo_stp
			echo SpotX yükleniyor... 
			powershell -ExecutionPolicy RemoteSigned -Command "Invoke-Expression ""& { $(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1' -UseBasicParsing) } !param!"""
			if exist "%appdata%\Spotify\Spotify.bak" (
				set "spotx_install_status=true"
				echo [32mSpotX başarıyla yüklendi.[0m
				timeout /t %delay% /nobreak >nul 2>&1
			) else (
				set "spotx_install_status=false"
				echo [31mSpotX yüklenemedi.[0m
				if "%pause%" EQU "true" (echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1) else (timeout /t %delay% /nobreak >nul 2>&1)
			)
		)
	)
)

if "%spicetify_install%" EQU "true" (
	cls & echo ╔═══════════════════╗ & echo ║ Spicetify Install ║ & echo ╚═══════════════════╝
	if not exist "%appdata%\Spotify\Spotify.exe" (
		echo [31mSpotify yüklü değil, Spicetify yüklenemez.[0m
		timeout /t %delay% /nobreak >nul 2>&1
	) else (
		if exist "%localappdata%\spicetify\spicetify.exe" (
			echo [33mSpicetify zaten yüklü.[0m
			timeout /t %delay% /nobreak >nul 2>&1
		) else (
			call :spo_stp
			echo Spicetify yükleniyor... 
			powershell -ExecutionPolicy RemoteSigned -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/spicetify/cli/main/install.ps1' -UseBasicParsing | Invoke-Expression"
			if exist "%localappdata%\spicetify\spicetify.exe" (
				set "spicetify_install_status=true"
				echo [32mSpicetify başarıyla yüklendi.[0m
				timeout /t %delay% /nobreak >nul 2>&1
			) else (
				set "spicetify_install_status=false"
				echo [31mSpicetify yüklenemedi.[0m
				if "%pause%" EQU "true" (echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1) else (timeout /t %delay% /nobreak >nul 2>&1)
			)
		)
	)
)

if "%spicetify_update%" EQU "true" (
	cls & echo ╔══════════════════╗ & echo ║ Spicetify Update ║ & echo ╚══════════════════╝
	if not exist "%appdata%\Spotify\Spotify.exe" (
		echo [31mSpotify yüklü değil, Spicetify güncellenemez.[0m
		timeout /t %delay% /nobreak >nul 2>&1
	) else (
		if not exist "%localappdata%\spicetify\spicetify.exe" (
			echo [31mSpicetify yüklü değil, Güncellenemez.[0m
			timeout /t %delay% /nobreak >nul 2>&1
		) else (
			call :spo_stp
			echo Spicetify güncelleniyor...
			for /f %%a in ('spicetify --version') do set "old_spi_ver=%%a"
			if "%debug%" EQU "true" (echo [45;97m Debug [0m old_spi_ver:!old_spi_ver!)
			powershell -ExecutionPolicy RemoteSigned -Command "spicetify update"
			timeout /t 2 /nobreak >nul 2>&1
			for /f %%a in ('spicetify --version') do set "new_spi_ver=%%a"
			if "%debug%" EQU "true" (echo [45;97m Debug [0m new_spi_ver:!new_spi_ver!)
			if "!old_spi_ver!" EQU "!new_spi_ver!" (
				set "spicetify_update_status=false"
				echo [31mSpicetify güncellenemedi.[0m
				if "%pause%" EQU "true" (echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1) else (timeout /t %delay% /nobreak >nul 2>&1)
			) else (
				set "spicetify_update_status=true"
				echo [32mSpicetify başarıyla güncellendi.[0m
				timeout /t %delay% /nobreak >nul 2>&1
			)
		)
	)
)

if "%spotify_uninstall%" EQU "true" (
	if "%backup%" EQU "true" (
		if exist "%temp%\SpotifyBackup\prefs." (
			call :spo_stp
			echo Spotify yedeği geri yükleniyor...
			move /y "%appdata%\Spotify\prefs." "%appdata%\Spotify\prefs.backup" >nul 2>&1
			xcopy "%temp%\SpotifyBackup\prefs." "%appdata%\Spotify\" /i /y >nul 2>&1
			xcopy "%temp%\SpotifyBackup\Users\*" "%appdata%\Spotify\Users\" /s /e /i /y >nul 2>&1
			xcopy "%temp%\SpotifyBackup\Local State." "%localappdata%\Spotify\" /i /y >nul 2>&1
			if exist "%appdata%\Spotify\prefs." (
				echo [32mSpotify yedeği başarıyla geri yüklendi.[0m
				rd /s /q "%temp%\SpotifyBackup" >nul 2>&1
				del /q "%appdata%\Spotify\prefs.backup" >nul 2>&1
				timeout /t %delay% /nobreak >nul 2>&1
			) else (
				echo [31mSpotify yedeği geri yüklenemedi.[0m
				move /y "%appdata%\Spotify\prefs.backup" "%appdata%\Spotify\prefs." >nul 2>&1
				if "%pause%" EQU "true" (echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1) else (timeout /t %delay% /nobreak >nul 2>&1)
			)
		) else (
			echo [33mSpotify yedeği bulunamadı.[0m
			if "%pause%" EQU "true" (echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1) else (timeout /t %delay% /nobreak >nul 2>&1)
		)
	)
	if "%spotify_desktop_shortcut%" NEQ "true" (
		del /q "%userprofile%\Desktop\Spotify.lnk" >nul 2>&1
	)
)

for %%v in (
    spotify_uninstall_status
    spotify_install_status
    spotify_update_status
    spotx_uninstall_status
    spotx_install_status
    spotx_update_status
    spicetify_uninstall_status
    spicetify_install_status
    spicetify_update_status
) do (
    call :set_symbol %%v !%%v!
)

if not "%debug%" EQU "true" (cls)
echo ╔═══════════╦══════════╦══════════╦══════════╗
echo ║ Prog/Drum ║  Kaldır  ║  Yükle   ║ Güncelle ║
echo ╠═══════════╬══════════╬══════════╬══════════╣
echo ║ Spotify   ║    !spotify_uninstall_status!    ║    !spotify_install_status!    ║    !spotify_update_status!    ║
echo ╠═══════════╬══════════╬══════════╬══════════╣
echo ║ SpotX     ║    !spotx_uninstall_status!    ║    !spotx_install_status!    ║    !spotx_update_status!    ║
echo ╠═══════════╬══════════╬══════════╬══════════╣
echo ║ Spicetify ║    !spicetify_uninstall_status!    ║    !spicetify_install_status!    ║    !spicetify_update_status!    ║
echo ╚═══════════╩══════════╩══════════╩══════════╝
echo Çıkmak için herhangi bir tuşa basın... & endlocal & pause >nul 2>&1 & exit

:spo_stp
set "retry=1"
set "max_retry=3"
if not exist "%appdata%\Spotify\Spotify.exe" (
	echo [33mSpotify bulunamadı, durdurulamaz.[0m
	timeout /t %delay% /nobreak >nul 2>&1
) else (
	:retry
	tasklist | findstr "Spotify.exe" >nul 2>&1
	if "%debug%" EQU "true" (echo [45;97m Debug [0m tasklist_1:!errorlevel!)
	if "!errorlevel!" EQU "1" (
		echo [33mSpotify zaten durdurulmuş.[0m
		timeout /t %delay% /nobreak >nul 2>&1
	) else (
		echo Spotify durduruluyor...
		taskkill /f /im "Spotify.exe" >nul 2>&1
		timeout /t 2 /nobreak >nul 2>&1
		tasklist | findstr "Spotify.exe" >nul 2>&1
		if "%debug%" EQU "true" (echo [45;97m Debug [0m tasklist_2:!errorlevel!)
		if "!errorlevel!" EQU "1" (
			echo [32mSpotify başarıyla durduruldu.[0m
			timeout /t %delay% /nobreak >nul 2>&1
		) else (
			if "%debug%" EQU "true" (echo [45;97m Debug [0m retry:%retry%)
			if "%retry%" GEQ "%max_retry%" (
				echo Spotify %retry% kez denemenin ardından durdurulamadı, Spotify'ı manuel olarak kapatmayı deneyin.
				echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
			)
			echo [31mSpotify durdurulamadı, tekrar deneniyor...[0m
			timeout /t %delay% /nobreak >nul 2>&1
			set /a "retry+=1"
			goto :retry
		)
	)
)
exit /b

:set_symbol
set "varname=%~1"
set "value=%~2"
if "%value%" EQU "true" (
    set "%varname%=✔️"
) else if "%value%" EQU "false" (
    set "%varname%=❌"
) else (
    set "%varname%=➖"
)
exit /b
