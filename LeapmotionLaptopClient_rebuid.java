import de.voidplus.leapmotion.*;
import processing.video.*;
import processing.net.*;
import de.voidplus.leapmotion.*;
//leap Motion
//import every lib we need

LeapMotion leap = new LeapMotion(this);
//Init leapMotion Device

String ServerIP = "127.0.0.1";
int ServerPort = 10002;
Client myClient = new Client(this, ServerIP, ServerPort);;
//Init Socket services

Movie BackGround1 = new Movie(this, sketchPath("")+"Background1.mov");
PImage FrontCover1 = loadImage(sketchPath("")+"Cover1.jpg");
PImage FrontCover2 = loadImage(sketchPath("")+"Cover2.jpg");  
PImage FrontCover3 = loadImage(sketchPath("")+"Cover3.jpg");  
// Load the image into the program
// The image file must be in the data folder of the current sketch to load successfully
Movie Movie1 = new Movie(this, sketchPath("")+"/Movie1.mov");
Movie Movie2 = new Movie(this, sketchPath("")+"/Movie2.mov");
Movie Movie3 = new Movie(this, sketchPath("")+"/Movie3.mov"); 
//three Movie we need

int programStatue = 0;
public static int VideoChooseScene = 0; 
public static int Video_1_PlayScene = 1; 
public static int Video_2_PlayScene = 2; 
public static int Video_3_PlayScene = 3; 
public static int Video_1_ColorChangeScene = 4; 
public static int Video_2_ColorChangeScene = 5; 
public static int Video_3_ColorChangeScene = 6; 

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


void setup(){
    size(1280, 960);
    //set Window Size
    //fullscreen();
    noStroke();
    //Disables drawing the stroke (outline). 
    //If both noStroke() and noFill() are called, 
    //nothing will be drawn to the screen.
    Movie1.loop();
    Movie2.loop();
    Movie3.loop();
    //Set Movie Play Mode to Loop
}

void draw(){
    //无论如何都会刷新背景
    BackGroundScene();
    //这里检测控制信号，判断程序是否应该退出
    ControlCmdCheck();
    //一下代码制定了程序可能出现的7种情况，根据操作检测环节的返回值来确定该如何刷新界面
    if(programStatue == VideoChooseScene){
        VideoChooseScene();
    }else if(programStatue == Video_1_PlayScene){
        Video_1_PlayScene();
    }else if(programStatue == Video_2_PlayScene){
        Video_2_PlayScene();
    }else if(programStatue == Video_3_PlayScene){
        Video_3_PlayScene();
    }else if(programStatue == Video_1_ColorChangeScene){
        Video_1_ColorChangeScene();
    }else if(programStatue == Video_2_ColorChangeScene){
        Video_2_ColorChangeScene();
    }else if(programStatue == Video_3_ColorChangeScene){
        Video_3_ColorChangeScene();
    }
}

void BackGroundScene(){
    //这里刷新和显示背景的变化，其他内容都在此基础上刷新和显示
}

int ControlCmdCheck(){
    //检测手势并返回手势代码，每次返回值唯一
    //在这里应对手部突然抽出的情况
    Hand hand = leap.getHands();
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
    }else if (fingerIndex.isExtended() && fingerMiddle.isExtended()) {
        if (!fingerRing.isExtended() && !fingerPink.isExtended()) {
          println("--------Sword!Sword!!");
          return HandShapSword;
        }
    }else if (!fingerThumb.isExtended()  && !fingerMiddle.isExtended() && !fingerRing.isExtended()) {
        if (fingerIndex.isExtended()) {
          println("--------Bye!Bye!!");
          return HandShapBye;
        }
    }else if (!fingerThumb.isExtended()  &&!fingerIndex.isExtended() && !fingerMiddle.isExtended() && !fingerRing.isExtended() && !fingerPink.isExtended()) {
        println("--------Stone!Stone!!");
        return HandShapStone;
    }else if (fingerThumb.isExtended() && fingerIndex.isExtended() && fingerMiddle.isExtended() && fingerRing.isExtended() && fingerPink.isExtended()) {
        println("--------Five!Five!!");
        return HandShapBack;
    }
    //检测鼠标和键盘输入，检测退出按钮
}

void VideoChooseScene(){
    //发送循环屏幕指令和封面信息供客户端播放
    int HandX = 0;//检测手的位置
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
    //这里循环刷新和显示视频选择界面
    int FrontCoverMinWidth = width / 8;
    int FrontCoverMinHight = height / 10;
    int FrontCoverMaxWidth = width / 3;
    int FrontCoverMaxHight = height / 2;
    int FrontCover1Width = int(map(width-abs(FrontCover1X+FrontCoverMaxWidth/2-GetHandX()), 0, width, FrontCoverMinWidth, FrontCoverMaxWidth));
    int FrontCover1Hight = FrontCover1Width*FrontCover1.height/FrontCover1.width;
    int FrontCover2Width = int(map(width-abs(width/2-GetHandX()), 0, width, FrontCoverMinWidth, FrontCoverMaxWidth));
    int FrontCover2Hight = FrontCover2Width*FrontCover2.height/FrontCover2.width;
    int FrontCover3Width = int(map(width-abs(FrontCover3X+FrontCoverMaxWidth/2-GetHandX()), 0, width, FrontCoverMinWidth, FrontCoverMaxWidth));
    int FrontCover3Hight = FrontCover3Width*FrontCover3.height/FrontCover3.width;
    //Frash Img size
    int FrontCover1X = LRedge+FrontCover1X/2;
    int FrontCover1Y = height/2;
    int FrontCover2X = width/2;
    int FrontCover2Y = height/2;
    int FrontCover3X = width - LRedge - FrontCover3X;
    int FrontCover3Y = height/2;
    //Frash Img Location

    imageMode(CENTER);
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

void Video_1_PlayScene(){
    CommandSend(Command_Video_1_Play);
    //播放视频1
}

void Video_2_PlayScene(){
    CommandSend(Command_Video_2_Play);
    //播放视频2
}

void Video_3_PlayScene(){
    CommandSend(Command_Video_2_Play);
    //播放视频3
}

void Video_1_ColorChangeScene(){
    CommandSend(Command_Video_1_ChangeColor);
     Video_1_PlayScene();
     //后面写发送信息要求客户端播放视频1换色指令
}

void Video_2_ColorChangeScene(){
    CommandSend(Command_Video_2_ChangeColor);
    Video_2_PlayScene();
    //后面写发送信息要求客户端播放视频2换色指令
}

void Video_3_ColorChangeScene(){
    CommandSend(Command_Video_2_ChangeColor);
    Video_3_PlayScene();
    //后面写发送信息要求客户端播放视频3换色指令
}

void CommandSend(int CommandStateMant){
    myClient.clear();
    myClient.write(CommandStateMant);
    //向客户端发送相应指令
}

void movieEvent(Movie m) {
    m.read();
    //用不断显示图片的方法播放视频
  }