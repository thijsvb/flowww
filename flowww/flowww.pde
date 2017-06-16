final float d = 25;
final float res = 0.5;
float last;
int version = 0;

Field field;
Thing[] things;

void setup() {
  size(1414, 1000);
  background(0);
  
  field = new Field();
  things = new Thing[100];
  for(int i=0; i!=things.length; ++i) {
    things[i] = new Thing(random(width), random(height), random(-2,2), random(-2,2));
  }
  last = frameCount;
}

void draw() {
  for(int i=0; i!=things.length; ++i) {
    things[i].update();
    things[i].show();
  }
  
  if(frameCount - last >= 600) {
    for(int i=0; i!=things.length; ++i) {
      things[i] = new Thing(random(width), random(height), random(-2,2), random(-2,2));
    }
    last = frameCount;
  }
}

void keyPressed() {
  if(key == 's' || key == 'S') {
    save("flow" + "-" + day() + "-" + month() + "-" + version++ + ".png");
  }
}

class Field {
  PVector[][] vectors;
  int cols, rows;

  Field() {
    cols = floor(width/d);
    rows = floor(height/d);
    vectors = new PVector[cols][rows];


    for (int i=0; i!=cols; ++i) {
      for (int j=0; j!=rows; ++j) {
        float n = noise(i*res, j*res);
        vectors[i][j] = PVector.fromAngle(n * TWO_PI - PI);
      }
    }
  }
}

class Thing {
  PVector pos, vel, acc;
  ArrayList<PVector> path;
  
  Thing(float x, float y, float vx, float vy) {
    pos = new PVector(x, y);
    vel = new PVector(vx, vy);
    acc = new PVector();
  }
  
  void update() {
    pos.add(vel);
    vel.add(acc).limit(2);
    acc.mult(0);
    
    //float x = (pos.x + width)%width;
    //float y = (pos.y + height)%height;
    //pos.set(x, y);
    
    int c = (floor(pos.x/d)+field.cols)%field.cols;
    int r = (floor(pos.y/d)+field.rows)%field.rows;
    PVector f = field.vectors[c][r].copy();
    acc.add(f);
  }
  
  void show() {
    fill(0, 255, 0, 10);
    noStroke();
    ellipse(pos.x, pos.y, 4, 4);
  }
}