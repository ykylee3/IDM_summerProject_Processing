import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import peasy.PeasyCam; 
import toxi.geom.*; 
import toxi.physics2d.*; 
import toxi.physics2d.behaviors.*; 
import KinectPV2.KJoint; 
import KinectPV2.*; 
import processing.serial.*; 
import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class IDMsummerProj_environment extends PApplet {

//import java.util.Random; //<>//




//Toxiclibs and Kinect libs







//serial lib



//Random r = new Random();

PeasyCam cam;
Minim minim;
AudioPlayer ambient;
AudioPlayer globeEffect;
AudioPlayer kinectEffect;

Movie galaxy;
Movie creation1;
Movie creation2;
Movie destruction1;
Movie destruction2;

//arduino communication
Serial myPort;  // Create object from Serial class

//kinect
KinectPV2 kinect;

//main particles arraylist
ArrayList<Particle> particles;

//particles_remove arraylist (used for removing particles to the main particles array)
ArrayList<Integer> particles_remove = new ArrayList<Integer>();

//attractor
Attractor[][] attractors = new Attractor[6][1800];
VerletPhysics2D physics;

//shapes
PShape alien;
PShape helix;
PShape virus;
PShape DNA;
PShape threeobjects;
PShape six;
PShape bowl;
PShape rock5;
PShape earth;
PShape jupiter;
PShape sharpsphere;

PVector[] vertices;
PVector[] vRef;
PVector[] elementPos;
PVector[] vReset;

int[] elementCache;

int nPoints = 1500;  //The number of vertices to be shown
int nElements = 50;  //The number of floating elements
int nFloatObj = 4;   //Total number of varaieties for floating elements

float Rad = 1000; //The to-be-formed sphere's (the 'dome' container) radius
float buffer = 200; //distance between the shpere mesh and the floating elements
float connectionDistance = 140; //Threshold parameter of distance to connect
float startTime;
float now = millis();
float meshBeatRate = 4300;

//kinect threshold 
int maxD = 2000;
int minD = 1000;

//coordinates for the particles to be created (through plasma globe interactions)
float cdX;
float cdY;
float cdZ;
int cdInit = 7;

boolean playCreation1 = false;
boolean playCreation2 = false;
boolean playDestruction1 = false;
boolean playDestruction2 = false;
boolean destroy = false;
boolean drawSkeleton = false;

int getUsers;
int numUsers = 0;

////initializing variables for random voice overs
//float VOnow;
//float time;
//int[] number = new int[13];
//int count=0;
//int num;
//int pause = 8000;
//int tracksPlayed;
//int finalTrack = -1;
//boolean result = false;
//boolean repeat = false;
//boolean playVO = false;
//AudioPlayer sequence0, sequence1, sequence2, sequence3, sequence4, sequence5, sequence6, 
//  sequence7, sequence8, sequence9, sequence10, sequence11, sequence12;

public void setup() {
  
  //size(1280, 720, P3D);

  //for debuggings
  sphereDetail(8);

  minim = new Minim(this);

  ////loads voice over files
  //sequence0 = minim.loadFile("1_3.mp3");
  //sequence1 = minim.loadFile("2_3.mp3");
  //sequence2 = minim.loadFile("3_3.mp3");
  //sequence3 = minim.loadFile("4_3.mp3");
  //sequence4 = minim.loadFile("5_3.mp3");
  //sequence5 = minim.loadFile("6_3.mp3");
  //sequence6 = minim.loadFile("7_3.mp3");
  //sequence7 = minim.loadFile("8_3.mp3");
  //sequence8 = minim.loadFile("9_3.mp3");
  //sequence9 = minim.loadFile("10_3.mp3");
  //sequence10 = minim.loadFile("11_3.mp3");
  //sequence11 = minim.loadFile("12_3.mp3");
  //sequence12 = minim.loadFile("13_3.mp3");

  ////Creates a playlist of voice overs
  //setOrder();

  cam = new PeasyCam(this, -Rad); // init camera distance at the center of the sphere

  minim = new Minim(this);
  ambient = minim.loadFile("ambience_combine.mp3");
  globeEffect = minim.loadFile("globe_2_new.mp3");
  kinectEffect = minim.loadFile("kinect_2_new.mp3");

  alien = loadShape("alien.obj");
  helix = loadShape("helix.obj");
  virus = loadShape("virus.obj");
  DNA = loadShape("DNA.obj");
  threeobjects = loadShape("threeobjects.obj");
  six = loadShape("six.obj");
  bowl = loadShape("bowl.obj");
  rock5 = loadShape("rock5.obj");
  earth = loadShape("earth2.obj");
  jupiter = loadShape("jupiter.obj");
  sharpsphere = loadShape("sharpsphere.obj");

  //galaxy = new Movie(this, "g2.mp4 ");
  galaxy = new Movie(this, "galaxy3.mp4 ");
  galaxy.loop();
  creation1 = new Movie(this, "creationwithsound_2.mp4 ");
  creation2 = new Movie(this, "creationwithaudio.mp4 ");
  creation1.loop();
  creation1.jump(creation1.duration()-0.1f);
  creation1.pause();
  creation2.loop();
  creation2.jump(creation2.duration()-0.1f);
  creation2.pause();
  destruction1 = new Movie(this, "destruction_2.mp4");
  destruction2 = new Movie(this, "destruction_3.mp4");
  destruction1.loop();
  destruction1.jump(destruction1.duration()-0.1f);
  destruction1.pause();
  destruction2.loop();
  destruction2.jump(destruction2.duration()-0.1f);
  destruction2.pause();

  startTime = millis();   //Get time in seconds

  //add physics to the world (toxiclibs)
  physics = new VerletPhysics2D ();
  physics.setDrag ( 0.01f );
  physics.setWorldBounds(new Rect(-(Rad+buffer)/2, -(Rad+buffer)/2, (Rad+buffer)*2, (Rad+buffer)*2));//do we need to set a world bound? YES:)
  //physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.01f)));
  particles = new ArrayList<Particle>();
  for (int i=0; i<attractors[0].length; i++) {
    particles.add(new Particle(new Vec2D(random(Rad*2), random(Rad*2))));
  }

  initBirds(250);
  initPreds(40);
  sphereMeshSetup();
  createMesh4Elements();
  plantSeed(); //plantseeds for Floating_elements, must be called after createMesh4Elements();

  //initialize creation/destruction array
  addCD();

  ambient.play();
  ambient.loop();

  //Kinect Setup
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.enableDepthImg(true);
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.enableSkeleton3DMap(true);
  //kinect.enablePointCloud(true);
  kinect.init();

  getUsers = PApplet.parseInt( kinect.getNumOfUsers() );

  //kinect.setLowThresholdPC(minD);
  //kinect.setHighThresholdPC(maxD);

  //serial communication
  myPort = new Serial(this, "COM4", 9600);
  delay(1000);
  myPort.bufferUntil( 10 );

  //Will run before draw, but always before draw runs, middle way among draw and setup
  registerMethod("pre", this);
}

//method always executed before the draw() method (being used to update the physics engine and avoid thread issues)
public void pre() {
  if (destroy) {
    destroy();
    destroy = false;
  }
}

public void draw() {
  background(0);

  //reset coordinates
  camera();

  //manually set start the peasy cam
  cam.feed();

  //xyz axis for debugging
  stroke(255, 0, 0);
  line(-300, 0, 0, 300, 0, 0); //x
  stroke(0, 255, 0);
  line(0, -300, 0, 0, 300, 0); //y
  stroke(0, 0, 255);
  line(0, 0, -300, 0, 0, 300); //z

  //animations to be placed before initializing the light
  //to avoid being affected with the specular settings
  pushMatrix();
  //draws the galaxy animation on the left screen
  customRotate(0, 0, 0, 0);
  scale(0.3f, 0.3f, 0.3f);
  translate(-(Rad*3.5f), -(Rad*1.2f), -Rad*0.8f);
  rotateY(radians(60));
  rotateX(-radians(20));
  image(galaxy, 0, 0);
  popMatrix();

  //check if cd particles are less than 2
  //and adds new batch of particles
  if (cd.size()<=2) {
    addCD();
    println("new batch of particles");
  }

  pushMatrix();
  //draws the creation1 animation (on the left)
  rotateY(radians(30));
  translate(-Rad*2, -(Rad*0.3f), -Rad*1.5f);
  rotateY(radians(40));
  image(creation1, 0, 0);
  if (creation1.time() == creation1.duration()-3) {
    //set coordinates and calls the function to create particles
    cdX = -Rad;
    cdY = -(Rad*0.1f);
    cdZ = -(Rad*0.6f);
    cd.add(new CD(new PVector(cdX, cdY, cdZ)));
  }
  if (creation1.time() >= creation1.duration()-0.2f) {
    //stops the video when a play is complete
    creation1.pause();
    creation1.jump(0); //rewind the video for the next play event
    playCreation1 = false;
  }
  popMatrix();

  pushMatrix();
  //draws the creation2 animation (on the middle-right)
  scale(1.3f, 1.3f, 1.3f);
  rotateY(-radians(20));
  translate((-Rad), -(Rad), -(Rad*2));
  rotateX(-radians(20));
  image(creation2, 0, 0);
  if (creation2.time() == creation2.duration()-1) {
    //set coordinates and calls the function to create particles
    cdX = Rad*0.3f;
    cdY = -(Rad*0.6f);
    cdZ = -(Rad*1.5f);
    cd.add(new CD(new PVector(cdX, cdY, cdZ)));
  }
  if (creation2.time() >= creation2.duration()-0.2f) {
    //stops the video when a play is complete
    creation2.pause();
    creation2.jump(0); //rewind the video for the next play event
    playCreation2 = false;
  }
  popMatrix();

  pushMatrix();
  //draws the destruction1 animation (on the right)
  translate((Rad+buffer*2.5f), -(Rad*0.8f), -Rad*1.5f);
  rotateY(-radians(90));
  rotateX(radians(10));
  image(destruction1, 0, 0);
  if (destruction1.time() >= destruction1.duration()-0.2f) {
    //stops the video when a play is complete
    destruction1.pause();
    destruction1.jump(0); //rewind the video for the next play event
    destroy = true;
    playDestruction1 = false;
  }
  popMatrix();

  pushMatrix();
  //draws the destruction2 animation (on the middle-left)
  translate(-(Rad*1.5f), -(Rad*0.5f), -(Rad+buffer)*1.5f);
  rotateY(radians(20));
  image(destruction2, 0, 0);
  if (destruction2.time() >= destruction2.duration()-0.2f) {
    //stops the video when a play is complete
    destruction2.pause();
    destruction2.jump(0); //rewind the video for the next play event
    destroy = true;
    playDestruction2 = false;
  }
  popMatrix();

  lightFalloff(1, 0.3f, 0.4f); 
  lightSpecular(255, 255, 255);

  //set coordinate/direction of spotlight to follow camera
  pushMatrix();
  //set ambient 
  ambientLight(255, 255, 255);
  //set rotation attributes for the directional light
  customRotate(0, 0, 0, 0);
  directionalLight(255, 255, 255, 0, 0, -1);
  popMatrix();

  pushMatrix();
  //draws the earth model
  rotate(radians(23.44f));
  translate((Rad*0.8f), -(Rad*0.5f), -(Rad+buffer));
  customRotate(0.8f, 0, 1, 0);
  shape(earth, 0, 0);
  popMatrix();

  pushMatrix();
  //draws the jupiter model
  rotate(radians(26.73f));
  translate(Rad+buffer/2, -(Rad*0.4f), -buffer*2.5f);
  customRotate(1, 0, 1, 0);
  scale(0.4f, 0.5f, 0.4f);
  shape(jupiter, 0, 0);
  popMatrix();

  pushMatrix();
  customRotate(0.05f, -0.5f, -0.2f, 0.1f);
  drawSphereMesh();
  popMatrix();

  pushMatrix();
  //draws the floating elements
  customRotate(0.25f, 0.3f, -1, -0.5f);
  placeElements();
  popMatrix();

  pushMatrix();
  //updating physics of particles (kinect interaction)
  physics.update ();
  popMatrix();

  pushMatrix();
  //display particles
  translate(-Rad, -Rad, -(Rad*0.75f));
  for (Particle p : particles) {
    pushMatrix();
    p.display();
    popMatrix();
  } 
  //to get the number of users and for each new user play the sound effect
  getUsers = PApplet.parseInt( kinect.getNumOfUsers() );
  if ( getUsers > numUsers ) {
    kinectEffect.play();
    kinectEffect.rewind();
    println("numUsers var value is " + numUsers + " and the value of getUsers is " + getUsers);
  }
  numUsers = getUsers;
  println("users: " + numUsers + " get users: " + getUsers);
  //draw kinect
  drawKinect();
  popMatrix();

  pushMatrix();
  drawCD();
  popMatrix();

  translate(-width/2, -height/2, -Rad);
  drawBirds();
  drawPreds();
}

//if (playVO) {
//  //random voice overs
//  playTrack();
//  result = listComplete(tracksPlayed);
//}

//reads new frame of the movie 
public void movieEvent(Movie m) {
  m.read();
}

//serial event from arduino
public void serialEvent( Serial p ) {
  String val = p.readString();
  if ( val != null ) {
    int number = PApplet.parseInt( trim( val ) ); //converting string to int
    println( "plasma globe " + number );
    inputSignal( number );
  }
}

//MOOC ARDUINO
public void keyPressed() {
  switch( key ) {
  case 49:
    inputSignal( 1 );
    particles_remove.add( 1 );
    if (!playCreation1) {
      creation1.play();
      playCreation1 = true;
    }
    break;

  case 50:
    inputSignal( 2 );
    particles_remove.add( 1 );
    if (!playCreation2) {
      creation2.play();
      playCreation2 = true;
    }
    break;

  case 51:
    inputSignal( 3 );
    if (!playDestruction1) {
      destruction1.play();
      playDestruction1 = true;
    }
    break;

  case 52:
    inputSignal( 4 );
    if (!playDestruction2) {
      destruction2.play();
      playDestruction2 = true;
    }
    break;

    //case 32:
    //  if (!playVO) {
    //    playVO = true;
    //  } else {
    //    playVO=false;
    //  }
    //  break;
  }
}

public void inputSignal( int globe ) {
  //if  (globe == 1) {
  //  particles_remove.add( 1 );
  //  if (!playCreation1) {
  //    creation1.play();
  //    playCreation1 = true;
  //  }
  //}
  if  (globe == 2) {
    int rndN = PApplet.parseInt(random(1));
    switch(rndN) {
    case 0:
      particles_remove.add( 1 );
      if (!playCreation2) {
        creation2.play();
        playCreation2 = true;
      }
      break;

    case 1:
      if (!playDestruction2) {
        destruction2.play();
        playDestruction2 = true;
      }
      break;
    }
  }

  if (globe == 3) {
    int rndN = PApplet.parseInt(random(1));
    switch(rndN) {
    case 0:
      particles_remove.add( 1 );
      if (!playCreation1) {
        creation1.play();
        playCreation1 = true;
      }
      break;

    case 1:
      if (!playDestruction1) {
        destruction1.play();
        playDestruction1 = true;
      }
      break;
    }
  }
  //if (globe == 4) {
  //  if (!playDestruction2) {
  //    destruction2.play();
  //    playDestruction2 = true;
  //  }
  //}
}
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

  public void display () {
    fill(244);
    ellipse (x, y, r*2, r*2);
  }
  
  public void remove () {
     physics.removeBehavior(myBehavior); 
     physics.removeParticle(this);
  }
}
ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList<Predators> pred = new ArrayList<Predators>();
int offset = 0; //off set value to allow the 'bird'to fly throught the sphere

public void initBirds(int n) {
  //resize the ArrayList
  for (int i = 0; i<n; i++) {
    birds.add(new Bird());
  }
}

public void initPreds(int n) {
  //resize the ArrayList
  for (int i = 0; i<n; i++) {
    pred.add(new Predators());
  }
}

public void drawBirds() {
  for (Bird b : birds) {
    b.render();
    b.step();
  }
}

public void drawPreds() {
  for (Predators p : pred) {
    p.render();
    p.step();
  }
}

//create the class Bird
class Bird {
  PVector position = new PVector(random(-(Rad+offset), Rad*2+offset), random(-offset, Rad*2+offset), random(-(offset), Rad+offset));
  PVector direction = new PVector (random(-1, 1), random(-1, 1)); //speed

  public void render() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    customRotate(0.5f, 0.4f, 0.4f, 0);
    shape(alien, 0, 0);
    popMatrix();
  }

  public void step() {
    //find closest Bird
    Bird closestBird = null;
    float closestDistance = 9000;
    for (Bird b : birds) {
      if (this != b) {
        float distance = position.dist(b.position);
        if (distance < closestDistance) {
          closestDistance = distance;
          closestBird = b;
        }
      }
    }

    //average directions so they converge to the same direction
    direction = new PVector((direction.x+closestBird.direction.x)/2, (direction.y+closestBird.direction.y)/2, (direction.z+closestBird.direction.z)/2);

    position.add(direction);

    //keep the birds on the screen
    if (position.x < offset) {
      position.x = width-offset;
    }
    if (position.x > width-offset) {
      position.x = offset;
    }
    if (position.y < offset) {
      position.y = height-offset;
    }
    if (position.y > height-offset) {
      position.y = offset;
    }
    if (position.z < offset) {
      position.z = Rad*2-offset;
    }
    if (position.z > Rad*2-offset) {
      position.z =offset;
    }
  }
}

class Predators extends Bird {
  PVector position = new PVector(random(-(Rad+offset), Rad*2+offset), random(-offset, Rad*2+offset), random(-(offset), Rad+offset));
  PVector Bdirection = new PVector (random(-1, 1), random(-1, 1)); //speed of chasing after birds
  PVector Pdirection = new PVector (random(-1, 1), random(-1, 1)); //speed of repelling away from other predators

  public void render() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    customRotate(0.5f, 0.4f, 0.4f, 0);
    shape(helix, 0, 0);
    popMatrix();
  }

  public void step() {
    //find closest predator
    Predators closestPred = null;
    Bird closestBird = null;
    float closestDistanceP = 5000;
    float closestDistanceB = 7000;
    for (Predators p : pred) {
      if (this != p) {
        float distance = position.dist(p.position);
        if (distance < closestDistanceP) {
          closestDistanceP = distance;
          closestPred = p;
        }
      }
      for (Bird b : birds) {
        float distance = position.dist(b.position);
        if (distance < closestDistanceB) {
          closestDistanceB = distance;
          closestBird = b;
        }
      }
    }

    Bdirection = new PVector((direction.x+closestBird.direction.x)/2, (direction.y+closestBird.direction.y)/2, (direction.z+closestBird.direction.z)/2);
    position.add(Bdirection);
    //average directions so they converge to the same direction
    Pdirection = new PVector((direction.x+closestPred.direction.x)/2, (direction.y+closestPred.direction.y)/2, (direction.z+closestPred.direction.z)/2);
    position.add(Pdirection);

    //keep the predators on the screen
    if (position.x < offset) {
      position.x = width-offset;
    }
    if (position.x > width-offset) {
      position.x = offset;
    }
    if (position.y < offset) {
      position.y = height-offset;
    }
    if (position.y > height-offset) {
      position.y = offset;
    }
    if (position.z < offset) {
      position.z = Rad*2-offset;
    }
    if (position.z > Rad*2-offset) {
      position.z =offset;
    }
  }
}
public void createMesh4Elements() {
  //Define the size and fill the vertices array
  elementPos = new PVector[nElements];
  elementCache = new int[nElements];

  for (int i = 0; i<elementPos.length; i++) {
    //Scan all the points
    //Generate the center of the points
    //as a random point on the sphere

    //Take the random point from
    //cube [-1,1]x[-1,1]x[-1,1]  to form the sphere
    PVector center = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    center.normalize(); //Normalize vector's length to 1

    center.mult(Rad-buffer);  //Now the center vector has length 'Rad'

    //Set the randomly selected vertices
    //as the center of the spheres
    elementPos[i] = center;
  }
}

public void plantSeed() {
  //this function is called once in setup();
  //it assigns an obj from the varieties to each element positions
  for (int i = 0; i<elementPos.length; i++) {
    int seed = randomSeeds(nFloatObj);
    elementCache[i] = seed;
  }
}

public void placeElements() {
  for (int i = 0; i<elementPos.length; i++) {
    int seed = elementCache[i];
    pushMatrix();
    translate(elementPos[i].x, elementPos[i].y, elementPos[i].z);

    //draws the objs based on the assigned attribute
    switch(seed) {
    case 0:
      //set value of self-rotation of the elements
      pushMatrix();
      customRotate(0.8f, 0.3f, -0.5f, 0.4f);
      scale(8, 8, 8);
      shape(virus, 0, 0);
      popMatrix();
      break;

    case 1:
      //set value of self-rotation of the elements
      pushMatrix();
      customRotate(2, 0.1f, 0.5f, 0.2f);
      scale(5, 5, 5);
      shape(DNA, 0, 0);
      popMatrix();
      break;

    case 2:
      //set value of self-rotation of the elements
      pushMatrix();
      customRotate(1, 0.5f, 0.2f, 0.3f);
      scale(8, 8, 8);
      shape(threeobjects, 0, 0);
      popMatrix();
      break;

    case 3:
      //set value of self-rotation of the elements
      pushMatrix();
      customRotate(0.8f, 0.7f, 0.6f, 0.7f);
      scale(4, 4, 4);
      shape(rock5, 0, 0);
      popMatrix();
      break;
    }
    //sphere(8);
    popMatrix();
  }
}

//return a middle point between two joints
public float[] getMiddlePoint(float aX, float aY, float bX, float bY) {
  float[] ret = new float[2];
  ret[0] = (aX + bX) / 2;
  ret[1] = (aY + bY) / 2;
  return ret;
}

//return n points between two joints
public float[][] getMiddlePoints(float aX, float aY, float bX, float bY, int points) {
  float[][] ret = new float[points][2];

  float segX = (aX - bX) / (points + 1);
  float segY = (aY - bY) / (points + 1);

  for (int i = 0; i < points; i++) {
    ret[i][0] =  bX + (segX * (i + 1));
    ret[i][1] =  bY + (segY * (i + 1));
  }
  return ret;
}  

//Create our custom joints
//n points between equidistant coordinates of 2 points
public ArrayList<float[]> getMyJoints(KJoint[] joints) {
  ArrayList<float[]> ret = new ArrayList<float[]>();

  int[][] combinations = {

    //Neck
    { KinectPV2.JointType_Head, KinectPV2.JointType_Neck, 2 }, 

    //Shoulder
    { KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight, 1 }, 
    { KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft, 1 }, 

    //Right arm
    { KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight, 4 }, 
    { KinectPV2.JointType_ElbowRight, KinectPV2.JointType_ShoulderRight, 4 }, 

    //Left arm
    { KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft, 4 }, 
    { KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_ShoulderLeft, 4 }, 

    //Spine
    { KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase, 2 }, 
    { KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid, 2 }, 

    { KinectPV2.JointType_SpineMid, KinectPV2.JointType_HipLeft, 2 }, 
    { KinectPV2.JointType_SpineMid, KinectPV2.JointType_HipRight, 2 }, 

    { KinectPV2.JointType_SpineMid, KinectPV2.JointType_ShoulderRight, 2 }, 
    { KinectPV2.JointType_SpineMid, KinectPV2.JointType_ShoulderLeft, 2 }, 

    //Right Leg
    { KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight, 6 }, 
    { KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight, 6 }, 

    // Left Leg
    { KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft, 6 }, 
    { KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft, 6 }, 

  };

  //for each combination, gets x and y values
  for (int i = 0; i < combinations.length; i++) {
    float aX = joints[combinations[i][0]].getX();
    float aY = joints[combinations[i][0]].getY();
    float bX = joints[combinations[i][1]].getX();
    float bY = joints[combinations[i][1]].getY();
    int nPoints = combinations[i][2];

    //add joint to array
    ret.add(getMiddlePoint(aX, aY, bX, bY));

    float[][] mp = getMiddlePoints(aX, aY, bX, bY, nPoints);

    //for each n points within the combinations 
    for (int m = 0; m < mp.length; m++) {
      //adds joint to array
      ret.add(mp[m]);
      //println(mp[m][0], mp[m][1]);
    }
  }
  return ret;
}

//adapted from KinectPV2
public void drawKinect() {

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  ArrayList<KSkeleton> skeletonArray3D =  kinect.getSkeleton3d();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    KSkeleton skeleton3D = (KSkeleton) skeletonArray3D.get(i);
    if (skeleton.isTracked() ) {
      KJoint[] joints = skeleton.getJoints();
      KJoint[] joints3D = skeleton3D.getJoints();

      ArrayList<float[]> myJoints = getMyJoints(joints);

      float skeletonDistance = joints3D[KinectPV2.JointType_Head].getZ();

      if (skeletonDistance > 3) {
        for (int j = 0; j < attractors[i].length; j++) {
         if (attractors[i][j] != null){ 
         attractors[i][j].remove();
         attractors[i][j] = null;
         }
        }
      } else {

        //color col  = skeleton.getIndexColor();
        //fill(col);
        //stroke(col);

        drawBody(joints);


        //draw different color for each hand state
        //drawHandState(joints[KinectPV2.JointType_HandRight]);
        //drawHandState(joints[KinectPV2.JointType_HandLeft]);

        // Creates attractors for each joint
        for (int j = 0; j < joints.length - 1; j++) {
          if (attractors[i][j] == null)
          {
            attractors[i][j] = new Attractor(new Vec2D(joints[j].getX(), joints[j].getY()));
            println("Joint "+ j + " - " + joints[j].getX() + " - " + joints[j].getY());
          } else {
            attractors[i][j].set(joints[j].getX(), joints[j].getY());
          }
          attractors[i][j].display();
        }

        //  int [] rawData = kinect.getRawDepthData();
        //  for ( int d = 0; d < rawData.length; d++ ) {
        //    if ( rawData[d] > maxD ) {
        //      kinect.enableSkeletonColorMap(false);
        //    }
        //  }
        //}

        int attr = joints.length - 1;

        //creates attractors for each custom joints
        for (int t = 0; t < myJoints.size(); t++) {
          fill(255, 255, 255);
          //noFill();
          //noStroke();
          float[] myJoint = myJoints.get(t);
          ellipse(myJoint[0], myJoint[1], 5, 5);

          if (attractors[i][attr] == null)
          {
            attractors[i][attr] = new Attractor(new Vec2D(myJoint[0], myJoint[1]));
          } else {
            attractors[i][attr].set(myJoint[0], myJoint[1]);
          }
          attractors[i][attr].display();
          attr++;
        }
      }
    }
  }
}

/*Skeleton from library KinectPV2*/
//DRAW BODY
public void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

//draw joint
public void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  fill(255, 255, 255);
  noStroke();
  ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw bone
public void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  fill(255, 255, 255);
  ellipse(0, 0, 15, 15);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

//draw hand state
public void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
public void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    break;
  }
}
//Referencing Particles from The Nature of Code - Daniel Shiffman
// class Spore extends the class "VerletParticle2D"

class Particle extends VerletParticle2D {

  float r;

  Particle (Vec2D loc) {
    super(loc);
    r = 1.5f;
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior(this, r*random(5), -1));
  }

  public void display () {
    pushMatrix();
    //fill (255, 0, 0);
    //translate(x, y);
    //sphere(r*2);
    shape(six, x, y);
    popMatrix();
  }
}
//void setOrder() {
//  sequence0.rewind();
//  sequence1.rewind();
//  sequence2.rewind();
//  sequence3.rewind();
//  sequence4.rewind();
//  sequence5.rewind();  
//  sequence6.rewind();
//  sequence7.rewind();
//  sequence8.rewind();
//  sequence9.rewind();
//  sequence10.rewind();
//  sequence11.rewind();
//  sequence12.rewind();

//  while (count<number.length) {
//    //generates a random number between the range of 1 to 13. (both range values are inclusive)
//    num = r.nextInt(14-1)+1;
//    do {
//      for (int i=0; i<number.length; i++) {
//        if (num == number[i]) {
//          repeat = true;
//          break;
//        } else if (i == count) { 
//          number[count] = num;
//          count++;
//          repeat = true;
//          break;
//        }
//        finalTrack = number[number.length-1];
//        if (number[0]==finalTrack) {
//          repeat = true;
//          break;
//        }
//      }
//    } while (!repeat);
//  }
//  result = false;
//  delay(int(time));
//}

//void playTrack() {
//  //println("playTrack");
//  for (int x=0; x<number.length; x++) {
//    //println(tracksPlayed + ": " + number[x]);
//    //println(result);

//    if (result == true) {
//      //println("in the loop: " + result);
//      count = 0;
//      finalTrack = -1;
//      repeat = false;
//      setOrder();
//    } else {
//      if (tracksPlayed<number.length) {
//        //println("in the loop: " + result);
//        if (number[x]==1) {
//          sequence0.play();
//          time=5000+pause;
//        }
//        if (number[x]==2) {
//          sequence1.play();
//          time=9000+pause;
//        }
//        if (number[x]==3) {
//          sequence2.play();
//          time=7000+pause;
//        }
//        if (number[x]==4) {
//          sequence3.play();
//          time=7000+pause;
//        }
//        if (number[x]==5) {
//          sequence4.play();
//          time=8000+pause;
//        }
//        if (number[x]==6) {
//          sequence5.play();
//          time=9000+pause;
//        }
//        if (number[x]==7) {
//          sequence6.play();
//          time=6000+pause;
//        }
//        if (number[x]==8) {
//          sequence7.play();
//          time=8000+pause;
//        }
//        if (number[x]==9) {
//          sequence8.play();
//          time=6000+pause;
//        }
//        if (number[x]==10) {
//          sequence9.play();
//          time=7000+pause;
//        }
//        if (number[x]==11) {
//          sequence10.play();
//          time=4000+pause;
//        }
//        if (number[x]==12) {
//          sequence11.play();
//          time=7000+pause;
//        }
//        if (number[x]==13) {
//          sequence12.play();
//          time=7000;
//        }
//        tracksPlayed+=1;
//        if (tracksPlayed==number.length) {
//          result = listComplete(tracksPlayed);
//          tracksPlayed=0;
//        }
//        delay(int(time));
//      }
//    }
//  }
//}

//boolean listComplete(int n) {
//  if (n<number.length-1 && n>0) {
//    result = false;
//  } 
//  if (n==number.length) {
//    result = true;
//  }
//  return result;
//}
public void customRotate(float speed, float x, float y, float z) {
  float timePassed = millis()-startTime;
  float angle = timePassed/5000 * speed;      //Compute angle. We rotate at speed 0.3 degrees per 5 seconds
  rotate(angle, x, y, z);       //Rotate along the y-coordinate
}
public void sphereMeshSetup() {
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

public void drawSphereMesh() {
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
      vRef[i] = PVector.lerp(vRef[i], vReset[i], 0.8f);
    }

    vertices[i] = PVector.lerp(vertices[i], vRef[i], 0.1f);

    //Draw an obj at the vertices of the sphere
    //pushMatrix();
    //translate(vertices[i].x, vertices[i].y, vertices[i].z);
    //shape(bowl, 0, 0);
    //popMatrix();

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
        stroke(255, 78);
        fill(255, 78);
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
ArrayList<CD> cd = new ArrayList<CD>(); 
int randParticleN;


public void drawCD() {
  for (CD p : cd) {
    p.update();
    p.display();
    p.bounce();
  }
  println("destroy particles array: " + cd.size());
}

public void destroy() {
  for ( Integer num : particles_remove ) {
    randParticleN = PApplet.parseInt( random(cd.size()-1) );
    CD randParticle = cd.get( randParticleN );
    println( randParticle.pos.x, randParticle.pos.y );
    float coordArray[] = new float [] { randParticle.pos.x, randParticle.pos.y };
    //calling explosion event
    //particles_explosion.add( coordArray );
  }
  //removes from particles
  cd.remove( randParticleN );
  //clean array particles_remove
  particles_remove.clear();
  println("after destroy particles array: " + cd.size());
}

//create and destroy elements automatically overtime
//to maintain the balance and avoid null pointer bugs
public void addCD() {  
  for (int i=0; i <cdInit; i++) {
    cd.add(new CD(new PVector(random(-Rad, Rad), random(-Rad, 0), random(-Rad, 0))));
    println("add particles: " + i);
  }
}

class CD {
  PVector pos;
  PVector vel;
  PVector acc;
  PVector min = new PVector(-(Rad), -(Rad*0.3f), -(Rad));
  PVector max = new PVector((Rad), Rad*0.3f, 0);
  float lifespan = 60; //seconds

  CD(PVector p) {
    pos = p;
    vel = new PVector(random(-1, 1), random(1, 1), random(-1, 1));
    acc = new PVector(random(-1, 1), random(-1, 1), random(-1, 1)); //speed
  }

  public void update() {
    vel.add(acc);
    pos.add(vel);
    acc.mult(0); //Reset acc every time update() is called.
    vel.limit(4);
  }

  public void display() {
    pushMatrix();
    //scale(10, 10, 10);
    translate(pos.x, pos.y, pos.z);
    customRotate(2, 0.7f, 0.4f, 0.5f);
    scale(4, 4, 4);
    shape(sharpsphere, 0, 0);
    popMatrix();
  }

  public void bounce() {
    //keep the particles on the screen
    if (pos.x > max.x) {
      pos.x = max.x;
      vel.x *= -1;
    }
    if (pos.x < min.x) {
      pos.x = min.x;
      vel.x *= -1;
    }
    if (pos.y > max.y) {
      pos.y = max.y;
      vel.y *= -1;
    }
    if (pos.y < min.y) {
      pos.y = min.y;
      vel.y *= -1;
    }
    if (pos.z > max.z) {
      pos.z = max.z;
      vel.z *= -1;
    }
    if (pos.z < min.z) {
      pos.z = min.z;
      vel.z *= -1;
    }
  }
}
public int randomSeeds(int n) {
  int result = PApplet.parseInt(random(0, n));
  return result;
}
  public void settings() {  fullScreen(P3D, SPAN); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "IDMsummerProj_environment" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
