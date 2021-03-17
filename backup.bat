@echo off

 :: Definição das Variaveis
 set dbUser=
 set dbPassword=
 set backupDir="C:\backupMysqlServer\backup36"
 set mysqldump="C:\Program Files\MySQL\MySQL Server 5.7\bin\mysqldump.exe"
 set mysqlDataDir="C:\ProgramData\MySQL\MySQL Server 5.7\Data"
 set zip="C:\Program Files\7-Zip\7z.exe" 

 :: Captura a data do sistema
for /f "tokens=1-4 delims=/ " %%a IN ('DATE /T') do (set MYDATE=%%a%%b%%c%%d)

 :: Captura Hora do Sistema
for /f "tokens=1-2 delims=: " %%a IN ('TIME /T') do (set MYTIME=%%ah%%bm)

 echo dirName=%MYDATE%_%MYTIME%
 set dirName=%MYDATE%_%MYTIME%
 
 :: Muda para o diretorio do mysqlData
 pushd %mysqlDataDir%

 :: Realizando for com schemas do banco de dados
 for /d %%f in (*) do (

 if not exist %backupDir%\%dirName%\ (
      mkdir %backupDir%\%dirName%
 )
:: Realizando Dump dos arquivos do banco de dados
 %mysqldump% --host="localhost" --user=%dbUser% --password=%dbPassword% --single-transaction --add-drop-table --databases %%f > %backupDir%\%dirName%\%%f.sql

:: Compactando arquivos
 %zip% a -tgzip %backupDir%\%dirName%\%%f.sql.gz %backupDir%\%dirName%\%%f.sql

 del %backupDir%\%dirName%\%%f.sql
 )
 popd
