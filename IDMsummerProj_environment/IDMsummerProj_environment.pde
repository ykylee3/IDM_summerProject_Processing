import peasy.PeasyCam;

PeasyCam cam;

PVector[] vertices;
PVector[] elementPos;

int nPoints = 1500;  //The number of vertices to be shown
int nElements = 30;  //The number of floating elements
float Rad = 250; //The to-be-formed sphere's (the 'dome' container) radius
float buffer = 30; //distance between the shpere mesh and the floating elements
float connectionDistance = 30; //Threshold parameter of distance to connect
float startTime;

void setup() {
  size(1024, 768, P3D);
  frameRate(60);
  sphereDetail(8);

  //set ambient color
  ambientLight(255, 214, 104);

  cam = new PeasyCam(this, -Rad); // init camera distance at the center of the sphere

  startTime = millis();   //Get time in seconds

  initBirds(150);
  sphereMeshSetup();
  createMesh4Elements();
}

void draw() {
  background(0);
  lights();
  lightFalloff(1.0, 0.001, 0.0);
  lightSpecular(255, 243, 183);

  pushMatrix();
  customRotate(0.3, 0, 1, 0);
  int concentration = 600;
  spotLight(255, 199, 60, float(width), float(height), -Rad, 0, 0, -1, PI/16, concentration); 
  popMatrix();

  pushMatrix();
  customRotate(0.5, 0.8, 0.5, 0.3);
  drawSphereMesh();
  popMatrix();

  pushMatrix();
  customRotate(0.25, 0.3, -1, -0.5);
  placeElements();
  popMatrix();

  pushMatrix();
  //camera
  fill(250, 0, 0);
  customRotate(0, 0, 0, 0);
  sphere(20);
  popMatrix();
  
  translate(-width/2, -height/2, -Rad);
  drawBirds();
}