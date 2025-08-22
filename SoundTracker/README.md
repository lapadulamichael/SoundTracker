# Mini SoundTracker (OCaml)

Projet universitaire en **OCaml** : génération d’un fichier **WAV** à partir d’une composition (patrons, pistes, instruments).
Le programme convertit une partition déclarative en **échantillons audio** (44.1 kHz) via **synthèse additive**.

## Fonctionnalités
- **Composition** → ordre de **patrons**, chaque patron regroupe des **pistes** jouées en parallèle.
- **Pistes** → suite d’instructions : `N` (note), `S` (silence), `C` (continue).
- **Notes** → nom + octave + dièse (optionnel) + volume → calcul de la **fréquence**.
- **Instruments** → somme de fonctions d’onde : **Sin**, **Pulse**, **Triangle** (avec enveloppes simples).
- **Rendu** → échantillonnage à **44 100 Hz**, mixage des pistes, **clamp** des valeurs à `[-32767, 32767]`, export **.wav**.

## Points techniques
- Calcul de fréquence au tempérament égal (A4=440 Hz).
- Gestion de la durée par pas (`Dc`) et continuation (`C`).
- Synthèse additive avec phase, duty-cycle, enveloppes.
- Concaténation des patrons et mixage des pistes (somme indice-à-indice).

## Build & Run
```bash
ocamlc -o tp2 wave.mli wave.ml tracker.mli tracker.ml principal.ml
./tp2
