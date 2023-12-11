import processing.sound_modified.*;
FFT fft1;
SoundFile file;

int POINT_LIGHT = 0;
int FLUORESCENT_LIGHT = 1;


int bands = 512; //hversu margir punktar per linu, veldi af 2 (512, 256, 128, 64, 32, 16, 8)
float fft_array[] = new float[bands];

int light_count_x = 3;
int light_count_y = 8;
float global_light_strength = 1.0;

Light[][] lights;

void setup(){
  Sound s = new Sound(this);
  Sound.list();
  //set input device (can use Sound.list() to find which one it is, can also find by name)
  s.inputDevice(2);
  fft1 = new FFT(this, bands);
  file = new SoundFile(this, "hryllingsmyndadot.wav");
  file.play();

  //attach the ffts to each input
  fft1.input(file);


  size(400,400);
  ellipseMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER,CENTER);
  lights = new Light[light_count_x][light_count_y];
  for(int y = 0; y < light_count_y; y++){
    for(int x = 0; x < light_count_x; x++){
      lights[x][y] = new Light(x,y,FLUORESCENT_LIGHT);
    }
  }

}

void draw(){
  if(!file.isPlaying()){
    file.play();
  }
  fft1.analyze(fft_array);
  background(0);
  stroke(255);
  fill(255,90);
  rect(mouseX,mouseY,75,50);
  display_lights();
  
  float old_global_light_strength = global_light_strength;
  float new_global_light_strength = getEnergy(200,10000,true,fft_array) * 255;
  global_light_strength = lerp(old_global_light_strength,new_global_light_strength, 0.3);
}

void display_lights(){
  for(int y = 0; y < light_count_y; y++){
    for(int x = 0; x < light_count_x; x++){
      lights[x][y].update();
      lights[x][y].show();
    }
  }
}


float getEnergy(float frequency1, float frequency2, boolean rangeYesOrNo, float[] fft_array) {
  //var nyquist = p5sound.audiocontext.sampleRate / 2;
  float nyquist = 22050;

  if (!rangeYesOrNo) {
    // if only one parameter:
    int index = round((frequency1 / nyquist) * fft_array.length);
    return fft_array[index];
  } else if (rangeYesOrNo) {
    // if two parameters:
    // if second is higher than first
    if (frequency1 > frequency2) {
      float swap = frequency2;
      frequency2 = frequency1;
      frequency1 = swap;
    }
    int lowIndex = round(
      (frequency1 / nyquist) * fft_array.length
      );
    int highIndex = round(
      (frequency2 / nyquist) * fft_array.length
      );

    float total = 0;
    int numFrequencies = 0;
    // add up all of the values for the frequencies
    for (int i = lowIndex; i < highIndex; i++) {
      total += fft_array[i];
      numFrequencies += 1;
    }
    // divide by total number of frequencies
    float toReturn = total / numFrequencies;
    return toReturn;
  }
  return 0;
}

float mapf(float x, float in_min, float in_max, float out_min, float out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}
