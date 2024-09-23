#!/bin/bash

# Déterminer le chemin du répertoire où se trouve le script
REPO_PATH=$(dirname "$0")
TODO_FILE="$REPO_PATH/todo.txt"

# Fonction pour afficher les tâches numérotées
afficher_taches() {
  echo "Liste des tâches :"
  nl -w 2 -s ") " "$TODO_FILE" # Utiliser 'nl' pour numéroter les lignes
}

# Fonction pour ajouter une tâche
ajouter_tache() {
  echo "- [ ] $*" >> "$TODO_FILE"
  echo "Tâche ajoutée: $*"
}

# Fonction pour marquer une tâche comme effectuée par numéro
marquer_effectuee() {
  ligne_num=$1
  # Vérifier si l'on est sur un système comme macOS qui requiert un argument avec -i
  if sed --version >/dev/null 2>&1; then
    # Utiliser sed avec l'option -i pour Linux
    sed -i "${ligne_num}s/\[ \]/[x]/" "$TODO_FILE"
  else
    # Utiliser sed avec l'option -i '' pour macOS
    sed -i "" "${ligne_num}s/\[ \]/[x]/" "$TODO_FILE"
  fi
  echo "Tâche #$ligne_num marquée comme effectuée."
}

# Fonction pour supprimer une tâche par numéro
supprimer_tache() {
  ligne_num=$1
  if sed --version >/dev/null 2>&1; then
    sed -i "${ligne_num}d" "$TODO_FILE"
  else
    sed -i "" "${ligne_num}d" "$TODO_FILE"
  fi
  echo "Tâche #$ligne_num supprimée."
}

# Fonction pour supprimer toutes les tâches
supprimer_toutes_les_taches() {
  > "$TODO_FILE" # Vide le fichier todo.txt
  echo "Toutes les tâches ont été supprimées."
}

# Vérifier quelle commande est passée
case "$1" in
  list) afficher_taches ;;
  add) shift; ajouter_tache "$@" ;;
  done) marquer_effectuee "$2" ;;
  drop) supprimer_tache "$2" ;;
  clear) supprimer_toutes_les_taches ;;
  *) echo "Usage: $0 {list|add|done|drop|clear} [tâche|numéro]"; exit 1 ;;
esac
