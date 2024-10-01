class Box {
  //State members
  private PImage boxImg;
  private int boxX, boxY, boxSize = 120;
  private Components compInBox;
  private boolean unlocked;
  PImage[] boxes = new PImage [3];
  private boolean essential;

  Box(int boxX, int boxY, Components compInBox, boolean unlocked, boolean essential) { //Constructor to get the X,Y,Component inside the box values and image and set them
    this.boxX = boxX;
    this.unlocked = unlocked;
    this.essential = essential;
    this.boxY = boxY;
    this.compInBox = compInBox;
    for (int i = 0; i < boxes.length; i++) { //Load the different box imaged (Unlocked, locked, not essential)
      boxes[i] = loadImage("Box"+(i+1)+".png");
    }
  }

  public void drawBox() { //Will be called to draw the boxes
    if (unlocked && essential) {
      boxImg = boxes[1]; //If umlocked and essential display the tick
    } else if (unlocked && !essential) {
      boxImg = boxes[0]; //if unlocked and essential display the cross
    } else if (!unlocked) {
      boxImg = boxes[2]; //if not unlocked display the lock
    }

    boxImg.resize(boxSize, boxSize); //Resize and draw image
    image(boxImg, boxX, boxY);
  }

  public boolean mouseOnBox() {  //If true return boolean value which will then the game class will call the getComponent() method so it spawns the right component.

    if (dist(mouseX, mouseY, boxX, boxY) < boxSize/2 ) {  //if the distance between the box coordinates and mouse coordinates is less than its size return true.
      return true;
    }
    return false; //Else return false.
  }

  public Components getComponent() { //As the compInBox Enum is private it needs to have a get to get the right value
    return compInBox;
  }
}
