boolean splashScreen = true; //True when the splash screen is on as it is the first thing that pops up it is true;
GameModes gameMode; //Enumerator variable for game modes.
MainMenu menu; //create an object from the class MainMenu
Game game;
boolean componentSelected; //global variable

void setup() {
  size(1875, 950); //Setting size of canvas
  menu = new MainMenu(); //initiate the class
  game = new Game(); //initiate the game class
  gameMode = GameModes.MENU;
}

void draw() {

  if (frameCount <= 340) //when the game has just been opened a splash screen will occur for 5 seconds
  {
    menu.splashScreen(); //call the splashscreen function from the mainmenu class.
  } else  //If the game wasnt just opened or the amount of time has passed
  {
    splashScreen = false; //splashScreen is set to false
    if (gameMode == GameModes.MENU) //If the Enum set is MENU
    {
      menu.main(); //call the main function from the MainMenu class
    } else if (gameMode == GameModes.GAME) //If the player hits the start button gameMode uses the enum GAME
    {
      game.drawGame(); //call the drawGame function
    } else if (gameMode == GameModes.GAMEOVER) {//When the player loses all lives display game over screen
      menu.gameOver();
    }
  }
}

void mousePressed() {
  if (gameMode == GameModes.MENU && splashScreen == false) { //checks that the splashscreen has occured and the player is in the main menu
    if (menu.startButton.buttonHover()) { //checks if the startbutton is being hovered over by the mouse when clicked.
      gameMode = GameModes.GAME; //start the game by making the value true.
    }
  } else if (gameMode == GameModes.GAME) {//If the game is being played and the player clicks it checks inside the checkBoxClick method to see if a player clicked on a box.
    game.checkBoxClick(); //Checks any collisions between boxes
  }
  if (gameMode == GameModes.GAMEOVER) { //When the game over screen is showing if the player presses the mouse
    gameMode = GameModes.MENU;
    //Will take user back to home screen
    game.resetValues(); //Resets the values
  }
}
