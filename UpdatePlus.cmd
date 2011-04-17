@echo off
hg incoming "https://bitbucket.org/garl/plus.maps/"
::echo %ERRORLEVEL%
IF ERRORLEVEL 9009 goto NoHg
IF ERRORLEVEL 2 goto err
IF ERRORLEVEL 1 goto noupdates
IF ERRORLEVEL 0 goto ok

goto err

:ok
        echo Забираем изменения из репозитория
        hg pull "https://bitbucket.org/garl/plus.maps/" -u -f
        IF ERRORLEVEL 1 goto err
        IF NOT ERRORLEVEL 0 goto err
rem        call BuildZMmp.cmd
        goto end
:noupdates
        echo Нет новых изменений
        goto end
:err
        echo Ошибка связи с сервером
        goto end
:NoHg
        echo Не установлен Mercurial
        goto end
:end
pause