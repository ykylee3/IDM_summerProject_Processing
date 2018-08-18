import ddf.minim.*;

Minim minim;

int total = 13;
float VOnow;
float time;
int j;

AudioPlayer sequence0, sequence1, sequence2, sequence3, sequence4, sequence5, sequence6, 
  sequence7, sequence8, sequence9, sequence10, sequence11, sequence12;

int[] listen=new int[total];
int[] check=new int[total];
int[] timeCheck=new int[total];

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
    listen[x]=-1;
  }

  for (int x=0; x<total; x++) {
    int ran=(int)(Math.random()*total);
    if (check[ran]==0) {
      listen[x]=ran;
      timeCheck[x]=ran;
      check[ran]=1;
    } else {
      x=x-1;
    }
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

void trackLength() {
  if (timeCheck[j]==0) {
    time=8000;
    println("0");
    delay(int(time));
    sequence0.rewind();
  }
  if (timeCheck[j]==1) {
    time=12000;
    println("1");
    delay(int(time));
    sequence1.rewind();
  }
  if (timeCheck[j]==2) {
    time=10000;
    println("2");
    delay(int(time));
    sequence2.rewind();
  }
  if (timeCheck[j]==3) {
    time=10000;
    println("3");
    delay(int(time));
    sequence3.rewind();
  }
  if (timeCheck[j]==4) {
    time=11000;
    println("4");
    delay(int(time));
    sequence4.rewind();
  }
  if (timeCheck[j]==5) {
    time=12000;
    println("5");
    delay(int(time));
    sequence5.rewind();
  }
  if (timeCheck[j]==6) {
    time=9000;
    println("6");
    delay(int(time));
    sequence6.rewind();
  }
  if (timeCheck[j]==7) {
    time=11000;
    println("7");
    delay(int(time));
    sequence7.rewind();
  }
  if (timeCheck[j]==8) {
    time=9000;
    println("8");
    delay(int(time));
    sequence8.rewind();
  }
  if (timeCheck[j]==9) {
    time=10000;
    println("9");
    delay(int(time));
    sequence9.rewind();
  }
  if (timeCheck[j]==10) {
    time=7000;
    println("10");
    delay(int(time));
    sequence10.rewind();
  }
  if (timeCheck[j]==11) {
    time=10000;
    println("11");
    delay(int(time));
    sequence11.rewind();
  }
  if (timeCheck[j]==12) {
    time=7000;
    println("12");
    delay(int(time));
    sequence12.rewind();
  }
}

void playTrack() {
  for (int x=0; x<total; x++) {
    if (listen[x]==0) {
      sequence0.play();
      trackLength();
    }
    if (listen[x]==1) {
      sequence1.play();
        trackLength();

    }
    if (listen[x]==2) {
      sequence2.play();
        trackLength();

    }
    if (listen[x]==3) {
      sequence3.play();
        trackLength();

    }
    if (listen[x]==4) {
      sequence4.play();
        trackLength();

    }
    if (listen[x]==5) {
      sequence5.play();
        trackLength();

    }
    if (listen[x]==6) {
      sequence6.play();
        trackLength();

    }
    if (listen[x]==7) {
      sequence7.play();
        trackLength();

    }
    if (listen[x]==8) {
      sequence8.play();
        trackLength();

    }
    if (listen[x]==9) {
      sequence9.play();
        trackLength();

    }
    if (listen[x]==10) {
      sequence10.play();
        trackLength();

    }
    if (listen[x]==11) {
      sequence11.play();
        trackLength();

    }
    if (listen[x]==12) {
      sequence12.play();
        trackLength();

    }
  }
}