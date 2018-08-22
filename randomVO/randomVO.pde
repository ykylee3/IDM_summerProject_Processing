import ddf.minim.*;
import java.util.Random;

Minim minim;
Random r = new Random();

float VOnow;
float time;
int[] number = new int[13];
int count=0;
int num;

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


  for (int x=0; x<total; x++) {
    check[x]=0;
    number[x]=-1;
  }
}

void draw() {
  playTrack();

  if (millis()-VOnow > time) { 
    VOnow = millis();
    j+=1;
    if (j==total) {
      j=0;
    }
  }
}

void setOrder() {
  while (count<number.length) {
    num = r.nextInt(14);
    boolean repeat = false;
    do { //1
      for (int i=0; i<number.length; i++) { //2
        if (num == number[i]) {//3
          repeat = true;
          break;
        } //3
        else if (i == count) { 
          number[count] = num;
          count++;
          repeat = true;
          break;
        }
      } //2
    } while (!repeat); //1
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
}

void playTrack() {
  for (int x=0; x<number.length; x++) {
    if (number[x]==0) {
      sequence0.play();
      time=8000;
    }
    if (number[x]==1) {
      sequence1.play();
      time=12000;
    }
    if (number[x]==2) {
      sequence2.play();
      time=10000;
    }
    if (number[x]==3) {
      sequence3.play();
      time=10000;
    }
    if (number[x]==4) {
      sequence4.play();
      time=11000;
    }
    if (number[x]==5) {
      sequence5.play();
      time=12000;
    }
    if (number[x]==6) {
      sequence6.play();
      time=9000;
    }
    if (number[x]==7) {
      sequence7.play();
      time=11000;
    }
    if (number[x]==8) {
      sequence8.play();
      time=9000;
    }
    if (number[x]==9) {
      sequence9.play();
      time=10000;
    }
    if (number[x]==10) {
      sequence10.play();
      time=7000;
    }
    if (number[x]==11) {
      sequence11.play();
      time=10000;
    }
    if (number[x]==12) {
      sequence12.play();
      time=7000;
    }
    delay(int(time));
  }
}
