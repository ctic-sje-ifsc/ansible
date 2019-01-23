@ECHO Off
SETLOCAL EnableDelayedExpansion
SET HOME_ADM=""

REM Altere aqui. Pasta acessivel pelo administrador contendo os snapshots dos usuarios.
SET HOME_ADM=c:\users\administrador

Set /P USU=Digite o nome do usuario a desproteger:|| Set USU=vazio

IF "%USU%"=="vazio" ( ECHO Insira nome de usuario valido/existente.
GOTO :eof )

IF NOT EXIST %HOME_ADM%\backup\%USU% ( ECHO Usuario atualmente desprotegido.
GOTO :eof )

schtasks /delete /tn restaura-padrao-%USU% /F
RD /S /Q %HOME_ADM%\backup\%USU%
ECHO Usuario %USU% desprotegido.
