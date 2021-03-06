final float d = 25;
final float res = 0.5;
float last;
int version = 0;
final int min = 212;
final int max = 42;

Field field;
Thing[] things;

void setup() {
  size(1414, 1000);
  background(0);

  field = new Field();
  things = new Thing[100];
  for (int i=0; i!=things.length; ++i) {
    things[i] = new Thing(random(width), random(height), random(-2, 2), random(-2, 2));
  }
  colorMode(HSB);
  last = millis();
}

void draw() {
  for (int i=0; i!=things.length; ++i) {
    things[i].update();
    things[i].show();
  }

  if (millis() - last >= 10000) {
    for (int i=0; i!=things.length; ++i) {
      things[i] = new Thing(random(width), random(height), random(-2, 2), random(-2, 2));
    }
    last = millis();
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    save(min + "-" + max + "-" + version++ + ".png");
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
  float h;

  Thing(float x, float y, float vx, float vy) {
    pos = new PVector(x, y);
    vel = new PVector(vx, vy);
    acc = new PVector();
    path = new ArrayList<PVector>();
    if (min > max) {
      h = random(min, max+255)%255;
    } else {
      h = random(min, max);
    }
  }

  void update() {
    path.add(pos.copy());
    pos.add(vel);
    vel.add(acc).limit(2);
    acc.mult(0);

    float x = (pos.x + width)%width;
    float y = (pos.y + height)%height;
    pos.set(x, y);

    int c = (floor(pos.x/d)+field.cols)%field.cols;
    int r = (floor(pos.y/d)+field.rows)%field.rows;
    PVector f = field.vectors[c][r].copy();
    acc.add(f);

    if (path.size() == 100) {
      path.remove(0);
    }
  }

  void show() {
    fill(h, 255, 255, 10);
    noStroke();
    ellipse(pos.x, pos.y, 4, 4);
  }
}