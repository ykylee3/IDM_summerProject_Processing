import peasy.PeasyCam;


PeasyCam cam;
PShape hillix;
PShape virus;

PVector[] vertices;
PVector[] elementPos;

int nPoints = 1850;  //The number of vertices to be shown
int nElements = 50;  //The number of floating elements
float Rad = 550; //The to-be-formed sphere's (the 'dome' container) radius
float buffer = 200; //distance between the shpere mesh and the floating elements
float connectionDistance = 65; //Threshold parameter of distance to connect
float startTime;

void setup() {
  size(1024, 768, P3D);
  frameRate(60);
  //sphereDetail(8);

  cam = new PeasyCam(this, -Rad); // init camera distance at the center of the sphere
  hillix = loadShape("test_textured.obj");
  virus = loadShape("virus_textured.obj");
  startTime = millis();   //Get time in seconds

  initBirds(350);
  sphereMeshSetup();
  createMesh4Elements();
}

void draw() {
  //reset coordinates
  camera();
  background(10);

  //set coordinate/direction of spotlight to follow camera
  pushMatrix();
  lightFalloff(1, 0.3, 0.0);
  lightSpecular(255, 243, 183);
  //set ambient color
  ambientLight(255, 214, 104);
  //set rotation attributes for the light
  customRotate(0.3, 0.3, 0.2, 0);
  directionalLight(255, 255, 255, 0, 0, -1);
  popMatrix();

  //manually set start the peasy camr
  cam.feed();

  stroke(255, 0, 0);
  line(-300, 0, 0, 300, 0, 0); //x
  stroke(0, 255, 0);
  line(0, -300, 0, 0, 300, 0); //y
  stroke(0, 0, 255);
  line(0, 0, -300, 0, 0, 300); //z

  pushMatrix();
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
  shininess(0.5);
  specular(255, 0, 0);
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