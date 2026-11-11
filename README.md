# ASTRA – Academic Scientific Thesis & Research Architecture (v2.0)

[![LaTeX](https://img.shields.io/badge/LaTeX-KOMA--Script%20(scrbook)-blue.svg)](https://komascript.de/)
[![Engine](https://img.shields.io/badge/Engine-pdfLaTeX%20%7C%20Biber-success.svg)](https://www.ctan.org/)
[![Style](https://img.shields.io/badge/Citation-IEEE%20(numeric--comp)-orange.svg)](https://ieee.org/)
[![OS](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)](#3-kompilierung--automatisierung)
[![Build](https://img.shields.io/badge/Build-Makefile%20%7C%20PowerShell%20%7C%20Bash-informational.svg)](#3-kompilierung--automatisierung)

**ASTRA** ist eine modulare, produktionserprobte LaTeX-Vorlage für anspruchsvolle akademische Abschlussarbeiten (Master- und Bachelorarbeiten, Forschungsberichte, Dissertationen) in den Ingenieur-, Natur- und Computerwissenschaften. 

Ursprünglich an der **Hochschule Karlsruhe (HKA)** in der Fakultät für Maschinenbau und Mechatronik (Studiengang *Robotik und KI in der Produktion*) entwickelt, erfüllt die Vorlage höchste typografische Ansprüche gemäß den Richtlinien für wissenschaftliche Ausarbeitungen und lässt sich mühelos an jede andere Universität oder Hochschule anpassen.

---

## Inhaltsverzeichnis

- [1. Hauptmerkmale & Highlights](#1-hauptmerkmale--highlights)
- [2. Projektstruktur](#2-projektstruktur)
- [3. Schnelleinstieg & Voraussetzungen](#3-schnelleinstieg--voraussetzungen)
- [4. Konfiguration & Metadaten](#4-konfiguration--metadaten)
- [5. Kompilierung & Automatisierung](#5-kompilierung--automatisierung)
  - [5.1 Arbeiten mit dem Makefile](#51-arbeiten-mit-dem-makefile)
  - [5.2 Standalone PGF-Plot Rendering](#52-standalone-pgf-plot-rendering)
  - [5.3 Versionierung & Release (`copy_and_rename`)](#53-versionierung--release-copy_and_rename)
  - [5.4 Manueller Build-Workflow](#54-manueller-build-workflow)
- [6. Wissenschaftliche Werkzeuge & Best Practices](#6-wissenschaftliche-werkzeuge--best-practices)
  - [6.1 Literaturverwaltung (BibLaTeX & Biber)](#61-literaturverwaltung-biblatex--biber)
  - [6.2 Nomenklatur & Einheiten (siunitx & nomencl)](#62-nomenklatur--einheiten-siunitx--nomencl)
  - [6.3 Abkürzungsverzeichnis (acronym)](#63-abkürzungsverzeichnis-acronym)
  - [6.4 Abbildungen, Subfigures & Vektorgrafiken](#64-abbildungen-subfigures--vektorgrafiken)
  - [6.5 Professionelle Tabellen (booktabs & xltabular)](#65-professionelle-tabellen-booktabs--xltabular)
  - [6.6 Quellcode-Listings](#66-quellcode-listings)
  - [6.7 Projektplan & Gantt-Diagramm (pgfgantt)](#67-projektplan--gantt-diagramm-pgfgantt)
  - [6.8 Notizen & Review (todonotes)](#68-notizen--review-todonotes)
- [7. Editor-Integration (VS Code / LaTeX Workshop)](#7-editor-integration-vs-code--latex-workshop)
- [8. Fehlerbehebung & FAQ](#8-fehlerbehebung--faq)
- [9. Lizenz](#9-lizenz)

---

## 1. Hauptmerkmale & Highlights

- **KOMA-Script Basis (`scrbook`):** Modernes deutsches Satzspiegel-Layout (A4, 11pt, zweiseitig, `parskip=full`), optimierte Kopf- und Fußzeilen via `scrlayer-scrpage`.
- **Duale Corporate Identity (Hochschule & Industrie):** 
  - Standardmäßig vorkonfiguriertes HKA-Farbschema (`hka_blue`: `#3A68AA`, `hka_red`: `#D62506`) für Überschriften, Verlinkungen und Akzente.
  - Dynamisches Logo-Handling: Firmenlogo und Industrie-Betreuer können über ein einzelnes Flag (`\CompanyName{NoCompanyInvolved}`) sauber ausgeblendet werden.
- **Leistungsstarker PGF/TikZ-Plot-Workflow:**
  - Vordefinierte Farbpaletten für Messreihen, Trajektorien und Manöverklassen.
  - `plot_wrapper.tex`: Eigenständiges Kompilieren rechenintensiver PGF-Plots zu PDF (`make pgf`) zur massiven Beschleunigung des Hauptdokuments.
- **Akademische Verzeichnisse:**
  - Nomenklatur mit bündiger Symbol-, Beschreibungs- und Einheiten-Spalte via `\nomunit{...}`.
  - Intelligentes Abkürzungsverzeichnis mit Plural-Unterstützung (`\acrodefplural`).
  - IEEE-Zitierweise mit komprimierten Nummern (`numeric-comp`) über `biblatex` und `biber`.
- **Gantt-Projektplan:** Fertig vorkonfigurierter, rotierter 26-Wochen-Projektplan (`pgfgantt`) im Anhang.
- **Versions- & Release-Automation:** Cross-Platform-Skripte (`.sh` und `.ps1`) für automatische Zählung von Arbeitsständen (`YYYYMMDD_MA_MAFSiM_V1_1.pdf`, `DRAFT`).

---

## 2. Projektstruktur

Die Vorlage ist modular nach Best Practices aufgebaut:

```text
ASTRA-template/
├── main.tex                    # Hauptdokument (Dokumentklasse, Verzeichnisse, Einbindungen)
├── settings.sty                # Zentrale Konfiguration (Metadaten, Pakete, Farben, Layout)
├── Makefile                    # Plattformunabhängige Build-Befehle (Linux, macOS, Windows)
├── acronyms.tex                # Abkürzungsverzeichnis-Definitionen
├── nomenclature.tex            # Nomenklatur-Einträge (Symbole, Beschreibungen, Einheiten)
├── bibliography.bib            # BibLaTeX-Literaturdatenbank
├── plot_wrapper.tex            # Standalone-Renderer für PGF-Grafiken zu PDF
├── copy_and_rename.sh          # Bash-Exportskript mit automatischer Versionierung (Linux/macOS)
├── copy_and_rename.ps1         # PowerShell-Exportskript mit automatischer Versionierung (Windows)
│
├── chapters/                   # Kapitel des Hauptteils & Anhangs
│   ├── 00-titlepage.tex        # Titelseite (mit Hochschule, Fakultät, Betreuern & Logos)
│   ├── 00-declaration.tex      # Eidesstattliche Eigenständigkeitserklärung
│   ├── 00-preface.tex          # Abstract (Englisch) & Kurzfassung (Deutsch)
│   ├── 01-introduction.tex     # Einleitung, Problemstellung & Forschungsfragen
│   ├── 02-related-work.tex     # Stand der Technik und Grundlagen
│   ├── 03-methodology.tex      # Methodik & Versuchsaufbau
│   ├── 04-validation.tex       # Validierung
│   ├── 05-preparation.tex      # Entwicklung & Vorbereitung
│   ├── 06-evaluation.tex       # Auswertung & Ergebnisse
│   ├── 07-application.tex      # Praktische Anwendung
│   ├── 08-conclusion-outlook.tex# Fazit, Diskussion & Ausblick
│   │
│   ├── app-b-additional-02-related.tex       # Anhang B: Ergänzungen Grundlagen
│   ├── app-c-additional-03-methodology.tex   # Anhang C: Ergänzungen Methodik
│   ├── app-d-additional-04-validation.tex    # Anhang D: Ergänzungen Validierung
│   ├── app-e-additional-05-preparation.tex   # Anhang E: Ergänzungen Entwicklung
│   ├── app-f-additional-06-evaluation.tex    # Anhang F: Ergänzungen Auswertung
│   ├── app-g-additional-07-application.tex   # Anhang G: Ergänzungen Anwendung
│   └── app-h-projectplan.tex                 # Anhang H: 26-Wochen Gantt-Projektplan
│
├── figures/                    # Abbildungen und Grafiken
│   ├── png/                    # Rastergrafiken & Logos (hka_logo.png, firmen_logo.png)
│   ├── pdf/                    # Vektorgrafiken (und gerenderte PGF-Plots)
│   ├── pgf/                    # PGFPlots-Code (z.B. aus Python/Matplotlib exportiert)
│   ├── tikz/                   # TikZ-Diagramme und Schemata
│   └── jpg/                    # Fotos und Renderings
│
├── tables/                     # Ausgelagerte TeX-Tabellen (z.B. forschungsfragen.tex)
├── code/                       # Externe Quellcode-Dateien für Listings
├── Poster/                     # Platzhalter für Präsentationsposter
├── Presentation/               # Platzhalter für Abschlusspräsentations-Folien
└── sonstiges/                  # Prüfungsordnungen, Leitfäden & Richtlinien (PDF)
```

---

## 3. Schnelleinstieg & Voraussetzungen

### Voraussetzungen

1. **LaTeX-Distribution:**
   - **Linux:** TeX Live (`sudo apt install texlive-full` bzw. distributionseigenes Paket)
   - **macOS:** MacTeX (`brew install --cask mactex-no-gui` oder MacTeX Komplettversion)
   - **Windows:** MiKTeX oder TeX Live für Windows
2. **Bibliografie-Backend:**
   - **Biber** (in allen modernen Distributionen enthalten)
3. **Build-Tool:**
   - **Make** (`make`) – unter Linux/macOS standardmäßig vorhanden, unter Windows via Git Bash, WSL, MSYS2 oder Chocolatey (`choco install make`).
4. **Shell/Skripte:**
   - `bash` (macOS/Linux) oder `PowerShell 5.0+` (Windows).

### In 3 Schritten zum fertigen PDF

1. **Repository klonen oder herunterladen:**
   ```bash
   git clone <repo-url> my-thesis
   cd my-thesis
   ```
2. **Eigene Metadaten in `settings.sty` eintragen** (Name, Titel, Betreuer etc. – siehe [Abschnitt 4](#4-konfiguration--metadaten)).
3. **Kompilieren:**
   ```bash
   make
   ```
   Das generierte PDF liegt nun als `main.pdf` im Hauptverzeichnis bereit.

---

## 4. Konfiguration & Metadaten

Sämtliche globalen Dokumentvariablen werden im Kopfbereich der Datei `settings.sty` gepflegt:

| Befehl | Beispielwert | Beschreibung |
|---|---|---|
| `\Title` | `LaTeX-Vorlage zur Erstellung...` | Haupttitel der Arbeit |
| `\Subtitle` | `Spezialisiert auf die Hochschule...` | Untertitel (optional) |
| `\Name` | `Max Mustermann, B. Eng.` | Vollständiger Name des Verfassers |
| `\Id` | `123456` | Matrikelnummer |
| `\DateOfBirth` | `01. Januar 2000` | Geburtsdatum (für Erklärung) |
| `\PlaceOfBirth`| `Karlsruhe` | Geburtsort |
| `\Location` | `Karlsruhe` | Ausstellungsort der Arbeit |
| `\DeliveryDate`| `\today` | Abgabedatum |
| `\University` | `Hochschule Karlsruhe` | Name der Hochschule/Universität |
| `\Faculty` | `Fakultät für Maschinenbau...` | Fakultät |
| `\StudyCourse` | `Robotik und KI in der Produktion`| Studiengang |
| `\Degree` | `Master of Science` | Angestrebter akademischer Grad |
| `\DegreeShort` | `M. Sc.` | Abkürzung des Grads |
| `\DocName` | `Masterthesis` | Art der Arbeit (Bachelorarbeit / Masterthesis) |
| `\DocNr` | `26/005` | Interne Arbeiten-Nummer |
| `\Supervisor` | `Prof. Dr.-Ing. Donald Duck` | Erstprüfer / Hochschulbetreuer |
| `\CoSupervisor`| `Prof. Dr.-Ing. Dagobert Duck`| Zweitprüfer |
| `\CompanyName` | `NoCompanyInvolved` | Name des Unternehmens oder `NoCompanyInvolved` |
| `\CompSupervisor`| `Dipl.-Ing. Tick Duck` | Industrieller Betreuer (nur aktiv mit Firma) |

> [!TIP]
> **Reine Hochschularbeit ohne Industriepartner:**  
> Belasse `\newcommand*{\CompanyName}{NoCompanyInvolved}`. Die Titelseite und Kopfzeilen passen sich vollautomatisch an und blenden Firmenlogo sowie Firmenbetreuer aus. Setzt du dort einen Firmennamen ein, wird automatisch das Logo aus `figures/png/firmen_logo.png` und der Betreuer aktiviert.

---

## 5. Kompilierung & Automatisierung

### 5.1 Arbeiten mit dem Makefile

Das beiliegende `Makefile` erkennt automatisch, ob es unter macOS/Linux oder Windows ausgeführt wird, und bietet maßgeschneiderte Targets:

```bash
# Vollständiger Build (pdflatex -> biber -> makeindex -> 2x pdflatex)
make
# bzw.
make full

# Schneller Build (nur ein pdflatex-Lauf für Textänderungen)
make fast

# Nur das Literaturverzeichnis aktualisieren
make biber

# Nur das Nomenklaturverzeichnis aktualisieren
make nomen

# Temporäre Hilfsdateien (.aux, .log, .toc, .bbl etc.) rekursiv löschen
make clean

# Hilfsdateien UND erzeugtes main.pdf löschen
make fclean

# Ausführliche Compiler-Ausgaben anzeigen (Debugging)
make full VERBOSE=1
```

### 5.2 Standalone PGF-Plot Rendering

Komplexe `pgfplots` mit tausenden Datenpunkten verlangsamen die normale Kompilierung spürbar. ASTRA enthält dafür den Mechanismus `plot_wrapper.tex`:

```bash
make pgf PGF=figures/pgf/04_methodology/synthetic_route.pgf
```

**Was passiert hierbei?**
1. Der PGF-Code wird über `plot_wrapper.tex` isoliert mit `--extra-mem-top=1000000000` kompiliert.
2. Das resultierende PDF wird automatisch nach `figures/pdf/synthetic_route.pdf` verschoben.
3. Temporäre Hilfsdateien werden aufgeräumt.
4. Im Kapitel kann die Grafik nun blitzschnell als fertiges PDF via `\includegraphics{pdf/synthetic_route}` eingebunden werden, anstatt sie bei jedem Durchlauf neu zu berechnen.

### 5.3 Versionierung & Release (`copy_and_rename`)

Zur Abgabe von Zwischenständen an Betreuer stehen automatisierte Skripte bereit:

**Unter macOS / Linux (`copy_and_rename.sh`):**
```bash
chmod +x copy_and_rename.sh

# Erstellt eine versionierte Kopie mit aktuellem Datumsstempel
./copy_and_rename.sh V1
# Ausgabe z. B.: Kopie erstellt: 20261111_MA_MAFSiM_V1_1.pdf
# Bei erneutem Aufruf zählt das Skript automatisch hoch (V1_2, V1_3, ...)

# DRAFT-Snapshot erstellen:
./copy_and_rename.sh DRAFT
# Ausgabe: 20261111_MA_MAFSiM_DRAFT.pdf
```

**Unter Windows (`copy_and_rename.ps1`):**
```powershell
.\copy_and_rename.ps1 V1
.\copy_and_rename.ps1 DRAFT
```

### 5.4 Manueller Build-Workflow

Falls kein `make` zur Verfügung steht, lässt sich die Kompilierung manuell in der Konsole durchführen:

```bash
pdflatex -interaction=nonstopmode main.tex
biber main
makeindex main.nlo -s nomencl.ist -o main.nls
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
```

---

## 6. Wissenschaftliche Werkzeuge & Best Practices

### 6.1 Literaturverwaltung (BibLaTeX & Biber)

In `main.tex` ist `biblatex` im IEEE-Stil vorkonfiguriert (`citestyle=numeric-comp`):

- Zitate im Fließtext:
  ```latex
  Wie in der Literatur beschrieben~\cite{hka_profil}.
  Mehrere Quellen zusammenfassen:~\cite{quelle1, quelle2, quelle3} % Erzeugt z. B. [1–3]
  ```
- Einträge in `bibliography.bib` pflegen:
  ```bibtex
  @article{hka_profil,
    author  = {Musterautor, Max and Forscher, Erika},
    title   = {Moderne Methoden der Prädiktiven Robotik},
    journal = {Journal of Robotics and Automation},
    year    = {2026},
    volume  = {42},
    pages   = {100--115}
  }
  ```

### 6.2 Nomenklatur & Einheiten (siunitx & nomencl)

Die Nomenklatur wird über `nomenclature.tex` definiert. Die Vorlage formatiert automatisch eine 3-spaltige Tabelle mit Einheiten:

```latex
% In nomenclature.tex:
\nomenclature{$F_\mathrm{x}$}{Längskraft des Reifens \nomunit{\unit{\newton}}}
\nomenclature{$v$}{Fahrzeuggeschwindigkeit \nomunit{\unit{\kilo\metre\per\hour}}}
\nomenclature{$\mu$}{Reibwertbeiwert \nomunit{--}}
```

**SI-Einheiten im Fließtext (`siunitx`):**
```latex
Die Geschwindigkeit beträgt \qty{120}{\kilo\metre\per\hour} bei einer Kraft von \qty{3.5}{\kilo\newton}.
Messbereich: \qtyrange{10}{50}{\degreeCelsius}.
```

### 6.3 Abkürzungsverzeichnis (acronym)

Abkürzungen werden in `acronyms.tex` deklariert:

```latex
\begin{acronym}[MeanAPE]
  \acro{KI}{Künstliche Intelligenz}
  \acro{AP}{Arbeitspaket}
  \acrodefplural{AP}[APs]{Arbeitspakete}
\end{acronym}
```

Verwendung im Text:
- `\ac{KI}`: Erste Verwendung schreibt aus ("Künstliche Intelligenz (KI)"), jede weitere nutzt nur "KI".
- `\acp{AP}`: Verwendet die Pluralform ("Arbeitspakete (APs)").
- `\acs{KI}`: Erzwingt Kurzform ("KI").
- `\acl{KI}`: Erzwingt Langform ("Künstliche Intelligenz").

### 6.4 Abbildungen, Subfigures & Vektorgrafiken

Grafiken werden idealerweise als Vektorgrafik (`.pdf`, `.pgf`, `.tikz`) eingebunden:

```latex
\begin{figure}[htbp]
  \centering
  \begin{minipage}[c]{0.48\textwidth}
    \centering
    \input{figures/tikz/sim_strecke/sim_strecke.pgf}
    \subcaption{Trajektorie der Teststrecke.\label{fig:trajektorie}}
  \end{minipage}
  \hfill
  \begin{minipage}[c]{0.48\textwidth}
    \centering
    \includegraphics[width=\linewidth]{figures/png/hka_logo.png}
    \subcaption{Referenzdarstellung.\label{fig:referenz}}
  \end{minipage}
  \caption{Gesamtaufbau der Simulation und Validierung.}
  \label{fig:gesamtaufbau}
\end{figure}
```

### 6.5 Professionelle Tabellen (booktabs & xltabular)

Die Vorlage vermeidet unschöne vertikale Trennlinien und nutzt typografisch saubere `booktabs`-Linien:

```latex
\begin{table}[htbp]
  \centering
  \caption{Vergleich der Parameterkonfigurationen.}
  \label{tab:parameter_vergleich}
  \begin{tabular}{llr}
    \toprule
    \textbf{Parameter} & \textbf{Beschreibung} & \textbf{Wert} \\
    \midrule
    $T_\mathrm{sample}$ & Abtastzeit & \qty{10}{\milli\second} \\
    $v_\mathrm{max}$    & Maximalgeschwindigkeit & \qty{50}{\metre\per\second} \\
    $m_\mathrm{veh}$    & Gesamtmasse & \qty{1500}{\kilo\gram} \\
    \bottomrule
  \end{tabular}
\end{table}
```

### 6.6 Quellcode-Listings

Code kann direkt oder aus Dateien im Ordner `code/` eingebunden werden:

```latex
\begin{lstlisting}[language=Python, caption={Initialisierung des Kalman-Filters.}, label={lst:kalman}]
import numpy as np

def init_filter(dim_x: int, dim_z: int):
    x = np.zeros((dim_x, 1))
    P = np.eye(dim_x) * 500.0
    return x, P
\end{lstlisting}

% Oder direkt aus Datei einbinden:
% \lstinputlisting[language=Python, caption={CSV-Loader}]{code/csv_loader.py}
```

### 6.7 Projektplan & Gantt-Diagramm (pgfgantt)

In `chapters/app-h-projectplan.tex` befindet sich ein vollständiges Gantt-Diagramm, das automatisch im Querformat (90° rotiert) gesetzt wird:

```latex
\begin{ganttchart}[
  hgrid, vgrid,
  x unit=0.45cm,
  milestone/.append style={fill=hka_red},
  group/.append style={fill=hka_blue, draw=hka_blue}
]{1}{26}
  \gantttitle{Wochenplan Masterthesis}{26} \\
  \gantttitlelist{1,...,26}{1} \\
  \ganttgroup{1. Recherche}{1}{4} \\
  \ganttbar{Stand der Technik}{1}{3} \\
  \ganttmilestone{Meilenstein 1}{4}
\end{ganttchart}
```

### 6.8 Notizen & Review (todonotes)

Während des Schreibens können Anmerkungen und ToDos gesetzt werden:

```latex
\todox{Abschnitt mit Betreuer abstimmen!}      % Notiz am Seitenrand (blau)
\todoix{Hier fehlt noch die Validierungskurve} % Inline-Notiz (orange)
```
Zum finalen Druck können ToDos global über `settings.sty` (Option `disable` bei `todonotes`) oder durch Kommentieren der Zeilen ausgeblendet werden.

---

## 7. Editor-Integration (VS Code / LaTeX Workshop)

Für **Visual Studio Code** mit der Erweiterung [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) wird folgende Konfiguration in `.vscode/settings.json` empfohlen:

```json
{
  "latex-workshop.latex.tools": [
    {
      "name": "pdflatex",
      "command": "pdflatex",
      "args": [
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
        "--extra-mem-top=1000000000",
        "%DOC%"
      ]
    },
    {
      "name": "biber",
      "command": "biber",
      "args": ["%DOCFILE%"]
    },
    {
      "name": "nomencl",
      "command": "makeindex",
      "args": ["%DOCFILE%.nlo", "-s", "nomencl.ist", "-o", "%DOCFILE%.nls"]
    }
  ],
  "latex-workshop.latex.recipes": [
    {
      "name": "ASTRA: Vollständiger Build (pdf -> biber -> nomencl -> 2x pdf)",
      "tools": ["pdflatex", "biber", "nomencl", "pdflatex", "pdflatex"]
    },
    {
      "name": "ASTRA: Schneller Build (pdflatex)",
      "tools": ["pdflatex"]
    }
  ],
  "latex-workshop.view.pdf.viewer": "tab",
  "latex-workshop.latex.autoBuild.run": "onFileChange"
}
```

---

## 8. Fehlerbehebung & FAQ

<details>
<summary><b>1. Nomenklatur oder Abkürzungsverzeichnis erscheint nicht im PDF</b></summary>

*Lösung:* Für die Nomenklatur muss `makeindex` mit dem Stil `nomencl.ist` ausgeführt werden. Führe einfach `make nomen` oder `make full` aus.
</details>

<details>
<summary><b>2. TeX capacity exceeded / Speichermangel bei großen PGFPlots</b></summary>

*Lösung:* Das Makefile übergibt bereits `--extra-mem-top=1000000000`. Falls das Limit dennoch erreicht wird, rendere den entsprechenden Plot separat mit:
```bash
make pgf PGF=figures/pgf/pfad_zum_plot.pgf
```
und binde das generierte PDF via `\includegraphics` ein.
</details>

<details>
<summary><b>3. Biber bricht mit Cache-Fehlern ab</b></summary>

*Lösung:* Lösche den temporären Biber-Cache:
```bash
# macOS / Linux:
rm -rf $(biber --cache)

# Windows:
biber --cache  # Zeigt den Pfad an, diesen Ordner im Explorer löschen
```
Anschließend `make clean && make full`.
</details>

<details>
<summary><b>4. Kopfzeilen-Warnung: 'headheight too small'</b></summary>

*Lösung:* In `settings.sty` ist `headheight=1.5cm` im `geometry`-Paket definiert, damit die Logos sauber Platz finden. Sollten die Logos vergrößert werden, muss `headheight` in `settings.sty` entsprechend proportional angepasst werden.
</details>

---

## 9. Lizenz

Dieses Vorlagen-Paket steht zur freien Nutzung für akademische Arbeiten an Universitäten und Hochschulen zur Verfügung.

Viel Erfolg bei der Ausarbeitung deiner wissenschaftlichen Abschlussarbeit! 🎓
