@echo off
REM Vérifier si le tag a été fourni
if "%1"=="" (
    echo Error : Not tag specified.
    echo Usage : build.cmd <tag> push
    exit /b 1
)

echo Build Asterisk image registry.thelis.be:5001/thelis/asterisk:%1

if "%2"=="push" (
    echo Push option specified, image will be pushed after build
)

:confirm
choice /c YN /n /m "Proceed ? (Y/N)"
if errorlevel 2 goto no
if errorlevel 1 goto yes

:yes
docker build --pull --force-rm -t registry.thelis.be:5001/thelis/asterisk:%1 --file .\debian\%1\Dockerfile debian\%1

if "%2"=="push" (
    docker push registry.thelis.be:5001/thelis/asterisk:%1
)
goto end

:no
echo Build cancelled
exit /b 1

:end
