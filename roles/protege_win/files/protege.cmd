@ECHO Off

SETLOCAL EnableDelayedExpansion
SET HOME_ADM=""

REM Altere aqui. Pasta acessivel pelo administrador contendo os snapshots dos usuarios.
SET HOME_ADM=c:\users\administrador

Set /P USU=Digite o nome do usuario a proteger:|| Set USU=vazio

IF "%USU%"=="vazio" ( ECHO Insira nome de usuario valido/existente.
GOTO :eof )

IF NOT EXIST %SystemDrive%\Users\%USU% ( ECHO Insira nome de usuario valido/existente.
GOTO :eof )

FOR /F "tokens=1,2 delims==" %%s IN ('wmic path win32_useraccount where name^='%USU%' get sid /value ^| find /i "SID"') DO SET SID=%%t

REM usuarios que não serão protegidos.
IF %USU% == ifsc ( ECHO Usuario informado nao sera protegido.
GOTO :eof )
IF %USU% == Administrador ( ECHO Usuario informado nao sera protegido.
GOTO :eof )

SET BACKUP=""
SET BACKUP_USU=""

SET BACKUP=%HOME_ADM%\backup
SET BACKUP_USU=%HOME_ADM%\backup\%USU%

IF EXIST %BACKUP_USU% ( ECHO Usuario atualmente protegido.
GOTO :eof )

MD %BACKUP_USU%\job %BACKUP_USU%\reg
COPY /B /Y ln.exe %BACKUP%\ln.exe

ECHO ^@ECHO Off > %BACKUP_USU%\job\faz-copia.cmd
ECHO %BACKUP%\ln.exe --backup --copy %SystemDrive%\users\%USU% %BACKUP_USU%\arq >> %BACKUP_USU%\job\faz-copia.cmd
ECHO %BACKUP%\ln.exe --backup --copy %SystemDrive%\$recycle.bin\%SID% %BACKUP_USU%\lixeira >> %BACKUP_USU%\job\faz-copia.cmd
ECHO REG LOAD HKU\temp "%SystemDrive%\Users\%USU%\NTUSER.DAT" >> %BACKUP_USU%\job\faz-copia.cmd
ECHO REG SAVE HKU\temp %BACKUP_USU%\reg\reg.hiv >> %BACKUP_USU%\job\faz-copia.cmd
ECHO REG UNLOAD HKU\temp >> %BACKUP_USU%\job\faz-copia.cmd

CALL %BACKUP_USU%\job\faz-copia.cmd

ECHO ^@ECHO Off > %BACKUP_USU%\job\restaura-copia.cmd
ECHO REG LOAD HKU\temp "%SystemDrive%\Users\%USU%\NTUSER.DAT" >> %BACKUP_USU%\job\restaura-copia.cmd
ECHO REG RESTORE HKU\temp %BACKUP_USU%\reg\reg.hiv >> %BACKUP_USU%\job\restaura-copia.cmd
ECHO REG UNLOAD HKU\temp >> %BACKUP_USU%\job\restaura-copia.cmd
ECHO %BACKUP%\ln.exe --mirror %BACKUP_USU%\arq %SystemDrive%\users\%USU% >> %BACKUP_USU%\job\restaura-copia.cmd
ECHO %BACKUP%\ln.exe --mirror %BACKUP_USU%\lixeira %SystemDrive%\$recycle.bin\%SID% >> %BACKUP_USU%\job\restaura-copia.cmd

schtasks /create /tn restaura-padrao-%USU% /tr %BACKUP_USU%\job\restaura-copia.cmd /sc ONSTART /ru "System"

REM não altere a posicao das virgulas/espaços da linha abaixo.
RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters ,1 ,True

REM muda codepage para aceitar acentos nas linhas seguintes.
for /f "tokens=2 delims=:." %%x in ('chcp') do set cp=%%x
chcp 1252>nul
ICACLS %SYSTEMDRIVE%\ /remove:g "Authenticated Users" /q
ICACLS %SYSTEMDRIVE%\ /remove:g "Usuários Autenticados" /q
chcp %cp%>nul