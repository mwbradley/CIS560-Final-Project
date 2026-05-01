# Project Concept
Initial idea is sort of like fantasy football, but for soccer. Users will be able to see stats from three different leagues. These stats will include individual player stats, match stats, referee stats, etc. The primary function (not a fantasy football) would  be to find stats for the various leagues with some visuals to show when players and teams are doing good or bad. 

![A table presenting the Fantasy Football schema.](./design/FantasyFootball_Schema.png)
![A table presenting the data operations of the tables in the Fantasy Football schema.](./design/Data_Operations.png)

# Start

To be able to run the project you must do a couple of things. The first is to set up a virtual environment (see below) and run the the command

pip install -r ./requirements.txt

which will install what you need. There are a few more steps that you will be required to install but those are mentioned in the next few sections.

To start the program you will need to go into a virtual environment (venv) and run the command

python app.py

then you will need to cd into the frontend folder and run

npm start
o

and it will open the webpage which is a login page. 

If you do not have anything installed, see below and it will walk you through the steps to properly install everything.

## \frontend

Frontend was done using ReactJS. To be able to run the program you first must install all the dependencys by going into the frontend directory and running the command

npm install

which will install everything you need.

## \database

Go into the the database directory. Here you will need to run the venv again, and then install the requirements text file to be able to insert the data. 

python -m venv venv

then venv\Scripts\activate then pip install -r requirements.txt

After you have those installed and running you now want to run the sql_setup file.
It will take around 5-10 minutes to insert all the data depending on your computer. 
After it is setup then you are able to start the program.

## \backend

### venv

You will need to have a virtual environment (venv).
To do this you will you use the command (if you are on windows)

cd .\backend\
python -m venv venv

To run your venv (if you are on windows)

venv\Scripts\activate

### app

app.py is the script that will start the program we will run in the virtual environment (venv). To start you will cd into the backend directory and start the venv (see below for more help). Once you have the venv running then you will be able to use the command

python app.py

which will start the program.

### db.py

This is the connection to your database.
load_dotenv() line will read your .env (create one by clicking new file and naming it ".env" nothing else) file. This is where you will have your DB_SERVER and DB_NAME located.

### \routes

Routes directory is where each feature is connected to a file. So every file holds their own feature. Also where the raw sql would be found.
Example:

get_player_goals()

This query would get back a selected players goals to be seen on the frontend.
