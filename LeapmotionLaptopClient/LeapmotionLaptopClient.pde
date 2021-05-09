import de.voidplus.leapmotion.*;
import processing.video.*;
import processing.net.*;
import de.voidplus.leapmotion.*;
//leap Motion
//import every lib we need

LeapMotion leap;
//Init leapMotion
HandXLocationMin = 0;
HandXLocationMax = 1200;
int ProgramStatus = 0;
public static int VIDEOCHOOSEN = 0;
public static int VIDEO1_PLAYING = 1;
public static int VIDEO2_PLAYING = 2;
public static int VIDEO3_PLAYING = 3;
//Identify ProgramStatus List

public static int PLAY_SCENE = 1;
public static int STOP_PLAYING = 2;
public static int CHANGE_COLOR = 3;
public static int PLAYING_MOVIE1 = 4;
public static int PLAYING_MOVIE2 = 5;
public static int PLAYING_MOVIE3 = 6;
public static int STOP_CHANGE_COLOR = 7;
//Identify CommandCode List


String ServerIP = "127.0.0.1";
int ServerPort = 10002;
int dataIn = 0;
boolean SomeThingNeedToSend = false;
int CommandCode = 0;

Client myClient;

PImage FrontCover1, FrontCover2, FrontCover3;  
// Declare 3 variable of type PImage
Movie Movie1, Movie2, Movie3;
//three Movie we need
Movie BackGround1, BackGround2;
// Declare 2 variable of type PImage for Backgroud

int LRedge = 20/width;
int HandShapPlay = 0;
int HandShapBack = 0;
int Is_Playing = 0;

void setup() {

  size(1280, 960);
  //set Window Size
  //fullScreen();
  noStroke();
  //  Disables drawing the stroke (outline). 
  //If both noStroke() and noFill() are called, 
  //nothing will be drawn to the screen.
  BackGround1 = new Movie(this, sketchPath("")+"Background1.mov");
  BackGround1.loop();
  FrontCover1 = loadImage(sketchPath("")+"Cover1.jpg");
  FrontCover2 = loadImage(sketchPath("")+"Cover2.jpg");  
  FrontCover3 = loadImage(sketchPath("")+"Cover3.jpg");  
  // Load the image into the program
  // The image file must be in the data folder of the current sketch to load successfully
  Movie1 = new Movie(this, sketchPath("")+"/Movie1.mov");
  Movie2 = new Movie(this, sketchPath("")+"/Movie2.mov");
  Movie3 = new Movie(this, sketchPath("")+"/Movie3.mov");
  //load videos
  Movie1.loop();
  Movie2.loop();
  Movie3.loop();
  Movie1.pause();
  Movie2.pause();
  Movie3.pause();
  //SetPlayMode
  LRedge = width/20;
  FrontCoverMinWidth = width / 8;
  FrontCoverMinHight = height / 10;
  FrontCoverMaxWidth = width / 3;
  FrontCoverMaxHight = height / 2; 
  // set limit Value
  leap = new LeapMotion(this);
  //Init LeapMotion
  myClient = new Client(this, ServerIP, ServerPort); 
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  //myClient.write(STOP_PLAYING);
  frameRate(60);
}

void drawRebuile() {
  //judge trigger status
  for (Hand hand : leap.getHands ()) {
    if (hand == null)break;
    //If there is no hand
    if (HandShapIsOK(hand))HandShapPlay = 1;
    //check if handshape Play,when handshap is Play
    //founction VideoChoose will make it play
    if (HandShapIsFive(hand))HandShapBack = 1;
  }
  //Handle Signals
  if (SomeThingNeedToSend) {
    SomeThingNeedToSend = false;
    myClient.clear();
    myClient.write(CommandCode);
    //handle any Command Send task
  }
  if (HandShapBack==1)HandleReturnButton();
  //if handShap "Return" is detected, Handle it
  if (mouseButton == CENTER)exit();
  switch(ProgramStatus) {
  case 0:
    {
      SceneVideoChoose();
      //fresh the choose scene and check handshap
      break;
    }
  case 1:
    {
      //playing video1
      image(Movie1, width/2, height/2, width, height);
      for (Hand hand : leap.getHands ()) {
        if (HandShapIsStone(hand)) {
          CommandCode = CHANGE_COLOR;
          SomeThingNeedToSend = true;
        }
      }
      break;
    }
  case 2:
    {
      //playing video2
      image(Movie2, width/2, height/2, width, height);
      for (Hand hand : leap.getHands()){
      if (HandShapIsSword(hand)) {
        CommandCode = CHANGE_COLOR;
        SomeThingNeedToSend = true;
      }
      }
      break;
    }
  case 3:
    {
      //playing video3
      image(Movie3, width/2, height/2, width, height);
      for (Hand hand : leap.getHands()){
      if (HandShapIsBye(hand)) {
        CommandCode = CHANGE_COLOR;
        SomeThingNeedToSend = true;
      }
      }
      break;
    }
  }
}

void draw() {
  
  if (SomeThingNeedToSend) {
    SomeThingNeedToSend = false;
    myClient.clear();
    myClient.write(CommandCode);
    //handle any Command Send task
  }
  //Try Receive data from server
  background(127);
  //image(BackGround1, 0, 0, width, height);
  //image(BackGround1, 0, 0);
  for (Hand hand : leap.getHands ()) {
    if (hand == null)break;
    //If there is no hand
    if (HandShapIsOK(hand))HandShapPlay = 1;
    //check if handshape Play
    if (HandShapIsFive(hand))HandShapBack = 1;
    //check if handshape Return
    if (Is_Playing == 0) {
      //If no Video is Playing, Show VideoChoose Scene
      SceneVideoChoose();
    } else {
      //SceneMoviePlay will check witch movie was choosen automaticlly
      imageMode(CENTER);
      if (Is_Playing ==1) {
        image(Movie1, width/2, height/2, width, height);
        if (HandShapIsStone(hand)) {
          CommandCode = CHANGE_COLOR;
          SomeThingNeedToSend = true;
        }
      } else if (Is_Playing ==2) {
        image(Movie2, width/2, height/2, width, height);
        if (HandShapIsSword(hand)) {
          CommandCode = CHANGE_COLOR;
          SomeThingNeedToSend = true;
        }
      } else if (Is_Playing ==3) {
        image(Movie3, width/2, height/2, width, height);
        if (HandShapIsBye(hand)) {
          CommandCode = CHANGE_COLOR;
          SomeThingNeedToSend = true;
        }
      }
    }
  }
  if (HandShapBack==1)HandleReturnButton();
  //if handShap "Return" is detected, Handle it
  if (mouseButton == CENTER)exit();
}

void movieEvent(Movie m) {
  m.read();
}

void SceneVideoChoose() {
  public int FrontCoverMinWidth = 0;
  public int FrontCoverMinHight = 0;
  public int FrontCoverMaxWidth = 0;
  public int FrontCoverMaxHight = 0;
  
  public int FrontCover1Width = 0;
  public int FrontCover1Hight = 0;
  public int FrontCover2Width = 0;
  public int FrontCover2Hight = 0;
  public int FrontCover3Width = 0;
  public int FrontCover3Hight = 0;
  
  public int FrontCover1X = 0;
  public int FrontCover1Y = 0;
  public int FrontCover2X = 0;
  public int FrontCover2Y = 0;
  public int FrontCover3X = 0;
  public int FrontCover3Y = 0;
  
  imageMode(CENTER);
  FrontCover1Width = int(map(width-abs(FrontCover1X+FrontCoverMaxWidth/2-GetHandX()), 0, width, FrontCoverMinWidth, FrontCoverMaxWidth));
  FrontCover1Hight = FrontCover1Width*FrontCover1.height/FrontCover1.width;
  FrontCover2Width = int(map(width-abs(width/2-GetHandX()), 0, width, FrontCoverMinWidth, FrontCoverMaxWidth));
  FrontCover2Hight = FrontCover2Width*FrontCover2.height/FrontCover2.width;
  FrontCover3Width = int(map(width-abs(FrontCover3X+FrontCoverMaxWidth/2-GetHandX()), 0, width, FrontCoverMinWidth, FrontCoverMaxWidth));
  FrontCover3Hight = FrontCover3Width*FrontCover3.height/FrontCover3.width;
  //Frash Img size

  FrontCover1X = LRedge+FrontCover1X/2;
  FrontCover1Y = height/2;
  FrontCover2X = width/2;
  FrontCover2Y = height/2;
  FrontCover3X = width - LRedge - FrontCover3X;
  FrontCover3Y = height/2;
  //Frash Img Location

  //get mouse location
  image(FrontCover1, FrontCover1X, FrontCover1Y, FrontCover1Width, FrontCover1Hight);
  image(FrontCover2, FrontCover2X, FrontCover2Y, FrontCover2Width, FrontCover2Hight);
  image(FrontCover3, FrontCover3X, FrontCover3Y, FrontCover3Width, FrontCover3Hight);
  // Displays the image at point (0, height/2) at half of its size
  if (GetHandX()>FrontCover1X && GetHandX()<FrontCover1X+FrontCover1Width) {
    if (CommandCode != PLAYING_MOVIE1) {
      SomeThingNeedToSend = true;
      CommandCode = PLAYING_MOVIE1;
    }
  } else if (GetHandX()>FrontCover2X && GetHandX()<FrontCover2X+FrontCover2Width) {
    if (CommandCode != PLAYING_MOVIE2) {
      SomeThingNeedToSend = true;
      CommandCode = PLAYING_MOVIE2;
    }
  } else if (GetHandX()>FrontCover3X && GetHandX()<FrontCover3X+FrontCover3Width) {
    if (CommandCode != PLAYING_MOVIE3) {
      SomeThingNeedToSend = true;
      CommandCode = PLAYING_MOVIE3;
    }
  }
  //Notice Screen2 to Show Cover
  if (HandShapPlay!=0) {
    //Check If hand shap is "Play"
    HandShapPlay = 0;
    VidoeChooseToPlay();
    //set Is_Playing to 1/2/3 judged by mouse location
  }
}

void VidoeChooseToPlay() {
  //Play Movie1 or Movie2 or Movie3
  if (GetHandX()>FrontCover1X && GetHandX()<FrontCover1X+FrontCover1Width) {
    myClient.clear();
    myClient.write(PLAYING_MOVIE1);
    myClient.write(PLAY_SCENE);
    Movie1.play();
    Is_Playing = 1;
    ProgramStatus = 1;
    //play movie1
  } else if (GetHandX()>FrontCover2X && GetHandX()<FrontCover2X+FrontCover2Width) {
    myClient.clear();
    myClient.write(PLAYING_MOVIE2);
    myClient.write(PLAY_SCENE);
    Movie2.play();
    Is_Playing = 2;
    ProgramStatus = 2;
    //play movie2
  } else if (GetHandX()>FrontCover3X && GetHandX()<FrontCover3X+FrontCover3Width) {
    myClient.clear();
    myClient.write(PLAYING_MOVIE3);
    myClient.write(PLAY_SCENE);
    Movie3.play();
    Is_Playing = 3;
    ProgramStatus = 3;
    //play movie3
  }
}

void HandleReturnButton() {
  HandShapBack = 0;
  Movie1.stop();
  Movie2.stop();
  Movie3.stop();
  Is_Playing = 0;
  ProgramStatus = 0;
  myClient.write(STOP_PLAYING);
}

int GetHandX() {
  PVector handPosition;
  hand=leap.getHands();
  handPosition = hand.getPosition();
  return int(map(handPosition.x, HandXLocationMin, HandXLocationMax, 0, width));
}

boolean HandShapIsOK(Hand hand) {
  Finger  fingerThumb        = hand.getThumb();
  Finger  fingerIndex        = hand.getIndexFinger();
  Finger  fingerMiddle       = hand.getMiddleFinger();
  Finger  fingerRing         = hand.getRingFinger();
  Finger  fingerPink         = hand.getPinkyFinger();

  if (!fingerIndex.isExtended()) {
    if (fingerMiddle.isExtended() && fingerRing.isExtended() && fingerPink.isExtended()) {
      println("--------OK!OK!!");
      return true;
    }
  }
  return false;
}

boolean HandShapIsSword(Hand hand) {
  Finger  fingerThumb        = hand.getThumb();
  Finger  fingerIndex        = hand.getIndexFinger();
  Finger  fingerMiddle       = hand.getMiddleFinger();
  Finger  fingerRing         = hand.getRingFinger();
  Finger  fingerPink         = hand.getPinkyFinger();

  if (fingerIndex.isExtended() && fingerMiddle.isExtended()) {
    if (!fingerRing.isExtended() && !fingerPink.isExtended()) {
      println("--------Sword!Sword!!");
      return true;
    }
  }
  return false;
}

boolean HandShapIsFive(Hand hand) {
  Finger  fingerThumb        = hand.getThumb();
  Finger  fingerIndex        = hand.getIndexFinger();
  Finger  fingerMiddle       = hand.getMiddleFinger();
  Finger  fingerRing         = hand.getRingFinger();
  Finger  fingerPink         = hand.getPinkyFinger();

  if (fingerThumb.isExtended() && fingerIndex.isExtended() && fingerMiddle.isExtended() && fingerRing.isExtended() && fingerPink.isExtended()) {
    println("--------Five!Five!!");
    return true;
  }
  return false;
}

boolean HandShapIsBye(Hand hand) {
  Finger  fingerThumb        = hand.getThumb();
  Finger  fingerIndex        = hand.getIndexFinger();
  Finger  fingerMiddle       = hand.getMiddleFinger();
  Finger  fingerRing         = hand.getRingFinger();
  Finger  fingerPink         = hand.getPinkyFinger();

  if (!fingerThumb.isExtended()  && !fingerMiddle.isExtended() && !fingerRing.isExtended()) {
    if (fingerIndex.isExtended()) {
      println("--------Bye!Bye!!");
      return true;
    }
  }
  return false;
}

boolean HandShapIsStone(Hand hand) {
  Finger  fingerThumb        = hand.getThumb();
  Finger  fingerIndex        = hand.getIndexFinger();
  Finger  fingerMiddle       = hand.getMiddleFinger();
  Finger  fingerRing         = hand.getRingFinger();
  Finger  fingerPink         = hand.getPinkyFinger();

  if (!fingerThumb.isExtended()  &&!fingerIndex.isExtended() && !fingerMiddle.isExtended() && !fingerRing.isExtended() && !fingerPink.isExtended()) {
    println("--------Stone!Stone!!");
    return true;
  }
  return false;
}
