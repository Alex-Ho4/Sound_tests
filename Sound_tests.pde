import themidibus.*; //Import the library

int basePitch = 35;
int pitch = 80;
int channel = 0;
int noteLength = 150;
int instrument = 1;
//                Major       Minor     Augmented  Diminished
int[][] triads = {{0, 4, 3}, {0, 3, 4}, {0, 4, 4}, {0, 3, 3}};
//                 Diminished    Half-Dim     Minor        Minor-Major  Dominant     Major        Augmented     Augmented Maj
int[][] sevenths = {{0, 3, 3, 3},{0, 3, 3, 4},{0, 3, 4, 2},{0, 3, 4, 3},{0, 4, 3, 2},{0, 4, 3, 3},{0, 4, 4, 1}, {0, 4, 4, 2}};
int i = 0;

String[] notes;

MidiBus myBus; // The MidiBus

void setup() {
  size(800, 400);
  background(0);
  notes = genNotes();
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

  // Either you can
  //                   Parent In Out
  //                     |    |  |
  //myBus = new MidiBus(this, 0, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

  // or you can ...
  //                   Parent         In                   Out
  //                     |            |                     |
  //myBus = new MidiBus(this, "IncomingDeviceName", "OutgoingDeviceName"); // Create a new MidiBus using the device names to select the Midi input and output devices respectively.

  // or for testing you could ...
  //                 Parent  In        Out
  //                   |     |          |
  myBus = new MidiBus(this, -1, "Microsoft GS Wavetable Synth"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
  for(int i = 0; i < 8; i++)
  {
    rect(i*100, 0, 400, 100);
  }
  
}

void draw() {
  
  int velocity = 1000;
  int triadPick = (int)map(mouseX, 0, 800, 0, 8);
  int tempo = 120;
    
  if(i == 0) {
    pitch = basePitch;
    }
  else {
    pitch += sevenths[triadPick][i];
  }
  i = (i+1)%sevenths[0].length;
    
  Note note = new Note(channel, basePitch, velocity);
  myBus.sendMessage(0xc0, channel, instrument, 0); 
  
  myBus.sendNoteOn(note); // Send a Midi noteOn
  delay(noteLength);
  myBus.sendNoteOff(note); // Send a Midi nodeOff
  

  int number = 0;
  int value = 90;
  ControlChange change = new ControlChange(channel, number, velocity);

  //myBus.sendControllerChange(change); // Send a controllerChange
  
  println("Note: " + notes[basePitch]);
  println("tempo: " + tempo);
  println("noteLength: " + noteLength);
  println("instrument: " + instrument);
  
  //background((255));
  //if(millis()%noteLength*7 == 0)
  //thread("playSound");
  //playSound();
  
}

void noteOn(Note note) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+note.channel());
  println("Pitch:"+note.pitch());
  println("Velocity:"+note.velocity());
}

void noteOff(Note note) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+note.channel());
  println("Pitch:"+note.pitch());
  println("Velocity:"+note.velocity());
}

void controllerChange(ControlChange change) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+change.channel());
  println("Number:"+change.number());
  println("Value:"+change.value());
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      basePitch++;
    } else if (keyCode == DOWN) {
      basePitch--;
    } 
    if (keyCode == LEFT) {
      noteLength++;
    } else if (keyCode == RIGHT) {
      noteLength--;
    } 
  }
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

//void playSound()
//{
//  int velocity = 1000;
//  int triadPick = (int)map(mouseX, 0, 800, 0, 8);
//  int tempo = 120;
//    
//  if(i == 0) {
//    pitch = basePitch;
//    }
//  else {
//    pitch += sevenths[triadPick][i];
//  }
//  i = (i+1)%sevenths[0].length;
//    
//  Note note = new Note(channel, pitch, velocity);
//  myBus.sendMessage(0xc0, channel, instrument, 0); 
//  
//  myBus.sendNoteOn(note); // Send a Midi noteOn
//  delay(noteLength);
//  myBus.sendNoteOff(note); // Send a Midi nodeOff
//  
//
//  int number = 0;
//  int value = 90;
//  ControlChange change = new ControlChange(channel, number, velocity);
//
//  //myBus.sendControllerChange(change); // Send a controllerChange
//  
//  println(pitch);
//  println("tempo: " + tempo);
//  println("noteLength: " + noteLength);
//  println("instrument: " + instrument);
//}

String[] genNotes()
{
  String[] fin = new String[108];
  for(int i = 0; i < 108; i+= 12)
  {
    fin[i+11] = "B";
    fin[i+10] = "A#";
    fin[i+9] = "A";
    fin[i+8] = "G#";
    fin[i+7] = "G";
    fin[i+6] = "F#";
    fin[i+5] = "F";
    fin[i+4] = "E";
    fin[i+3] = "D#";
    fin[i+2] = "D";
    fin[i+1] = "C#";
    fin[i] = "C";
  }
  return fin;
}
