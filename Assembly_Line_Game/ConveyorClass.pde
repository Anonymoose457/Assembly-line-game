class Conveyor {
  int x, y, direction, size = 120; //the direction integer will be 0 for left to right, 1 for top to bottom, 2 for right to left. it will be in the order that the product goes through.
  PImage currentImage;
  Conveyor(int x, int y, PImage currentImage, int direction) {
    this.x = x;  //Set members to the values passed in.
    this.y = y;
    this.currentImage = currentImage;
    this.direction = direction;
    currentImage.resize(size, size); //resize the image.
  }

  void changeImage(PImage changeTo)  //is called to change the image of the conveyor belt.
  {
    currentImage = changeTo;
    currentImage.resize(size, size);
  }

  void drawImage() { //This method checks the direction the conveyor belt should be and rotates it accordingly
    switch(direction) {
    case 1:
      renderRotated(PI/2);
      break;
    case 2:
      renderRotated(PI);
      break;
    default:
      renderImage();
      break;
    }
  }
  //angleRadians is a an angle measured in radians [0..2Pi], see processing.org/reference/rotate_.html
  void renderRotated(float angleRadians) //draws a rotated rectangle
  {
    imageMode(CENTER); //this version for a PImage
    pushMatrix(); //store everything on canvas
    translate(this.x, this.y); //move origin to centre of rotation
    rotate(angleRadians); //rotate around x,y
    image(currentImage, 0, 0);
    popMatrix(); //put everything back
  }

  void renderImage() {
    image(currentImage, x, y); //render conveyor image not rotated.
  }
}
