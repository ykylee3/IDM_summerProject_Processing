import ddf.minim.*;
import java.util.Random;

Minim minim;
Random r = new Random();

float VOnow;
float time;
int[] number = new int[13];
int count=0;
int num;
int tracksPlayed;
boolean result = false;

AudioPlayer sequence0, sequence1, sequence2, sequence3, sequence4, sequence5, sequence6, 
  sequence7, sequence8, sequence9, sequence10, sequence11, sequence12;

void setup() {
  size(10, 10);
  minim = new Minim(this);

  sequence0 = minim.loadFile("1_3.mp3");
  sequence1 = minim.loadFile("2_3.mp3");
  sequence2 = minim.loadFile("3_3.mp3");
  sequence3 = minim.loadFile("4_3.mp3");
  sequence4 = minim.loadFile("5_3.mp3");
  sequence5 = minim.loadFile("6_3.mp3");
  sequence6 = minim.loadFile("7_3.mp3");
  sequence7 = minim.loadFile("8_3.mp3");
  sequence8 = minim.loadFile("9_3.mp3");
  sequence9 = minim.loadFile("10_3.mp3");
  sequence10 = minim.loadFile("11_3.mp3");
  sequence11 = minim.loadFile("12_3.mp3");
  sequence12 = minim.loadFile("13_3.mp3");

  setOrder();
}

void draw() {
  playTrack();
}

void setOrder() {
  while (count<number.length) {
    num = r.nextInt(14);
    boolean repeat = false;
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
      }
    } while (!repeat);
  }

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

  result = false;
}

void playTrack() {
  for (int x=0; x<number.length; x++) {
    println(tracksPlayed + ": " + number[x]);

    if (number[x]==1) {
      sequence0.play();
      time=8000;
    }
    if (number[x]==2) {
      sequence1.play();
      time=12000;
    }
    if (number[x]==3) {
      sequence2.play();
      time=10000;
    }
    if (number[x]==4) {
      sequence3.play();
      time=10000;
    }
    if (number[x]==5) {
      sequence4.play();
      time=11000;
    }
    if (number[x]==6) {
      sequence5.play();
      time=12000;
    }
    if (number[x]==7) {
      sequence6.play();
      time=9000;
    }
    if (number[x]==8) {
      sequence7.play();
      time=11000;
    }
    if (number[x]==9) {
      sequence8.play();
      time=9000;
    }
    if (number[x]==10) {
      sequence9.play();
      time=10000;
    }
    if (number[x]==11) {
      sequence10.play();
      time=7000;
    }
    if (number[x]==12) {
      sequence11.play();
      time=10000;
    }
    if (number[x]==13) {
      sequence12.play();
      time=7000;
    }
    delay(int(time));
    tracksPlayed+=1;
    
    if (result == true) {
      println("hi i'm in");
      tracksPlayed = 0;
      count = 0;
      setOrder();
    } else {
      result = listComplete(tracksPlayed);
    }
  }
}

boolean listComplete(int n) {
  if (n<number.length) {
    result = false;
  } 
  if (n==number.length-1) {
    result = true;
  }
  return result;
}
