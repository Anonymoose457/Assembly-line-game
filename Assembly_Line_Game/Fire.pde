class Fire {
  //Members
  private PImage fireImg;
  private int size = 70, xPos, yPos;

  Fire() {
    fireImg = loadImage("Fire.png"); //Load the fire image when creating the object
    fireImg.resize(size, size);//resize the image to be smaller
    xPos = int(random(300, 1500)); //Generate a random x position within bounds.
    yPos = int(random(400, 600)); //Generate a random y position within bounds
  }

  public void drawFire() {
    image(fireImg, xPos, yPos); //draw the image at the x and y position
  }

  public boolean checkMousecollision() { //As boxes will be the only thing on fire just checking for box collisions.
    if (dist(mouseX, mouseY, xPos, yPos) < size/2) { //Check if the mouse is hovering inside the fire image
      return true; //return truw to remove all lives
    } else {
      return false; //return false.
    }
  }
}
