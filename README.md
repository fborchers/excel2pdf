### Für Ungeduldige

Tabellen erscheinen in Markup-Sprachen nicht besonders übersichtlich (LaTeX, MarkDown, DokuWiki usw.). Auf der anderen Seite lassen sich Tabellen aus MS Excel oder LibreOffice nicht weiterverarbeiten. Das hier vorgestellte Makefile bietet einen Ansatz für letzteres an: Die Dateien aus dem Tabellenkalkulationsprogramm werden intern als `csv` zwischengespeichert und mit `pandoc` zu einem PDF umgewandelt.

Man kann so mit dem Besten aus beiden Welten arbeiten: die Übersicht des Tabellenkalkulationsprogramms, die Klarheit einer Markup-Sprache und die Schönheit eines mit LaTeX gesetzten PDF.

Entstanden ist das Tool aus dem Wunsch heraus, ein Curriculum mit Inhalten, Kompetenzen und Zeitangaben sauber zu setzen, das auch einige mathematische Formeln enthält. Das Beispiel zeigt die erste Seite eines solchen Curriculums.

Verwendung:

    make test 
    make pdf

Voraussetzung: LaTeX, LibreOffice, `pandoc`, `make`, `sed`.

## README

### Eingabeformat

Die Eingabe erfolgt über Tabellen im MS Excel-Format. Dies hat den Vorteil, dass die Tabellen sehr übersichtlich dargestellt werden und Inhalte (Zeilen) leicht von der einen Stelle an eine andere verschoben werden können. Alle Excel-Tabellen aus dem Unterordner `input/` werden in alphabetischer Reihenfolge angefügt.

Es werden genau fünf Spalten gesetzt, die erste Spalte bleibt frei (aus technischen Gründen).
Der Text der Tabellen hat entweder kein Markup (plain text) oder muss im [DokuWiki-Format](https://www.dokuwiki.org/wiki:syntax) eingegeben werden. Angefügt ist ein Beispiel, wie die Eingabedatei aussehen kann:

<img width="1151" height="380" alt="Image" src="https://github.com/user-attachments/assets/78b02117-294f-4f7d-92e1-1540bf76c79b" />



### PDF-Ausgabe

Die Ausgabe erfolgt als PDF im Querformat.

### Formeln

Formeln können in den Eingabedateien verwendet werden, man tippt die Formel in der Datei mit UTF8-Sonderzeichen ein, zum Beispiel a∙b = c∙d. Damit die Formel später von LaTeX richtig gesetzt wird, hinterlegt man in einem Nachschlagewerk den korrekten LaTeX-Code der Formel.
In der Datei `lib/dictionary.txt` werden die Formeln in UTF8-Sonderzeichen und in LaTeX-Code gesammelt. Sie sind durch ein `\t` voneinander getrennt. Der LaTeX-Code muss anstelle der backslashes `\` doppelte backslashes enthalten `\\`

### Beschreibung der Maschinerie (für Liebhaber)

Die Quelldatei wird mit LibreOffice über das Kommandozeileninterface

    soffice --headless --convert-to csv

zunächst nach `csv` übertragen. Daraus resultiert eine Datei im DokuWiki-Format, die mit `pandoc` nach LaTeX übertragen wird. Sobald alle Dateien in LaTeX-Format vorliegen, werden sie zusammen gesetzt und das PDF erzeugt.

Weil im DokuWiki-Format jediglich die Position der Pipe `|` über die Spalten entscheidet, ist es (auf den ersten Blick) besser als Markdown geeignet, die Tabelle abzubilden. Aus diesem Grund erfolgt die Eingabe im DokuWiki-Format und nicht als Markdown.

### Beispiel: ein Curriculum

Die oben abgebildete Eingabedatei ist als `ein-beispiel.xlsx` beigefügt. Sie enthält das Beispiel, eine Zeile aus einem Curriculum. Der Aufruf

    make pdf

setzt das Beispiel als PDF.

### Beispiel Deckblatt

Das Deckblatt kann angepasst werden, z.B. kann ein Inhaltsverzeichnis eingefügt werden.
Dies geschieht durch die Eingabe von LaTeX-Code in die Datei `lib/header.tex`. Anbei ein Beispiel, wie eine solche Datei aussehen kann:

    % Titelseite ---
    % \title{Titel meines Dokuments}% Titel
    % \author{Max Mustermann}
    % \maketitle

    % Titelseite selbst gemacht ---
    {\LARGE\textbf{Titel meines Dokuments}}% Titel


    % Inhaltsverzeichnis drucken ---
    \thispagestyle{empty}
    $\;$\vfill% nach unten schieben, falls gewünscht
    \tableofcontents

    % Zeile mit "Inhaltsverzeichnis" dem toc hinzufügen:
    \addcontentsline{toc}{subsection}{Inhaltsverzeichnis}
    \label{toc-anchor}% anchor to jump back to toc

    % Seitenzahl nach Inhaltsverzeichnis zurücksetzen,
    % falls gewünscht:
    \setcounter{page}{0}

Die Datei `lib/header.tex` wird nicht als Quelldatei mitgeliefert (aus dem einfachen Grund, dass die Datei sonst bei einem Update überschrieben werden könnte). Sie wird aber eingelesen, falls sie existiert.
