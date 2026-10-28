@echo off
chcp 932 >nul
cd /d "%~dp0"
rem ============================================
rem 調査結果をあてる
rem   1つ上の階層の「調査結果」とREADME.mdを
rem   ハッカソン\①調査 へコピーします
rem   既存の①調査は _archive へ移します。削除はしません
rem ============================================
echo 調査結果を ハッカソン\①調査 へコピーします
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

set "SRC=%~dp0.."
if not exist "%SRC%\調査結果\" goto NG_SRC
if not exist "%SRC%\README.md" goto NG_SRC

rem ---- 既存の①調査を退避 ----
if not exist "%HK%\①調査\" goto COPY
if not exist "%HK%\_archive\" mkdir "%HK%\_archive"
move "%HK%\①調査" "%HK%\_archive\①調査_%TS%" >nul
if errorlevel 1 goto NG_MOVE
if exist "%HK%\①調査\" goto NG_MOVE
echo 前の①調査は _archive\①調査_%TS% へ移しました

:COPY
mkdir "%HK%\①調査"
robocopy "%SRC%\調査結果" "%HK%\①調査\調査結果" /E /NFL /NDL /NJH /NJS /NP >nul
if errorlevel 8 goto NG_COPY
copy /y "%SRC%\README.md" "%HK%\①調査\README.md" >nul
if errorlevel 1 goto NG_COPY

rem ---- ファイル数の照合 ----
set "N_SRC=0"
set "N_DST=0"
for /f %%n in ('dir /a-d /s /b "%SRC%\調査結果" 2^>nul ^| find /c /v ""') do set "N_SRC=%%n"
set /a N_SRC=N_SRC+1
for /f %%n in ('dir /a-d /s /b "%HK%\①調査" 2^>nul ^| find /c /v ""') do set "N_DST=%%n"
if not "%N_SRC%"=="%N_DST%" goto NG_COUNT

echo.
echo OK: ①調査へ %N_DST% ファイルをコピーしました。元 %N_SRC% 件と一致しています
goto END

:NG_SRC
echo NG: コピー元の調査結果またはREADME.mdが見つかりません。何もせず、この画面を見せてください
goto END

:NG_MOVE
echo NG: 既存の①調査を_archiveへ移せませんでした。何もせず、この画面を見せてください
goto END

:NG_COPY
echo NG: コピーに失敗しました。何もせず、この画面を見せてください
goto END

:NG_COUNT
echo NG: ファイル数が合いません 元 %N_SRC% 件 / コピー先 %N_DST% 件。何もせず、この画面を見せてください
goto END

:END
echo.
pause
