<#
.SYNOPSIS
    Erstellt eine datumsstempel- und versionsbasierte Kopie der Datei main.pdf.

.DESCRIPTION
    Dieses Script kopiert die Datei main.pdf im aktuellen Verzeichnis
    und benennt die Kopie nach dem Schema yyyyMMdd_MA_MAFSiM_<Version>_<Subversion>.pdf.
    Wird eine Version wie V1 oder V3 übergeben, ermittelt das Skript
    automatisch die höchste vorhandene Unternummerierung und zählt sie um 1 hoch
    (z. B. V1 -> V1_1, V1_1 -> V1_2, V1_23 -> V1_24).

.PARAMETER Version
    Hauptversionsnummer (z. B. "V1", "V2", "V3" oder "1", "2"). Standardwert ist "V1".
    Auch "DRAFT" kann weiterhin übergeben werden.

.NOTES
    Dateiname   : copy_and_rename.ps1
    Voraussetzung: PowerShell 5.0 oder höher
    Ausführung  : .\copy_and_rename.ps1 [Version]

.EXAMPLE
    .\copy_and_rename.ps1 V1
    Ausgabe: Kopie erstellt: 20261015_MA_MAFSiM_V1_1.pdf

.EXAMPLE
    .\copy_and_rename.ps1 V3
    Ausgabe: Kopie erstellt: 20261015_MA_MAFSiM_V3_1.pdf
#>

param(
    [Parameter(Position = 0)]
    [string]$Version = "V1"
)

# Quelldatei prüfen
$src = "main.pdf"
if (-Not (Test-Path $src)) {
    Write-Error "Fehler: '$src' wurde im aktuellen Verzeichnis nicht gefunden."
    exit 1
}

# Aktuelles Datum im Format yyyyMMdd
$today = Get-Date -Format "yyyyMMdd"

# Version normalisieren (z. B. "1" -> "V1", "v1" -> "V1")
if ($Version -match '^\d+$') {
    $Version = "V$Version"
} elseif ($Version -match '^[vV](\d+)$') {
    $Version = "V$($Matches[1])"
} else {
    $Version = $Version.ToUpper()
}

# Zieldateiname bestimmen
if ($Version -eq "DRAFT") {
    $dst = "${today}_MA_MAFSiM_DRAFT.pdf"
} else {
    # Suche alle bestehenden Versionen dieser Hauptversion im aktuellen Verzeichnis
    $escapedVersion = [regex]::Escape($Version)
    $pattern = "^(?:.+_)?MA_MAFSiM_${escapedVersion}(?:_(\d+))?\.pdf$"

    $maxMinor = 0
    $existingFiles = Get-ChildItem -File -Filter "*_MA_MAFSiM_${Version}*.pdf" -ErrorAction SilentlyContinue

    foreach ($file in $existingFiles) {
        if ($file.Name -match $pattern) {
            $minor = if ($Matches[1]) { [int]$Matches[1] } else { 0 }
            if ($minor -gt $maxMinor) {
                $maxMinor = $minor
            }
        }
    }

    $nextMinor = $maxMinor + 1
    $dst = "${today}_MA_MAFSiM_${Version}_${nextMinor}.pdf"

    # Sicherstellen, dass keine existierende Datei überschrieben wird
    while (Test-Path $dst) {
        $nextMinor++
        $dst = "${today}_MA_MAFSiM_${Version}_${nextMinor}.pdf"
    }
}

# Datei kopieren
Copy-Item -Path $src -Destination $dst
Write-Host "Kopie erstellt: $dst"