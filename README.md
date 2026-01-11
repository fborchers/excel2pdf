### Für Ungeduldige

Tabellen erscheinen in Markup-Sprachen nicht besonders übersichtlich (LaTeX, MarkDown, DokuWiki usw.). Auf der anderen Seite lassen sich Tabellen aus MS Excel oder LibreOffice nicht weiterverarbeiten. Das hier vorgestellte Makefile bietet einen Ansatz für letzteres an: Die Dateien aus dem Tabellenkalkulationsprogramm werden intern als `csv` zwischengespeichert und mit `pandoc` zu einem PDF umgewandelt.

Man kann so mit dem Besten aus beiden Welten arbeiten: die Übersicht des Tabellenkalkulationsprogramms, die Klarheit einer Markup-Sprache und die Schönheit eines mit LaTeX gesetzten PDF.

Entstanden ist das Tool aus dem Wunsch heraus, ein Curriculum mit Inhalten, Kompetenzen und Zeitangaben sauber zu setzen, das auch einige mathematische Formeln enthält. Das Beispiel zeigt die erste Seite eines solchen Curriculums.

## README

### Eingabeformat

Die Eingabe erfolgt über Tabellen im MS Excel-Format. Dies hat den Vorteil, dass die Tabellen sehr übersichtlich dargestellt werden und Inhalte (Zeilen) leicht von der einen Stelle an eine andere verschoben werden können.

Es werden genau fünf Spalten gesetzt, die erste Spalte bleibt frei (aus technischen Gründen).
Der Text der Tabellen hat entweder kein Markup (plain text) oder muss im DokuWiki-Format eingegeben werden.

### PDF-Ausgabe

Die Ausgabe erfolgt als PDF im Querformat:

### Formeln

Formeln können in den Eingabedateien verwendet werden, man tippt die Formel in der Datei mit UTF8-Sonderzeichen ein, zum Beispiel a∙b = c∙d. Damit die Formel später von LaTeX richtig gesetzt wird, hinterlegt man in einem Nachschlagewerk den korrekten LaTeX-Code der Formel.
In der Datei `lib/dictionary.txt` werden die Formeln in UTF8-Sonderzeichen und in LaTeX-Code gesammelt. Sie sind durch ein `\t` voneinander getrennt. Der LaTeX-Code muss anstelle der backslashes `\` doppelte backslashes enthalten `\\`

### Beispiel: ein Curriculum

### Beschreibung der Maschinerie (für Liebhaber)

Weil im DokuWiki-Format jediglich die Position der Pipe `|` über die Spalten entscheidet, ist es (auf den ersten Blick) besser als Markdown geeignet, die Tabelle abzubilden.
