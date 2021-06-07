#!/bin/bash

# ECHO COMMAND
#echo Hello World!

# VARIABLES
#Name="test"
#echo "My name is $NAME"

# USER INPUT
read -p "Enter your name: " NAME
echo "Hello $NAME, nice to meet you!"

# SIMPLE IF STATEMENT
if [ "$NAME" == "test" ]
then
    echo "Your name is test"
else 
    echo "Your name is not test"
fi

# ELSE_IF (elif)
if [ "$NAME" == "test" ]
then
    echo "Your name is test"
elif [ "$NAME" == "juan" ]
then 
    echo "Your name is juan"
else 
    echo "Your name is not test or juan"
fi

#COMPARISON
NUM=9
NUM2=12
if [ "$NUM1" -gt "$NUM2" ]
then
    echo "$NUM1 is greater than $NUM2"
else
    echo "$NUM1 is less than $NUM2"
fi

# FILE CONDITIONS
FILE="test.txt"
if [ -f "$FILE" ]
then
    echo "$FILE is a file"
else
    echo "$FILE is not a file"
fi

# CASE STATEMENT
read -p "ARE you 21 or over? Y/N " ANSWER
case "$ANSWER" in 
    [yY] | [yY] [eE] [sS])
      echo "You can have a beer!"
      ;;
    [nN] | [nN] [oO])
      echo "No drink for you :("
      ;;
    *)
      echo "Please enter y/yes or n/no"
      ;;
esac    

# SIMPLE FOR LOOP
NAMES="Brad Kevin ALice Mark"
for NAME in $NAMES
    do
      echo "Hello $NAME"
done

# FOR LOOP TO RENAME FILES
FILES=$(ls *.txt)
NEW="new"
for FILE in $FILES
  do 
    echo "Renaming $FILE to new-$FILE"
    mv $FILE $NEW-$FILE
done

# WHILE LOOP - READ THROUGH A FILE LINE BY LINE
LINE=1
while read -r CURRENT_LINE
    do
       echo "$LINE: $CURRENT_LINE"
       ((LINE++))
done < "./new-1.txt"

# FUNCTION
function sayHello() {
    echo "Hello World"
}

sayHello

# FUNCTION WITH PARAMS
function greet() {
    echo "Hello, I am $1 and I am $2"
}

greet "Brad" "36"

# CREATE FOLDER AND WRITE TO A FILE
mkdir hello
touch "hello/world.txt"
echo "Hello World" >> "hello/world.txt"
echo "Created hello/world.txt"