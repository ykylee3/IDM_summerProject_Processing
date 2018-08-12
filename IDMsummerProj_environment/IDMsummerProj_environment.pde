
import ddf.minim.*;
import peasy.PeasyCam;

//Toxiclibs and Kinect libs

import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

import KinectPV2.KJoint;
import KinectPV2.*;

PeasyCam cam;
Minim minim;
AudioPlayer ambient;

//kinect
KinectPV2 kinect;
//attractor
ArrayList<Particle> particles;
Attractor[][] attractors = new Attractor[6][200];

VerletPhysics2D physics;

PShape helix;
PShape virus;
PShape DNA;
PShape threeobjects;
PShape six;
PShape alien;
PShape starcloud;

//PShader neon;

PVector[] vertices;
PVector[] vRef;
PVector[] elementPos;
PVector[] vReset;
PVector[] attractorPos;

int[] elementCache;
int[] attractorCache;

int nPoints = 1500;  //The number of vertices to be shown
int nElements = 50;  //The number of floating elements
int nBirdObj = 3;    //Total number of varaieties for bird elements
int nFloatObj = 3;   //Total number of varaieties for floating elements

float Rad = 1000; //The to-be-formed sphere's (the 'dome' container) radius
float buffer = 200; //distance between the shpere mesh and the floating elements
float connectionDistance = 140; //Threshold parameter of distance to connect
float startTime;
float now = millis();
float meshBeatRate = 4300;

void setup() {
  size(1024, 768, P3D);
  //fullScreen(P3D);
  sphereDetail(8);

  cam = new PeasyCam(this, -Rad); // init camera distance at the center of the sphere
  minim = new Minim(this);
  ambient = minim.loadFile("JupiterSound2001.mp3");
  helix = loadShape("helix.obj");
  virus = loadShape("virus.obj");
  DNA = loadShape("DNA.obj");
  threeobjects = loadShape("threeobjects.obj");
  six = loadShape("six.obj");
  alien = loadShape("alien.obj");
  //starcloud = loadShape("starcloud.obj");

  //neon = loadShader("neon.glsl");

  startTime = millis();   //Get time in seconds

  //add physics to the world (toxiclibs)
  physics = new VerletPhysics2D ();
  physics.setDrag (0.01);
  //physics.setWorldBounds(new Rect(0, 0, width, height));//do we need to set a world bound?
  //physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.01f)));
  particles = new ArrayList<Particle>();
  AttractorPos(400);

  initBirds(350);
  sphereMeshSetup();
  createMesh4Elements();
  plantSeed(); //must be called after createMesh4Elements();

  ambient.play();
  ambient.loop();

  //Kinect Setup
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.init();
}

void draw() {
  background(10);
  lightFalloff(1, 0.3, 0.4); 
  lightSpecular(255, 255, 255);
  //shininess(0.5);
  //specular(255, 255, 255); 

  //reset coordinates
  camera();

  //set coordinate/direction of spotlight to follow camera
  pushMatrix();

  //set ambient DNA
  ambientLight(255, 255, 255);

  //set rotation attributes for the directional light
  customRotate(0, 0, 0, 0);
  directionalLight(255, 255, 255, 0, 0, -1);

  popMatrix();

  //manually set start the peasy camr
  cam.feed();

  //xyz axis for debugging
  stroke(255, 0, 0);
  line(-300, 0, 0, 300, 0, 0); //x
  stroke(0, 255, 0);
  line(0, -300, 0, 0, 300, 0); //y
  stroke(0, 0, 255);
  line(0, 0, -300, 0, 0, 300); //z

  pushMatrix();
  customRotate(0.05, -0.5, -0.2, 0.1);
  drawSphereMesh();
  popMatrix();

  pushMatrix();
  customRotate(0.25, 0.3, -1, -0.5);
  placeElements();
  popMatrix();

  pushMatrix();
  //camera
  fill(255, 255, 255);
  noStroke();
  customRotate(0, 0, 0, 0);
  //translate(0, 0, -100);
  drawParticles();
  sphere(20);
  popMatrix();

  physics.update ();
  //display particles
  for (Particle p : particles) {
    pushMatrix();
    p.display();
    popMatrix();
  }

  //draw kinect
  drawKinect();

  translate(-width/2, -height/2, -Rad);
  drawBirds();
}

//void mouseReleased() {
//  println("rotation");  
//  println(cam.getRotations());  
//  println("position");  
//  println(cam.getPosition());
//}

//MOOC ARDUINO
void keyPressed(){
  switch(key){
  case 49:
  inputSignal(1);
  break;

  case 50:
  inputSignal(2);
  break;

  case 51:
  inputSignal(3);
  break;

  case 52:
  inputSignal(4);
  break;
  }
  //inputSignal(key);

}

void inputSignal(int globe) {
  //if 1 or 2
  if (globe == 1 || globe == 2){
    int randomNum = int(random(particles.size())); 
    println(randomNum, particles.size());
    particles.remove(randomNum);
  }
  //if 3 or 4
  else if (globe == 3 || globe == 4){
    particles.add(new Particle(new Vec2D(random(width), random(height))));
    println(particles.size());
  }

  println("globe " + globe + " pressed, particle created");
}