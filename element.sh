#! /bin/bash

#run PSQL
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#read argument
ELEMENT=$1

#check if argument exists
if [[ -z $ELEMENT ]]
then
#print missing argument text
  echo "Please provide an element as an argument."
else
  #check if element not Number
  if [[ ! $ELEMENT =~ ^[0-9]+$ ]]
  then
    #read argument string
    ARGUMENT_SYMBOL=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    #check if argument is symbol
    if [[ -z $ARGUMENT_SYMBOL ]]
    then
      ARGUMENT_NAME=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
      #check if argument is name
      if [[ -z $ARGUMENT_NAME ]]
      then
        #element does not exist
        echo "I could not find that element in the database."
      else
        #get information of argument is name
        READ_ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number='$ARGUMENT_NAME'")
        #while loop to read and print text
        echo "$READ_ELEMENT_INFO" | while read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELT BAR BOIL BAR
        do
          echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
        done    
      fi
    else  
      #get information if argument is symbol
      READ_ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number='$ARGUMENT_SYMBOL'")
      ##while loop to read and print text
      echo "$READ_ELEMENT_INFO" | while read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELT BAR BOIL BAR
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi
  else
    #get information if argument is number
    ARGUMENT_NR=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    #check if number is atomic number
    if [[ -z $ARGUMENT_NR ]]
    then
      echo "I could not find that element in the database."
    else
      #get information of argument is atomic number
      READ_ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number='$ARGUMENT_NR'")
      #while loop to read and print text
      echo "$READ_ELEMENT_INFO" | while read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELT BAR BOIL BAR
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi
  fi
fi