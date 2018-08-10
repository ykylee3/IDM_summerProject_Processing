//Referencing Particles from The Nature of Code - Daniel Shiffman
// class Spore extends the class "VerletParticle2D"
void AttractorPos(int nParticles) {
  //Define the size and fill the vertices array
  attractorPos = new PVector[nParticles];
  //attractorCache = new int[nParticles];

  for (int i = 0; i<attractorPos.length; i++) {
    //Scan all the points
    //Generate the center of the points
    //as a random point on the sphere

    //Take the random point from
    //cube [-1,1]x[-1,1]x[-1,1]  to form the sphere
    PVector center = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    center.normalize(); //Normalize vector's length to 1

    center.mult(Rad-(buffer/2));  //Now the center vector has length 'Rad'

    //Set the randomly selected vertices
    //as the center of the spheres
    attractorPos[i] = center;

    particles.add(new Particle(new Vec2D(attractorPos[i].x, attractorPos[i].y)));

    println(i + ": " + attractorPos[i]);
  }
}

void drawParticles() {
  for (int i = 0; i<attractorPos.length; i++) {
    pushMatrix();
    fill (0, 255, 0);
    translate(attractorPos[i].x, attractorPos[i].y, attractorPos[i].z);
    sphere(8);
    popMatrix();
  }
}

class Particle extends VerletParticle2D {

  float r;

  Particle (Vec2D loc) {
    super(loc);
    r = 4;
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior(this, r*3, -1));
  }


  void display () {
    pushMatrix();
    fill (255, 0, 0);
    translate(x, y);
    sphere(r*2);
    //shape(helix, x, y);//test with helix shape as the particles
    popMatrix();
  }
}