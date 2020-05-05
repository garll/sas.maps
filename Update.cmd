@echo off

set maps_dir=sas.maps
set maps_url="https://github.com/sasgis/sas.maps"

git fetch --verbose %maps_url%

echo %ERRORLEVEL%

if ERRORLEVEL 9009 goto NoGit
if ERRORLEVEL 128 goto CloneRepo
if ERRORLEVEL 0 goto UpdateRepo
if ERRORLEVEL -1 goto CloneRepo

goto err

:CloneRepo    
    echo Делаем клон репозитория с сервера
    rd /s /q %maps_dir%
    git clone %maps_url% %maps_dir%
    if not ERRORLEVEL 0 goto err
    
    echo Копируем папку с репозиторием из подпапки в текущую папку
    xcopy /i /s /h /e /y %maps_dir%\.git .\.git
    if not ERRORLEVEL 0 goto ErrorCopyGit
    
    echo Удаляем временно созданную подпапку
    rd /s /q %maps_dir%
    if not ERRORLEVEL 0 goto ErrorRemoveTemp
    goto UpdateRepo
 
:UpdateRepo
    echo Обновляем файлы до последней версии
    git clean -d --force
    git reset --hard
    goto end
    
:err
    echo Ошибка связи с сервером
    goto end
    
:ErrorCopyGit
    echo Ошибка копирования папки .git 
    goto end
    
:ErrorRemoveTemp
    echo Ошибка удаления временной папки sas.maps 
    goto end
    
:NoGit
    echo Ошибка: Не установлен Git
    goto end
    
:end
    pause