void sphereMeshSetup() {
  //Define the size and fill the vertices array
  vertices = new PVector[nPoints];
  vRef = new PVector[nPoints];

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
    vRef[i] = vertices[i];
  }
}

void drawSphereMesh() {
  PVector velocity = new PVector(0, 0, 0);
  if (millis() > now + meshBeatRate) {
    for (int i = 0; i<vertices.length; i++) {
      PVector acceleration = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
      velocity.add(acceleration);
      vertices[i].add(velocity);
      println("updateMesh");
    }
    now = millis();
  }

  //Draw the mesh (vertices) of the sphere
  beginShape(POINTS);
  for (int i = 0; i<vertices.length; i++) {
    vertex(vertices[i].x, vertices[i].y, vertices[i].z);
  }
  endShape();

  float nlines=0;

  //draw lines between near points,
  //lines are created as 3D quads to reflect the lights
  for (int a = 0; a<vertices.length; a++) {
    PVector verta = vertices[a];
    for (int b = a + 1; b<vertices.length; b++) {
      PVector vertb = vertices[b];
      float distance = dist(verta.x, verta.y, verta.z, vertb.x, vertb.y, vertb.z);
      if (distance  < connectionDistance) {
        nlines+=1;        
        stroke(255);
        beginShape();
        vertex(verta.x, verta.y, verta.z);
        vertex(verta.x+1, verta.y+1, verta.z+1);
        vertex(vertb.x, vertb.y, vertb.z);
        vertex(vertb.x+1, vertb.y+1, vertb.z+1);
        endShape(CLOSE);
      }
    }
  }
  //for (int i = 0; i<vertices.length; i++) {
  //  translate(vertices[i].x, vertices[i].y, vertices[i].z);
  //  stroke(130*noise(nlines/1), 130-130*noise(nlines/1), 130);
  //  ellipse(3, 3, 3, 3);
  //  filter(BLUR,5);
  //}
}