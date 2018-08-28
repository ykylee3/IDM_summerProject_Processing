ArrayList<CD> cd = new ArrayList<CD>(); 

void drawCD() {
  for (CD p : cd) {
    p.update();
    p.display();
    p.bounce();
  }
  println("destroy particles array: " + cd.size());
}

void destroy() {
for ( Integer num : particles_remove ) {
    int randParticleN = int( random( cd.size() ) );
    CD randParticle = cd.get( randParticleN );
    println( randParticle.pos.x, randParticle.pos.y );
    float coordArray[] = new float [] { randParticle.pos.x, randParticle.pos.y };
    //calling explosion event
    //particles_explosion.add( coordArray );
    //removes from particles
    cd.remove( randParticleN );
  }
  //clean array particles_remove
  particles_remove.clear();
  println("after destroy particles array: " + cd.size());
}

class CD {
  PVector pos;
  PVector vel;
  PVector acc;
  PVector min = new PVector(-(Rad), -(Rad*0.3), -(Rad));
  PVector max = new PVector((Rad), Rad*0.3, 0);


  CD(PVector p) {
    pos = p;
    vel = new PVector(random(-1, 1), random(1, 1), random(-1, 1));
    acc = new PVector(random(-1, 1), random(-1, 1), random(-1, 1)); //speed
  }

  void update() {
    vel.add(acc);
    pos.add(vel);
    acc.mult(0); //Reset acc every time update() is called.
    vel.limit(4);
  }

  void display() {
    pushMatrix();
    //scale(10, 10, 10);
    translate(pos.x, pos.y, pos.z);
    customRotate(2, 0.7, 0.4, 0.5);
    scale(5, 5, 5);
    shape(sharpsphere, 0, 0);
    popMatrix();
  }

  void bounce() {
    //keep the particles on the screen
    if (pos.x > max.x) {
      pos.x = max.x;
      vel.x *= -1;
    }
    if (pos.x < min.x) {
      pos.x = min.x;
      vel.x *= -1;
    }
    if (pos.y > max.y) {
      pos.y = max.y;
      vel.y *= -1;
    }
    if (pos.y < min.y) {
      pos.y = min.y;
      vel.y *= -1;
    }
    if (pos.z > max.z) {
      pos.z = max.z;
      vel.z *= -1;
    }
    if (pos.z < min.z) {
      pos.z = min.z;
      vel.z *= -1;
    }
  }
}