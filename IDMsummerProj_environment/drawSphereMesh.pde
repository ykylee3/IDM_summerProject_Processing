void sphereMeshSetup() {
  //Define the size and fill the vertices array
  vertices = new PVector[nPoints];  //the 'from' position
  vRef = new PVector[nPoints]; //the 'to' position
  vReset = new PVector[nPoints]; //the 'to' position

  for (int i = 0; i<vertices.length; i++) {
    //Scan all the points
    //Generate the center of the points
    //as a random point on the sphere

    //Take the random point from
    //cube [-1,1]x[-1,1]x[-1,1]  to form the sphere
    PVector center = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    center.normalize(); //Normalize vector's length to 1
    center.mult(Rad);  //Now the center vector has length 'Rad'

    vertices[i] = center;
    vReset[i] = vertices[i];
    vRef[i] = vertices[i];
  }
}

void drawSphereMesh() {
  PVector velocity = new PVector(0, 0, 0);
  PVector centroid = new PVector(0, 0, 0);

  //changes the position of the vertices every cetain seconds
  if (millis() > now + meshBeatRate) {
    for (int i = 0; i<vRef.length; i++) {
      PVector accelerate = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
      velocity.add(accelerate);
      vRef[i].add(velocity);
    }
    velocity.set(centroid);
    now = millis();
  }

  for (int i = 0; i<nPoints; i++) {
    if (vRef[i].dist(centroid)>=Rad+50 || vRef[i].dist(centroid)<=Rad-50) {
      vRef[i] = PVector.lerp(vRef[i], vReset[i], 0.8);
    }

    vertices[i] = PVector.lerp(vertices[i], vRef[i], 0.1);

    ////Draw the mesh (vertices) of the sphere
    //beginShape(POINT);
    //vertex(vertices[i].x, vertices[i].y, vertices[i].z);
    //endShape();
    //reset vertices to initial position if it is offsetting too much
  }

  //draw lines between near points,
  //lines are created as 3D quads to reflect the lights
  for (int a = 0; a<vertices.length; a++) {
    PVector verta = vertices[a];
    for (int b = a + 1; b<vertices.length; b++) {
      PVector vertb = vertices[b];
      float distance = dist(verta.x, verta.y, verta.z, vertb.x, vertb.y, vertb.z);
      if (distance  < connectionDistance) {
        //nlines+=1;
        stroke(255);
        fill(255, 255, 255);
        beginShape();
        vertex(verta.x, verta.y, verta.z);
        vertex(verta.x+1, verta.y+1, verta.z+1);
        vertex(vertb.x, vertb.y, vertb.z);
        vertex(vertb.x+1, vertb.y+1, vertb.z+1);
        endShape(CLOSE);
      }
    }
  }
}