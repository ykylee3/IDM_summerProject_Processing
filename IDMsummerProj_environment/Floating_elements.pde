void createMesh4Elements() {
  //Define the size and fill the vertices array
  elementPos = new PVector[nElements];

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

void placeElements() {
  fill(0, 0, 255);
  stroke(200);

  for (int i = 0; i<elementPos.length; i++) {
    pushMatrix();
    translate(elementPos[i].x, elementPos[i].y, elementPos[i].z);
    //set value of self-rotation of the elements
    customRotate(0.7, 0.3, -0.5, 0.4);
    sphere(8);
    popMatrix();
  }
}