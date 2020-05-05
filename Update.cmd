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
    echo ������ ���� ९������ � �ࢥ�
    rd /s /q %maps_dir%
    git clone %maps_url% %maps_dir%
    if not ERRORLEVEL 0 goto err
    
    echo �����㥬 ����� � ९����ਥ� �� �������� � ⥪���� �����
    xcopy /i /s /h /e /y %maps_dir%\.git .\.git
    if not ERRORLEVEL 0 goto ErrorCopyGit
    
    echo ����塞 �६���� ᮧ������ ��������
    rd /s /q %maps_dir%
    if not ERRORLEVEL 0 goto ErrorRemoveTemp
    goto UpdateRepo
 
:UpdateRepo
    echo ������塞 䠩�� �� ��᫥���� ���ᨨ
    git clean -d --force
    git reset --hard
    goto end
    
:err
    echo �訡�� �裡 � �ࢥ஬
    goto end
    
:ErrorCopyGit
    echo �訡�� ����஢���� ����� .git 
    goto end
    
:ErrorRemoveTemp
    echo �訡�� 㤠����� �६����� ����� sas.maps 
    goto end
    
:NoGit
    echo �訡��: �� ��⠭����� Git
    goto end
    
:end
    pause