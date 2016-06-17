# image processing for galleries in jekyll blogs with NConvert on Windows

author: Raffael Jesche  
license: free for all forever

Anleitung und Kommentare sind auch im Script selbst vorhanden  
getestet mit Windows 7 und cmd.exe mit deutscher Sprach-Umgebung  
// you can find manual and comments in the script  
// tested with Windows 7 and cmd.exe with German environment

## Umwandlung aller jpg-Dateien innerhalb eines Ordners in:
 - /medium  500px breit // fixed width, default: 500px
 - /large   1000px breit // fixed width, default: 1000px
 - /thumbs  150 x 150px Thumbnails
 - folder-name.md-Datei mit Galerieliste
 - folder-name.yml-Datei mit Galerieliste

## Voraussetzungen:
 - NConvert ist auf dem Computer vorhanden Download hier: http://www.xnview.com/de/nconvert/
 - Lege einen Ordner mit dem Namen des Fotoalbums an, z. B. "Urlaub in Prag".
   - Erstelle in diesem Ordner den Ordner "original" und lege dort alle Original-Bilder ab
 - Dieses Script (convert.bat) muss in den Foto-Ordner kopiert werden
 - Wenn gewünscht, muss eine Wasserzeichen-Datei in den Foto-Ordner kopiert werden
 - Umlaute wie ä,ö,ü,ß mag das Script nicht. Die Dateiumwandlungen sollten zwar auch mit 
   Sonderzeichen funktionieren, aber die Textausgaben (.md u. .yml) müssen anschließend
   nochmal per Hand angepasst werden
 - Leerzeichen in Dateinamen sollten allgemein vermieden werden, funktionieren aber in der Umwandlung

### So sieht die Ordnerstruktur dann aus: // folder structure

 Urlaub in Prag/
 +-- original/
 |   +-- bild01.jpg
 |   +-- bild...jpg
 |   +-- bild99.jpg
 +-- convert.bat
 +-- watermark.png

Jetzt starte die Datei "convert.bat". Der Rest passiert automatisch.
// Start "convert.bat" for automatic processing


## to do

- Dateinamensumwandlungen
  - [ ] Umlaute (äöüß zu ae,ss...)
  - [ ] Leerzeichen zu Unterstrichen
  - [ ] sonstige Sonderzeichen, die Windows erlaubt, aber nichts auf Webseiten zu suchen haben
- generierte md-Datei sinnvoll anpassen
  - [ ] Verlinkung von `thumbs` zu `large`
  - [ ] Albumname als Unterordner einfügen
- [ ] evtl. json-Datei erstellen