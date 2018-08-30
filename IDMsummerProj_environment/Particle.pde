//Referencing Particles from The Nature of Code - Daniel Shiffman
// class Spore extends the class "VerletParticle2D"

// create a box from (-100,-100,-100) -> (100,100,100)
ParticleConstraint2D pc = new CircularConstraint(new Vec2D(0, 0), (Rad*0.2));
ParticleConstraint2D myConstraint = new myConstraint();

//ParticleConstraint2D minX = new MinConstraint(X, -Rad);

class myConstraint implements ParticleConstraint2D {
  public void apply(VerletParticle2D p) {
    if (p.x > Rad*1.7 || p.x < -Rad*1.7) {
      //p.x = random((-Rad/2), (Rad/2));
      p.scale(p.getInverted());
    }
    if (p.y > Rad*1.7 || p.y < -Rad*1.7) {
      p.scale(p.getInverted());
      //p.y = random((-Rad/2), (Rad/2));
    }
  }
}

class Particle extends VerletParticle2D {

  float r;

  Particle (Vec2D loc) {
    super(loc);
    r = 1.5;
    //this.addConstraint(pc);
    this.addConstraint(myConstraint);
    this.applyConstraints();
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