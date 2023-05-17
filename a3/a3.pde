int bombtime;
int ntime;
int trailCount;
float trailLength;
float trailSpacing;
float trailX;
float trailY;
float ground = 600;
boolean start = false;



//This section is the generation of the bombs
class bomb {
  float x, y; // position of the enemy bomb
  float velx, vely; // velocity of the enemy bomb
  boolean exploded;
  int explosionTime;
  
  // set bomb pos & velovcity
  bomb() {
    x = random(800);
    y = 0;
    velx = random(1) < 0.5 ? -1: 1; //randomly choose between 1 and -1 
    vely = 2;
    exploded = false;
  }
  
  //enemy bomb pos
  void advance() {
    if (!exploded) {  //checks if bomb has reached the ground
      x += velx;
      y += vely;
      if (x < 0 || x > 800) { //if bomb tries to go out of bounds it bounces back ideally some kind of targeting system may be better but idk how 
        velx = velx * -1;
      }
     if (y >= ground) {
       exploded = true;
       explosionTime = millis(); // stores time for explosion this will be used for fade out 'explosion effect'
      }
    }
  }
  
  // draw bombs
  void render() {
    if (!exploded){
      stroke(255, 255, 0);
      strokeWeight(10);
      line(x, y, x - velx, y - vely);
      trailLength = 200;
      trailSpacing = 5;
      trailCount = int(trailLength / trailSpacing);
      for (int i = 1; i <= trailCount; i++) {
        float alpha = map(i, 1, trailCount, 255, 0);
        stroke(255, 0, 0, alpha);
        strokeWeight(10);
        trailX = x - velx * i * trailSpacing / vely;
        trailY = y - i * trailSpacing;
        line(trailX, trailY, trailX - velx, trailY - vely);
      }
    } else {
      //explosion
      noStroke();
      int fadeTime = 500; //duration of fade out or flash 
      int fadingTime = millis() - explosionTime; //time since explosion 
      int alpha = int(map(fadingTime, 0, fadeTime, 255, 0)); //adjust alpha based on elapsed time
      fill(255, 243, 166, alpha);
      circle(x, y, 30);
    }
  }
}

bomb[] bombs = new bomb[10];

void setup() {
  size(800, 800);
  bombtime = millis();
}

void draw() {
  if (start) {
    background(0);
    stroke(255, 0, 0);
    strokeWeight(1);
    line(0, ground, width, ground);
    //using time to add new bombs added every 3 seconds up until there have been 10 bombs
    ntime = millis(); 
    if (ntime - bombtime > 3000) {
      for (int i = 0; i < bombs.length; i++) {
        if (bombs[i] == null) {
          bombs[i] = new bomb();
          break;
        }
      }
      bombtime = ntime;
    }
    else if (bombtime == 0) {
      bombs[0] = new bomb();
      bombtime = ntime;
    }
    
    for (int i = 0; i < bombs.length; i++) {
      if (bombs[i] != null) {
        bombs[i].advance();
        bombs[i].render();    
    }
  }
} else {
  //start screen
  background(0);
  textSize(40);
  textAlign(CENTER, CENTER);
  fill(255, 0, 0);
  text("Click to Start", width/2, height/2);
  text("Missile Command", width/2, 350);
  }
}

void mousePressed() {
  if (!start) {
    start = true;
  }
}
