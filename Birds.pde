ArrayList<Bird> birds = new ArrayList<Bird>();
int offset = 0; //off set value to allow the 'bird'to fly throught the sphere

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
  PVector position = new PVector(random(-offset, width+offset), random(-offset, height+offset), random(-(offset), Rad+offset));
  PVector direction = new PVector(random(-4, 4), random(-4, 4), random(-4, 4)); //speed

  void render() {
    pushMatrix();
    fill(0, 255, 0);
    translate(position.x, position.y, position.z);
    customRotate(0.5, 0.4, 0.4, 0);
    shape(hillix, 0, 0);
    //box(8);
    popMatrix();
  }

  void step() {
    //find closest Bird
    Bird closestBird = null;
    float closestDistance = 5000;
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