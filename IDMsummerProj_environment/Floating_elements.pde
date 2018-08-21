void createMesh4Elements() {
  //Define the size and fill the vertices array
  elementPos = new PVector[nElements];
  elementCache = new int[nElements];

  for (int i = 0; i<elementPos.length; i++) {
    //Scan all the points
    //Generate the center of the points
    //as a random point on the sphere

    //Take the random point from
    //cube [-1,1]x[-1,1]x[-1,1]  to form the sphere
    PVector center = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    center.normalize(); //Normalize vector's length to 1

    center.mult(Rad-buffer);  //Now the center vector has length 'Rad'

    //Set the randomly selected vertices
    //as the center of the spheres
    elementPos[i] = center;
  }
}

void plantSeed() {
  //this function is called once in setup();
  //it assigns an obj from the varieties to each element positions
  for (int i = 0; i<elementPos.length; i++) {
    int seed = randomSeeds(nFloatObj);
    elementCache[i] = seed;
  }
}

void placeElements() {
  for (int i = 0; i<elementPos.length; i++) {
    int seed = elementCache[i];
    pushMatrix();
    translate(elementPos[i].x, elementPos[i].y, elementPos[i].z);

    //draws the objs based on the assigned attribute
    switch(seed) {
    case 0:
      //set value of self-rotation of the elements
      pushMatrix();
      customRotate(0.8, 0.3, -0.5, 0.4);
      scale(8, 8, 8);
      shape(virus, 0, 0);
      popMatrix();
      break;

    case 1:
      //set value of self-rotation of the elements
      pushMatrix();
      customRotate(2, 0.1, 0.5, 0.2);
      scale(5, 5, 5);
      shape(DNA, 0, 0);
      popMatrix();
      break;

    case 2:
      //set value of self-rotation of the elements
      pushMatrix();
      customRotate(1, 0.5, 0.2, 0.3);
      scale(8, 8, 8);
      shape(threeobjects, 0, 0);
      popMatrix();
      break;

    case 3:
      //set value of self-rotation of the elements
      pushMatrix();
      customRotate(0.8, 0.7, 0.6, 0.4);
      shape(rock5, 0, 0);
      popMatrix();
      break;
    }
    //sphere(8);
    popMatrix();
  }
}
