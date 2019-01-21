//////////////////////////////////////////////////////////////////////////
//                                                                      //
//   _____                _____           _                _            //
//  |  __ \              / ____|         | |              | |           //
//  | |__) |___  _ __   | (___   __ _  __| | _____   _____| | ___   _   //
//  |  _  // _ \| '_ \   \___ \ / _` |/ _` |/ _ \ \ / / __| |/ / | | |  //
//  | | \ \ (_) | | | |  ____) | (_| | (_| | (_) \ V /\__ \   <| |_| |  //
//  |_|  \_\___/|_| |_| |_____/ \__,_|\__,_|\___/ \_/ |___/_|\_\\__, |  //
//                                                              __/ |   //
//                                                             |___/    //
// Due Date: Monday, April 25, 2016                                     //
// Description: Pong Game - Final Submission                            //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

boolean [] button = new boolean [256];

PImage bng;
PImage ball;

Minim minim;
AudioPlayer player;
AudioPlayer ballhit;

int y = 185;
int y2 = 185;

float x = 300;
float y3 = 300;

float hspeed = 5;
float vspeed = 5;

float hpause = 3;
float vpause = 3;

int score1 = 0;
int score2 = 0;

boolean introB = false;

boolean pmove = true;

boolean cheat = false;

boolean cheatworks = true;

void setup() { //inputs start-up features; size, images, sound
  size(600, 450);
  introB = false;
  bng = loadImage("blackbrickwall1.jpg");
  ball = loadImage("redball.png");
  minim = new Minim(this);
  player = minim.loadFile("pongmusic.mp3");
  ballhit = minim.loadFile("thudsound.mp3");
  player.play();
  player.loop();
  for (int i=0; i<5; i++) {
    println(" ");
  }
}

void redrawGameField() { //draws elements of the game field
  bng.resize(600, 450);
  background(bng);
  fill(255);
  noStroke();
  if (score1 < 10 && score2 < 10) {
    rect(565, y, 15, 80);
    rect(20, y2, 15, 80);
    ball.resize(24, 24);
    ellipse(x, y3, 20, 20);
    image(ball, x-12, y3-12);
  }
  textAlign(CENTER);
  textSize(20);
  fill(255);
  text(score1, 100, 50);
  text(score2, 500, 50);
}

void bounceBall() { //bounces ball if it hits a paddle
  if (x+10 > 565 && y3>y && y3<y+80) {
    x = 565-10;
    hspeed *= -1;
    vspeed = random(-7, 7);
    ballhit.play();
    ballhit.rewind();
  }
  if (x-10 < 20+15 && y3>y2 && y3<y2+80) {
    x = 20+15+10;
    hspeed *= -1;
    vspeed = random(-7, 7);
    ballhit.play();
    ballhit.rewind();
  }
}

void playerOne() { //moves right paddle up and down

  if (keyPressed && key=='p' || keyPressed && key=='P') {
    cheat = true;
  }

  if (pmove==true) { 

    if (button[UP]) {
      y = y - 5;
      if (cheat==true && cheatworks==true) {
        y = y - 10;
      }
    }
    if (button[DOWN]) {
      y = y + 5;
      if (cheat==true && cheatworks==true) {
        y = y + 10;
      }
    }
    if (y>370) {
      y = 370;
    }
    if (y<0) {
      y = 0;
    }
  }
}

void playerTwo() { //moves left paddle up and down

  if (pmove==true) {

    if (button['W']) {
      y2 = y2 - 5;
    }
    if (button['S']) {
      y2 = y2 + 5;
    }
    if (y2>370) {
      y2 = 370;
    }
    if (y2<0) {
      y2 = 0;
    }
  }
}

void moveBall() { //bounces the ball around the screen and adds point when it hits the sides

  x = x + hspeed;
  y3 = y3 + vspeed;

  if (x+10 >= width) {
    castNewBall();
    score1++;
  }

  if (x-10 <= 0) {
    castNewBall();
    score2++;
    if (cheat==true) {
      cheat = false;
      cheatworks = false;
    }
  }

  if (y3+10 >= height) {
    vspeed *= -1;
  }

  if (y3-10 <= 0) {
    vspeed *= -1;
  }
}


void castNewBall() { //casts a new ball once it hits the edge of the screen
  x = width/2;
  y3 = width/2;
  vspeed = random(-7, 7);
}


void draw() {

  if (introB==false) { //animates the introduction screen
    bng.resize(600, 450);
    background(bng);
    noStroke();
    textAlign(CENTER);
    textSize(30);
    fill(255);
    rect(225, 350, 150, 50);
    fill(0);
    text("START", 300, 385);
    fill(255);
    textSize(60);
    text("PONG", 300, 75);
    textSize(15);
    text("Arrow Keys = Right Paddle", 300, 135);
    text("'W' and 'S' Keys = Left Paddle", 300, 165);
    text("Press spacebar to pause", 300, 195);
    text("10 points needed to win", 300, 225);
    text("Press 'START' to begin playing", 300, 255);

    return;
  } else {

    redrawGameField(); 

    if (score1==10) { //shows text if player wins
      vspeed = 0;
      hspeed = 0;
      fill(255);
      textSize(30);
      text("LEFT SIDE WINS!", 300, 225);
    } else if (score2==10) {
      vspeed = 0;
      hspeed = 0;
      fill(255);
      textSize(30);
      text("RIGHT SIDE WINS!", 300, 225);
    } else if (vspeed == 0 && hspeed == 0 ) {
      textSize(30);
      textAlign(CENTER);
      fill(255);
      text("PAUSED", 300, 225);
    }

    playerOne();
    playerTwo();
    moveBall();
    bounceBall();
  }
}


void mousePressed() { //operates the button on the introduction screen
  if (mouseX>225 && mouseX<375 && mouseY>350 && mouseY<400) {
    introB = true;
  }
}


void keyPressed() { //operates the pause function
  button[keyCode] = true;

  if (keyPressed && key==' ' && (vspeed != 0 || hspeed != 0)) {
    vpause = vspeed;
    hpause = hspeed;
    vspeed = 0;
    hspeed = 0;
    pmove = false;
  } else if (keyPressed && key==' ') {
    vspeed = vpause;
    hspeed = hpause;
    pmove = true;
  }
}

void keyReleased() {
  button[keyCode] = false;
}

//Cheat function: At any point of the game, the player controlling the right
//paddle can press "P", which will enable the right paddle to move faster. Once the 
//right player scores a point while using the cheat, the cheat will be disabled. 
//The cheat may not be used more than once per game.