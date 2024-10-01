class Product extends ConveyorMovement {
  private int totalValue = 0, xPos = 60, yPos = 65, size = 70, imageNum = 0, compIndToAdd = 0, animationImg = 6; //Members totalValue is sum of value of components.
  private boolean basicCompAdded, remove = false, animation = false; //BasicCompAdded used to tell if all basic components are in the phone, MotherboardAdded is used to tell its been added
  private PImage productImg; //product image variable
  //Remove is used to tell if its reached end of conveyor so to be removed off screen.
  private ArrayList<Components> componentsAdded = new ArrayList<Components>(); //Enum of components in the product already will be added to this array
  private ArrayList<Components> basicComponents = new ArrayList<Components>(); //ArrayList stores the Enums of the basic components which need to be added
  private PImage[] prodImgs = new PImage[7]; //Array of the product images
  private PImage[] addedAnim = new PImage[7]; //Animation images array.

  Product(int essentialComp) {
    Components comp[] = Components.values(); //Put the enum of the components into an array.
    for (int i = 0; i < essentialComp; i++) {
      basicComponents.add(comp[i]); //add the Enums to the basic components enum list
    }
    for (int i = 0; i<prodImgs.length; i++) {
      prodImgs[i] = loadImage("Product"+(i+1)+".png"); //load the product images to the array
    }
    productImg = prodImgs[0]; //set current product image to the first image
    for (int i = 0; i<addedAnim.length; i++) {
      addedAnim[i] = loadImage("Added"+(i+1)+".png"); //Load animation images to the array
    }
  }

  public void drawProduct() {
    xPos += moveOnConvX(xPos, yPos);//Use abstract class to move product conveyor belt
    yPos += moveOnConvY(xPos, yPos);
    imageMode(CENTER);
    if (basicCompAdded == true) { //If product has essential components added
      productImg = prodImgs[6]; //Set to final image
    } else {
      productImg = prodImgs[imageNum]; //Else set to the imageNum image
    }
    productImg.resize(size, size); //resize image
    image(productImg, xPos, yPos); //draw image
    if (animation) {  //If component was added and animation is true.
      //Array of animation image every few frames ontop of the component
      //When all images done animation = false
      if (animationImg == 6) { //reset the animation
        animationImg = 0;
      } else {
        if (frameCount %2 == 0) {
          animationImg += 1; //every 2 frames add to the animationImg variable
        }
        addedAnim[animationImg].resize(size, size); //resize the image
        image(addedAnim[animationImg], xPos, yPos); //draw image/animation ontop of the product
        if (animationImg == 6) { //When the image is at 6
          animation = false; //Set to false
        }
      }
    }
  }

  public boolean checkInList(Component component) {
    for (int i = 0; i < componentsAdded.size(); i++) { //Check each item in the componentsAdded list
      if (componentsAdded.get(i) == component.compEnum) { //If the component matches one in the list
        return true; //Return true
      }
    }
    if (component.compEnum != basicComponents.get(compIndToAdd) && !basicCompAdded) {
      return true; //Return true as its not in the correct order to be added for essential components as extra ones that arent essential can be added anytime after completion
    }
    addToList(component.compEnum); //Else if no match add to the list
    totalValue += component.value; //Add the value to the total value.
    checkBasicComp(); //Check if all basic components are now added

    if (!basicCompAdded) {
      compIndToAdd += 1;
      if (imageNum < 5) {
        imageNum += 1;
      }
    }

    return false; //Return false as it wasnt in the list
  }

  public void addToList(Components component) { //Called by checkInList
    componentsAdded.add(component);
    animation = true;
  }

  private void checkBasicComp() {
    //For each item in the basic comp array
    //For each item in the list of current components
    //if it matches add to the counter
    //if the counter is the same as the items in the basic comp array
    //set basicCompAdded to true.
    int BaseCompCount = 0;
    for (Components basic : basicComponents) {
      for (Components compAdded : componentsAdded) {
        if (basic == compAdded) {
          BaseCompCount += 1;
        }
      }
    }
    if (BaseCompCount == basicComponents.size()) {
      basicCompAdded = true;
    }
  }

  public int getSize() {
    return size;
  }
  public int getX() {
    return xPos;
  }

  public int getY() {
    return yPos;
  }

  public int getValue() {
    return totalValue;
  }

  public boolean getBasic() {
    return basicCompAdded;
  }

  public boolean getRemove() {
    return remove;
  }

  public void setRemove(boolean setTo) {
    remove = setTo;
  }
}
