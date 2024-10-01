class MainMenu { //<>// //<>//
  //Splash screen and main menu images will go here.
  private PImage[] conveyors;
  private int currentConvIm = 0, splashTextY = 500, splashTextX = 0, highScoreToAdd = 0, temporaryStore, temporaryStore2;
  private PImage splashComponent;
  private PFont titleFont, bodyFont, subTitleFont;
  private int[] highScoreList = new int[5];
  final private color background = color(153, 157, 168);

  Buttons startButton;

  MainMenu() {
    readArrayOfScores();
    titleFont = createFont("windows_command_prompt.otf", 100); //create the font used for the splash screen and main menu
    bodyFont = createFont("windows_command_prompt.otf", 25); //Font that will be used for explaining how to play and high scores.
    subTitleFont = createFont("windows_command_prompt.otf", 70);//Font for subtitles such as How to play.

    splashComponent = loadImage("Component1.png");
    splashComponent.resize(150, 150); //Load and resize the image so it fits onto the belt.
    conveyors = new PImage[5]; //Array of images for the conveyor belt for animation.
    startButton = new Buttons((width/3)+80, 350, 400, 100, "Start", 100);
    for (int i = 0; i<conveyors.length; i++)
    {
      conveyors[i] = loadImage("Con" + (i+1) +".png");  //For each item in the array load each conveyor image into the index i
    }

    for (int i = 0; i < conveyors.length; i ++)
    {
      conveyors[i].resize(200, 200); //for each image in the array resize the image
    }
  }

  void main() {
    background(background); //set background colour
    fill(255, 255, 255); //Text fill for white
    textFont(titleFont); //font for title
    textAlign(CENTER); //Align to center
    text("Phone Assembly", width/2, 100);  //Title

    //Button and its text
    startButton.drawButton(); //draw button
    textFont(subTitleFont); //Add subtitles to the menu screen
    textAlign(CENTER);
    text("How to Play", 200, 100);
    text("High scores", 1600, 100);
    //Reading high scores and adding them to the high score area
    text("1)" + highScoreList[0] + "\n2)" + highScoreList[1] + "\n3)" + highScoreList[2] + "\n4)" + highScoreList[3] + "\n5)" + highScoreList[4], 1600, 160);

    textAlign(CORNER); //How to play text.
    textFont(bodyFont);
    text("Drag components out of the boxes\nand drag them onto the phone body\nthat is travelling along the conveyor belt \nfinish the phone before it gets to the end", 30, 140);
    text("Add the components in the order from the left box to the right box\nAs the levels increase new components will unlock\nIf the inside of the phone is visible components need to be added", 30, 240);
    text("If the box has a tick the component is essential and must be added \nIf there is a cross it is not essential but optional \nIf there is a padlock it is locked \n these will unlock with levels", 30, 310);
    text("From level 2 fire will spread around the screen\navoid this with your mouse", 30, 410);
  }

  void gameOver() {
    background(background); //Set background colour
    textFont(titleFont);
    textAlign(CENTER);
    fill(255, 255, 255);
    text("Game over", width/2, 200);
    textFont(subTitleFont);
    text("Score: " + highScoreToAdd + "\nPress mouse to go to main menu", width/2, 600);
  }

  public void passThroughScore(int score) {
    boolean foundSpace = false; //found space is for the list
    highScoreToAdd = score; //Set the high score to compare to variable
    for (int i = 0; i < highScoreList.length; i++) {
      if (highScoreList[i] >= highScoreToAdd) {
        continue;
      } else if (highScoreList[i] < highScoreToAdd && !foundSpace) {
        temporaryStore = highScoreList[i]; //Store the value temporarily in a variable
        highScoreList[i] = highScoreToAdd; //add the new score to the slot
        foundSpace = true; //Set found space to true to start moving itmes down array.
      } else if (foundSpace) {
        temporaryStore2 = highScoreList[i]; //Set the current score to temporary store 2
        highScoreList[i] = temporaryStore; //Move temporary score down to the next item in list
        temporaryStore = temporaryStore2; //Set the temporary store to the value of the second value so it can be moved down the list
      }
    }
    saveScoresToFile(); //Save to file
  }

  private void saveScoresToFile() {
    String[] stringScores = new String[5]; //Make an array of strings to store the integer values in string form
    for (int i = 0; i < highScoreList.length; i++) {
      stringScores[i] = str(highScoreList[i]); //Convert each high score to a string value.
    }
    saveStrings("data/HighScores.txt", stringScores); //Store the strings in the high score text file.
  }

  private void readArrayOfScores() {
    String[] ScoreLines = loadStrings("HighScores.txt"); //Load the high score text file in an array of strings
    for (int i = 0; i < highScoreList.length; i++) { //for the length of the high score list
      highScoreList[i] = int(ScoreLines[i]); //change each line to an integer and store in high score list.
    }
  }


  void splashScreen() {
    splashTextX += 5; //When the method is called increase the X value of the menu text by 5.
    background(0); //set the background to black.
    if (frameCount % 5 == 0) //every 5 frames
    {
      if (currentConvIm == 4) //if the current image on screen is index 4
      {
        currentConvIm = 0;  //reset it back to 0
      }
      currentConvIm += 1; //if not add 1 to the value
    }
    for (int i = 0; i < 11; i++) { //As roughly 11 images will fit on the screen
      image(conveyors[currentConvIm], 0+(185*i), 400);  //draw image
    }

    textFont(titleFont); //Set the font to the game font
    fill(0); //So rectangle is black
    rect(splashTextX, 420, 610, 100);  //Draw the rectangle
    fill(255, 255, 255); //Set the fill to white
    text("Phone Assembly", splashTextX, splashTextY); //Display the text
    image(splashComponent, splashTextX - 150, splashTextY - 100); //Add the component on splash screen
  }
}
