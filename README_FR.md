**CTInfer**  
**Compound Target Inference Tool**

*Documentation technique & Guide d'utilisation*

|             |               |
|-------------|---------------|
| **Version** | 1.0           |
| **Date**    | 30 juin 2026  |
| **Auteur**  | Maxence Belin |
| **Statut**  | Finalisé |
| **Licence** | GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 |

**1. Présentation**

CTInfer (Molecular Inhibitor Research Assistant) est une application de
bureau permettant d'identifier automatiquement les protéines inhibées
par des composés chimiques. À partir d'une liste de composés et de leurs
identifiants PubChem (CID), CTInfer interroge simultanément trois bases
de données de référence, PubChem, MedChemExpress et canSAR.ai, extrait les cibles
moléculaires, les mots-clés de détection, les descriptions biologiques
et les références bibliographiques, puis génère un fichier Excel
structuré.

|                                                                                                                                                                                                                                    |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| *CTInfer est conçu pour traiter des centaines de composés en une seule session, en combinant l'intelligence de trois sources complémentaires : PubChem (base publique NCBI) et MedChemExpress (fournisseur de composés bioactifs) et canSAR.ai (base oncologique du MD Anderson Cancer Center).* |

## 1.1 Problème résolu

L'identification manuelle des cibles moléculaires pour un panel de
composés est une tâche longue et répétitive. Pour chaque composé, il
faut consulter PubChem, MedChemExpress et canSAR.ia, extraire les informations
pertinentes, les consolider et les mettre en forme. Pour plus de 500 composés,
cela représente des heures de travail.

CTInfer automatise entièrement ce processus et génère un tableau Excel
structuré en quelques dizaines de minutes.

## 1.2 Capacités principales

- Chargement d'un fichier Excel ou CSV contenant les noms de composés et
  leurs CID PubChem

- Interrogation automatique de MedChemExpress via un vrai navigateur
  (Playwright/Chromium)

- Interrogation de PubChem via l'API PUG View (3 endpoints en cascade)

- Extraction des cibles moléculaires inhibées depuis les liens /Targets/
  de MCE

- Extraction des cibles par 14 patterns regex différents sur les textes
  de description

- Identification du mot-clé qui a déclenché la détection (MCE et PubChem
  séparément)

- Récupération des descriptions biologiques complètes (MCE et PubChem)

- Récupération de toutes les références bibliographiques (MCE : onglet
  Références ; PubChem : champs Reference)

- Génération d'un fichier Excel formaté avec 9 colonnes et filtre
  automatique

- Fallback par recherche MCE si l'URL directe ne fonctionne pas

- Interface multilingue : français, anglais, espagnol, portugais,
  allemand, chinois

- Journal en temps réel avec progression par composé

- Interrogation de canSAR.ai (target affinity) : récupère les cibles
  validées Homo sapiens avec Mean Potency \< 1000 nM

# 2. Installation

## 2.1 Prérequis

|                            |                                        |
|----------------------------|----------------------------------------|
| **Prérequis**              | **Détail**                             |
| **Système d'exploitation** | Windows 10 ou 11 (64 bits)             |
| **Python**                 | Version 3.8 ou supérieure              |
| **Connexion internet**     | Requise pour interroger PubChem et MCE |
| **Espace disque**          | ~500 Mo (Chromium inclus)              |

## 2.2 Contenu du dossier CTInfer

|                        |                                                          |
|------------------------|----------------------------------------------------------|
| **Fichier**            | **Rôle**                                                 |
| **CTInfer_app.py**     | Script principal de l'application                        |
| **translations.py**    | Traductions (6 langues)                                  |
| **Lancer_CTInfer.bat** | Lanceur Windows installe les dépendances automatiquement |
| **CTInfer.ico**        | Icône de l'application                                   |
| **settings.json**      | Préférences utilisateur (créé automatiquement)           |

## 2.3 Installation

**Étape 1 : Installer Python**

- Aller sur https://python.org/downloads

- Télécharger la dernière version stable (3.11 ou supérieur recommandé)

- Lors de l'installation, cocher impérativement la case Add Python to
  PATH

**Étape 2 : Premier lancement**

- Double-cliquer sur Lancer_CTInfer.bat

- Lors du premier lancement, les dépendances sont installées
  automatiquement : Playwright, Chromium, openpyxl, beautifulsoup4

- Cette installation ne se produit qu'une seule fois (environ 3–5
  minutes)

|                                                                                  |
|----------------------------------------------------------------------------------|
| *Ne pas fermer la fenêtre noire pendant l'installation automatique de Chromium.* |

# 3. Obtention des CID PubChem

CTInfer nécessite les identifiants CID PubChem pour chaque composé. Si
vous disposez uniquement des noms des molécules, voici la marche à
suivre pour obtenir les CID correspondants en quelques minutes.

| *Le CID (Compound ID) est l'identifiant numérique unique attribué par PubChem à chaque molécule. Il est indispensable pour que CTInfer puisse interroger la base de données.* |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

## 3.1 Conversion des noms en CID via PubChem ID Exchange

PubChem propose un outil en ligne gratuit permettant de convertir en
masse une liste de noms de molécules en CID. Voici la procédure :

| **1** | Aller sur le service PubChem ID Exchange : https://pubchem.ncbi.nlm.nih.gov/idexchange/ |
|-------|-----------------------------------------------------------------------------------------|

| **2** | Dans la section Input ID List, sélectionner « Synonyms » dans le menu déroulant : cela permet d'entrer des noms courants, des noms IUPAC, des noms commerciaux, des numéros CAS, etc. |
|-------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

| **3** | Coller la liste de noms de molécules directement dans le champ texte (un nom par ligne), ou cliquer sur Import File pour charger un fichier .txt contenant la liste. |
|-------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|

| **4** | Dans la section Output IDs, sélectionner « CIDs » dans le menu déroulant. |
|-------|---------------------------------------------------------------------------|

| **5** | Cliquer sur Submit Job et attendre quelques secondes. Les CID correspondants s'affichent ou peuvent être téléchargés. |
|-------|-----------------------------------------------------------------------------------------------------------------------|

## 3.2 Format du fichier pour CTInfer

Une fois les CID obtenus, préparer un fichier Excel avec au minimum deux
colonnes :

| **Colonne**  | **Contenu**                   | **Exemple** |
|--------------|-------------------------------|-------------|
| **Compound** | Nom du composé                | Dacinostat  |
| **CID**      | Identifiant PubChem numérique | 6445533     |

| *Si un composé n'est pas trouvé par PubChem ID Exchange, essayer des variantes du nom (nom commercial, numéro CAS, nom IUPAC). Certains composés très récents ou propriétaires peuvent ne pas figurer dans PubChem.* |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

# 

# 

# 

# 

# 4. Utilisation

## 4.1 Préparer le fichier source

CTInfer accepte un fichier Excel (.xlsx) ou CSV (.csv) contenant au
minimum deux colonnes :

|                             |                               |              |
|-----------------------------|-------------------------------|--------------|
| **Colonne**                 | **Contenu**                   | **Exemple**  |
| **Compound (ou similaire)** | Nom du composé                | Sangivamycin |
| **CID (ou similaire)**      | Identifiant PubChem numérique | 14978        |

CTInfer détecte automatiquement la colonne CID (colonne dont le nom
contient "cid") et la colonne composé (colonne dont le nom contient
"compound").

## 4.2 Choix des sources de recherche

Dans la section « 3. Sources de recherche » du panneau gauche, deux
cases à cocher permettent de sélectionner les bases à interroger :

| **Option**                     | **Comportement**                                                                                                                                                                                                                                |
|--------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **☑ MCE + ☑ PubChem (défaut)** | Interroge les deux sources et fusionne les résultats                                                                                                                                                                                            |
| **☑ MCE uniquement**           | Recherche uniquement sur MedChemExpress (plus rapide)                                                                                                                                                                                           |
| **☑ PubChem uniquement**       | Recherche uniquement via l'API PubChem (plus rapide)                                                                                                                                                                                            |
| **☑ CanSAR (optionnel)**       | Interroge en plus la base canSAR.ai (target affinity) ; ne retient que les protéines dont l'organisme est Homo sapiens et dont le Mean Potency est strictement inférieur à 1000 nM. Décochée par défaut (plus lente, navigation par recherche). |

## 4.3 Lancer une recherche

|           |                                                                                                                                                          |
|-----------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Étape** | **Action**                                                                                                                                               |
| **1**     | Charger le fichier Excel ou CSV via le bouton de chargement                                                                                              |
| **2**     | Sélectionner la colonne CID dans le menu déroulant (auto-détectée)                                                                                       |
| **3**     | Choisir le dossier de sortie pour le fichier Excel résultant                                                                                             |
| **4**     | Vérifier les termes de recherche et mots à exclure si nécessaire                                                                                         |
| **5**     | Cliquer sur Lancer la recherche PubChem                                                                                                                  |
| **6**     | Suivre la progression dans le journal en temps réel                                                                                                      |
| **7**     | Récupérer le fichier Results_targets.xlsx dans le dossier choisi (un suffixe \_1, \_2… est ajouté automatiquement si un fichier du même nom existe déjà) |

## 4.4 Mots à exclure

La zone « Mots à exclure » contient des termes qui, s'ils précèdent un
inhibiteur dans le texte, invalident la détection. Par exemple, le mot
"not" dans "does not inhibit X" empêche X d'être listé comme cible. Les
valeurs par défaut (not, no) sont adaptées à la majorité des cas.

## 4.5 Durée estimée

|                  |                   |                  |
|------------------|-------------------|------------------|
| **Volume**       | **Durée estimée** | **Note**         |
| **30 composés**  | 5–10 minutes      | Test rapide      |
| **100 composés** | 20–35 minutes     | Session standard |
| **350 composés** | 60–90 minutes     | Session complète |

Le temps principal est lié à MedChemExpress (Playwright charge chaque
page en 3–5 secondes comme un vrai navigateur). PubChem est interrogé
via API et est plus rapide.

# 5. Fichier de sortie Excel

## 5.1 Structure du fichier

Le fichier Results_targets.xlsx contient 10 colonnes avec filtre
automatique et ligne d'en-tête fixée :

|                         |                                                                                                                   |
|-------------------------|-------------------------------------------------------------------------------------------------------------------|
| **Colonne**             | **Contenu**                                                                                                       |
| **Compound Name**       | Nom du composé tel que saisi dans le fichier source                                                               |
| **CID**                 | Identifiant PubChem numérique                                                                                     |
| **Target(s)**           | Protéines inhibées, séparées par des points-virgules                                                              |
| **Targets CanSAR**      | Protéines issues de canSAR.ai (Homo sapiens, Mean Potency \< 1000 nM), si la source CanSAR est cochée, vide sinon |
| **Keyword MCE**         | Mot ou pattern qui a déclenché la détection depuis MCE                                                            |
| **Keyword PubChem**     | Mot ou pattern qui a déclenché la détection depuis PubChem                                                        |
| **Description MCE**     | Phrase descriptive extraite de MedChemExpress                                                                     |
| **Description PubChem** | Phrase descriptive extraite de PubChem                                                                            |
| **References MCE**      | Références bibliographiques de l'onglet Références MCE                                                            |
| **References PubChem**  | Références trouvées dans PubChem                                                                                  |

## 5.2 Mise en forme

- Lignes vertes : composé avec au moins une cible trouvée

- Lignes jaunes : composé sans cible identifiée

- Filtre automatique sur toutes les colonnes

- Ligne d'en-tête fixée (freeze panes)

# 6. Mécanisme d'extraction des cibles

## 6.1 Priorité des sources

CTInfer interroge d'abord MedChemExpress puis PubChem. Les cibles MCE
sont prioritaires car MCE identifie explicitement les cibles dans sa
base de données. CanSAR, lorsqu'il est activé, fonctionne en parallèle
et de manière indépendante : ses résultats alimentent uniquement la
colonne « Targets CanSAR » et ne sont jamais fusionnés avec la colonne «
Target(s) » issue de MCE/PubChem.

|              |               |                                                                                                                                                                                   |
|--------------|---------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Priorité** | **Source**    | **Méthode**                                                                                                                                                                       |
| **1**        | MCE           | Liens \<a href='/Targets/...'\> dans le paragraphe de description                                                                                                                 |
| **2**        | MCE regex     | 14 patterns regex sur le texte de description MCE                                                                                                                                 |
| **3**        | PubChem regex | 14 patterns regex sur le texte PubChem                                                                                                                                            |
| **4**        | CanSAR        | Recherche du composé par nom sur canSAR.ai, lecture du tableau Target Affinity, filtre strict Homo sapiens + Mean Potency \< 1000 nM. Ne suit pas les patterns regex MCE/PubChem. |

## 6.2 Patterns de détection

|                                   |                                                     |
|-----------------------------------|-----------------------------------------------------|
| **Pattern**                       | **Exemple**                                         |
| **Liens MCE /Targets/**           | \<a href='/Targets/ERK.html'\>ERK\</a\>             |
| **Nom composé : X/Y Inhibitor N** | HDACs/mTOR Inhibitor 1 → HDACs, mTOR                |
| **Nom composé : X-IN-N**          | PLK1/BRD4-IN-5 → PLK1, BRD4                         |
| **"inhibitor of X (ABR)"**        | inhibitor of histone deacetylase (HDAC) → HDAC      |
| **"X inhibitor"**                 | CDK9 inhibitor → CDK9                               |
| **"inhibits X"**                  | inhibits PKC → PKC                                  |
| **"designed to inhibit X"**       | designed to inhibit IGF1R → IGF1R                   |
| **"dual X and Y inhibitor"**      | dual PI3K and HDAC inhibitor → PI3K, HDAC           |
| **"inhibition of X pathway"**     | inhibition of PI3K/Akt/mTOR pathway → PI3K/Akt/mTOR |
| **"suppression of X"**            | suppression of VEGFR-2 signaling → VEGFR-2          |
| **"X/Y/Z pathway"**               | PI3K/Akt/mTOR pathway → PI3K/Akt/mTOR               |
| **"through inhibition of X"**     | through inhibition of Akt → Akt                     |
| **"blocks X"**                    | blocks ATM pathway → ATM                            |
| **"binds to / targets X"**        | binds to Aurora kinases → Aurora kinases            |

## 6.3 Filtres anti-faux-positifs

- Mots parasites en début de cible : a, an, the, both, many, novel,
  potent, selective, cancer, tumor, cell, activity...

- Mots génériques seuls : inhibitor, kinase, receptor, enzyme...

- Lignes cellulaires : HepG2, MCF7, HCC, patterns X/Y de type G2/ADM

- Phrases avec verbes : is, are, was, were, has, have, can, will...

- Mots à exclure configurables par l'utilisateur (not, no par défaut)

# 7. Architecture technique

## 7.1 Technologies et bibliothèques

|                    |             |                                       |              |
|--------------------|-------------|---------------------------------------|--------------|
| **Bibliothèque**   | **Version** | **Rôle**                              | **Licence**  |
| **Python**         | 3.8+        | Langage principal                     | PSF          |
| **tkinter**        | stdlib      | Interface graphique                   | PSF (inclus) |
| **Playwright**     | ≥ 1.40      | Navigation MCE (Chromium)             | Apache 2.0   |
| **BeautifulSoup4** | ≥ 4.12      | Parsing HTML                          | MIT          |
| **requests**       | ≥ 2.31      | Requêtes API PubChem                  | Apache 2.0   |
| **openpyxl**       | ≥ 3.1       | Lecture/écriture Excel                | MIT          |
| **Pillow**         | ≥ 10.0      | Génération de l'icône .ico            | PIL          |
| **re**             | stdlib      | Extraction par expressions régulières | PSF          |
| **json**           | stdlib      | Settings et configuration             | PSF          |
| **pathlib**        | stdlib      | Gestion des chemins de fichiers       | PSF          |
| **threading**      | stdlib      | Exécution non-bloquante (UI réactive) | PSF          |

## 7.2 Sources de données

|                          |                                         |                                                                                                            |
|--------------------------|-----------------------------------------|------------------------------------------------------------------------------------------------------------|
| **Source**               | **URL**                                 | **Données récupérées**                                                                                     |
| **MedChemExpress (MCE)** | www.medchemexpress.com                  | Description, liens /Targets/, références bibliographiques                                                  |
| **PubChem PUG View**     | pubchem.ncbi.nlm.nih.gov/rest/pug_view  | Données pharmacologiques complètes, références                                                             |
| **PubChem API simple**   | pubchem.ncbi.nlm.nih.gov/rest/pug       | Description courte (fallback)                                                                              |
| **PubChem HTML**         | pubchem.ncbi.nlm.nih.gov/compound       | Page HTML complète (fallback)                                                                              |
| **canSAR.ai**            | cansar.ai/compound/{id}/target-affinity | Protéines cibles (Homo sapiens, Mean Potency \< 1000 nM), via Playwright, navigation simulée par recherche |

## 7.3 Flux d'exécution

- Lecture du fichier source → extraction des paires (nom, CID)

- Pour chaque composé : ouverture de la page MCE via Playwright (vrai
  navigateur Chromium)

- Extraction depuis MCE : liens /Targets/, description \#product_syn,
  références \#cpd_References1

- Fallback MCE : si l'URL directe échoue, recherche par nom et clic sur
  premier résultat

- Interrogation PubChem en parallèle : PUG View → API simple → HTML

- Fusion des cibles : MCE prioritaire, PubChem en complément (sans
  doublon), colonne « Target(s) »

- CanSAR coché : recherche du composé par nom, lecture du tableau Target
  Affinity filtré Homo sapiens / Mean Potency \< 1000 nM, écriture dans
  la colonne « Targets CanSAR » (jamais fusionnée avec « Target(s) »)

- Écriture dans le fichier Excel avec mise en forme

- Mise à jour du journal et de la barre de progression en temps réel

# 8. Interface utilisateur

## 8.1 Panneau gauche (configuration)

|                              |                                                           |
|------------------------------|-----------------------------------------------------------|
| **Section**                  | **Contenu**                                               |
| **1. Fichier source**        | Bouton de chargement CSV/Excel + sélecteur de colonne CID |
| **2. Dossier de sortie**     | Sélecteur du dossier où sera généré le fichier Excel      |
| **3. Mots-clés (optionnel)** | Termes de recherche supplémentaires + mots à exclure      |

## 8.2 Panneau droit (exécution et résultats)

|                           |                                                                    |
|---------------------------|--------------------------------------------------------------------|
| **Zone**                  | **Rôle**                                                           |
| **Bouton Lancer**         | Démarre la recherche dans un thread séparé (UI non bloquée)        |
| **Barre de progression**  | Affiche le % d'avancement et le composé en cours                   |
| **Tableau des résultats** | Aperçu en temps réel des cibles trouvées par composé               |
| **Journal**               | Log détaillé de l'avancement, coloré par niveau (ok/warning/error) |

## 8.3 Langues disponibles

|             |                   |
|-------------|-------------------|
| **Drapeau** | **Langue**        |
| **🇫🇷**      | Français (défaut) |
| **🇬🇧**      | English           |
| **🇪🇸**      | Español           |
| **🇵🇹**      | Português         |
| **🇩🇪**      | Deutsch           |
| **🇨🇳**      | Chinois simplifié |

# 9. Conformité RGPD et sécurité

CTInfer a été conçu dès l'origine pour respecter les exigences du
Règlement Général sur la Protection des Données (RGPD Règlement (UE)
2016/679) et les recommandations de l'ANSSI en matière de développement
sécurisé.

| *CTInfer ne traite aucune donnée à caractère personnel. Les données manipulées sont exclusivement des identifiants chimiques publics (CID PubChem), des noms de composés et des informations pharmacologiques issues de bases de données scientifiques publiques.* |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

## 9.1 Nature des données traitées

| **Type de données**             | **Nature**                             | **Sensibilité RGPD**               |
|---------------------------------|----------------------------------------|------------------------------------|
| **CID PubChem**                 | Identifiant numérique public           | AUCUNE : donnée publique           |
| **Nom du composé**              | Dénomination chimique                  | AUCUNE : donnée publique           |
| **Descriptions biologiques**    | Texte extrait de bases publiques       | AUCUNE : donnée publique           |
| **Références bibliographiques** | Citations scientifiques publiques      | AUCUNE : donnée publique           |
| **Fichier Excel de sortie**     | Résultats de recherche pharmacologique | AUCUNE : pas de donnée personnelle |

## 9.2 Principes RGPD appliqués

**Minimisation des données**

CTInfer ne collecte que les informations strictement nécessaires à
l'identification des cibles moléculaires : le nom du composé et son CID
PubChem. Aucune donnée supplémentaire n'est requise ou stockée.

**Absence de transmission vers des tiers non autorisés**

Les seuls flux réseau de l'application sont vers trois bases de données
scientifiques publiques : PubChem (NIH/NCBI, États-Unis), MedChemExpress
(base commerciale de composés bioactifs) et, si la source CanSAR est
activée, canSAR.ai (MD Anderson Cancer Center). Ces interrogations sont
équivalentes à une consultation manuelle depuis un navigateur web.
Aucune donnée utilisateur n'est transmise.

**Pas de stockage supplémentaire**

CTInfer ne crée aucune copie locale des données au-delà du fichier Excel
de résultats généré dans le dossier choisi par l'utilisateur. Aucune
base de données locale, aucun cache, aucun log persistant n'est créé.

**Absence de télémétrie**

L'application ne contient ni système de télémétrie, ni journalisation
externe, ni connexion à des services cloud tiers. Aucune statistique
d'utilisation n'est collectée ou transmise.

**Traçabilité**

Le journal en temps réel affiché dans l'interface constitue une trace de
chaque opération effectuée durant la session. Ce journal n'est pas
sauvegardé automatiquement, il disparaît à la fermeture de
l'application.

## 9.3 Analyse des risques

| **Risque identifié**                 | **Niveau** | **Mesure de mitigation**                                                                                                                                                                           |
|--------------------------------------|------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Fuite de données personnelles**    | NONE       | Aucune donnée personnelle n'est traitée par l'application.                                                                                                                                         |
| **Transmission non autorisée**       | FAIBLE     | Seuls PubChem, MCE et, si activé, canSAR.ai sont interrogés : bases publiques/institutionnelles. Aucun autre flux réseau.                                                                          |
| **Accès non autorisé aux résultats** | FAIBLE     | Le fichier Excel de sortie est stocké localement dans le dossier choisi par l'utilisateur. L'accès dépend de la politique de sécurité du poste.                                                    |
| **Indisponibilité des sources**      | FAIBLE     | En cas d'indisponibilité de PubChem ou MCE, les cellules correspondantes restent vides. L'application ne plante pas.                                                                               |
| **Dépendance à Playwright/Chromium** | FAIBLE     | Playwright est maintenu par Microsoft (Apache 2.0). Chromium est le navigateur open source de Google. Deux organisations mondiales de référence.                                                   |
| **Compatibilité MCE future**         | MOYEN      | Si MCE modifie sa structure HTML, les sélecteurs peuvent nécessiter une mise à jour. Mitigation : fallback par recherche + patterns regex.                                                         |
| **Compatibilité canSAR.ai future**   | MOYEN      | Si canSAR.ai modifie sa structure HTML ou son parcours de recherche, les sélecteurs Playwright peuvent nécessiter une mise à jour. Source désactivable indépendamment sans impact sur MCE/PubChem. |
| **Mise à jour non contrôlée**        | FAIBLE     | Application autonome sans mise à jour automatique. Toute modification est validée manuellement.                                                                                                    |

## 9.4 Conformité aux recommandations ANSSI

- Utilisation exclusive de bibliothèques open source maintenues par des
  organisations reconnues (Python Software Foundation, Microsoft, NIH)

- Pas de composant propriétaire ou opaque dans la chaîne de traitement

- Code source entièrement lisible et auditable

- Aucune élévation de privilèges requise, l'application fonctionne en
  mode utilisateur standard

- Pas de modification du registre Windows ni de services système

- Dépendances installées uniquement via pip (canal officiel PyPI)

## 9.5 Adoption institutionnelle des technologies utilisées

| **Technologie**    | **Éditeur**                       | **Références d'adoption**                                                                                                                              |
|--------------------|-----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Python**         | Python Software Foundation        | Langage de référence en recherche scientifique, bioinformatique, OMS                                                                                   |
| **Playwright**     | Microsoft Corporation             | Utilisé en production par Microsoft, Google, Adobe, GitHub, LinkedIn                                                                                   |
| **Chromium**       | Google Chromium Project           | Base open source de Chrome, plus de 3 milliards d'utilisateurs                                                                                         |
| **PubChem**        | NIH / NCBI (États-Unis)           | Base de données chimique publique de référence mondiale, \>115 millions de composés                                                                    |
| **MedChemExpress** | MedChemExpress LLC                | Fournisseur référencé de composés bioactifs pour la recherche                                                                                          |
| **openpyxl**       | Projet openpyxl                   | Standard de facto pour la manipulation Excel en Python, licence MIT                                                                                    |
| **canSAR.ai**      | MD Anderson Cancer Center (Texas) | Base de connaissances intégrée en cancérologie (biologie, chimie, pharmacologie) ; référence académique pour l'identification de cibles thérapeutiques |

# 10. Références et sources

| **Source**                      | **URL et référence**                                                               |
|---------------------------------|------------------------------------------------------------------------------------|
| **Python Software Foundation**  | https://www.python.org/about/ Gouvernance, licence, sécurité                       |
| **Playwright Microsoft**        | https://playwright.dev Documentation, architecture, licence Apache 2.0             |
| **Chromium Security**           | https://www.chromium.org/Home/chromium-security/                                   |
| **PubChem NIH/NCBI**            | https://pubchem.ncbi.nlm.nih.gov Base chimique publique                            |
| **PubChem API PUG View**        | https://pubchem.ncbi.nlm.nih.gov/docs/pug-view                                     |
| **MedChemExpress**              | https://www.medchemexpress.com                                                     |
| **RGPD EUR-Lex**                | https://eur-lex.europa.eu/eli/reg/2016/679 Règlement (UE) 2016/679                 |
| **ANSSI Guide sécurité Python** | https://www.ssi.gouv.fr Recommandations développement sécurisé                     |
| **canSAR.ai MD Anderson**       | https://cansar.ai Base de connaissances cancérologie (cibles, affinités, biologie) |

*Document établi le 30 juin 2026*
