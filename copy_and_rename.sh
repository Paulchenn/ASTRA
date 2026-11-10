#!/bin/bash
# ==============================================================================
# Name        : copy_and_rename.sh
# Beschreibung: Erstellt eine datumsstempel- und versionsbasierte Kopie von main.pdf.
#               Wird eine Version wie V1 oder V3 übergeben, ermittelt das Skript
#               automatisch die nächste Unternummerierung (z. B. V1_1 -> V1_2).
# Voraussetzung: Bash, GNU coreutils (date, cp)
# Ausführung  : chmod +x copy_and_rename.sh && ./copy_and_rename.sh [Version]
# Beispiel    : ./copy_and_rename.sh V1
#               Ausgabe: Kopie erstellt: 20261015_MA_MAFSiM_V1_1.pdf
# ==============================================================================

VERSION="${1:-V1}"

# Normalisieren: "1" -> "V1", "v1" -> "V1"
if [[ "$VERSION" =~ ^[0-9]+$ ]]; then
    VERSION="V$VERSION"
elif [[ "$VERSION" =~ ^[vV]([0-9]+)$ ]]; then
    VERSION="V${BASH_REMATCH[1]}"
fi

SRC="main.pdf"

# Prüfen ob Quelldatei existiert
if [ ! -f "$SRC" ]; then
    echo "Fehler: '$SRC' wurde im aktuellen Verzeichnis nicht gefunden." >&2
    exit 1
fi

# Aktuelles Datum im Format yyyyMMdd
TODAY=$(date +"%Y%m%d")

if [ "$VERSION" = "DRAFT" ]; then
    DST="${TODAY}_MA_MAFSiM_DRAFT.pdf"
else
    MAX_MINOR=0
    for f in *MA_MAFSiM_${VERSION}*.pdf; do
        [ -e "$f" ] || continue
        if [[ "$f" =~ _MA_MAFSiM_${VERSION}_([0-9]+)\.pdf$ ]]; then
            num="${BASH_REMATCH[1]}"
            if (( num > MAX_MINOR )); then
                MAX_MINOR=$num
            fi
        fi
    done

    NEXT_MINOR=$((MAX_MINOR + 1))
    DST="${TODAY}_MA_MAFSiM_${VERSION}_${NEXT_MINOR}.pdf"

    while [ -f "$DST" ]; do
        NEXT_MINOR=$((NEXT_MINOR + 1))
        DST="${TODAY}_MA_MAFSiM_${VERSION}_${NEXT_MINOR}.pdf"
    done
fi

# Datei kopieren
cp "$SRC" "$DST"
echo "Kopie erstellt: $DST"