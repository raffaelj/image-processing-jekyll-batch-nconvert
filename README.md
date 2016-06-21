# image processing for galleries in jekyll blogs with NConvert on Windows

author: Raffael Jesche  
license: free for all forever

// most parts of this text are translated into English

Anleitung und Kommentare sind auch im Script selbst vorhanden  
getestet mit Windows 7 und cmd.exe mit deutscher Sprach-Umgebung  
// you can find manual and comments in the script  
// tested with Windows 7 and cmd.exe with German environment

## Umwandlung aller jpg-Dateien innerhalb eines Ordners in: // processing all jpg-files in a folder
 - /medium  500px breit // fixed width, default: 500px
 - /large   1000px breit // fixed width, default: 1000px
 - /thumbs  150 x 150px Thumbnails
 - index.md-Datei mit Galerieliste
 - folder-name.yml-Datei mit Galerieliste

## Voraussetzungen: // requirements
 - NConvert ist auf dem Computer vorhanden
   - und liegt im Ordner `C:\ProgrammePortable\NConvert\nconvert.exe`
   - --> oder du änderst den Pfad zu NConvert direkt im Script (1. Variable nach dem Info-Teil)
   - --> // or define your path variable in the script. It's the first one after the info part.
   - Download hier: http://www.xnview.com/de/nconvert/
 - Lege einen Ordner mit dem Namen des Fotoalbums an, z. B. "Urlaub in Prag".
   - Erstelle in diesem Ordner den Ordner `original` und lege dort alle Original-Bilder ab
 - Dieses Script `convert.bat` muss in den Foto-Ordner kopiert werden
 - Wenn gewünscht, muss eine Wasserzeichen-Datei in den Foto-Ordner kopiert werden

### So sieht die Ordnerstruktur dann aus: // folder structure

```
 Urlaub in Prag/
 +-- original/
 |   +-- bild01.jpg
 |   +-- bild...jpg
 |   +-- bild99.jpg
 +-- convert.bat
 +-- watermark.png
```

Jetzt starte die Datei `convert.bat`. Der Rest passiert automatisch.
// Start `convert.bat` for automatic processing

### Ordnerstruktur nach der Konvertierung // folder structure after conversion

```
 Urlaub in Prag/
 +-- original/
 |   +-- bild01.jpg
 |   +-- bild...jpg
 |   +-- bild99.jpg
 +-- urlaub-in-prag/
 |   +-- large/
 |   |   +-- bild01.jpg
 |   |   +-- bild...jpg
 |   |   +-- bild99.jpg
 |   +-- medium/
 |   |   +-- bild01.jpg
 |   |   +-- bild...jpg
 |   |   +-- bild99.jpg
 |   +-- thumbs/
 |   |   +-- bild01.jpg
 |   |   +-- bild...jpg
 |   |   +-- bild99.jpg
 |   +-- index.md
 |   +-- urlaub-in-prag.yml
 +-- convert.bat
 +-- watermark.png
```

### Copy Paste zu jekyll

Der frisch erstellte Ordner kann nun direkt in den jekyll-Galerie-Ordner kopiert werden.

Damit die generierten Links in der md-Datei funktonieren, muss zuvor der Ordner `_galerie` erstellt worden sein und in der `config.yml` müssen folgende Variablen eingetragen sein:

config.yml

```yaml
galpath: /gallery

collections:
  gallery:
    output: true
    permalink: /gallery/:path/
```

_layouts/gallery.html

```
---
layout: default
---

{{ content }}

<div class="gallery">
{% for item in page.images %}
  <a href="{{site.galpath}}{{page.album_folder}}/large/{{item.image}}" data-lightbox="{{ item.title }}">
    <img alt="Bild" class="thumbs" src="{{site.galpath}}{{page.album_folder}}/thumbs/{{item.image}}" />
  </a>
{% endfor %}
</div>

```


## to do

- NConvert
  - [ ] für Web optimieren (Metadaten löschen etc.)
  - [x] Rotation nach Exif-Tag
- [ ] englische Übersetzung vollständig
- Dateinamensumwandlungen
  - [x] Umlaute (äöüß zu ae,ss...)
  - [x] Leerzeichen zu Minuszeichen
  - [x] sonstige Sonderzeichen, die Windows erlaubt, aber nichts auf Webseiten zu suchen haben
  - [ ] rename-submodule auch auf Ordner anwenden
  - [x] prevent jekyll specific filename correlation https://help.github.com/articles/files-that-start-with-an-underscore-are-missing/
- generierte md-Datei sinnvoll anpassen
  - [x] Verlinkung von `thumbs` zu `large`
  - [x] `class="gallery"` und `data-lightbox="album_name"` setzen --> via include und layout files
- [ ] verschachtelte Alben verarbeiten (z. B. /wunderland/malusion + /wunderland/wundersprueh + ...)
- [ ] evtl. json-Datei erstellen