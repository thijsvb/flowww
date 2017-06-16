final float d = 25;
final float res = 0.5;
final float grid = 30;
float last;
int version = 0;

Field field;
Thing[] things;

void setup() {
  size(1414, 1000);
  background(0);
  randomSeed(14);
  noiseSeed(14);

  field = new Field();
  things = new Thing[100];
  for (int i=0; i!=things.length; ++i) {
    things[i] = new Thing(random(width), random(height), random(-2, 2), random(-2, 2));
  }
  last = frameCount;
}

void draw() {
  for (int i=0; i!=things.length; ++i) {
    things[i].update();
  }

  if (frameCount - last >= 600) {
    for (int i=0; i!=things.length; ++i) {
      things[i].show();
      things[i] = new Thing(random(width), random(height), random(-2, 2), random(-2, 2));
    }
    last = frameCount;
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    save(int(grid) + ".png");
  }
  if (key == 't') println(things[0].path);
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
    path = new ArrayList<PVector>();
  }

  void update() {
    path.add(new PVector(round(pos.x/grid)*grid, round(pos.y/grid)*grid));
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

    //if (path.size() == 100) {
    //  path.remove(0);
    //}
  }

  void show() {
    //fill(0, 255, 0, 10);
    //noStroke();
    //ellipse(pos.x, pos.y, 4, 4);
    stroke(0, 255, 255, 5);
    strokeWeight(4);
    for (int i=0; i!=path.size()-1; ++i) {
      line(path.get(i).x, path.get(i).y, path.get(i+1).x, path.get(i+1).y);
    }
  }
}