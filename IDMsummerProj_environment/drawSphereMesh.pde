void sphereMeshSetup() {
  //Define the size and fill the vertices array
  vertices = new PVector[nPoints];

  for (int i = 0; i<vertices.length; i++) {
    //Scan all the points
    //Generate the center of the points
    //as a random point on the sphere

    //Take the random point from
    //cube [-1,1]x[-1,1]x[-1,1]  to form the sphere
    PVector center = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    center.normalize(); //Normalize vector's length to 1

    center.mult(Rad);  //Now the center vector has length 'Rad'

    //Set the randomly selected vertices
    //as the center of the spheres
    vertices[i] = center;
  }
}

void drawSphereMesh() {
  fill(255);
  stroke(255);

  //Draw the mesh (vertices) of the sphere
  beginShape(POINTS);
  for (int i = 0; i<vertices.length; i++) {
    vertex(vertices[i].x, vertices[i].y, vertices[i].z);
  }
  endShape();

  //draw lines between near points
  for (int a = 0; a<vertices.length; a++) {
    PVector verta = vertices[a];
    for (int b = a + 1; b<vertices.length; b++) {
      PVector vertb = vertices[b];
      float distance = dist(verta.x, verta.y, verta.z, vertb.x, vertb.y, vertb.z);
      if (distance  < connectionDistance) {
        line(verta.x, verta.y, verta.z, vertb.x, vertb.y, vertb.z);
      }
    }
  }
}