ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList<Predators> pred = new ArrayList<Predators>();
int offset = 0; //off set value to allow the 'bird'to fly throught the sphere

void initBirds(int n) {
  //resize the ArrayList
  for (int i = 0; i<n; i++) {
    birds.add(new Bird());
  }
}

void initPreds(int n) {
  //resize the ArrayList
  for (int i = 0; i<n; i++) {
    pred.add(new Predators());
  }
}

void drawBirds() {
  for (Bird b : birds) {
    b.render();
    b.step();
  }
}

void drawPreds() {
  for (Predators p : pred) {
    p.render();
    p.step();
  }
}

//create the class Bird
class Bird {
  PVector position = new PVector(random(-(Rad+offset), Rad*2+offset), random(-offset, Rad*2+offset), random(-(offset), Rad+offset));
  PVector direction = new PVector (random(-1, 1), random(-1, 1)); //speed

  void render() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    customRotate(0.5, 0.4, 0.4, 0);
    shape(alien, 0, 0);
    popMatrix();
  }

  void step() {
    //find closest Bird
    Bird closestBird = null;
    float closestDistance = 9000;
    for (Bird b : birds) {
      if (this != b) {
        float distance = position.dist(b.position);
        if (distance < closestDistance) {
          closestDistance = distance;
          closestBird = b;
        }
      }
    }

    //average directions so they converge to the same direction
    direction = new PVector((direction.x+closestBird.direction.x)/2, (direction.y+closestBird.direction.y)/2, (direction.z+closestBird.direction.z)/2);

    position.add(direction);

    //keep the birds on the screen
    if (position.x < offset) {
      position.x = width-offset;
    }
    if (position.x > width-offset) {
      position.x = offset;
    }
    if (position.y < offset) {
      position.y = height-offset;
    }
    if (position.y > height-offset) {
      position.y = offset;
    }
    if (position.z < offset) {
      position.z = Rad*2-offset;
    }
    if (position.z > Rad*2-offset) {
      position.z =offset;
    }
  }
}

class Predators extends Bird {
  PVector position = new PVector(random(-(Rad+offset), Rad*2+offset), random(-offset, Rad*2+offset), random(-(offset), Rad+offset));
  PVector Bdirection = new PVector (random(-1, 1), random(-1, 1)); //speed of chasing after birds
  PVector Pdirection = new PVector (random(-1, 1), random(-1, 1)); //speed of repelling away from other predators

  void render() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    customRotate(0.5, 0.4, 0.4, 0);
    shape(helix, 0, 0);
    popMatrix();
  }

  void step() {
    //find closest predator
    Predators closestPred = null;
    Bird closestBird = null;
    float closestDistanceP = 5000;
    float closestDistanceB = 7000;
    for (Predators p : pred) {
      if (this != p) {
        float distance = position.dist(p.position);
        if (distance < closestDistanceP) {
          closestDistanceP = distance;
          closestPred = p;
        }
      }
      for (Bird b : birds) {
        float distance = position.dist(b.position);
        if (distance < closestDistanceB) {
          closestDistanceB = distance;
          closestBird = b;
        }
      }
    }

    Bdirection = new PVector((direction.x+closestBird.direction.x)/2, (direction.y+closestBird.direction.y)/2, (direction.z+closestBird.direction.z)/2);
    position.add(Bdirection);
    //average directions so they converge to the same direction
    Pdirection = new PVector((direction.x+closestPred.direction.x)/2, (direction.y+closestPred.direction.y)/2, (direction.z+closestPred.direction.z)/2);
    position.add(Pdirection);

    //keep the predators on the screen
    if (position.x < offset) {
      position.x = width-offset;
    }
    if (position.x > width-offset) {
      position.x = offset;
    }
    if (position.y < offset) {
      position.y = height-offset;
    }
    if (position.y > height-offset) {
      position.y = offset;
    }
    if (position.z < offset) {
      position.z = Rad*2-offset;
    }
    if (position.z > Rad*2-offset) {
      position.z =offset;
    }
  }
}