# Project Concept
Initial idea is sort of like fantasy football, but for soccer. Users will be able to see stats from three different leagues. These stats will include individual player stats, match stats, referee stats, etc. The primary function (not a fantasy football) would  be to find stats for the various leagues with some visuals to show when players and teams are doing good or bad. 

![A table presenting the data operations of the tables in the Fantasy Football schema.](.\design\Data_Operations.png)
![A table presenting the data operations of the tables in the Fantasy Football schema.](.\design\FantasyFootball_Schema.png)

# Start

## \frontend

We have not started frontend as we are in the early stages of creating and testing our database.

## \backend

### app

app.py is the script that will start the program we will run in the virtual environment (venv). To start you will cd into the backend directory and start the venv (see below for more help). Once you have the venv running then you will be able to use the command

python app.py

which will start the program.

### venv

You will need to have a virtual environment (venv).
To do this you will you use the command (if you are on windows)

cd .\backend\
python -m venv venv

To run your venv (if you are on windows)

venv\Scripts\activate

### db.py

This is the connection to your database.
load_dotenv() line will read your .env (create one by clicking new file and naming it ".env" nothing else) file. This is where you will have your DB_SERVER and DB_NAME located.

### \routes

Routes directory is where each feature is connected to a file. So every file holds their own feature. Also where the raw sql would be found.
Example:

get_player_goals()

This query would get back a selected players goals to be seen on the frontend.