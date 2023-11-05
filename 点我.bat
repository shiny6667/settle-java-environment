@echo off
:: 检查是否以管理员权限运行
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 请以管理员权限运行此脚本
    pause
    exit
)

:: 获取当前脚本文件的目录
for %%I in ("%~dp0.") do set "SCRIPT_DIR=%%~fI"

:: 在脚本目录下执行后续操作
cd /d "%SCRIPT_DIR%"

:: 获取当前 `PATH` 的值
for /f "tokens=2,*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH') do (
    set "CURRENT_PATH=%%b"
)

:: 定义新的 Java 路径
set "JAVA_HOME=C:\Program Files\Java\jdk-20.0.2"

:: 将当前 `PATH` 保存到一个临时变量
set "TEMP_PATH=%CURRENT_PATH%"

:: 在当前 `PATH` 的基础上追加新的路径
set "NEW_PATH=%TEMP_PATH%;%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin"

:: 使用 setx 命令将新的 `PATH` 设置为系统环境变量
setx PATH "%NEW_PATH%" -m

echo 欢迎使用寻千百度工具箱
echo 本工具用来一键配置Java环境

if exist "jdk-20.0.2" (
    echo 文件存在，正在进行下一步操作
    xcopy "jdk-20.0.2" "%JAVA_HOME%" /s /e /i
    del /q "jdk-20.0.2"

    echo 移动JDK成功！

    :: 设置 JAVA_HOME
    setx JAVA_HOME "%JAVA_HOME%" -m

    :: 设置 CLASSPATH
    setx CLASSPATH ".;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar;" -m
) else (
    echo 文件不存在，检查是否解压完整
)

pause
