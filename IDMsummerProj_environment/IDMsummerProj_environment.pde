//import java.util.Random; //<>//

import ddf.minim.*;
import peasy.PeasyCam;

//Toxiclibs and Kinect libs
import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

import KinectPV2.KJoint;
import KinectPV2.*;

//serial lib
import processing.serial.*;
import processing.video.*;

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
int numUsers = 0;

//main particles arraylist
ArrayList<Particle> particles;

//particles_add arraylist (used for adding particles to the main particles array)
ArrayList<Integer> particles_add = new ArrayList<Integer>();

//particles_remove arraylist (used for removing particles to the main particles array)
ArrayList<Integer> particles_remove = new ArrayList<Integer>();

//particles_explosion/creation arraylists 
//(used to display particles with special effects in the same coordinates of the added/removed particles)
ArrayList<float[]> particles_explosion = new ArrayList<float[]>();
ArrayList<float[]> particles_creation = new ArrayList<float[]>();

//attractor
Attractor[][] attractors = new Attractor[4][1500];
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

//coordinates for the particles to be created (through plasma globe interactions)
float cdX;
float cdY;
float cdZ;

boolean playCreation1 = false;
boolean playCreation2 = false;
boolean playDestruction1 = false;
boolean playDestruction2 = false;

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

void setup() {
  //fullScreen(P3D, SPAN);
  size(1280, 720, P3D);

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
  creation1.jump(creation1.duration()-0.1);
  creation1.pause();
  creation2.loop();
  creation2.jump(creation2.duration()-0.1);
  creation2.pause();
  destruction1 = new Movie(this, "destruction_2.mp4");
  destruction2 = new Movie(this, "destruction_3.mp4");
  destruction1.loop();
  destruction1.jump(destruction1.duration()-0.1);
  destruction1.pause();
  destruction2.loop();
  destruction2.jump(destruction2.duration()-0.1);
  destruction2.pause();

  startTime = millis();   //Get time in seconds

  //add physics to the world (toxiclibs)
  physics = new VerletPhysics2D ();
  physics.setDrag ( 0.01 );
  physics.setWorldBounds(new Rect(-(Rad+buffer), -(Rad+buffer), (Rad+buffer)*4, (Rad+buffer)*4));//do we need to set a world bound? YES:)
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

  ambient.play();
  ambient.loop();

  //Kinect Setup
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.init();

  //serial communication
  //myPort = new Serial(this, "COM4", 9600);
  //delay(1000);
  //myPort.bufferUntil( 10 );

  //Will run before draw, but always before draw runs, middle way among draw and setup
  registerMethod("pre", this);
}

// It will run this inside draw() every time a particle is removed
// Add here whatever you want to appear in the dead particle coordinates
//void explodeParticle( float x, float y ) {
//  fill(0, 255, 255);
//  translate(x, y);
//  sphere(100);
//}

// It will run this inside draw() every time a particle is created
// Add here whatever you want to appear in the new particle coordinates
//void createParticle( float x, float y ) {
//  fill(0, 255, 0);
//  translate(x, y);
//  sphere(100);
//}

//method always executed before the draw() method (being used to update the physics engine and avoid thread issues)
void pre() {
  //adds particles to the array particles_remove and from the particles added to 
  //that array, removes particles from the array particles 
  for ( Integer num : particles_remove ) {
    int randParticleN = int( random( particles.size() ) );
    Particle randParticle = particles.get( randParticleN );
    println( randParticle.x(), randParticle.y() );
    float coordArray[] = new float [] { randParticle.x(), randParticle.y() };
    //calling explosion event
    particles_explosion.add( coordArray );
    //removes from particles
    particles.remove( randParticleN );
  }
  //clean array particles_remove
  particles_remove.clear();

  //adds particles to the array particles_add and from the particles added to 
  //that array, adds particles in the array particles
  for ( Integer num : particles_add ) {
    float coordArray[] = new float [] { cdX, cdY };
    //calling creation event
    particles_creation.add( coordArray );
    //adds to particles
    particles.add( new Particle( new Vec2D( cdX, cdY ) ) );
  }
  //clean array particles_add
  particles_add.clear();
}

void draw() {
  background(200);

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
  scale(0.3, 0.3, 0.3);
  translate(-(Rad*3.5), -(Rad*1.2), -Rad*0.8);
  rotateY(radians(60));
  rotateX(-radians(20));
  image(galaxy, 0, 0);
  popMatrix();

  pushMatrix();
  //draws the creation1 animation (on the left)
  rotateY(radians(30));
  translate(-Rad*2, -(Rad*0.3), -Rad*1.5);
  rotateY(radians(40));
  image(creation1, 0, 0);
  if (creation1.time() >= creation1.duration()-0.2) {
    //stops the video when a play is complete
    creation1.pause();
    creation1.jump(0); //rewind the video for the next play event
    playCreation1 = false;
    //set coordinates and calls the function: create particles
    cdX = 0;
    cdY = 0;
    cdZ = 0;
    //particles_add.add( 1 );
    //println(particles_add.size() );
    cd.add(new CD(new PVector(cdX, cdY, cdZ)));
  }
  popMatrix();

  pushMatrix();
  //draws the creation2 animation (on the middle-right)
  scale(1.3, 1.3, 1.3);
  rotateY(-radians(20));
  translate((-Rad), -(Rad), -(Rad*2));
  rotateX(-radians(20));
  image(creation2, 0, 0);
  if (creation2.time() >= creation2.duration()-0.2) {
    //stops the video when a play is complete
    creation2.pause();
    creation2.jump(0); //rewind the video for the next play event
    playCreation2 = false;
  }
  popMatrix();

  pushMatrix();
  //draws the destruction1 animation (on the right)
  translate((Rad+buffer*2.5), -(Rad*0.8), -Rad*1.5);
  rotateY(-radians(90));
  rotateX(radians(10));
  image(destruction1, 0, 0);
  if (destruction1.time() >= destruction1.duration()-0.2) {
    //stops the video when a play is complete
    destruction1.pause();
    destruction1.jump(0); //rewind the video for the next play event
    playDestruction1 = false;
  }
  popMatrix();

  pushMatrix();
  //draws the destruction2 animation (on the middle-left)
  translate(-(Rad*1.5), -(Rad*0.5), -(Rad+buffer)*1.5);
  rotateY(radians(20));
  image(destruction2, 0, 0);
  if (destruction2.time() >= destruction2.duration()-0.2) {
    //stops the video when a play is complete
    destruction2.pause();
    destruction2.jump(0); //rewind the video for the next play event
    playDestruction2 = false;
  }
  popMatrix();

  lightFalloff(1, 0.3, 0.4); 
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
  rotate(radians(23.44));
  translate((Rad*0.8), -(Rad*0.5), -(Rad+buffer));
  customRotate(0.8, 0, 1, 0);
  shape(earth, 0, 0);
  popMatrix();

  pushMatrix();
  //draws the jupiter model
  rotate(radians(26.73));
  translate(Rad+buffer/2, -(Rad*0.4), -buffer*2);
  customRotate(1, 0, 1, 0);
  scale(0.4, 0.5, 0.4);
  shape(jupiter, 0, 0);
  popMatrix();

  pushMatrix();
  customRotate(0.05, -0.5, -0.2, 0.1);
  drawSphereMesh();
  popMatrix();

  pushMatrix();
  //draws the floating elements
  customRotate(0.25, 0.3, -1, -0.5);
  placeElements();
  popMatrix();

  //pushMatrix();
  ////camera position - mock up
  //fill(255, 255, 255);
  //noStroke();
  //customRotate(0, 0, 0, 0);
  //sphere(20);
  //popMatrix();

  //to get the number of users and for each new user play the sound effect
  int getUsers = int(kinect.getNumOfUsers());
  if (getUsers > numUsers) {
    kinectEffect.play();
    kinectEffect.rewind();
    println("numUsers var value is " + numUsers + " and the value of getUsers is " + getUsers);
  }
  numUsers = int(kinect.getNumOfUsers());
  println(numUsers);
  println(getUsers);

  pushMatrix();
  //updating physics of particles (kinect interaction)
  physics.update ();
  popMatrix();

  pushMatrix();
  //display particles
  translate(-Rad, -Rad, -(Rad*0.75));
  for (Particle p : particles) {
    pushMatrix();
    p.display();
    popMatrix();
  } 
  //draw kinect
  drawKinect();
  popMatrix();

  
  
  pushMatrix();
  //calling explosion
  //for ( float coordArray[] : particles_explosion ) {    
  //  explodeParticle( coordArray[0], coordArray[1] );
  //}
  //cleaning array
  particles_explosion.clear();

  //calling creation
  //for ( float coordArray[] : particles_creation ) {    
  //  createParticle( coordArray[0], coordArray[1] );
  //}
  //cleaning array
  particles_creation.clear();
  popMatrix();
  
  pushMatrix();
  drawCD();
  popMatrix();

  translate(-width/2, -height/2, -Rad);
  drawBirds();
  drawPreds();
  


  //if (playVO) {
  //  //random voice overs
  //  playTrack();
  //  result = listComplete(tracksPlayed);
  //}
}

//reads new frame of the movie 
void movieEvent(Movie m) {
  m.read();
}

//serial event from arduino
void serialEvent( Serial p ) {
  String val = p.readString();
  if ( val != null ) {
    int number = int( trim( val ) ); //converting string to int
    println( "plasma globe " + number );
    inputSignal( number );
  }
}

//MOOC ARDUINO
void keyPressed() {
  switch( key ) {
  case 49:
    inputSignal( 1 );
    if (!playCreation1) {
      creation1.play();
      playCreation1 = true;
    }
    break;

  case 50:
    inputSignal( 2 );
    if (!playCreation2) {
      creation2.play();
      playCreation2 = true;
    }
    particles_add.add( 1 );
    break;

  case 51:
    inputSignal( 3 );
    if (!playDestruction1) {
      destruction1.play();
      playDestruction1 = true;
    }
    particles_remove.add( 1 );
    break;

  case 52:
    inputSignal( 4 );
    if (!playDestruction2) {
      destruction2.play();
      playDestruction2 = true;
    }
    particles_remove.add( 1 );
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

void inputSignal( int globe ) {
  if  (globe == 1) {
    //particles_remove.add( 1 );
    //particles_add.add( 1 );
    //particles_add.add(new Particle(new Vec2D(random(width), random(height))));
    if (!playCreation1) {
      creation1.play();
      playCreation1 = true;
    }
  }
  if  (globe == 2) {
    particles_add.add( 1 );
    //particles_add.add(new Particle(new Vec2D(random(width), random(height))));
    //println( particles_add.size() );
    if (!playCreation2) {
      creation2.play();
      playCreation2 = true;
    }
  }
  if (globe == 3) {
    particles_remove.add( 1 );
    //println( particles_add.size() );
    if (!playDestruction1) {
      destruction1.play();
      playDestruction1 = true;
    }
  }
  if (globe == 4) {
    particles_remove.add( 1 );
    if (!playDestruction2) {
      destruction2.play();
      playDestruction2 = true;
    }
  }
}