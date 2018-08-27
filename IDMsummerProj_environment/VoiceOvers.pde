void setOrder() {
  sequence0.rewind();
  sequence1.rewind();
  sequence2.rewind();
  sequence3.rewind();
  sequence4.rewind();
  sequence5.rewind();  
  sequence6.rewind();
  sequence7.rewind();
  sequence8.rewind();
  sequence9.rewind();
  sequence10.rewind();
  sequence11.rewind();
  sequence12.rewind();

  while (count<number.length) {
    //generates a random number between the range of 1 to 13. (both range values are inclusive)
    num = r.nextInt(14-1)+1;
    do {
      for (int i=0; i<number.length; i++) {
        if (num == number[i]) {
          repeat = true;
          break;
        } else if (i == count) { 
          number[count] = num;
          count++;
          repeat = true;
          break;
        }
        finalTrack = number[number.length-1];
        if (number[0]==finalTrack) {
          repeat = true;
          break;
        }
      }
    } while (!repeat);
  }
  result = false;
  delay(int(time));
}

void playTrack() {
  //println("playTrack");
  for (int x=0; x<number.length; x++) {
    //println(tracksPlayed + ": " + number[x]);
    //println(result);

    if (result == true) {
      //println("in the loop: " + result);
      count = 0;
      finalTrack = -1;
      repeat = false;
      setOrder();
    } else {
      if (tracksPlayed<number.length) {
        //println("in the loop: " + result);
        if (number[x]==1) {
          sequence0.play();
          time=5000+pause;
        }
        if (number[x]==2) {
          sequence1.play();
          time=9000+pause;
        }
        if (number[x]==3) {
          sequence2.play();
          time=7000+pause;
        }
        if (number[x]==4) {
          sequence3.play();
          time=7000+pause;
        }
        if (number[x]==5) {
          sequence4.play();
          time=8000+pause;
        }
        if (number[x]==6) {
          sequence5.play();
          time=9000+pause;
        }
        if (number[x]==7) {
          sequence6.play();
          time=6000+pause;
        }
        if (number[x]==8) {
          sequence7.play();
          time=8000+pause;
        }
        if (number[x]==9) {
          sequence8.play();
          time=6000+pause;
        }
        if (number[x]==10) {
          sequence9.play();
          time=7000+pause;
        }
        if (number[x]==11) {
          sequence10.play();
          time=4000+pause;
        }
        if (number[x]==12) {
          sequence11.play();
          time=7000+pause;
        }
        if (number[x]==13) {
          sequence12.play();
          time=7000;
        }
        tracksPlayed+=1;
        if (tracksPlayed==number.length) {
          result = listComplete(tracksPlayed);
          tracksPlayed=0;
        }
        delay(int(time));
      }
    }
  }
}

boolean listComplete(int n) {
  if (n<number.length-1 && n>0) {
    result = false;
  } 
  if (n==number.length) {
    result = true;
  }
  return result;
}