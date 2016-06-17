:: image processing for galleries in jekyll blogs with NConvert on Windows 7
:: 
:: author: Raffael Jesche
:: license: free for all forever
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
::  - Umlaute wie ä,ö,ü,ß mag das Script nicht. Die Dateiumwandlungen sollten zwar auch mit 
::    Sonderzeichen funktionieren, aber die Textausgaben (.md u. .yml) müssen anschließend
::    nochmal per Hand angepasst werden
::  - Leerzeichen in Dateinamen sollten allgemein vermieden werden, funktionieren aber in der Umwandlung
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
set nc=C:\ProgrammePortable\NConvert\nconvert.exe
:: Bildgröße // image sizes
set MediumX=500
set MediumY=2000
set LargeX=1000
set LargeY=4000
set ThumbsXY=150
:: jpg-Qualität // jpg quality
set qualM=40
set qualL=40
set qualT=40
:: Transparenz des Wasserzeichens // opacity of watermark
set wmop=60

:: Umlaute richtig darstellen (cmd-default: 850) // German umlauts
chcp 1252

:: 
:: NConvert-Konvertierungen // NConvert conversions
::

:: medium, 500px breit, Qualität 40% // width: 500px
%nc% -overwrite -out jpeg -o medium\%%.jpg -ratio -rtype lanczos -resize %MediumX% %MediumY% -q %qualM% -wmflag center -wmopacity %wmop% -wmfile watermark.png original\*.jpg

:: large, 1000px breit, Qualität 40% // width: 1000px
%nc% -overwrite -out jpeg -o large\%%.jpg -ratio -rtype lanczos -resize %LargeX% %LargeY% -q %qualL% -wmflag center -wmopacity %wmop% -wmfile watermark.png original\*.jpg

:: Thumbnail 150x150 px // width & height: 150px
%nc% -overwrite -out jpeg -o thumbs\%%.jpg -ratio -rtype lanczos -resize shortest %ThumbsXY% -q %qualT% original\*.jpg
%nc% -overwrite -out jpeg -o thumbs\%%.jpg -canvas %ThumbsXY% %ThumbsXY% center thumbs\*.jpg

::
:: Dateien für jekyll erstellen // files for jekyll
::

:: Name des Ordners, in dem die Batch-Datei liegt // current dir of batch file
for %%* in (.) do set CurrDirName=%%~nx*

:: Leerzeichen in CurrDirName ersetzen // replace whitespaces
set FolderName=%CurrDirName: =-%

:: md-Datei erstellen // create .md
Type NUL >%FolderName%.md
>>%FolderName%.md echo ---
>>%FolderName%.md echo title: %CurrDirName%
>>%FolderName%.md echo date: %date:~6,4%-%date:~3,2%-%date:~0,2%
>>%FolderName%.md echo ---
>>%FolderName%.md echo.

:: Bilderliste in Markdown // image list in markdown
for /F "tokens=*" %%f in ('dir /b thumbs') do (
 >>%FolderName%.md echo ![Bild]^({{site.imgpath}}%%f^)
)

:: yml-Datei erstellen // create .yml
Type NUL >%FolderName%.yml
for /F "tokens=*" %%f in ('dir /b thumbs') do (
 >>%FolderName%.yml echo - %%f
)