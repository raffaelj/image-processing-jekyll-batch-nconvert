@echo off & setlocal
:: image processing for galleries in jekyll blogs with NConvert on Windows 7
:: 
:: author: Raffael Jesche
:: license: free for all forever
:: source: https://github.com/raffaelj/image-processing-jekyll-batch-nconvert
:: 
:: # Umwandlung aller jpg-Dateien innerhalb eines Ordners in:
::  - /medium  500px breit // fixed width, default: 500px
::  - /large   1000px breit // fixed width, default: 1000px
::  - /thumbs  150 x 150px Thumbnails
::  - folder-name.md-Datei mit Galerieliste
::  - folder-name.yml-Datei mit Galerieliste
:: 
:: # Voraussetzungen:
::  - NConvert ist auf dem Computer vorhanden Download hier: http://www.xnview.com/de/nconvert/
::  - Lege einen Ordner mit dem Namen des Fotoalbums an, z. B. "Urlaub in Prag".
::    - Erstelle in diesem Ordner den Ordner "original" und lege dort alle Original-Bilder ab
::  - Dieses Script (convert.bat) muss in den Foto-Ordner kopiert werden
::  - Wenn gewünscht, muss eine Wasserzeichen-Datei in den Foto-Ordner kopiert werden
::
:: ## So sieht die Ordnerstruktur dann aus: // folder structure
:: 
::  Urlaub in Prag/
::  +-- original/
::  |   +-- bild01.jpg
::  |   +-- bild...jpg
::  |   +-- bild99.jpg
::  +-- convert.bat
::  +-- watermark.png
:: 
:: Jetzt starte die Datei "convert.bat". Der Rest passiert automatisch.
:: // Start "convert.bat" for automatic processing

:: 
:: Variablen // variables
::
:: Pfad zu NConvert setzen // path/to/NConvert
set "nc=C:\ProgrammePortable\NConvert\nconvert.exe"
:: Bildgröße // image sizes
set "MediumX=500"
set "MediumY=2000"
set "LargeX=1000"
set "LargeY=4000"
set "ThumbsXY=150"
:: jpg-Qualität // jpg quality
set "qualM=40"
set "qualL=40"
set "qualT=25"
:: Pfad zur Wasserzeichen-Datei
set "watermark=watermark.png"
:: Transparenz des Wasserzeichens // opacity of watermark
set "wmop=40"

:: Pfad zu Bildern für jekyll-Dateien
set "imgpath={{site.galpath}}{{page.album_folder}}"

:start
:: Umlaute richtig darstellen (cmd-default: 850) // German umlauts
chcp 1252
echo.
echo Image processing for jekyll galleries
echo =====================================
echo.

call :vartempfiles
call :copytempfiles
call :renaming
call :nconvert
call :jekyll
call :removetempfiles
goto :end


:vartempfiles
:: Name des Ordners, in dem die Batch-Datei liegt // current dir of batch file
for %%* in (.) do set CurrDirName=%%~nx*

:: Leerzeichen in CurrDirName ersetzen // replace whitespaces
set "FolderName=%CurrDirName: =-%"
set "FolderName=%FolderName:ä=ae%"
set "FolderName=%FolderName:ö=oe%"
set "FolderName=%FolderName:ü=ue%"
set "FolderName=%FolderName:ß=ss%"

set "tempFolder=temp-copy-of-original"

goto :eof

:copytempfiles
:: original in temp kopieren
echo copy originals into temp folder...
xcopy /i /y original %tempFolder%

goto :eof

:renaming
:: rename files in temp folder
echo.
echo renaming filenames...
for /f "delims=" %%a in ('dir /a:-d /o:n /b %tempFolder%') do call :rename "%%a"
::pause
goto :eof

:rename
set "oldname=%~nx1"
set "newname=%oldname%"

set "newname=%newname: =-%"
set "newname=%newname:)=-%"
set "newname=%newname:(=-%"
set "newname=%newname:&=-%"
set "newname=%newname:^=-%"
set "newname=%newname:$=-%"
set "newname=%newname:#=-%"
set "newname=%newname:@=-%"
set "newname=%newname:!=-%"
::set "newname=%newname:-=-%"
set "newname=%newname:+=-%"
set "newname=%newname:}=-%"
set "newname=%newname:{=-%"
set "newname=%newname:]=-%"
set "newname=%newname:[=-%"
set "newname=%newname:;=-%"
set "newname=%newname:'=-%"
set "newname=%newname:`=-%"
set "newname=%newname:,=-%"

set "newname=%newname:ä=ae%"
set "newname=%newname:ö=oe%"
set "newname=%newname:ü=ue%"
set "newname=%newname:ß=ss%"
set "newname=%newname:Ä=ae%"
set "newname=%newname:Ö=oe%"
set "newname=%newname:Ü=ue%"

set "newname=%newname:A=a%"
set "newname=%newname:B=b%"
set "newname=%newname:C=c%"
set "newname=%newname:D=d%"
set "newname=%newname:E=e%"
set "newname=%newname:F=f%"
set "newname=%newname:G=g%"
set "newname=%newname:H=h%"
set "newname=%newname:I=i%"
set "newname=%newname:J=j%"
set "newname=%newname:K=k%"
set "newname=%newname:L=l%"
set "newname=%newname:M=m%"
set "newname=%newname:N=n%"
set "newname=%newname:O=o%"
set "newname=%newname:P=p%"
set "newname=%newname:Q=q%"
set "newname=%newname:R=r%"
set "newname=%newname:S=s%"
set "newname=%newname:T=t%"
set "newname=%newname:U=u%"
set "newname=%newname:V=v%"
set "newname=%newname:W=w%"
set "newname=%newname:X=x%"
set "newname=%newname:Y=y%"
set "newname=%newname:Z=z%"

::echo ren temp\%1 "%newname%
ren "%tempFolder%\%oldname%" "%newname%"
echo file renamed from "%oldname%" to "%newname%"
echo.

goto :eof

:nconvert

:: 
:: NConvert-Konvertierungen // NConvert conversions
::
echo.

:: medium, 500px breit, Qualität 40% // width: 500px
%nc% -overwrite -out jpeg -o %FolderName%\medium\%%.jpg -ratio -rtype lanczos -resize %MediumX% %MediumY% -q %qualM% -wmflag center -wmopacity %wmop% -wmfile %watermark% %tempFolder%\*.jpg
echo.
echo created images (large)
echo.

:: large, 1000px breit, Qualität 40% // width: 1000px
%nc% -overwrite -out jpeg -o %FolderName%\large\%%.jpg -ratio -rtype lanczos -resize %LargeX% %LargeY% -q %qualL% -wmflag center -wmopacity %wmop% -wmfile %watermark% %tempFolder%\*.jpg
echo.
echo created images (medium)
echo.

:: Thumbnail 150x150 px // width & height: 150px
%nc% -overwrite -out jpeg -o %FolderName%\thumbs\%%.jpg -ratio -rtype lanczos -resize shortest %ThumbsXY% -q 100 %tempFolder%\*.jpg
%nc% -overwrite -out jpeg -o %FolderName%\thumbs\%%.jpg -canvas %ThumbsXY% %ThumbsXY% center -q %qualT% %FolderName%\thumbs\*.jpg
echo.
echo created images (thumbs)
echo.

goto :eof


:jekyll
::
:: Dateien für jekyll erstellen // files for jekyll
::

:: md-Datei erstellen // create .md

::set "mdName=%FolderName%"
set "mdName=index"

Type NUL >%FolderName%\%mdName%.md
>>%FolderName%\%mdName%.md echo ---
>>%FolderName%\%mdName%.md echo title: "%CurrDirName%"
>>%FolderName%\%mdName%.md echo date: %date:~6,4%-%date:~3,2%-%date:~0,2%
>>%FolderName%\%mdName%.md echo album_folder: /%FolderName%
>>%FolderName%\%mdName%.md echo ---
>>%FolderName%\%mdName%.md echo.
echo created %mdName%.md

:: Bilderliste in Markdown // image list in markdown
for /F "tokens=*" %%f in ('dir /b %FolderName%\thumbs') do (
 >>%FolderName%\%mdName%.md echo [![Bild]^(%imgpath%/thumbs/%%f^)]^(%imgpath%/large/%%f^)
)

:: yml-Datei erstellen // create .yml
Type NUL >%FolderName%\%FolderName%.yml
for /F "tokens=*" %%f in ('dir /b %FolderName%\thumbs') do (
 >>%FolderName%\%FolderName%.yml echo - %%f
)
echo created %FolderName%.yml

goto :eof

:removetempfiles
rd /s /q %tempFolder%
goto :eof

:end