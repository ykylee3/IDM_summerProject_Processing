ArrayList<CD> cd = new ArrayList<CD>(); 
float bound = 10;

void drawCD() {
  for (CD p : cd) {
    p.display();
    p.update();
  }
}

class CD {
  PVector pos;
  PVector vel;
  PVector acc;

  CD(PVector p) {
    pos = p;
    vel = new PVector(random(-1, 1), random(1, 1), random(-1, 1));
    acc = new PVector(random(-0.01, 0.01), random(-0.01, 0.01), random(-0.01, 0.01)); //speed
  }

  void update() {
    vel.add(acc);
    pos.add(vel);
    acc.mult(0); //Reset acc every time update() is called.
    vel.limit(5);


    //keep the particles on the screen
    if ((pos.x < -(bound)) || (pos.x > Rad*2)) {
      vel.x = vel.x*-1;
      //pos.add(vel);
    }
    if ((pos.y < -(bound)) || (pos.y > Rad*2)) {
      vel.y = vel.y * -1;
      //pos.add(vel);
    }
    if ((pos.z < -bound) || (pos.z > bound)) {
      vel.z = vel.z * -1;
      //pos.add(vel);
    }
  }

  void display() {
    pushMatrix();
    customRotate(2, 0.7, 0.4, 0.5);
    scale(10, 10, 10);
    translate(pos.x, pos.y, pos.z);
    shape(sharpsphere, 0, 0);
    popMatrix();
  }
}