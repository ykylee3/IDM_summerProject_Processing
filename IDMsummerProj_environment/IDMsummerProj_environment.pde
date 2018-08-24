import ddf.minim.*; //<>//
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


PeasyCam cam;
Minim minim;
AudioPlayer ambient;
Movie stardust;
Movie galaxy;

//kinect
KinectPV2 kinect;

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

//arduino communication
Serial myPort;  // Create object from Serial class

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

//PShader neon;

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

void setup() {
  //fullScreen(P3D, SPAN);
  size(1024, 560, P3D);

  //for debuggings
  sphereDetail(8);

  cam = new PeasyCam(this, -Rad); // init camera distance at the center of the sphere
  minim = new Minim(this);
  ambient = minim.loadFile("ambience_combine.mp3");
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


  //galaxy = new Movie(this, "g2.mp4 ");
  galaxy = new Movie(this, "galaxy3.mp4 ");
  galaxy.loop();

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

  initBirds(200);
  initPreds(30);
  sphereMeshSetup();
  createMesh4Elements();
  plantSeed(); //plantseeds for Floating_elements, must be called after createMesh4Elements();

  ambient.play();
  ambient.loop();

  //Kinect Setup
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.init();

  ////serial communication
  //myPort = new Serial(this, "COM4", 9600);
  //delay(1000);
  //myPort.bufferUntil( 10 );

  //Will run before draw, but always before draw runs, middle way among draw and setup
  registerMethod("pre", this);
}

// It will run this inside draw() every time a particle is removed
// Add here whatever you want to appear in the dead particle coordinates
void explodeParticle( float x, float y ) {
  fill(0, 255, 255);
  translate(x, y);
  sphere(100);
}

// It will run this inside draw() every time a particle is created
// Add here whatever you want to appear in the new particle coordinates
void createParticle( float x, float y ) {
  fill(100, 255, 100);
  translate(x, y);
  sphere(100);
}

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
    float rndW = random( width );
    float rndH = random( height );
    float coordArray[] = new float [] { rndW, rndH };
    //calling creation event
    particles_creation.add( coordArray );
    //adds to particles
    particles.add( new Particle( new Vec2D( rndW, rndH ) ) );
  }
  //clean array particles_add
  particles_add.clear();
}

void draw() {
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

  pushMatrix();
  //draws the galaxy animation on the left screen
  customRotate(0, 0, 0, 0);
  translate(-(Rad*2+buffer), -(Rad*1.3), Rad*1.5);
  rotateY(radians(90));
  //rotateX(-radians(20));
  image(galaxy, 0, 0);
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
  translate(200, -(Rad*0.3), -(Rad+buffer));
  customRotate(0.8, 0, 1, 0);
  shape(earth, 0, 0);
  popMatrix();

  pushMatrix();
  //draws the saturn model
  rotate(radians(26.73));
  translate((Rad+buffer*2), -200, 100);
  customRotate(1, 0, 1, 0);
  scale(2.5, 2.5, 2.5);
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

  pushMatrix();
  //camera
  fill(255, 255, 255);
  noStroke();
  customRotate(0, 0, 0, 0);
  sphere(20);
  popMatrix();

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
  for ( float coordArray[] : particles_explosion ) {    
    explodeParticle( coordArray[0], coordArray[1] );
  }
  //cleaning array
  particles_explosion.clear();

  //calling creation
  for ( float coordArray[] : particles_creation ) {    
    createParticle( coordArray[0], coordArray[1] );
  }
  //cleaning array
  particles_creation.clear();
  popMatrix();

  translate(-width/2, -height/2, -Rad);
  drawBirds();
  drawPreds();
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
    break;

  case 50:
    inputSignal( 2 );
    break;

  case 51:
    inputSignal( 3 );
    break;

  case 52:
    inputSignal( 4 );
  }
  //inputSignal( key );
}

void inputSignal( int globe ) {
  //if 1 or 2
  if  (globe == 1 || globe == 2 ) {
    particles_remove.add( 1 );
  }
  //if 3 or 4
  else if ( globe == 3 || globe == 4 ) {
    particles_add.add( 1 );
    //particles_add.add(new Particle(new Vec2D(random(width), random(height))));
    println( particles_add.size() );
  }
}