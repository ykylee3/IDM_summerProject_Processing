//Attractor class from The Nature of Code - Daniel Shiffman

class Attractor extends VerletParticle2D {
  float r;
  ParticleBehavior2D myBehavior;
  
  Attractor (Vec2D loc) {
    super (loc);
    r = 10;
    physics.addParticle(this);
    myBehavior = new AttractionBehavior(this, 180, 0.1f);
    physics.addBehavior(myBehavior);
  }

  void display () {
    fill(244);
    ellipse (x, y, r*2, r*2);
  }
  
  void remove () {
     physics.removeBehavior(myBehavior); 
     physics.removeParticle(this);
  }
}