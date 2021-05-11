import processing.net.*;
import processing.video.*;

String ServerIP = "127.0.0.1";
int ServerPort = 10002;
Server myServer;

//Identify CommandCode List
public static int PLAY_SCENE = 1;
public static int STOP_PLAYING = 2;
public static int CHANGE_COLOR = 3;
public static int PLAYING_MOVIE1 = 4;
public static int PLAYING_MOVIE2 = 5;
public static int PLAYING_MOVIE3 = 6;
public static int STOP_CHANGE_COLOR = 7;

public static int Command_Video_1_Cover = 1;
public static int Command_Video_2_Cover = 2;
public static int Command_Video_3_Cover = 3;
public static int Command_Video_1_Play = 4;
public static int Command_Video_2_Play = 5;
public static int Command_Video_3_Play = 6;
public static int Command_Video_1_ChangeColor = 7;
public static int Command_Video_2_ChangeColor = 8;
public static int Command_Video_3_ChangeColor = 9;

PImage FrontCover1, FrontCover2, FrontCover3;  
// Declare 3 variable of type PImage
Movie MovieShap1, MovieShap2, MovieShap3;
//three Movie we need

int CommandReceived = 0;
boolean myServerRunning = true;
int MovieBeenPointed = 0;
int Is_Playing = 0;
boolean ColorChenge = false;


void setup() {
  imageMode(CENTER);
  myServer = new Server(this, ServerPort);
  // Starts a myServer on port 10002
  size(640, 480);
  //set Window Size
  //fullScreen();
  noStroke();
  //所绘制的图形都没有描边
  //加载图像和视频并准备
  FrontCover1 = loadImage(sketchPath("")+"ShapeCover1.jpg");
  FrontCover2 = loadImage(sketchPath("")+"ShapeCover2.jpg");  
  FrontCover3 = loadImage(sketchPath("")+"ShapeCover3.jpg");  
  MovieShap1 = new Movie(this, sketchPath("")+"/MovieShap1.mov");
  MovieShap2 = new Movie(this, sketchPath("")+"/MovieShap2.mov");
  MovieShap3 = new Movie(this, sketchPath("")+"/MovieShap3.mov");
  //SetPlayMode
  MovieShap1.loop();
  MovieShap2.loop();
  MovieShap3.loop();
  MovieShap1.pause();
  MovieShap2.pause();
  MovieShap3.pause();
  textSize(30);
  text("server", 500, 45);
  //frameRate(60);
}

void draw() {
  if (mousePressed) {
    if (mouseButton == CENTER) {
      myServer.stop();
      myServerRunning = false;
      exit();
    }
  }
  //退出机制
  //image(MovieShap3, width/2, height/2, width, height);
    Client thisClient = myServer.available();
    //获取链接进来的client
    if(thisClient != null)println("got");
    if (thisClient != null && thisClient.available() > 0) {
      CommandReceived= thisClient.read();
      println("received: ", CommandReceived);
    }
    //获取读取到的数据 
      if (thisClient != null && thisClient.available() > 0) {
      CommandReceived= thisClient.read();
    }
    //对于每个连入的客户端，获取读取到的数据
    if (CommandReceived == Command_Video_1_Cover) {
    Video_1_Cover();
  } else if (CommandReceived == Command_Video_2_Cover) {
    Video_2_Cover();
  } else if (CommandReceived == Command_Video_3_Cover) {
    Video_3_Cover();
  } else if (CommandReceived == Command_Video_1_Play) {
    Video_1_Play();
  } else if (CommandReceived == Command_Video_2_Play) {
    Video_2_Play();
  } else if (CommandReceived == Command_Video_3_Play) {
    Video_3_Play();
  } else if (CommandReceived == Command_Video_1_ChangeColor) {
    Video_1_ColorChangeScene();
  } else if (CommandReceived == Command_Video_2_ChangeColor) {
    Video_2_ColorChangeScene();
  } else if (CommandReceived == Command_Video_3_ChangeColor) {
    Video_3_ColorChangeScene();
  }
}

void Video_1_Cover(){
  //封面1
  set(0, 0, FrontCover1);
}
void Video_2_Cover(){
  //封面2
  set(0, 0, FrontCover2);
}
void Video_3_Cover(){
  //封面3
  set(0, 0, FrontCover3);
}
void Video_1_Play(){
  //播放视频1
  image(MovieShap1, width/2, height/2, width, height);
}
void Video_2_Play(){
  //播放视频2
  image(MovieShap2, width/2, height/2, width, height);
}
void Video_3_Play(){
  //播放视频3
  image(MovieShap3, width/2, height/2, width, height);
}
void Video_1_ColorChangeScene(){
  ColorChange(MovieShap1, color(0, 0, 0), color(255, 0, 0), 50);
  //播放处理过的视频1(白色替换为蓝色)
}
void Video_2_ColorChangeScene(){
  ColorChange(MovieShap2, color(0, 0, 0), color(0, 255, 0), 50);
  //播放处理过的视频2(白色替换为红色)
}
void Video_3_ColorChangeScene(){
  ColorChange(MovieShap3, color(0, 0, 0), color(0, 0, 255), 50);
  //播放处理过的视频3(白色替换为绿色)
}

void PlayChoosenMovie() {
  //Play MovieShap1 or MovieShap2 or MovieShap3
  if (MovieBeenPointed == PLAYING_MOVIE1) {
    Is_Playing=PLAYING_MOVIE1;
    MovieShap1.play();
    //play movie1
  } else if (MovieBeenPointed == PLAYING_MOVIE2) {
    Is_Playing=PLAYING_MOVIE2;
    MovieShap2.play();
    //play movie2
  } else if (MovieBeenPointed == PLAYING_MOVIE3) {
    Is_Playing=PLAYING_MOVIE3;
    MovieShap3.play();
    //play movie3
  }
}

void HandleReturnButton() {
  Is_Playing = 0;
  MovieShap1.stop();
  MovieShap2.stop();
  MovieShap3.stop();
}

void SceneMoviePlay() {
  imageMode(CENTER);
  if (Is_Playing ==PLAYING_MOVIE1) {
    text("MOVIE_1", 15, 45);
    MovieShap1.play();
    image(MovieShap1, width/2, height/2, width, height);
    if (ColorChenge)ColorChange(MovieShap3, color(0, 0, 0), color(0, 0, 255), 50);
  } else if (Is_Playing ==PLAYING_MOVIE2) {
    text("MOVIE_2", 15, 45);
    MovieShap2.play();
    image(MovieShap2, width/2, height/2, width, height);
    if (ColorChenge)ColorChange(MovieShap3, color(0, 0, 0), color(0, 0, 255), 50);
  } else if (Is_Playing ==PLAYING_MOVIE3) {
    text("MOVIE_3", 15, 45);
    MovieShap3.play();
    image(MovieShap3, width/2, height/2, width, height);
    if (ColorChenge)ColorChange(MovieShap3, color(0, 0, 0), color(0, 0, 255), 50);
  } else {
    switch(MovieBeenPointed) {
    case 4:
      image(FrontCover1, width/2, height/2, width, height);
      //image(FrontCover1, width/2, height/2, width, height*FrontCover1.width/FrontCover1.height);
      break;
    case 5:
      image(FrontCover2, width/2, height/2, width, height);
      //image(FrontCover2, width/2, height/2, width, height*FrontCover2.width/FrontCover2.height);
      break;
    case 6:
      image(FrontCover3, width/2, height/2, width, height);
      //image(FrontCover3, width/2, height/2, width, height*FrontCover3.width/FrontCover3.height);
      break;
    }
  }
}

void ColorChange(PImage img, color Incolor, color Outcolor, int dif) {
  //输入图片开始颜色替换，替换完成的图片从0，0平铺在屏幕上
  int mx, my;
  int r, g, b, IncolorR, IncolorG, IncolorB;
  color SelectedPixColor;
  IncolorR = (Incolor >> 16) & 0xFF;
  IncolorG = (Incolor >> 8) & 0xFF;
  IncolorB = Incolor & 0xFF;
  for (mx=0; mx<width; mx++) {
    for (my=0; my<height; my++) {
      SelectedPixColor = img.get(mx, my);
      r = (SelectedPixColor >> 16) & 0xFF;
      g = (SelectedPixColor >> 8) & 0xFF;
      b = SelectedPixColor & 0xFF;
      if (r<IncolorR+dif&&r>IncolorR-dif)
        if (g<IncolorG+dif&&g>IncolorG-dif)
          if (b<IncolorB+dif&&b>IncolorB-dif)
            set(mx, my, Outcolor);
    }
  }
}

void movieEvent(Movie m) {
  m.read();
}
