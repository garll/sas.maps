@echo off
hg incoming "https://bitbucket.org/sas_team/sas.maps/"
::echo %ERRORLEVEL%
IF ERRORLEVEL 9009 goto NoHg
IF ERRORLEVEL 2 goto err
IF ERRORLEVEL 1 goto noupdates
IF ERRORLEVEL 0 goto ok
IF ERRORLEVEL -1 goto CloneRepo

goto err

:ok
        echo Забираем изменения из репозитория
        hg pull "https://bitbucket.org/sas_team/sas.maps/" -u -f
        IF ERRORLEVEL 1 goto err
        IF NOT ERRORLEVEL 0 goto err
	for /R /D %%d in (*.zmp) do rd /q %%d 2> nul
        goto end
:CloneRepo
	rd /s /q sas.maps
	echo Делаем клон репозитория с сервера
	hg clone -U "https://bitbucket.org/sas_team/sas.maps/" sas.maps
        IF NOT ERRORLEVEL 0 goto err
	echo Копируем папку с репозиторием из подпапки в текущую папку
	move /Y sas.maps\.hg .\.hg
        IF NOT ERRORLEVEL 0 goto errMoveHg
	echo Удаляем временно созданную подпапку
	rd /s /q sas.maps
        IF NOT ERRORLEVEL 0 goto errRemoveTemp
	echo Обновляем файлы до последней версии
	hg update -c
        goto end
:noupdates
        echo Нет новых изменений
        goto end
:err
        echo Ошибка связи с сервером
        goto end
:errMoveHg
        echo Ошибка перемещения папки .hg 
        goto end
:errRemoveTemp
        echo Ошибка удаления временной папки sas.maps 
        goto end
:NoHg
        echo Не установлен Mercurial
        goto end
:end
pause