@echo off
chcp 932 >nul
cd /d "%~dp0"
rem ============================================
rem 調査結果を戻す
rem   ハッカソン\①調査 を _archive\①調査_日付時刻 へ移します
rem   削除はしません
rem ============================================
echo ハッカソン\①調査 を _archive へ移します
echo.

set "HK="
if exist "%USERPROFILE%\Desktop\ハッカソン\" goto P1
if not defined OneDrive goto NOTFOUND
if exist "%OneDrive%\Desktop\ハッカソン\" goto P2
if exist "%OneDrive%\デスクトップ\ハッカソン\" goto P3
goto NOTFOUND

:P1
set "HK=%USERPROFILE%\Desktop\ハッカソン"
goto FOUND
:P2
set "HK=%OneDrive%\Desktop\ハッカソン"
goto FOUND
:P3
set "HK=%OneDrive%\デスクトップ\ハッカソン"
goto FOUND

:NOTFOUND
echo NG: ハッカソンフォルダが見つかりません。この画面を見せてください
goto END

:FOUND
echo ハッカソンフォルダ: %HK%

rem ---- 日付時刻 ----
set "TS=%date:/=%_%time::=%"
set "TS=%TS: =0%"
set "TS=%TS:.=%"
for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss" 2^>nul`) do set "TS=%%i"

if not exist "%HK%\①調査\" goto NG_NONE
if not exist "%HK%\_archive\" mkdir "%HK%\_archive"
move "%HK%\①調査" "%HK%\_archive\①調査_%TS%" >nul
if errorlevel 1 goto NG_MOVE
if exist "%HK%\①調査\" goto NG_MOVE
if not exist "%HK%\_archive\①調査_%TS%\" goto NG_MOVE

echo.
echo OK: ①調査を _archive\①調査_%TS% へ移しました
goto END

:NG_NONE
echo NG: ハッカソン\①調査 が見つかりません。何もせず、この画面を見せてください
goto END

:NG_MOVE
echo NG: ①調査を_archiveへ移せませんでした。何もせず、この画面を見せてください
goto END

:END
echo.
pause
