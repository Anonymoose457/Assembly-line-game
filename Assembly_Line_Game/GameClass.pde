class Game {
  final private int conveyorSize = 130, resetConY = 30, repositionConveyor = 65, spacingBetConveyor = 113; //Constants used to maintain the conveyors looks and keeps it around the edge of the screen
  final private color textColour = color(169, 169, 169); //text colour
  private int level = 0, playerScore = 0, essentialComp = 6, playerLives = 3;

  ArrayList<Product> products = new ArrayList<Product>();
  ArrayList<Component> components = new ArrayList<Component>();
  PFont gameTextFont;
  Conveyor[] conveyorBelts = new Conveyor[36];
  Box[] componentBoxes = new Box[9];
  private ArrayList<Fire> firesList = new ArrayList<Fire>();
  private PImage[] conveyorImages; //Store each conveyer image in an array
  private int convImgInd = 0; //Used when changing the index of the image for the belts.
  private PImage[] componentImages; //Will be used so not constantly loading in the same images.

  Game() {
    conveyorImages = new PImage[5];
    componentImages = new PImage[9];
    gameTextFont = createFont("windows_command_prompt.otf", 35); //Font used for displaying player info
    for (int i = 0; i<conveyorImages.length; i++) { //For the length of conveyor images array
      conveyorImages[i] = loadImage("Con" + (i+1)+".png"); //Load in each conveyor image to the array slot i
    }
    for (int i = 0; i<componentImages.length; i++) {
      componentImages[i] = loadImage("Component" + (i+1) + ".png"); //Load in component images to component slot i
    }
    setupConveyor(); //Setup the conveyor on the screen
    setupBoxes(); //Setup the box positions on the screen
  }

  void setupConveyor() {
    int conveyorX = 0, conveyorY = 65, direction = 0; //Base values
    for (int k = 0; k<conveyorBelts.length; k++) { //for the length of the conveyorBelts array
      if (conveyorX < width - conveyorSize && conveyorY < height - conveyorSize) { //If the X is less than the width and Y is at the top of the screen
        conveyorX += spacingBetConveyor; //Increase X
        direction = 0; //Direction is at 0
      } else if (conveyorX >= width - conveyorSize && conveyorY < height - conveyorSize) { //If the X is more than or equal to width - convSize and height is near top of screen
        if (direction == 0) { //If the current direction is 0
          conveyorY = resetConY;//Reset Y so its at the top of screen when rotated
        } else {
          conveyorY += spacingBetConveyor; //Increase Y
        }
        direction = 1; //Change direction to 1
      } else if (conveyorY > height - conveyorSize) { //If the conveyors Y is near the bottom of the screen
        if (direction == 1) { //If the last direction was 1
          conveyorX = width - repositionConveyor; //Reset X to be at the edge of the screen
          conveyorY = height - repositionConveyor; //SO the conveyor belt starts at the right coordinates
        } else {
          conveyorX -=spacingBetConveyor; //X is decreased.
        }
        direction = 2; //Change direction to 2
      }
      conveyorBelts[k] = new Conveyor(conveyorX, conveyorY, conveyorImages[convImgInd], direction); //Make new conveyor belt
    }
  }

  void setupBoxes() {
    int xPos = 0; //Initialise the X and Y positions
    int yPos = 300;
    Components comp[] = Components.values(); //Put the enum of the components into an array.
    for (int i = 0; i < componentBoxes.length; i++) {
      if (xPos >= width -400) { //If x is greater than width - 400
        yPos += 150; //Add to the Y coordinate
      } else {
        xPos += 200; //Else add to X
      }
      if (i < essentialComp) //If the essential components
      {
        componentBoxes[i] = new Box(xPos, yPos, comp[i], true, true); //Create the components boxes that are essential and unlocked
      } else {
        componentBoxes[i] = new Box(xPos, yPos, comp[i], false, false); //Create boxes which  are locked
      }
    }
  }

  void drawGame() {
    background(255, 255, 255);
    spawnProd(); //Method will randomly spawn a product
    drawConv(); //draw the conveyor belts
    checkFireCollisions(); //Check the fire collisions with the mouse
    if (level >= 2 && frameCount % 360 == 0) { //If level 2 and x time has passed
      firesList.add(new Fire()); //Add fire
      if (firesList.size() == 3) { //If theres 3 fires on screen
        firesList.remove(0); //Remove first one in list(oldest one)
      }
    }
    displayStats(); //Display player info like levels lives left and score.
    for (int i = 0; i<componentBoxes.length; i++) {
      componentBoxes[i].drawBox(); //for each box draw box
    }
    for (Component comp : components) {
      comp.drawComponent(); //draws all components
    }
    for (Product prod : products) {
      prod.drawProduct(); //draws all products
    }
    if (components.size() > 0) {
      checkCollisions(); //Checks collisions between any component on screen with the products.
    }
    if (products.size() > 0) {
      checkEnding(); //Checks if the product has reached the end of the conveyor belt
    }
    for (Fire fires : firesList) {
      fires.drawFire(); //draws any fires
    }
  }

  void checkFireCollisions() {
    for (Fire fires : firesList) {
      if (fires.checkMousecollision()) {//For each fire in fire list check the mouse collision if true call game over
        gameOver(); //Set to game over as it removes all lives from the player
      }
    }
  }

  void displayStats() {
    textFont(gameTextFont); //Set font
    fill(textColour); //Set colour of text
    text("Lives: "+playerLives + "\nScore: " + playerScore  + "\nLevel: " + level, 100, 800); //write info
  }

  void checkEnding() {
    int removeIndex = 0; //Reset the remove index

    for (int i = 0; i < products.size(); i++) {
      if (products.get(i).getX() < 481 && products.get(i).getY() > height - 300) //if it is at the end of the belt
      {
        products.get(i).setRemove(true); //Set remove to true inside the objects boolean variable
        if (products.get(i).getBasic()) { //Check if it had basic components added
          //Add value of product to total value of collection box
          //Get the index and remove from arraylist.
          playerScore += products.get(i).getValue(); //Add value
          removeIndex = products.indexOf(products.get(i)); //Set remove index
          if (playerScore != 0) { //If the player score isnt 0
            level = playerScore / 200; //Calculate level by dividing score by 200 (At 200 for quick gameplay)
            checkUnlocks(); //Check if anything is unlocked if level changed
          }
        } else {
          //Make the value of the collection box half of its current worth
          //Get the index remove from arraylist
          //Take away a life.
          playerScore -= products.get(i).getValue(); //take away value of the phone at that point
          removeIndex = products.indexOf(products.get(i)); //set remove index
          playerLives -= 1; // take away a life
          if (playerLives == 0) { //If lives are 0
            gameOver();
          }
        }
      }
      if (products.get(removeIndex).getRemove() == true) {
        products.remove(removeIndex);
      }
    }
  }

  void gameOver() {
    menu.passThroughScore(playerScore); //Pass score through
    gameMode = GameModes.GAMEOVER; //Set enum to game over.
  }


  void spawnProd() {
    if (frameCount % 500 == 0) {
      products.add(new Product(essentialComp)); //Pass through the amount of essential components to product (increases with level)
    }
  }

  void checkCollisions() {
    int indexToRemove = 0;
    for (Component comp : components) { //For each component in components
      for (Product prod : products) { //For each product in products
        if (comp.collideWithProduct(prod)) { //Check the component hasnt collided with that product
          if (prod.checkInList(comp) == false) { //Check the product to make sure the component hasnt already been added and if it hasnt data will be transferred in this method.
            comp.remove = true; //It will be removed in another method as if removed now will cause an error.
            indexToRemove = components.indexOf(comp); //Get the index of the item in the list
          }
        }
      }
    }
    if (components.get(indexToRemove).remove == true) { //If any collision was found at the index to remove value
      components.remove(indexToRemove); //Remove the item from the list.
    }
  }

  void drawConv() {
    boolean changeImage = false;
    if (frameCount % 2 == 0) { //means that it will change when the frameCount divided by 2 leaves a remainder of 0
      if (convImgInd == 4) { //If the image index is at 4 (Max)
        convImgInd = 0;  //Reset it to 0
      } else {
        convImgInd += 1; //Otherwise add 1 to the current value
      }
      changeImage = true; //Set change image to true
    }
    for (int i = 0; i < conveyorBelts.length; i++) {
      if (changeImage == true) {
        conveyorBelts[i].changeImage(conveyorImages[convImgInd]); //When change image is ttue call the changeImage subroutine for each conveyor
      }
      conveyorBelts[i].drawImage(); //draw the conveyor belt image.
    }
  }


  void resetValues() {//Reset is run when game is over so it can be played again
    playerLives = 3;
    playerScore = 0;
    level = 0;
    essentialComp = 6;
    components.removeAll(components);
    products.removeAll(products);
    firesList.removeAll(firesList);
    for (int i = 6; i< componentBoxes.length; i++) { //Set all component boxes to not essential and not unlocked
      componentBoxes[i].unlocked = false;
      componentBoxes[i].essential = false;
    }
  }


  void checkBoxClick() {
    for (Box boxes : componentBoxes) { //For each box in the game
      if (boxes.mouseOnBox()) { //If that box has the mouse hovered over (And clicked)
        switch(boxes.compInBox) { //Get the component in the box and create that component and add it to the ArrayList
        case MOTHERBOARD:
          components.add(new Motherboard(componentImages[0]));
          break;
        case CAMERA:
          components.add(new Camera(componentImages[1]));
          break;
        case SPEAKER:
          components.add(new Speaker(componentImages[2]));
          break;
        case GLASS:
          components.add(new Screen(componentImages[3]));
          break;
        case CPU:
          components.add(new Cpu(componentImages[4]));
          break;
        case RAM:
          components.add(new Ram(componentImages[5]));
          break;
        case WIRELESS:
          if (boxes.unlocked) {
            components.add(new Wireless(componentImages[6]));
          }
          break;
        case WATERPROOF:
          if (boxes.unlocked) {
            components.add(new Waterproof(componentImages[7]));
          }
          break;
        case FINGERPRINT:
          if (boxes.unlocked) {
            components.add(new FingerSensor(componentImages[8]));
          }
          break;
        default:
          break;
        }
      }
    }
  }

  void checkUnlocks() {
    switch(level) {
    case 1://Unlock one new component
      componentBoxes[6].unlocked = true;
      break;
    case 2: //Unlock random fires. and one new component
      componentBoxes[7].unlocked = true;
      break;
    case 3://Unlock last component
      componentBoxes[8].unlocked = true;
      break;
    case 4: //Make it so product needs new component
      componentBoxes[6].essential = true;
      essentialComp = 7;
      break;
    case 5: //Again
      componentBoxes[7].essential = true;
      essentialComp = 8;
      break;
    case 6: //Again last time
      componentBoxes[8].essential = true;
      essentialComp = 9;
      break;
    default:
      break;
    }
  }
}
