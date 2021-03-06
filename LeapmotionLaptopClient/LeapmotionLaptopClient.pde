import de.voidplus.leapmotion.*;  //<>//
import processing.video.*;
import processing.net.*;
import de.voidplus.leapmotion.*;
//leap Motion
//import every lib we need

LeapMotion leap;
//Init leapMotion Device

//String ServerIP = "127.0.0.1";
String ServerIP = "192.168.10.105";
int ServerPort = 10002;
Client myClient = new Client(this, ServerIP, ServerPort);
//Init Socket services



public int ProgramStatus = 0;

public static int Command_VideoChooseScene = 0;
public static int Command_Video_1_Cover = 1;
public static int Command_Video_2_Cover = 2;
public static int Command_Video_3_Cover = 3;
public static int Command_Video_1_Play = 4;
public static int Command_Video_2_Play = 5;
public static int Command_Video_3_Play = 6;
public static int Command_Video_1_ChangeColor = 7;
public static int Command_Video_2_ChangeColor = 8;
public static int Command_Video_3_ChangeColor = 9;

public static int HandShapBack = 0;
public static int HandShapOK = 1;
public static int HandShapStone = 2;
public static int HandShapSword = 3;
public static int HandShapBye = 4;

int HandXLocationMin = 200;
int HandXLocationMax = 1500;
PImage FrontCover1, FrontCover2, FrontCover3, BackGroundimg;
Movie Movie1, Movie2, Movie3, BackGround1;


void setup() {
  BackGround1 = new Movie(this, sketchPath("")+"Background1.mov");
  FrontCover1 = loadImage(sketchPath("")+"Cover1.jpg");
  FrontCover2 = loadImage(sketchPath("")+"Cover2.jpg");  
  FrontCover3 = loadImage(sketchPath("")+"Cover3.jpg");  
  BackGroundimg = loadImage(sketchPath("")+"Background.jpg"); 
  // Load the image into the program
  // The image file must be in the data folder of the current sketch to load successfully
  Movie1 = new Movie(this, sketchPath("")+"/Movie1.mov");
  Movie2 = new Movie(this, sketchPath("")+"/Movie2.mov");
  Movie3 = new Movie(this, sketchPath("")+"/Movie3.mov"); 
  //three Movie we need
  leap = new LeapMotion(this);
  //size(1280, 960);
  //set Window Size
  fullScreen();
  noStroke();
  //Disables drawing the stroke (outline). 
  //If both noStroke() and noFill() are called, 
  //nothing will be drawn to the screen.
  Movie1.loop();
  Movie2.loop();
  Movie3.loop();
  Movie1.pause();
  Movie2.pause();
  Movie3.pause();
  //Set Movie Play Mode to Loop
}

void draw() {
  //??????????????????????????????
  BackGroundScene();
  //?????????????????????????????????????????????????????????
  if (ControlCmdCheck() == HandShapBack)ProgramStatus = Command_VideoChooseScene;
  if (ControlCmdCheck() == HandShapBack)ProgramStatus = Command_VideoChooseScene;
  //??????????????????????????????????????????7??????????????????????????????????????????????????????????????????????????????
  if (ProgramStatus == Command_VideoChooseScene) {
    VideoChooseScene();
  } else if (ProgramStatus == Command_Video_1_Play) {
    Command_Video_1_Play();
  } else if (ProgramStatus == Command_Video_2_Play) {
    Command_Video_2_Play();
  } else if (ProgramStatus == Command_Video_3_Play) {
    Command_Video_3_Play();
  } else if (ProgramStatus == Command_Video_1_ChangeColor) {
    Command_Video_1_ChangeColor();
  } else if (ProgramStatus == Command_Video_2_ChangeColor) {
    Command_Video_2_ChangeColor();
  } else if (ProgramStatus == Command_Video_3_ChangeColor) {
    Command_Video_3_ChangeColor();
  }
}

void BackGroundScene() {
  //????????????????????????????????????????????????????????????????????????????????????
  image(BackGroundimg, width/2, height/2);
  //background(100, 25, 25);
}

int ControlCmdCheck() {
  //?????????????????????????????????????????????????????????
  //??????????????????????????????????????????
  //Hand hand = leap.getHand(0);
  for (Hand hand : leap.getHands ()) {
    Finger  fingerThumb        = hand.getThumb();
    Finger  fingerIndex        = hand.getIndexFinger();
    Finger  fingerMiddle       = hand.getMiddleFinger();
    Finger  fingerRing         = hand.getRingFinger();
    Finger  fingerPink         = hand.getPinkyFinger();
    if (!fingerIndex.isExtended()) {
      if (fingerMiddle.isExtended() && fingerRing.isExtended() && fingerPink.isExtended()) {
        println("--------OK!OK!!");
        return HandShapOK;
      }
    } 
    if (fingerIndex.isExtended() && fingerMiddle.isExtended()) {
      if (!fingerRing.isExtended() && !fingerPink.isExtended()) {
        println("--------Sword!Sword!!");
        return HandShapSword;
      }
    } 
    if (!fingerThumb.isExtended()  && !fingerMiddle.isExtended() && !fingerRing.isExtended()) {
      if (fingerIndex.isExtended()) {
        println("--------Bye!Bye!!");
        return HandShapBye;
      }
    } 
    if (!fingerThumb.isExtended()  &&!fingerIndex.isExtended() && !fingerMiddle.isExtended() && !fingerRing.isExtended() && !fingerPink.isExtended()) {
      println("--------Stone!Stone!!");
      return HandShapStone;
    } 
    if (fingerThumb.isExtended() && fingerIndex.isExtended() && fingerMiddle.isExtended() && fingerRing.isExtended() && fingerPink.isExtended()) {
      println("--------Five!Five!!");
      return HandShapBack;
    }
  }
  //????????????????????????????????????????????????
  return -1;
}

void VideoChooseScene() {
  Movie1.stop();
  Movie2.stop();
  Movie3.stop();
  //?????????????????????????????????????????????????????????
  int HandX = GetHandX();//??????????????????
  //?????????????????????????????????????????????
  //Frash Img Location
  int LRedge = width/25;
  //Frash Img size
  int FrontCoverMinWidth = width / 16;
  int FrontCoverMaxWidth = width / 3;
  int FrontCover1X = LRedge+FrontCoverMaxWidth/2;
  int FrontCover1Y = height/2;
  int FrontCover2X = width/2;
  int FrontCover2Y = height/2;
  int FrontCover3X = width - LRedge - FrontCoverMaxWidth/2;
  int FrontCover3Y = height/2;

  int FrontCover1Width = int(map(width-abs(FrontCover1X+FrontCoverMaxWidth/2-HandX), 0, width, FrontCoverMinWidth, FrontCoverMaxWidth));
  int FrontCover1Hight = FrontCover1Width*FrontCover1.height/FrontCover1.width;
  int FrontCover2Width = int(map(width-abs(width/2-HandX), 0, width, FrontCoverMinWidth, FrontCoverMaxWidth));
  int FrontCover2Hight = FrontCover2Width*FrontCover2.height/FrontCover2.width;
  int FrontCover3Width = int(map(width-abs(FrontCover3X+FrontCoverMaxWidth/2-HandX), 0, width, FrontCoverMinWidth, FrontCoverMaxWidth));
  int FrontCover3Hight = FrontCover3Width*FrontCover3.height/FrontCover3.width;

  //Play Movie1 or Movie2 or Movie3
  if (ControlCmdCheck() == HandShapOK) {//????????????????????????
    if (HandX < LRedge+FrontCover1Width) {
      CommandSend(Command_Video_1_Play);
      Movie1.play();
      ProgramStatus = Command_Video_1_Play;
      //play movie1
      return;
    } else if ( HandX > FrontCover2X-FrontCover2Width/2 && HandX < FrontCover2X+FrontCover2Width/2) {
      CommandSend(Command_Video_2_Play);
      Movie2.play();
      ProgramStatus = Command_Video_2_Play;
      //play movie2
      return;
    } else if ( HandX > FrontCover3X-FrontCover3Width/2) {
      CommandSend(Command_Video_3_Play);
      Movie3.play();
      ProgramStatus = Command_Video_3_Play;
      //play movie3
      return;
    }
  }
  imageMode(CENTER);
  //get mouse location
  image(FrontCover1, FrontCover1X, FrontCover1Y, FrontCover1Width, FrontCover1Hight);
  image(FrontCover2, FrontCover2X, FrontCover2Y, FrontCover2Width, FrontCover2Hight);
  image(FrontCover3, FrontCover3X, FrontCover3Y, FrontCover3Width, FrontCover3Hight);
  // Displays the image at point (0, height/2) at half of its size
  // ????????????????????????????????????????????????2??????????????????
  if (HandX > FrontCover1X && HandX < FrontCover1X+FrontCover1Width) {
    CommandSend(Command_Video_1_Cover);
  } else if ( HandX > FrontCover2X && HandX <FrontCover2X+FrontCover2Width) {
    CommandSend(Command_Video_2_Cover);
  } else if ( HandX > FrontCover3X && HandX <FrontCover3X+FrontCover3Width) {
    CommandSend(Command_Video_3_Cover);
  }
}

void Command_Video_1_Play() {
  if (ProgramStatus!=Command_Video_1_Play && ProgramStatus!=Command_Video_1_ChangeColor) {
    CommandSend(Command_Video_1_Play);
    ProgramStatus = Command_Video_1_Play;
  }
  //image(Movie1, width/2, height/2, width, height);
  image(Movie1, width/2, height/2);//?????????????????????
  if (ControlCmdCheck() == HandShapStone) {
    CommandSend(Command_Video_1_ChangeColor);
    ProgramStatus = Command_Video_1_ChangeColor;
  }
  //????????????1
}

void Command_Video_2_Play() {
  if (ProgramStatus!=Command_Video_2_Play && ProgramStatus!=Command_Video_2_ChangeColor) {
    CommandSend(Command_Video_2_Play);
    ProgramStatus = Command_Video_2_Play;
  }
  //image(Movie2, width/2, height/2, width, height);
  image(Movie2, width/2, height/2);//?????????????????????
  //ProgramStatus = Command_Video_2_Play;
  if (ControlCmdCheck() == HandShapSword) {
    CommandSend(Command_Video_2_ChangeColor);
    ProgramStatus = Command_Video_2_ChangeColor;
  }
  //????????????2
}

void Command_Video_3_Play() {
  if (ProgramStatus!=Command_Video_3_Play && ProgramStatus!=Command_Video_3_ChangeColor) {
    CommandSend(Command_Video_3_Play);
    ProgramStatus = Command_Video_3_Play;
  }
  //image(Movie3, width/2, height/2, width, height);
  image(Movie3, width/2, height/2);//?????????????????????
  //ProgramStatus = Command_Video_3_Play;
  if (ControlCmdCheck() == HandShapBye) {
    CommandSend(Command_Video_3_ChangeColor);
    ProgramStatus = Command_Video_3_ChangeColor;
  }
  //????????????3
}

void Command_Video_1_ChangeColor() {
  CommandSend(Command_Video_1_ChangeColor);
  ProgramStatus = Command_Video_1_ChangeColor;
  Command_Video_1_Play();
  //????????????????????????????????????????????????1????????????
}

void Command_Video_2_ChangeColor() {
  CommandSend(Command_Video_2_ChangeColor);
  ProgramStatus = Command_Video_2_ChangeColor;
  Command_Video_2_Play();
  //????????????????????????????????????????????????2????????????
}

void Command_Video_3_ChangeColor() {
  CommandSend(Command_Video_3_ChangeColor);
  ProgramStatus = Command_Video_3_ChangeColor;
  Command_Video_3_Play();
  //????????????????????????????????????????????????3????????????
}

void CommandSend(int CommandStateMant) {
  if (ProgramStatus != CommandStateMant) {
    myClient.clear();
    myClient.write(CommandStateMant);
    println("Net sent: ", CommandStateMant);
  }
  //??????????????????????????????
}

void movieEvent(Movie m) {
  m.read();
  //??????????????????????????????????????????
}

int GetHandX() {
  //??????????????????
  PVector handPosition;
  try {
    for (Hand hand : leap.getHands ()) {
      handPosition = hand.getPosition();
      return int(map(handPosition.x, HandXLocationMin, HandXLocationMax, 0, width));
    }
  } 
  catch (Exception ex) {
    return mouseX;
  }
  return mouseX;
}
