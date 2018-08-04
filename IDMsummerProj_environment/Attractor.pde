//Attractor class from The Nature of Code - Daniel Shiffman

class Attractor extends VerletParticle2D {

  float r;

  Attractor (Vec2D loc) {
    super (loc);
    r = 10;
    //physics.addParticle(this);
    //physics.addBehavior(new AttractionBehavior(this, 80, 0.1f));
  }

  void display () {
    noFill();
    ellipse (x, y, r*2, r*2);
  }
}
