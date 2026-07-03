**CTInfer**  
**Compound Target Inference Tool**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.21162534.svg)](https://doi.org/10.5281/zenodo.21162534)

*Technical Documentation, User Guide & GDPR Compliance*

| **Version** | 1.0           |
|-------------|---------------|
| **Date**    | 30 June 2026  |
| **Author**  | Maxence Belin |
| **Status**  | Final |
| **License** | GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 |

**1. Overview**

CTInfer (Compound Target Inference Tool) is a desktop application
developed for IARC to automatically identify proteins inhibited by
chemical compounds. Starting from a list of compounds and their PubChem
identifiers (CID), CTInfer simultaneously queries tree reference
databases, PubChem, MedChemExpress and canSAR.ai, extracts molecular targets,
detection keywords, biological descriptions and bibliographic
references, then generates a structured Excel file.

| *CTInfer is designed to process hundreds of compounds in a single session, combining the intelligence of three complementary sources: PubChem (NCBI public database) and MedChemExpress (supplier of bioactive compounds) and canSAR.ai (oncology database of the MD Anderson Cancer Center).* |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|


## 1.1 Problem Solved

Manually identifying molecular targets for a panel of compounds is a lengthy and repetitive task. For each compound, it is necessary to consult PubChem, MedChemExpress, and canSAR.ia, extract the relevant information, consolidate it, and format it. For more than 500 compounds, this represents hours of work.

CTInfer fully automates this process and generates a structured Excel spreadsheet in just a few dozen minutes.
## 1.2 Main capabilities

- Load an Excel or CSV file containing compound names and their PubChem CIDs

- Automatic query of MedChemExpress via a real browser (Playwright/Chromium)

- Query PubChem via the PUG View API (3 cascading endpoints)

- Extraction of inhibited molecular targets from MCE /Targets/ links

- Target extraction using 14+ different regex patterns on description texts

- Retrieval of complete biological descriptions (MCE and PubChem)

- Retrieval of all bibliographic references (MCE: References tab; PubChem: Reference fields)

- Generation of a structured Excel file with conditional columns (only active sources appear)

- MCE search fallback if the direct URL does not work

- Multilingual interface: French, English, Spanish, Portuguese, German, Chinese

- Real-time log with per-compound progress

- Query of canSAR.ai (target affinity): retrieves validated Homo sapiens targets with Mean Potency < 1000 nM

# 2. Installation

## 2.1 Requirements

| **Requirement**         | **Details**                       |
|-------------------------|-----------------------------------|
| **Operating system**    | Windows 10 or 11 (64-bit)         |
| **Python**              | Version 3.8 or higher             |
| **Internet connection** | Required to query PubChem and MCE |
| **Disk space**          | ~500 MB (Chromium included)       |

## 2.2 CTInfer folder contents

| **File**            | **Role**                                             |
|---------------------|------------------------------------------------------|
| **CTInfer_app.py**         | Main application script                              |
| **translations.py** | Translations (6 languages)                           |
| **Lancer_CTInfer.bat** | Windows launcher installs dependencies automatically |
| **CTInfer.ico**        | Application icon                                     |
| **settings.json**   | User preferences (created automatically)             |

## 2.3 Installation steps

**Step 1: Install Python**

- Go to https://python.org/downloads

- Download the latest stable version (3.11 or higher recommended)

- During installation, make sure to check the Add Python to PATH box

**Step 2: First launch**

- Double-click Lancer_CTInfer.bat

- Dependencies are installed automatically: Playwright, Chromium,
  openpyxl, beautifulsoup4

- This installation only occurs once (approximately 3–5 minutes)

| *Do not close the black window during the automatic Chromium installation.* |
|-----------------------------------------------------------------------------|

# 3. Obtaining PubChem CIDs

CTInfer requires PubChem CID identifiers for each compound. If you only
have molecule names, here is the procedure to obtain the corresponding
CIDs in just a few minutes.

| *The CID (Compound ID) is the unique numeric identifier assigned by PubChem to each molecule. It is required for CTInfer to query the database.* |
|--------------------------------------------------------------------------------------------------------------------------------------------------|

## 3.1 Converting names to CIDs via PubChem ID Exchange

PubChem offers a free online tool to convert a bulk list of molecule
names into CIDs. Here is the procedure:

| **1** | Go to the PubChem ID Exchange service: https://pubchem.ncbi.nlm.nih.gov/idexchange/ |
|-------|-------------------------------------------------------------------------------------|

| **2** | In the Input ID List section, select "Synonyms" from the dropdown menu this allows you to enter common names, IUPAC names, trade names, CAS numbers, etc. |
|-------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|

| **3** | Paste the list of molecule names directly into the text field (one name per line), or click Import File to load a .txt file containing the list. |
|-------|--------------------------------------------------------------------------------------------------------------------------------------------------|

| **4** | In the Output IDs section, select "CIDs" from the dropdown menu. |
|-------|------------------------------------------------------------------|

| **5** | Click Submit Job and wait a few seconds. The corresponding CIDs are displayed or can be downloaded. |
|-------|-----------------------------------------------------------------------------------------------------|

## 3.2 File format for CTInfer

Once the CIDs are obtained, prepare an Excel file with at least two
columns:

| **Column**   | **Content**                | **Example** |
|--------------|----------------------------|-------------|
| **Compound** | Compound name              | Dacinostat  |
| **CID**      | Numeric PubChem identifier | 6445533     |

| *If a compound is not found by PubChem ID Exchange, try name variants (trade name, CAS number, IUPAC name). Some very recent or proprietary compounds may not be listed in PubChem.* |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

# 4. Usage

## 4.1 Preparing the source file

CTInfer automatically detects the CID column (whose name contains "cid")
and the compound column (whose name contains "compound").

| **Column**               | **Content**                | **Example**   |
|--------------------------|----------------------------|---------------|
| **Compound (or similar)** | Compound name             | Sangivamycin  |
| **CID (or similar)**     | Numeric PubChem identifier | 14978         |

CTInfer automatically detects the CID column (whose name contains "cid") and the compound column (whose name contains "compound").

## 4.2 Choosing data sources

In the "3. Data sources" section of the left panel, two checkboxes allow
you to select which databases to query:

| **Option**                      | **Behaviour**                                                                                                                                                                                                                 |
|---------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **☑ MCE + ☑ PubChem (default)** | Queries both sources and merges results                                                                                                                                                                                       |
| **☑ MCE only**                  | Searches MedChemExpress only (faster)                                                                                                                                                                                         |
| **☑ PubChem only**              | Searches via PubChem API only (faster)                                                                                                                                                                                        |
| **☑ CanSAR**                    | Additionally queries the canSAR.ai database (target affinity); only keeps proteins where the organism is Homo sapiens and the Mean Potency is strictly below 1000 nM. Unchecked by default (slower, search-based navigation). |

## 4.3 Running a search

| **Step** | **Action**                                                                                                                                          |
|----------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| **1**    | Load the Excel or CSV file                                                                                                                          |
| **2**    | Select the CID column from the dropdown menu                                                                                                        |
| **3**    | Choose the output folder                                                                                                                            |
| **4**    | Check the desired sources (MCE, PubChem, or both)                                                                                                   |
| **5**    | Click Run search                                                                                                                                    |
| **6**    | Monitor progress in the real-time log                                                                                                               |
| **7**    | Retrieve the Results_targets.xlsx file in the chosen folder (a \_1, \_2… suffix is added automatically if a file with the same name already exists) |

## 4.4 Words to exclude

The "Words to exclude" field contains terms that, if they precede an inhibitor in the text, invalidate the detection. For example, the word "not" in "does not inhibit X" prevents X from being listed as a target. The default values (not, no) are suitable for the majority of cases.

## 4.5 Estimated duration

| **Volume**        | **MCE + PubChem** | **MCE only** | **PubChem only** |
|-------------------|-------------------|--------------|------------------|
| **30 compounds**  | 5–10 min          | 4–8 min      | 1–2 min          |
| **100 compounds** | 20–35 min         | 15–25 min    | 3–6 min          |
| **350 compounds** | 60–90 min         | 60–90 min    | 10–20 min        |

The main time cost is linked to MedChemExpress (Playwright loads each page in 3–5 seconds like a real browser). PubChem is queried via API and is faster.

# 5. Excel output file

## 5.1 File structure

The Results_targets.xlsx file contains columns with automatic filter and fixed header row. Only columns for active sources appear:

| **Column**              | **Content**                                                                                                       |
|-------------------------|-------------------------------------------------------------------------------------------------------------------|
| **Compound Name**       | Compound name                                                                                                     |
| **CID**                 | PubChem identifier                                                                                                |
| **Target(s)**           | Inhibited proteins, separated by semicolons                                                                       |
| **Targets CanSAR**      | Proteins from canSAR.ai (Homo sapiens, Mean Potency \< 1000 nM), if the CanSAR source is checked, empty otherwise |
| **Keyword MCE**         | Word(s) that triggered detection from MCE                                                                         |
| **Keyword PubChem**     | Word(s) that triggered detection from PubChem                                                                     |
| **Description MCE**     | Pharmacological sentence extracted from MedChemExpress                                                            |
| **Description PubChem** | Pharmacological sentence from PubChem (empty if no pharmacological keyword found)                                 |
| **References MCE**      | MCE bibliographic references                                                                                      |
| **References PubChem**  | PubChem references                                                                                                |

## 5.2 Formatting

- Green rows: compound with at least one target found

- Yellow rows: compound with no target identified

- Automatic filter on all columns

- Fixed header row (freeze panes)

# 6. Target extraction mechanism

## 6.1 Source priority

| **Priority** | **Source**    | **Method**                                                                                                                                                                         |
|--------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **1**        | MCE           | /Targets/ links on the MCE product page                                                                                                                                            |
| **2**        | MCE regex     | 14+ regex patterns on the MCE description text                                                                                                                                     |
| **3**        | PubChem regex | 14+ regex patterns on the PubChem text                                                                                                                                             |
| **4**        | CanSAR        | Searches the compound by name on canSAR.ai, reads the Target Affinity table, strict filter Homo sapiens + Mean Potency \< 1000 nM. Does not follow the MCE/PubChem regex patterns. |

## 6.2 Detection patterns

| **Pattern**                       | **Example**                                          |
|-----------------------------------|------------------------------------------------------|
| **MCE /Targets/ links**           | <a href='/Targets/ERK.html'>ERK</a>                  |
| **"inhibitor of X (ABR)"**        | inhibitor of histone deacetylase (HDAC) → HDAC       |
| **"X inhibitor"**                 | CDK9 inhibitor → CDK9                                |
| **"inhibits X"**                  | inhibits PKC → PKC                                   |
| **"designed to inhibit X"**       | designed to inhibit IGF1R → IGF1R                    |
| **"dual X and Y inhibitor"**      | dual PI3K and HDAC inhibitor → PI3K, HDAC            |
| **"inhibition of X pathway"**     | inhibition of PI3K/Akt/mTOR pathway → PI3K/Akt/mTOR  |
| **"suppression of X"**            | suppression of VEGFR-2 signaling → VEGFR-2           |
| **"X/Y/Z pathway"**               | PI3K/Akt/mTOR pathway → PI3K/Akt/mTOR                |
| **"through inhibition of X"**     | through inhibition of Akt → Akt                      |
| **"blocks X"**                    | blocks ATM pathway → ATM                             |
| **"binds to / targets X"**        | binds to Aurora kinases → Aurora kinases             |
| **"X kinase/receptor inhibitor"** | Aurora B kinase inhibitor → Aurora B                 |
| **"EC code (full name) inhibitor"** | EC 2.7.11.13 (protein kinase C) inhibitor → protein kinase C |

## 6.3 Anti-false-positive filters

- Noise words at the start of a target: a, an, the, both, many, novel, potent, selective, cancer, tumor, cell, activity...

- Generic words alone: inhibitor, kinase, receptor, enzyme...

- Cell lines: HepG2, MCF7, HCC, X/Y patterns like G2/ADM

- Sentences with verbs: is, are, was, were, has, have, can, will...

- User-configurable exclude words (not, no by default)

## 6.4 Special case: full name + acronym

When a sentence contains the full name followed by the acronym in parentheses, CTInfer extracts the acronym in priority. Example: "histone deacetylase (HDAC) inhibitor" → HDAC.

# 7. Technical architecture

## 7.1 Technologies and libraries

| **Library**        | **Version** | **Role**                    | **License**    |
|--------------------|-------------|-----------------------------|----------------|
| **Python**         | 3.8+        | Main language               | PSF            |
| **tkinter**        | stdlib      | Graphical interface         | PSF (included) |
| **Playwright**     | ≥ 1.40      | MCE navigation via Chromium | Apache 2.0     |
| **BeautifulSoup4** | ≥ 4.12      | HTML parsing                | MIT            |
| **requests**       | ≥ 2.31      | PubChem API requests        | Apache 2.0     |
| **openpyxl**       | ≥ 3.1       | Excel read/write            | MIT            |
| **Pillow**         | ≥ 10.0      | Icon (.ico) generation      | PIL            |
| **re**             | stdlib      | Regular expressions         | PSF            |
| **json**           | stdlib      | Settings and configuration  | PSF            |
| **pathlib**        | stdlib      | File path management        | PSF            |
| **threading**      | stdlib      | Non-blocking execution      | PSF            |

## 7.2 Data sources

| **Source**               | **URL**                                 | **Data retrieved**                                                                                     |
|--------------------------|-----------------------------------------|--------------------------------------------------------------------------------------------------------|
| **MedChemExpress (MCE)** | www.medchemexpress.com                  | Description, /Targets/ links, bibliographic references                                                 |
| **PubChem PUG View**     | pubchem.ncbi.nlm.nih.gov/rest/pug_view  | Full pharmacological data, references                                                                  |
| **PubChem simple API**   | pubchem.ncbi.nlm.nih.gov/rest/pug       | Short description (fallback)                                                                           |
| **PubChem HTML**         | pubchem.ncbi.nlm.nih.gov/compound       | Full HTML page (fallback)                                                                              |
| **canSAR.ai**            | cansar.ai/compound/{id}/target-affinity | Target proteins (Homo sapiens, Mean Potency < 1000 nM), via Playwright, simulated search navigation   |

## 7.3 Execution flow

- Reading the source file → extraction of (name, CID) pairs
- For each compound: opening the MCE page via Playwright (real Chromium browser)
- Extraction from MCE: /Targets/ links, description #product_syn, references #cpd_References1
- MCE fallback: if the direct URL fails, search by name and click on the first result
- PubChem query: PUG View → simple API → HTML
- Target merge: MCE first, PubChem as complement (no duplicates), columns "Target(s) MCE" and "Target(s) PubChem"
- If CanSAR is checked: search compound by name, read Target Affinity table filtered by Homo sapiens / Mean Potency < 1000 nM, written to the "Targets CanSAR" column (never merged with other target columns)
- Write to the Excel file with formatting
- Real-time update of the log and progress bar

# 8. User interface

## 8.1 Left panel (configuration)

| **Section**                | **Content**                                              |
|----------------------------|----------------------------------------------------------|
| **1. Source file**         | CSV/Excel load button + CID column selector              |
| **2. Output folder**       | Folder selector for the generated Excel file             |
| **3. Keywords (optional)** | Additional search terms + words to exclude               |

## 8.2 Right panel (execution and results)

| **Area**              | **Role**                                                             |
|-----------------------|----------------------------------------------------------------------|
| **Run button**        | Starts the search in a separate thread (UI remains responsive)       |
| **Progress bar**      | Displays % completion and current compound                           |
| **Results table**     | Real-time preview of targets found per compound                      |
| **Log**               | Detailed progress log, colour-coded by level (ok/warning/error)      |

## 8.3 Available languages

| **Flag** | **Language**       |
|----------|--------------------|
| 🇫🇷        | French (default)   |
| 🇬🇧        | English            |
| 🇪🇸        | Spanish            |
| 🇵🇹        | Portuguese         |
| 🇩🇪        | German             |
| 🇨🇳        | Simplified Chinese |

# 9. GDPR Compliance and Security

CTInfer was designed from the outset to comply with the requirements of the
General Data Protection Regulation (GDPR, Regulation (EU) 2016/679) and
the ANSSI recommendations for secure development.

| *CTInfer does not process any personal data. The data handled consists exclusively of public chemical identifiers (PubChem CIDs), compound names, and pharmacological information sourced from public scientific databases.* |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

## 9.1 Nature of processed data

| **Data type**                | **Nature**                           | **GDPR sensitivity**   |
|------------------------------|--------------------------------------|------------------------|
| **PubChem CID**              | Public numeric identifier            | NONE: public data      |
| **Compound name**            | Chemical denomination                | NONE: public data      |
| **Biological descriptions**  | Text extracted from public databases | NONE: public data      |
| **Bibliographic references** | Public scientific citations          | NONE: public data      |
| **Excel output file**        | Pharmacological research results     | NONE: no personal data |

## 9.2 GDPR principles applied

**Data minimisation**

CTInfer only collects information strictly necessary for identifying
molecular targets: the compound name and its PubChem CID. No additional
data is required or stored.

**No transmission to unauthorised third parties**

The only network flows from the application are to three public
scientific databases: PubChem (NIH/NCBI, United States), MedChemExpress
(commercial bioactive compound database) and, when the CanSAR source is
enabled, canSAR.ai (MD Anderson Cancer Center). These queries are
equivalent to a manual consultation from a web browser. No user data is
transmitted.

**No additional storage**

CTInfer creates no local copies of data beyond the Excel results file
generated in the folder chosen by the user. No local database, no cache,
no persistent log is created.

**No telemetry**

The application contains no telemetry system, no external logging, and
no connection to third-party cloud services. No usage statistics are
collected or transmitted.

**Traceability**

The real-time log displayed in the interface constitutes a record of
each operation performed during the session. This log is not saved
automatically, it disappears when the application is closed.

## 9.3 Risk analysis

| **Identified risk**                | **Level** | **Mitigation measure**                                                                                                                                               |
|------------------------------------|-----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Personal data leak**             | NONE      | No personal data is processed by the application.                                                                                                                    |
| **Unauthorised transmission**      | LOW       | Only PubChem, MCE and, when enabled, canSAR.ai are queried, public/institutional databases. No other network flow.                                                   |
| **Unauthorised access to results** | LOW       | The Excel output file is stored locally in the folder chosen by the user. Access depends on the workstation security policy.                                         |
| **Source unavailability**          | LOW       | If PubChem or MCE is unavailable, corresponding cells remain empty. The application does not crash.                                                                  |
| **Playwright/Chromium dependency** | LOW       | Playwright is maintained by Microsoft (Apache 2.0). Chromium is Google's open source browser. Two world-class reference organisations.                               |
| **Future MCE compatibility**       | MEDIUM    | If MCE modifies its HTML structure, selectors may need updating. Mitigation: search fallback + regex patterns.                                                       |
| **Future canSAR.ai compatibility** | MEDIUM    | If canSAR.ai modifies its HTML structure or search flow, Playwright selectors may need updating. Source can be disabled independently without affecting MCE/PubChem. |
| **Uncontrolled update**            | LOW       | Standalone application with no automatic updates. Any modification is manually validated.                                                                            |

## 9.4 Compliance with ANSSI recommendations

- Exclusive use of open source libraries maintained by recognised
  organisations (Python Software Foundation, Microsoft, NIH)

- No proprietary or opaque component in the processing chain

- Fully readable and auditable source code

- No privilege escalation required, the application runs in standard
  user mode

- No modification of the Windows registry or system services

- Dependencies installed only via pip (official PyPI channel)

## 9.5 Institutional adoption of technologies used

| **Technology**     | **Publisher**                     | **Adoption references**                                                                                                                |
|--------------------|-----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|
| **Python**         | Python Software Foundation        | Reference language in scientific research, bioinformatics, WHO                                                                         |
| **Playwright**     | Microsoft Corporation             | Used in production by Microsoft, Google, Adobe, GitHub, LinkedIn                                                                       |
| **Chromium**       | Google Chromium Project           | Open source base of Chrome, over 3 billion users                                                                                       |
| **PubChem**        | NIH / NCBI (United States)        | World reference public chemical database, \>115 million compounds                                                                      |
| **MedChemExpress** | MedChemExpress LLC                | Referenced supplier of bioactive compounds for research                                                                                |
| **openpyxl**       | openpyxl project                  | De facto standard for Excel manipulation in Python, MIT license                                                                        |
| **canSAR.ai**      | MD Anderson Cancer Center (Texas) | Integrated cancer research knowledge base (biology, chemistry, pharmacology); academic reference for therapeutic target identification |

# 10. References and sources

| **Source**                      | **URL and reference**                                                           |
|---------------------------------|---------------------------------------------------------------------------------|
| **Python Software Foundation**  | https://www.python.org/about/ Governance, license, security                     |
| **Playwright Microsoft**        | https://playwright.dev Documentation, architecture, Apache 2.0 license          |
| **Chromium Security**           | https://www.chromium.org/Home/chromium-security/                                |
| **PubChem NIH/NCBI**            | https://pubchem.ncbi.nlm.nih.gov Public chemical database                       |
| **PubChem API PUG View**        | https://pubchem.ncbi.nlm.nih.gov/docs/pug-view                                  |
| **MedChemExpress**              | https://www.medchemexpress.com                                                  |
| **GDPR EUR-Lex**                | https://eur-lex.europa.eu/eli/reg/2016/679 Regulation (EU) 2016/679             |
| **ANSSI Python Security Guide** | https://www.ssi.gouv.fr Secure development recommendations                      |
| **canSAR.ai MD Anderson**       | https://cansar.ai Cancer research knowledge base (targets, affinities, biology) |

*Document issued the 30 June 2026*
