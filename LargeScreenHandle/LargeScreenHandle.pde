import processing.net.*;
import processing.video.*;

//Identify CommandCode List
public static int PLAY_SCENE = 1;
public static int STOP_PLAYING = 2;
public static int CHANGE_COLOR = 3;
public static int PLAYING_MOVIE1 = 4;
public static int PLAYING_MOVIE2 = 5;
public static int PLAYING_MOVIE3 = 6;
public static int STOP_CHANGE_COLOR = 7;

PImage FrontCover1, FrontCover2, FrontCover3;  
// Declare 3 variable of type PImage
Movie MovieShap1, MovieShap2, MovieShap3;
//three Movie we need

int CommandReceived = 0;
int port = 10002;
boolean myServerRunning = true;
int MovieBeenPointed = 0;
int Is_Playing = 0;
boolean ColorChenge = false;
Server myServer;

void setup() {
  imageMode(CENTER);
  myServer = new Server(this, port);
  // Starts a myServer on port 10002
  size(640, 480);
  //set Window Size
  //fullScreen();
  noStroke();
  //  Disables drawing the stroke (outline). 
  //If both noStroke() and noFill() are called, 
  //nothing will be drawn to the screen.

  FrontCover1 = loadImage(sketchPath("")+"ShapeCover1.jpg");
  FrontCover2 = loadImage(sketchPath("")+"ShapeCover2.jpg");  
  FrontCover3 = loadImage(sketchPath("")+"ShapeCover3.jpg");  
  // Load the image into the program
  // The image file must be in the data folder of the current sketch to load successfully
  MovieShap1 = new Movie(this, sketchPath("")+"/MovieShap1.mov");
  MovieShap2 = new Movie(this, sketchPath("")+"/MovieShap2.mov");
  MovieShap3 = new Movie(this, sketchPath("")+"/MovieShap3.mov");
  //load videos
  MovieShap1.loop();
  MovieShap2.loop();
  MovieShap3.loop();
  MovieShap1.pause();
  MovieShap2.pause();
  MovieShap3.pause();
  //SetPlayMode
  textSize(30);
  frameRate(60);
}

void draw() {
  if (mouseButton == CENTER) {
    myServer.stop();
    myServerRunning = false;
  }
  //image(MovieShap3, width/2, height/2, width, height);
  if (myServerRunning == true)
  {
    text("server", 500, 45);
    Client thisClient = myServer.available();
    if (thisClient != null && thisClient.available() > 0) {
      CommandReceived= thisClient.read();
    }
    switch(CommandReceived) {
      case (4):
      {
        //PLAYING_MOVIE1
        MovieBeenPointed=PLAYING_MOVIE1;
        break;
      }
      case (5):
      {
        //PLAYING_MOVIE2
        MovieBeenPointed=PLAYING_MOVIE2;
        break;
      }
      case (6):
      {
        //PLAYING_MOVIE3
        MovieBeenPointed=PLAYING_MOVIE3;
        break;
      }
      case (7):
      {
        //STOP_CHANGE_COLOR
        ColorChenge = false;
        break;
      }
      case (1):
      {
        //PLAY_SCENE
        text("PlayChoosenMovie", 15, 80);
        PlayChoosenMovie();
        break;
      }
      case (2):
      {
        //STOP_PLAYING
        HandleReturnButton();
        break;
      }
      case (3):
      {
        //CHANGE COLOR
        ColorChenge = true;
        break;
      }
    }

    SceneMoviePlay();
    //SceneMoviePlay will check witch movie was choosen automaticlly
    //and play it :)
  }
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
