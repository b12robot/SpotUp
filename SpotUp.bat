@echo off
title SpotUp
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

:: ╔════════════╗
:: ║  Websites  ║
:: ╚════════════╝
::   Spotify: https://www.spotify.com/download | https://loadspot.pages.dev
:: Spicetify: https://github.com/spicetify/spicetify-cli | https://spicetify.app
::     SpotX: https://github.com/SpotX-Official/SpotX | https://github.com/SpotX-Official/SpotX/discussions/60
::    SpotUp: https://github.com/b12robot/SpotUp

:: ╔═══════════════╗
:: ║ SpotUp Config ║
:: ╚═══════════════╝
:: Hazır bir önayar seçin veya "custom" seçerek aşağıdan özelleştirin.

:: [Syntax] {action}_{target}
:: action: install, uninstall, reinstall, update
:: target: spotify, spotx, spicetify, all

:: [Single]
:: | install_spotify   | uninstall_spotify   | reinstall_spotify   |
:: | install_spotx     | uninstall_spotx     | reinstall_spotx     |
:: | install_spicetify | uninstall_spicetify | reinstall_spicetify | update_spicetify |

:: [Combined]
:: | install_spotify_spotx     | uninstall_spotify_spotx     | reinstall_spotify_spotx     |
:: | install_spotify_spicetify | uninstall_spotify_spicetify | reinstall_spotify_spicetify |
:: | install_all               | uninstall_all               | reinstall_all               |

:: [Special]
:: | custom | --> Aşağıda belirlediğiniz seçeneklere göre işlem yapar.
set preset=reinstall_spotify_spotx

:: ╔═══════════════╗
:: ║ Manuel Config ║
:: ╚═══════════════╝
:: Spotify: Dijital müzik ve podcast akış platformu.
:: Spotify'ı kaldırır. (true/false)
:: (Spotify'ı kaldırmak SpotX'i de kaldıracaktır.)
set spotify_uninstall=false
:: Spotify'ı kurar. (true/false)
set spotify_install=false

:: SpotX: Spotify için reklam engelleme ve güncelleme kontrol aracı.
:: SpotX'i kaldırır. (true/false)
set spotx_uninstall=false
:: SpotX'i kurar. (true/false)
set spotx_install=false

:: Spicetify: Spotify arayüzünü ve işlevlerini özelleştirme aracı.
:: Spicetify'ı kaldırır. (true/false)
set spicetify_uninstall=false
:: Spicetify'ı kurar. (true/false)
set spicetify_install=false
:: Spicetify'ı günceller. (true/false)
set spicetify_update=false

:: ╔══════════════════╗
:: ║ Advanced Options ║
:: ╚══════════════════╝
:: İşlemler öncesi Spotify ayarlarını ve kullanıcı verilerini yedekler, işlemler tamamlandığında geri yükler. (true/false)
set backup=true

:: Her işlem sonunda sonraki işleme geçmek için kullanıcı onayı bekler. (true/false)
set pause=false

:: İşlemler arasındaki bekleme süresi. (1-9 Saniye)
set delay=1

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
::  allow -> Otomatik güncellemelere izin verir. (Varsayılan) (Otomatik güncelleştirmeler SpotX yamasını bozabilir.)
:: prompt -> Kurulum sırasında kullanıcıya sorar.
set spotx_auto_updates=block

:: ╔═════════════════╗
:: ║  End of Config  ║
:: ╚═════════════════╝

:: Set presets
if "%preset%" NEQ "custom" (
	set "spotify_uninstall=false" & set "spotify_install=false"
	set "spotx_uninstall=false" & set "spotx_install=false"
	set "spicetify_uninstall=false" & set "spicetify_install=false" & set "spicetify_update=false"
	set "backup=false"
)
if "%preset%" EQU "install_spotify" (
	set "spotify_install=true"
) else if "%preset%" EQU "uninstall_spotify" (
	set "spotify_uninstall=true"
) else if "%preset%" EQU "reinstall_spotify" (
	set "spotify_uninstall=true" & set "spotify_install=true"
	set "backup=true"
) else if "%preset%" EQU "install_spotx" (
	set "spotx_install=true"
) else if "%preset%" EQU "uninstall_spotx" (
	set "spotx_uninstall=true"
) else if "%preset%" EQU "reinstall_spotx" (
	set "spotx_uninstall=true" & set "spotx_install=true"
) else if "%preset%" EQU "install_spicetify" (
	set "spicetify_install=true"
) else if "%preset%" EQU "uninstall_spicetify" (
	set "spicetify_uninstall=true"
) else if "%preset%" EQU "reinstall_spicetify" (
	set "spicetify_uninstall=true" & set "spicetify_install=true"
) else if "%preset%" EQU "update_spicetify" (
	set "spicetify_update=true"
) else if "%preset%" EQU "install_spotify_spotx" (
	set "spotify_install=true"
	set "spotx_install=true"
) else if "%preset%" EQU "uninstall_spotify_spotx" (
	set "spotify_uninstall=true"
	set "spotx_uninstall=true"
) else if "%preset%" EQU "reinstall_spotify_spotx" (
	set "spotify_uninstall=true" & set "spotify_install=true"
	set "spotx_uninstall=true" & set "spotx_install=true"
	set "backup=true"
) else if "%preset%" EQU "install_spotify_spicetify" (
	set "spotify_install=true"
	set "spicetify_install=true"
) else if "%preset%" EQU "uninstall_spotify_spicetify" (
	set "spotify_uninstall=true"
	set "spicetify_uninstall=true"
) else if "%preset%" EQU "reinstall_spotify_spicetify" (
	set "spotify_uninstall=true" & set "spotify_install=true"
	set "spicetify_uninstall=true" & set "spicetify_install=true"
	set "backup=true"
) else if "%preset%" EQU "install_all" (
	set "spotify_install=true"
	set "spotx_install=true"
	set "spicetify_install=true"
) else if "%preset%" EQU "uninstall_all" (
	set "spotify_uninstall=true"
	set "spotx_uninstall=true"
	set "spicetify_uninstall=true"
) else if "%preset%" EQU "reinstall_all" (
	set "spotify_uninstall=true" & set "spotify_install=true"
	set "spotx_uninstall=true" & set "spotx_install=true"
	set "spicetify_uninstall=true" & set "spicetify_install=true"
	set "backup=true"
)

:: Fix conflicts
if "%spicetify_install%" EQU "true" (
	if "%spicetify_update%" EQU "true" (
		if exist "%localappdata%\spicetify\spicetify.exe" (
			set "spicetify_install_status=skip"
			set "spicetify_install=false" & set "spicetify_update=true"
		) else (
			set "spicetify_update_status=skip"
			set "spicetify_install=true" & set "spicetify_update=false"
		)
	)
)

:: Check action
set "action=false"
if "%spotify_uninstall%" EQU "true" (set "action=true")
if "%spotify_install%" EQU "true" (set "action=true")
if "%spotx_uninstall%" EQU "true" (set "action=true")
if "%spotx_install%" EQU "true" (set "action=true")
if "%spicetify_uninstall%" EQU "true" (set "action=true")
if "%spicetify_install%" EQU "true" (set "action=true")
if "%spicetify_update%" EQU "true" (set "action=true")
if "%action%" EQU "false" (
	echo [36mHerhangi bir işlem seçilmedi veya preset yanlış yazıldı.
	echo Lütfen dosyaya sağ tıklayıp not defteri ile yapılandırmayı düzenleyin.[0m
	echo Çıkmak için herhangi bir tuşa basın... & endlocal & pause >nul 2>&1 & exit /b 0
)

:: Validate config
set "config_error=false"
for %%v in (
	spotify_install spotify_uninstall
	spotx_install spotx_uninstall
	spicetify_install spicetify_uninstall spicetify_update
	backup pause
) do (
    if "!%%v!" NEQ "true" if "!%%v!" NEQ "false" (
        echo [41;97m Error [0m '%%v' değişkeni için geçersiz değer: '!%%v!', true/false olmalı.
        set "config_error=true"
    )
)
if "%spotx_update_mode%" NEQ "overwrite" if "%spotx_update_mode%" NEQ "reinstall" if "%spotx_update_mode%" NEQ "prompt" (
    echo [41;97m Error [0m 'spotx_update_mode' değişkeni için geçersiz değer: '%spotx_update_mode%'
    set "config_error=true"
)
if "%spotx_homepage_content%" NEQ "remove" if "%spotx_homepage_content%" NEQ "keep" if "%spotx_homepage_content%" NEQ "prompt" (
    echo [41;97m Error [0m 'spotx_homepage_content' değişkeni için geçersiz değer: '%spotx_homepage_content%'
    set "config_error=true"
)
if "%spotx_auto_updates%" NEQ "block" if "%spotx_auto_updates%" NEQ "allow" if "%spotx_auto_updates%" NEQ "prompt" (
    echo [41;97m Error [0m 'spotx_auto_updates' değişkeni için geçersiz değer: '%spotx_auto_updates%'
    set "config_error=true"
)
echo %delay%| findstr /r "^[1-9]$" >nul 2>&1 || (
	echo [41;97m Error [0m 'delay' değişkeni için geçersiz değer: '%delay%', 1-9 aralığında olmalı.
	set "config_error=true"
)
if "%config_error%" EQU "true" (
    echo [36mLütfen yapılandırmayı düzeltip tekrar çalıştırın.[0m
    echo Çıkmak için herhangi bir tuşa basın... & endlocal & pause >nul 2>&1 & exit /b 0
)

:: Get shortcut status
set "spotify_desktop_shortcut=false"
if exist "%appdata%\Spotify\Spotify.exe" if exist "%userprofile%\Desktop\Spotify.lnk" (
    set "spotify_desktop_shortcut=true"
)

:: Call actions
call :main
if defined fatal_step (
	if "%backup%" EQU "true" (
		call :restore_spotify
	)
)

:: Remove shortcut if necessary
if "%spotify_desktop_shortcut%" NEQ "true" (
	del /q "%userprofile%\Desktop\Spotify.lnk" >nul 2>&1
)

:: Set symbols
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
	backup_status
	restore_status
) do (
    call :symbol %%v !%%v!
)

:: Display table
cls
echo ╔═══════════╦══════════╦══════════╦══════════╗
echo ║ [94mProg/Drum[0m ║  [94mKaldır[0m  ║  [94mYükle[0m   ║ [94mGüncelle[0m ║   ╔═════════════════╗
echo ╠═══════════╬══════════╬══════════╬══════════╣   ║ ✔️ [90m-^>[0m Başarılı  ║
echo ║ [92mSpotify[0m   ║    !spotify_uninstall_status!    ║    !spotify_install_status!    ║    !spotify_update_status!    ║   ║ ❌ [90m-^>[0m Hata      ║
echo ╠═══════════╬══════════╬══════════╬══════════╣   ║ ⚠️ [90m-^>[0m Uyarı     ║
echo ║ [93mSpotX[0m     ║    !spotx_uninstall_status!    ║    !spotx_install_status!    ║    !spotx_update_status!    ║   ║ ⏩ [90m-^>[0m Atlandı   ║
echo ╠═══════════╬══════════╬══════════╬══════════╣   ║ ➖ [90m-^>[0m Seçilmedi ║
echo ║ [91mSpicetify[0m ║    !spicetify_uninstall_status!    ║    !spicetify_install_status!    ║    !spicetify_update_status!    ║   ╚═════════════════╝
echo ╚═══════════╩══════════╩══════════╩══════════╝
echo [96mYedekleme:[0m !backup_status!  [96mGeri Yükleme:[0m !restore_status!
set "exit_code=0"
if defined fatal_step (set "exit_code=1" & echo [41;97m Error [0m !fatal_step!)
echo Çıkmak için herhangi bir tuşa basın... & endlocal & pause >nul 2>&1 & exit /b %exit_code%

:main
if "%backup%" EQU "true" (call :run backup_spotify || exit /b 1)
if "%spotify_uninstall%" EQU "true" (call :run uninstall_spotify || exit /b 1)
if "%spotx_uninstall%" EQU "true" (call :run uninstall_spotx || exit /b 1)
if "%spicetify_uninstall%" EQU "true" (call :run uninstall_spicetify || exit /b 1)
if "%spotify_install%" EQU "true" (call :run install_spotify || exit /b 1)
if "%spotx_install%" EQU "true" (call :run install_spotx || exit /b 1)
if "%spicetify_install%" EQU "true" (call :run install_spicetify || exit /b 1)
if "%spicetify_update%" EQU "true" (call :run update_spicetify || exit /b 1)
if "%backup%" EQU "true" (call :run restore_spotify || exit /b 1)
exit /b 0

:run
call :%~1
if !errorlevel! NEQ 0 (if not defined fatal_step (set "fatal_step=%~1"))
exit /b !errorlevel!

:backup_spotify
cls & echo ╔════════════════╗ & echo ║ Spotify Backup ║ & echo ╚════════════════╝
if not exist "%appdata%\Spotify\prefs." (
	set "backup_status=warn"
	echo [33mYedeklenecek Spotify dosyası bulunamadı.[0m
	call :wait
	exit /b 0
)
call :run stop_spotify || exit /b 1
echo Spotify yedekleniyor...
rd /s /q "%temp%\SpotifyBackup" >nul 2>&1
xcopy "%appdata%\Spotify\prefs." "%temp%\SpotifyBackup\" /i /y >nul 2>&1
xcopy "%appdata%\Spotify\Users\" "%temp%\SpotifyBackup\Users\" /s /e /i /y >nul 2>&1
if exist "%temp%\SpotifyBackup\prefs." (
	set "backup_status=success"
	echo [32mSpotify başarıyla yedeklendi.[0m
	call :wait
	exit /b 0
)
set "backup_status=error"
echo [31mSpotify yedeklenemedi.[0m
call :wait
exit /b 1

:restore_spotify
cls & echo ╔═════════════════╗ & echo ║ Spotify Restore ║ & echo ╚═════════════════╝
if not exist "%temp%\SpotifyBackup\prefs." (
	set "restore_status=warn"
	echo [33mSpotify yedeği bulunamadı, geri yüklenemiyor.[0m
	call :wait
	exit /b 0
)
call :run stop_spotify || exit /b 1
echo Spotify yedeği geri yükleniyor...
move /y "%appdata%\Spotify\prefs." "%appdata%\Spotify\prefs.bak" >nul 2>&1
xcopy "%temp%\SpotifyBackup\prefs." "%appdata%\Spotify\" /i /y >nul 2>&1
xcopy "%temp%\SpotifyBackup\Users\" "%appdata%\Spotify\Users\" /s /e /i /y >nul 2>&1
if exist "%appdata%\Spotify\prefs." (
	del /q "%appdata%\Spotify\prefs.bak" >nul 2>&1
	rd /s /q "%temp%\SpotifyBackup" >nul 2>&1
	set "restore_status=success"
	echo [32mSpotify yedeği başarıyla geri yüklendi.[0m
	call :wait
	exit /b 0
)
move /y "%appdata%\Spotify\prefs.bak" "%appdata%\Spotify\prefs." >nul 2>&1
set "restore_status=error"
echo [31mSpotify yedeği geri yüklenemedi.[0m
call :wait
exit /b 0

:install_spotify
cls & echo ╔═════════════════╗ & echo ║ Spotify Install ║ & echo ╚═════════════════╝
if exist "%appdata%\Spotify\Spotify.exe" (
	set "spotify_install_status=skip"
	echo [36mSpotify zaten yüklü.[0m
	call :wait
	exit /b 0
)
call :run stop_spotify || exit /b 1
echo Spotify indiriliyor...
del /q "%temp%\SpotifySetup.exe" >nul 2>&1
powershell -ExecutionPolicy RemoteSigned -Command "Invoke-WebRequest -Uri 'https://download.scdn.co/SpotifySetup.exe' -OutFile '%temp%\SpotifySetup.exe' -UseBasicParsing"
if not exist "%temp%\SpotifySetup.exe" (
	set "spotify_install_status=error"
	echo [31mSpotify indirilemedi.[0m
	call :wait
	exit /b 0
)
echo [32mSpotify başarıyla indirildi.[0m
timeout /t %delay% /nobreak >nul 2>&1
echo Spotify yükleniyor...
start /w "install_spotify" "%temp%\SpotifySetup.exe" >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1
if exist "%appdata%\Spotify\Spotify.exe" (
	set "spotify_install_status=success"
	echo [32mSpotify başarıyla yüklendi.[0m
) else (
	set "spotify_install_status=error"
	echo [31mSpotify yüklenemedi.[0m
)
call :wait
del /q "%temp%\SpotifySetup.exe" >nul 2>&1
exit /b 0

:uninstall_spotify
cls & echo ╔═══════════════════╗ & echo ║ Spotify Uninstall ║ & echo ╚═══════════════════╝
if not exist "%appdata%\Spotify\Spotify.exe" (
	set "spotify_uninstall_status=skip"
	echo [36mSpotify yüklü değil, kaldırılamıyor.[0m
	call :wait
	exit /b 0
)
call :run stop_spotify || exit /b 1
echo Spotify kaldırılıyor...
set "spotx_installed=false"
if exist "%appdata%\Spotify\Spotify.bak" (set "spotx_installed=true")
icacls "%localappdata%\Spotify\Update" /reset /t >nul 2>&1
start /w "uninstall_spotify" "%appdata%\Spotify\uninstall.exe" /silent >nul 2>&1
timeout /t 2 /nobreak >nul 2>&1
set "uninstall_retry=1"
set "uninstall_max=5"
:retry_uninstall
tasklist | findstr /i "SpotifyUninstall.exe" >nul 2>&1
if !errorlevel! EQU 0 (
	set /a "uninstall_wait=uninstall_retry*2"
	timeout /t !uninstall_wait! /nobreak >nul 2>&1
	if !uninstall_retry! GEQ !uninstall_max! (
		set "spotify_uninstall_status=error"
		echo [31mSpotify'ın kaldırılması beklendiğinden uzun sürdü, Spotify'ı manuel olarak kaldırmayı deneyin.[0m
		call :wait
		exit /b 1
	)
	set /a "uninstall_retry+=1"
	goto :retry_uninstall
)
rd /s /q "%appdata%\Spotify" >nul 2>&1
rd /s /q "%localappdata%\Spotify" >nul 2>&1
del /q "%temp%\SpotifyUninstall.exe" >nul 2>&1
del /q "%userprofile%\Desktop\Spotify.lnk" >nul 2>&1
if not exist "%appdata%\Spotify\Spotify.exe" (
	if "%spotx_installed%" EQU "true" (set "spotx_uninstall_status=success")
	set "spotify_uninstall_status=success"
	echo [32mSpotify başarıyla kaldırıldı.[0m
	call :wait
	exit /b 0
)
set "spotify_uninstall_status=error"
echo [31mSpotify kaldırılamadı.[0m
call :wait
exit /b 0

:install_spotx
cls & echo ╔═══════════════╗ & echo ║ SpotX Install ║ & echo ╚═══════════════╝
if "%spotx_update_mode%" EQU "overwrite" (
	set "spotx_update_mode= -confirm_spoti_recomended_over"
) else if "%spotx_update_mode%" EQU "reinstall" (
	set "spotx_update_mode= -confirm_spoti_recomended_uninstall"
) else (
	set "spotx_update_mode="
)
if "%spotx_homepage_content%" EQU "remove" (
	set "spotx_homepage_content= -podcasts_off"
) else if "%spotx_homepage_content%" EQU "keep" (
	set "spotx_homepage_content= -podcasts_on"
) else (
	set "spotx_homepage_content="
)
if "%spotx_auto_updates%" EQU "block" (
	set "spotx_auto_updates= -block_update_on"
) else if "%spotx_auto_updates%" EQU "allow" (
	set "spotx_auto_updates= -block_update_off"
) else (
	set "spotx_auto_updates="
)
set "param=!spotx_update_mode!!spotx_homepage_content!!spotx_auto_updates! -confirm_uninstall_ms_spoti -defender_exclusions_off -DisableStartup -start_spoti"
if not exist "%appdata%\Spotify\Spotify.exe" (
	set "spotx_install_status=error"
	echo [31mSpotify yüklü değil, SpotX yüklenemiyor.[0m
	call :wait
	exit /b 0
)
if exist "%appdata%\Spotify\Spotify.bak" (
	set "spotx_install_status=skip"
	echo [36mSpotX zaten yüklü.[0m
	call :wait
	exit /b 0
)
call :run stop_spotify || exit /b 1
echo SpotX yükleniyor...
powershell -ExecutionPolicy RemoteSigned -Command "Invoke-Expression ""& { $(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1' -UseBasicParsing) } !param!"""
if exist "%appdata%\Spotify\Spotify.bak" (
	set "spotx_install_status=success"
	echo [32mSpotX başarıyla yüklendi.[0m
	call :wait
	exit /b 0
)
set "spotx_install_status=error"
echo [31mSpotX yüklenemedi.[0m
call :wait
exit /b 0

:uninstall_spotx
if "!spotx_uninstall_status!" EQU "success" (exit /b 0)
cls & echo ╔═════════════════╗ & echo ║ SpotX Uninstall ║ & echo ╚═════════════════╝
if not exist "%appdata%\Spotify\Spotify.bak" (
	set "spotx_uninstall_status=skip"
	echo [36mSpotX yüklü değil, kaldırılamıyor.[0m
	call :wait
	exit /b 0
)
call :run stop_spotify || exit /b 1
echo SpotX kaldırılıyor...
del /q "%appdata%\Spotify\dpapi.dll" >nul 2>&1
del /q "%appdata%\Spotify\Spotify.exe" >nul 2>&1
move "%appdata%\Spotify\Spotify.bak" "%appdata%\Spotify\Spotify.exe" >nul 2>&1
del /q "%appdata%\Spotify\config.ini" >nul 2>&1
del /q "%appdata%\Spotify\apps\xpui.spa" >nul 2>&1
move "%appdata%\Spotify\apps\xpui.bak" "%appdata%\Spotify\apps\xpui.spa" >nul 2>&1
del /q "%appdata%\Spotify\blockthespot_log.txt" >nul 2>&1
if not exist "%appdata%\Spotify\Spotify.bak" (
	set "spotx_uninstall_status=success"
	echo [32mSpotX başarıyla kaldırıldı.[0m
	call :wait
	exit /b 0
)
set "spotx_uninstall_status=error"
echo [31mSpotX kaldırılamadı.[0m
call :wait
exit /b 0

:install_spicetify
cls & echo ╔═══════════════════╗ & echo ║ Spicetify Install ║ & echo ╚═══════════════════╝
if not exist "%appdata%\Spotify\Spotify.exe" (
	set "spicetify_install_status=error"
	echo [31mSpotify yüklü değil, Spicetify yüklenemiyor.[0m
	call :wait
	exit /b 0
)
if exist "%localappdata%\spicetify\spicetify.exe" (
	set "spicetify_install_status=skip"
	echo [36mSpicetify zaten yüklü.[0m
	call :wait
	exit /b 0
)
call :run stop_spotify || exit /b 1
echo Spicetify yükleniyor...
powershell -ExecutionPolicy RemoteSigned -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/spicetify/cli/main/install.ps1' -UseBasicParsing | Invoke-Expression"
if exist "%localappdata%\spicetify\spicetify.exe" (
	set "spicetify_install_status=success"
	echo [32mSpicetify başarıyla yüklendi.[0m
	call :wait
	exit /b 0
)
set "spicetify_install_status=error"
echo [31mSpicetify yüklenemedi.[0m
call :wait
exit /b 0

:uninstall_spicetify
cls & echo ╔═════════════════════╗ & echo ║ Spicetify Uninstall ║ & echo ╚═════════════════════╝
if not exist "%localappdata%\spicetify\spicetify.exe" (
	set "spicetify_uninstall_status=skip"
	echo [36mSpicetify yüklü değil, kaldırılamıyor.[0m
	call :wait
	exit /b 0
)
call :run stop_spotify || exit /b 1
echo Spicetify kaldırılıyor...
rd /s /q "%appdata%\spicetify" >nul 2>&1
rd /s /q "%localappdata%\spicetify" >nul 2>&1
if not exist "%localappdata%\spicetify\spicetify.exe" (
	set "spicetify_uninstall_status=success"
	echo [32mSpicetify başarıyla kaldırıldı.[0m
	call :wait
	exit /b 0
)
set "spicetify_uninstall_status=error"
echo [31mSpicetify kaldırılamadı.[0m
call :wait
exit /b 0

:update_spicetify
cls & echo ╔══════════════════╗ & echo ║ Spicetify Update ║ & echo ╚══════════════════╝
if not exist "%appdata%\Spotify\Spotify.exe" (
	set "spicetify_update_status=error"
	echo [31mSpotify yüklü değil, Spicetify güncellenemez.[0m
	call :wait
	exit /b 0
)
if not exist "%localappdata%\spicetify\spicetify.exe" (
	set "spicetify_update_status=error"
	echo [31mSpicetify yüklü değil, Güncellenemez.[0m
	call :wait
	exit /b 0
)
call :run stop_spotify || exit /b 1
echo Spicetify güncelleniyor...
for /f %%a in ('""%localappdata%\spicetify\spicetify.exe"" --version') do (set "old_spi_ver=%%a")
powershell -ExecutionPolicy RemoteSigned -Command "spicetify upgrade"
timeout /t 2 /nobreak >nul 2>&1
for /f %%a in ('""%localappdata%\spicetify\spicetify.exe"" --version') do (set "new_spi_ver=%%a")
if "!old_spi_ver!" NEQ "!new_spi_ver!" (
	set "spicetify_update_status=success"
	echo [32mSpicetify başarıyla güncellendi:[0m '!old_spi_ver!' [90m-^>[0m '!new_spi_ver!'
	call :wait
	exit /b 0
)
set "spicetify_update_status=warn"
echo [33mSpicetify güncellenemedi veya zaten güncel:[0m '!old_spi_ver!' [90m-^>[0m '!new_spi_ver!'
call :wait
exit /b 0

:stop_spotify
set "stop_retry=1"
set "stop_max=5"
:retry_stop
tasklist | findstr /i "Spotify.exe" >nul 2>&1
if !errorlevel! EQU 0 (
	if !stop_retry! EQU 1 (
		echo Spotify durduruluyor...
	) else (
		echo [33mSpotify durdurulamadı, tekrar deneniyor...[0m
	)
	set /a "stop_wait=stop_retry*2"
	taskkill /im "Spotify.exe" /f /t >nul 2>&1
	timeout /t !stop_wait! /nobreak >nul 2>&1
	if !stop_retry! GEQ !stop_max! (
		echo [31mSpotify !stop_retry! kez denemenin ardından durdurulamadı, Spotify'ı manuel olarak kapatmayı deneyin.[0m
		call :wait
		exit /b 1
	)
	set /a "stop_retry+=1"
	goto :retry_stop
)
if !stop_retry! EQU 1 (
	echo [36mSpotify zaten durdurulmuş.[0m
) else (
	echo [32mSpotify başarıyla durduruldu.[0m
)
timeout /t %delay% /nobreak >nul 2>&1
exit /b 0

:wait
if "%pause%" EQU "true" (
	echo Devam etmek için herhangi bir tuşa basın... & pause >nul 2>&1
) else (
	timeout /t %delay% /nobreak >nul 2>&1
)
exit /b 0

:symbol
set "varname=%~1"
set "value=%~2"
if "%value%" EQU "success" (
    set "%varname%=✔️"
) else if "%value%" EQU "error" (
    set "%varname%=❌"
) else if "%value%" EQU "warn" (
    set "%varname%=⚠️"
) else if "%value%" EQU "skip" (
    set "%varname%=⏩"
) else (
    set "%varname%=➖"
)
exit /b 0
