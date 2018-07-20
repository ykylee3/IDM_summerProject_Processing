import ddf.minim.*;
import peasy.PeasyCam;

PeasyCam cam;
Minim minim;
AudioPlayer ambient;

PShape hillix;
PShape virus;
PShape objColor;
PShape diamond;
PShape six;
PShape whole;

//PShader neon;

PVector[] vertices;
PVector[] vRef;
PVector[] elementPos;
PVector[] vReset;

int[] elementCache;

int nPoints = 1500;  //The number of vertices to be shown
int nElements = 50;  //The number of floating elements
int nBirdObj = 3;    //Total number of varaieties for bird elements
int nFloatObj = 3;   //Total number of varaieties for floating elements

float Rad = 550; //The to-be-formed sphere's (the 'dome' container) radius
float buffer = 200; //distance between the shpere mesh and the floating elements
float connectionDistance = 80; //Threshold parameter of distance to connect
float startTime;
float now = millis();
float meshBeatRate = 4300;

void setup() {
  size(1024, 768, P3D);
  frameRate(60);
  sphereDetail(8);

  cam = new PeasyCam(this, -Rad); // init camera distance at the center of the sphere
  minim = new Minim(this);
  ambient = minim.loadFile("JupiterSound2001.mp3");
  ambient.play();
  ambient.loop();
  hillix = loadShape("test_textured.obj");
  virus = loadShape("virus_textured.obj");
  objColor = loadShape("color.obj");
  diamond = loadShape("diamond.obj");
  six = loadShape("six.obj");
  whole = loadShape("whole.obj");

  //neon = loadShader("neon.glsl");

  startTime = millis();   //Get time in seconds

  initBirds(350);
  sphereMeshSetup();
  createMesh4Elements();
  plantSeed(); //must be called after createMesh4Elements();
}

void draw() {
  background(10);
  lightFalloff(1, 0.3, 0.4);
  lightSpecular(255, 243, 183);
  shininess(0.5);
  specular(255, 255, 206); 

  //reset coordinates
  camera();

  //set coordinate/direction of spotlight to follow camera
  pushMatrix();

  //set ambient color
  ambientLight(255, 214, 104);

  //set rotation attributes for the directional light
  customRotate(0.3, 0.3, 0.2, 0);
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
  customRotate(0.15, -0.5, -0.2, 0.1);
  drawSphereMesh();
  popMatrix();

  pushMatrix();
  customRotate(0.25, 0.3, -1, -0.5);
  placeElements();
  popMatrix();

  pushMatrix();
  //camera
  fill(255, 255, 255);
  customRotate(0, 0, 0, 0);
  //translate(0, 0, -100);
  noStroke();
  sphere(20);
  popMatrix();


  translate(-width/2, -height/2, -Rad);
  drawBirds();
}

void mouseReleased() {
  println("rotation");  
  println(cam.getRotations());  
  println("position");  
  println(cam.getPosition());
}