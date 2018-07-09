ArrayList<Bird> birds = new ArrayList<Bird>();
int offset = 50; //off set value to allow the 'bird'to fly throught the sphere

void initBirds(int n) {
  //resize the ArrayList
  for (int i = 0; i<n; i++) {
    birds.add(new Bird());
  }
}

void drawBirds() {
  for (Bird b : birds) {
    b.render();
    b.step();
  }
}

//create the class Bird
class Bird {
  PVector position = new PVector(random(-offset, width+offset), random(-offset, height+offset), random(-(Rad+offset), Rad+offset));
  PVector direction = new PVector(random(-6, 6), random(-6, 6), random(-6, 6)); //speed

  void render() {
    pushMatrix();
    fill(0, 255, 0);
    translate(position.x, position.y, position.z);
    box(8);
    popMatrix();
  }

  void step() {
    //find closest Bird
    Bird closestBird = null;
    float closestDistance = 100000;
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

    if (position.x < 100) {
      position.x = width-100;
    }
    if (position.x > width-100) {
      position.x = 100;
    }
    if (position.y < 100) {
      position.y = height-100;
    }
    if (position.y > height-100) {
      position.y = 100;
    }
    if (position.z < 100) {
      position.z = height-100;
    }
    if (position.z > height-100) {
      position.z =100;
    }
  }
}