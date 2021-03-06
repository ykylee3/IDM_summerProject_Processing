//Referencing Particles from The Nature of Code - Daniel Shiffman
// class Spore extends the class "VerletParticle2D"

class Particle extends VerletParticle2D {

  float r;

  Particle (Vec2D loc) {
    super(loc);
    r = 1.5;
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior(this, r*random(5), -1));
  }

  void display () {
    pushMatrix();
    //fill (255, 0, 0);
    //translate(x, y);
    //sphere(r*2);
    shape(six, x, y);
    popMatrix();
  }
}