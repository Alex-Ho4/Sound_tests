import themidibus.*; //Import the library

int basePitch = 55;
int pitch = 55;
int channel = 2;
//                Major       Minor     Augmented  Diminished
int[][] triads = {{0, 4, 3}, {0, 3, 4}, {0, 4, 4}, {0, 3, 3}};
//                 Diminished    Half-Dim     Minor        Minor-Major  Dominant     Major        Augmented     Augmented Maj
int[][] sevenths = {{0, 3, 3, 3},{0, 3, 3, 4},{0, 3, 4, 2},{0, 3, 4, 3},{0, 4, 3, 2},{0, 4, 3, 3},{0, 4, 4, 1}, {0, 4, 4, 2}};
int i = 0;

MidiBus myBus; // The MidiBus

void setup() {
  size(800, 400);
  background(0);

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
  
  
  int velocity = 127;
  int triadPick = (int)map(mouseX, 0, 800, 0, 8);
  int tempo = 120;
  int noteLength = 200;
    
  if(i == 0) {
    pitch = basePitch;
    }
  else {
    pitch += sevenths[triadPick][i];
  }
  i = (i+1)%sevenths[0].length;
    
  Note note = new Note(channel, pitch, velocity);
  
  myBus.sendNoteOn(note); // Send a Midi noteOn
  delay(noteLength);
  myBus.sendNoteOff(note); // Send a Midi nodeOff
  

  int number = 0;
  int value = 90;
  ControlChange change = new ControlChange(channel, number, velocity);

  //myBus.sendControllerChange(change); // Send a controllerChange
  
  println(pitch);
  println("tempo: " + tempo);
  println("noteLength: " + noteLength);
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

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}
