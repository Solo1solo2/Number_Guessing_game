#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your username: "
read USER

USERNAME=$($PSQL "SELECT username FROM users WHERE username = '$USER'")
GAME=$($PSQL "SELECT COUNT(*) FROM users INNER JOIN games USING(user_id) WHERE username='$USER'")
BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM users INNER JOIN games USING(user_id) WHERE username='$USER'") 


if [[ -z $USERNAME ]]
  then
   INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USER')")
  echo "Welcome, $USER! It looks like this is your first time here."
   else
    echo -e "\nWelcome back, $USER! You have played $GAME games, and your best game took $BEST_GAME guesses."
  fi
  RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))
  GUESS=1
      echo -e "\nGuess the secret number between 1 and 1000:"
   while read INPUT 
    do
    if [[ ! $INPUT =~ ^[0-9]+$ ]]
      then
         echo -e "\nThat is not an integer, guess again:"
       else
       if [[ $INPUT -eq $RANDOM_NUMBER ]]
        then
          break;
        else
        if [[ $INPUT -gt $RANDOM_NUMBER ]]
         then
            echo "It's lower than that, guess again:"
        elif [[ $INPUT -lt $RANDOM_NUMBER ]]
          then
            echo "It's higher than that, guess again:"
          fi
        fi
      fi
      GUESS=$(( $GUESS + 1 ))
    done
    if [[ $GUESS == 1 ]]
     then
       echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
      else
       echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
      fi

      USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USER'")
      INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(user_id, number_of_guesses) VALUES($USER_ID, $GUESS)")
