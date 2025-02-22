#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Verificar si se pasó un argumento
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Buscar el elemento en la base de datos
if [[ $1 =~ ^[0-9]+$ ]]; then
  ELEMENT_QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                 FROM elements 
                 JOIN properties USING(atomic_number) 
                 JOIN types USING(type_id) 
                 WHERE atomic_number=$1"
else
  ELEMENT_QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                 FROM elements 
                 JOIN properties USING(atomic_number) 
                 JOIN types USING(type_id) 
                 WHERE name='$1' OR symbol='$1'"
fi

RESULT=$($PSQL "$ELEMENT_QUERY")

# Verificar si el elemento existe
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

# Extraer datos
IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"

# Mostrar la información del elemento
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
