@echo off
:: Sprawdź, czy Node.js jest zainstalowane
node -v >nul 2>nul
if %errorlevel% neq 0 (
    echo Node.js nie jest zainstalowane, pobieram i instaluję...
    
    :: Pobierz instalator Node.js (64-bitowa wersja dla Windows)
    powershell -Command "Invoke-WebRequest -Uri https://nodejs.org/dist/v22.11.0/node-v22.11.0-x64.msi -OutFile nodejs-installer.msi"
    
    :: Upewnij się, że plik został pobrany
    if exist "nodejs-installer.msi" (
        echo Instalator Node.js został pobrany.
        
        :: Uruchom instalator Node.js za pomocą msiexec, aby wybrać ścieżkę instalacji
        msiexec /i "nodejs-installer.msi"
    ) else (
        echo Błąd: nie udało się pobrać instalatora Node.js.
    )
) else (
    echo Node.js jest już zainstalowane.
)
:: Poproś użytkownika o nazwę projektu
set /p project_name="Podaj nazwę projektu: "

:: Ścieżka do pulpitu na OneDrive
set desktop_path=%userprofile%\OneDrive\Pulpit

:: Wyświetl ścieżkę, aby upewnić się, że jest poprawna
echo Sciezka do pulpitu: %desktop_path%

:: Sprawdź, czy folder już istnieje, a jeśli nie, to utwórz
if exist "%desktop_path%\%project_name%" (
    echo Folder "%project_name%" już istnieje.
) else (
    echo Tworzę folder "%project_name%"...
    mkdir "%desktop_path%\%project_name%"
)

:: Upewnij się, że folder został utworzony
echo Sprawdzanie folderu "%desktop_path%\%project_name%"...
dir "%desktop_path%\%project_name%"

:: Przechodzimy do nowo utworzonego folderu
cd "%desktop_path%\%project_name%"

:: Tworzymy plik package.json
echo {"name": "%project_name%", "version": "1.0.0", "description": "Nowy projekt", "main": "Project.js", "scripts": {"start": "node Project.js"}} > package.json
echo package.json utworzony.

:: Tworzymy plik Project.js
echo const fs = require('fs'); >> Project.js
echo const path = require('path'); >> Project.js
echo const fileName = 'Project.txt'; >> Project.js
echo const fileContent = 'To jest plik tekstowy utworzony przez projekt %project_name%. '; >> Project.js
echo const desktopPath = path.join(process.env.USERPROFILE, 'OneDrive', 'Pulpit', fileName); >> Project.js
echo fs.writeFileSync(desktopPath, fileContent); >> Project.js
echo console.log('Plik "%project_name%.txt" utworzony na Pulpicie.'); >> Project.js
echo Project.js utworzony.

:: Powiedz użytkownikowi, że projekt został utworzony
echo Projekt "%project_name%" został utworzony na Pulpicie!
pause