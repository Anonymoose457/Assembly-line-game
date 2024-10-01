abstract class ConveyorMovement { //This abstract class exists as both products and components will need to move on the conveyorBelt this means less code is written.

  int convSpeed = 3; //Put the conveyor speed here so the value only needs to be changed once

  public int moveOnConvX(int xPos, int yPos) { //Checks if the product is on either the top or bottom conveyor and then if so will return convSpeed so its added onto the X value
    if (xPos < width - 60 && yPos < 120) { //This checks wether the product/Component is on the top conveyor
      return convSpeed; //Value will be added onto the xPos in the relevant class
    } else if (yPos >= height - 60 && xPos > 400) //Checks wether the product/component is on the bottom conveyor
    {
      return -convSpeed;
    }
    return 0; //If the product/component is on the vertical conveyor
  }

  public int moveOnConvY(int xPos, int yPos) { //Checks wether the product/Component is on the vertical conveyor and if so
    //Will return the convSpeed value so it can be added onto the Y value if not it returns 0
    if (xPos >= width - 60 && yPos <= height - 60)
    {
      return convSpeed;
    }
    return 0;
  }
}
