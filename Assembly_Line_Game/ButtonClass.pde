class Buttons {

  int buttonX, buttonY, buttonWidth, buttonHeight; //Members
  String buttonText;
  color FillCol;
  PFont buttonFont;
  final color Hovered = color(255, 0, 0);
  final color Basic = color(0);
  final color text = color(255, 255, 255);

  Buttons(int buttonX, int buttonY, int buttonWidth, int buttonHeight, String buttonText, int fontSize) { //For buttons with text.
    this.buttonX = buttonX;
    this.buttonY = buttonY;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.buttonText = buttonText;
    buttonFont = createFont("windows_command_prompt.otf", fontSize);
  }

  Buttons(int buttonX, int buttonY, int buttonWidth, int buttonHeight) { //For buttons with no text
    this.buttonX = buttonX;
    this.buttonY = buttonY;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.buttonText = "";
    buttonFont = createFont("windows_command_prompt.otf", 0);
  }

  void drawButton() {
    textFont(buttonFont);
    buttonHover();
    fill(FillCol); //Set the fill colour
    rectMode(CORNER); //Set the rectangle mode to corner
    rect(buttonX, buttonY, buttonWidth, buttonHeight);  //Draw rectangle
    textAlign(LEFT);
    fill(text);
    text(buttonText, buttonX, (buttonY + buttonHeight/2 + buttonHeight/4));
  }


  boolean buttonHover() //Has two functions it changes the colour of the button while also returning true when called to check if mouse pressed while on it.
  {
    if (mouseX >= buttonX && mouseX <= buttonX + buttonWidth && mouseY >= buttonY && mouseY <= buttonY+buttonHeight) { //Check if the mouse is inside the rectangle
      FillCol = Hovered;
      return true;
    }
    FillCol = Basic; //Else return false set base colour.
    return false;
  }
}
