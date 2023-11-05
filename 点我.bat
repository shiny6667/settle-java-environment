@echo off
:: ����Ƿ��Թ���ԱȨ������
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ���Թ���ԱȨ�����д˽ű�
    pause
    exit
)

:: ��ȡ��ǰ�ű��ļ���Ŀ¼
for %%I in ("%~dp0.") do set "SCRIPT_DIR=%%~fI"

:: �ڽű�Ŀ¼��ִ�к�������
cd /d "%SCRIPT_DIR%"

:: ��ȡ��ǰ `PATH` ��ֵ
for /f "tokens=2,*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH') do (
    set "CURRENT_PATH=%%b"
)

:: �����µ� Java ·��
set "JAVA_HOME=C:\Program Files\Java\jdk-20.0.2"

:: ����ǰ `PATH` ���浽һ����ʱ����
set "TEMP_PATH=%CURRENT_PATH%"

:: �ڵ�ǰ `PATH` �Ļ�����׷���µ�·��
set "NEW_PATH=%TEMP_PATH%;%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin"

:: ʹ�� setx ����µ� `PATH` ����Ϊϵͳ��������
setx PATH "%NEW_PATH%" -m

echo ��ӭʹ��Ѱǧ�ٶȹ�����
echo ����������һ������Java����

if exist "jdk-20.0.2" (
    echo �ļ����ڣ����ڽ�����һ������
    xcopy "jdk-20.0.2" "%JAVA_HOME%" /s /e /i
    del /q "jdk-20.0.2"

    echo �ƶ�JDK�ɹ���

    :: ���� JAVA_HOME
    setx JAVA_HOME "%JAVA_HOME%" -m

    :: ���� CLASSPATH
    setx CLASSPATH ".;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar;" -m
) else (
    echo �ļ������ڣ�����Ƿ��ѹ����
)

pause
