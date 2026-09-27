@echo off
echo ========================================================
echo   Pengunggah Otomatis Game Tahfizh ke GitHub Pages
echo ========================================================
echo.
set /p REPO_URL="Masukkan URL Repositori GitHub Anda (contoh: https://github.com/username/game-tahfizh.git): "

if "%REPO_URL%"=="" (
    echo [ERROR] URL Repositori tidak boleh kosong!
    pause
    exit /b
)

echo.
echo [1/5] Menginisialisasi Git lokal...
git init

echo [2/5] Menambahkan seluruh file...
git add .

echo [3/5] Membuat commit pertama...
git commit -m "Deploy Game Tahfizh PWA ke GitHub Pages"

echo [4/5] Mengatur branch ke main...
git branch -M main

echo [5/5] Mengirim kode ke GitHub...
git remote remove origin 2>nul
git remote add origin %REPO_URL%
git push -u origin main --force

echo.
echo ========================================================
echo  ALHAMDULILLAH! Kode berhasil diupload ke GitHub.
echo ========================================================
echo  Sekarang buka Settings ^> Pages di GitHub, dan opsi
echo  GitHub Actions / branch main sudah muncul!
echo.
pause
