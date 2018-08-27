ArrayList<CD> cd = new ArrayList<CD>(); 
float bound = 200;

void drawCD() {
  for (CD cd : cd) {
    cd.update();
    cd.display();
  }
}

class CD {
  PVector pos;
  PVector vel;
  PVector acc;

  CD(PVector p) {
    pos = p;
    vel = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    acc = new PVector(0, 0.1, 0.05);
  }

  void update() {
    vel.add(acc);
    pos.add(vel);

    //keep the particles on the screen
    if (pos.x < bound) {
      pos.x = width-bound;
    }
    if (pos.x > width-bound) {
      pos.x = bound;
    }
    if (pos.y < bound) {
      pos.y = height-bound;
    }
    if (pos.y > height-bound) {
      pos.y = bound;
    }
    if (pos.z < bound) {
      pos.z = Rad*2-bound;
    }
    if (pos.z > Rad*2-bound) {
      pos.z =bound;
    }
  }

  void display() {
    pushMatrix();
    shape(sharpsphere, pos.x, pos.y);
    popMatrix();
  }
}