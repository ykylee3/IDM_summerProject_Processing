import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

Vec2D[] positionList = new Vec2D[100];

ArrayList<Particle> particles;
Attractor[] attractors = new Attractor[200];

VerletPhysics2D physics;

void setup () {
  // General Setup
  size (1024, 768, P3D);
  //fullScreen(P3D);
  
  // Particles Setup
  physics = new VerletPhysics2D ();
  physics.setDrag (0.01);
  physics.setWorldBounds(new Rect(0, 0, width, height));
  //physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.01f)));
  particles = new ArrayList<Particle>();
  for (int i = 0; i < 300; i++) {
    particles.add(new Particle(new Vec2D(random(width),random(height))));
  }

  //Kinect Setup
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.init();
}


void draw () {
  background (255);  
  physics.update ();
  
  //display particles
  for (Particle p: particles) {
    p.display();
  }
  //draw kinect
  drawKinect();
}
