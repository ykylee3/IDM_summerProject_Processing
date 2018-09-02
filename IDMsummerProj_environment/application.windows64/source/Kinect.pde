
//return a middle point between two joints
float[] getMiddlePoint(float aX, float aY, float bX, float bY) {
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
void drawBody(KJoint[] joints) {
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
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  fill(255, 255, 255);
  noStroke();
  ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw bone
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  fill(255, 255, 255);
  ellipse(0, 0, 15, 15);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

//draw hand state
void drawHandState(KJoint joint) {
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
void handState(int handState) {
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