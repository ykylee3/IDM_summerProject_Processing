//Particles from The Nature of Code - Daniel Shiffman

// class Spore extends the class "VerletParticle2D"
class Particle extends VerletParticle2D {

  float r;

  
  Particle (Vec2D loc) {
    super(loc);
    r = 8;
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior(this, r*3, -1));
  }
  

  void display () {
    fill (127);
    //stroke (0);
    //strokeWeight(2);
    //ellipse (x, y, r*2, r*2);
    shape(helix, x, y);
  }
}
