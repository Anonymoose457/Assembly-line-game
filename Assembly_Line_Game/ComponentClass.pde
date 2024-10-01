//These components will be added onto the product then deleted when combined
//Each component is in a different class to load the different images at once to save speed also to easily differentiate
//The componenets will be added into an arraylist using all the multiple classes.
class Component extends ConveyorMovement {
  protected int value, xPos = mouseX, yPos = mouseY, size = 70; //As the component is created it sets the X and Y coordinates to the mouse as it spawns from the box when clicked on.
  protected boolean essential = true, unlocked = true, dragging = false, remove = false; //All booleans used to check if a component is unlocked to player/Essential to add/Needs removing from lists
  protected PImage componentImage; //Image of the component which is shown to the player
  protected Components compEnum; //Enumerator which is used when checking if the product already includes said component.


  void mouseDrag() {
    if (componentSelected == false && mousePressed) {
      if (dist(mouseX, mouseY, xPos, yPos) < size && (mousePressed)) {  //Code will be called in the games draw class it will check if the mouse is on the component
        dragging = true; //Set local member to true.
        componentSelected = true; //Set global variable true
      }
    }
    if (componentSelected == true && dragging == true && mousePressed) { //While the component is being held
      xPos = mouseX; //Set to mouse position
      yPos = mouseY;
    } else if (mousePressed == false) { //If the player let go of the component
      componentSelected = false; //Set values related to dragging to false.
      dragging = false;
    }
  }

  void drawComponent() {
    componentImage.resize(size, size); //Resize image to size in size variable
    mouseDrag(); //Check if the mouse is clicking on it if so set to mouse position
    moveOnConveyor(); //If the Component is on the conveyor belt and not currently being dragged move around conveyor
    image(componentImage, xPos, yPos); //Draw the image at the x and y coordinates of the component.
  }

  void moveOnConveyor() { //If the player doesnt use the stackers in the game or has no room left on them they can put them on the conveyor
    xPos += moveOnConvX(xPos, yPos); //Uses the method in the abstract class to adjust xPos and yPos of the component
    yPos += moveOnConvY(xPos, yPos);
  }

  boolean collideWithProduct(Product product) {
    //Check if the product and component distance is colliding if so return true
    //Then in the game class get the products arraylist check to make sure no Enums match
    //If no enums match add component to products list and remove from the games list.
    if (dist(xPos, yPos, product.getX(), product.getY()) < product.getSize()) {
      return true;
    } else {
      return false;
    }
  }
}


class Motherboard extends Component {
  Motherboard(PImage componentImage) {
    value = 10;
    this.componentImage = componentImage;
    this.compEnum = Components.MOTHERBOARD;
  }
}

class Camera extends Component {
  Camera(PImage componentImage) {
    value = 10;
    this.componentImage = componentImage;
    this.compEnum = Components.CAMERA;
  }
}

class Speaker extends Component {
  Speaker(PImage componentImage) {
    value = 10;
    this.componentImage = componentImage;
    this.compEnum = Components.SPEAKER;
  }
}

class Screen extends Component {
  Screen(PImage componentImage) {
    value = 10;
    this.componentImage = componentImage;
    this.compEnum = Components.GLASS;
  }
}

class Ram extends Component {
  Ram(PImage componentImage) {
    value = 20;
    this.componentImage = componentImage;
    this.compEnum = Components.RAM;
  }
}


class Cpu extends Component {
  Cpu(PImage componentImage) {
    value = 20;
    this.componentImage = componentImage;
    this.compEnum = Components.CPU;
  }
}

class FingerSensor extends Component { //Locked then optional component then required
  FingerSensor(PImage componentImage) {
    essential = false;
    value = 30;
    this.componentImage = componentImage;
    this.compEnum = Components.FINGERPRINT;
  }
}

class Waterproof extends Component { //same as above
  Waterproof(PImage componentImage) {
    essential = false;
    value = 50;
    this.componentImage = componentImage;
    this.compEnum = Components.WATERPROOF;
  }
}

class Wireless extends Component { //same as above
  Wireless(PImage componentImage) {
    essential = false;
    value = 50;
    this.componentImage = componentImage;
    this.compEnum = Components.WIRELESS;
  }
}
