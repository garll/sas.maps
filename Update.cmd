@echo off
hg incoming "https://bitbucket.org/garl/plus.zmp/"
::echo %ERRORLEVEL%
IF ERRORLEVEL 9009 goto NoHg
IF ERRORLEVEL 2 goto err
IF ERRORLEVEL 1 goto noupdates
IF ERRORLEVEL 0 goto ok

goto err

:ok
        echo Забраем изменения из репозитория
        hg pull "https://bitbucket.org/garl/plus.zmp/" -u -f
        IF ERRORLEVEL 1 goto err
        IF NOT ERRORLEVEL 0 goto err
        call BuildZMmp.cmd
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