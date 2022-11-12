#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")

cat games.csv | while IFS="," read YEAR ROUND WIN OP WIN_GOALS OP_GOALS
do
  # get winner and opponent
  TEAM_WIN=$($PSQL "SELECT name FROM teams WHERE name='$WIN'")
  TEAM_OP=$($PSQL "SELECT name FROM teams WHERE name='$OP'")

  # insert winner into teams
  if [[ $WIN != "winner" ]]
  then
    if [[ -z $TEAM_WIN ]]
    then
      INSERT_WIN=$($PSQL "INSERT INTO teams(name) VALUES('$WIN')")
    fi
  fi

  # insert opponent into teams
  if [[ $OP != "opponent" ]]
  then
    if [[ -z $TEAM_OP ]]
    then
      INSERT_OP=$($PSQL "INSERT INTO teams(name) VALUES('$OP')")
    fi 
  fi

  # get team_id (winner and opponent)

  WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
  OP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OP'")
  
  if [[ $YEAR != "year" ]]
  then
    INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND', $WIN_ID, $OP_ID, '$WIN_GOALS', '$OP_GOALS')")
  fi

done