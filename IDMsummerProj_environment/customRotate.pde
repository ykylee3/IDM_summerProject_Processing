void customRotate(float speed, float x, float y, float z) {
  float timePassed = millis()-startTime;
  float angle = timePassed/5000 * speed;      //Compute angle. We rotate at speed 0.3 degrees per 5 seconds
  rotate(angle, x, y, z);       //Rotate along the y-coordinate
}