import themidibus.*; //Import the library

int pitch = 25;
int channel = 0;

MidiBus myBus; // The MidiBus

void setup() {
  size(400, 400);
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
  
}

void draw() {
  
  int velocity = 127;
  Note note = new Note(channel, pitch, velocity);
  pitch++;;
  
  int tempo = (int)map(mouseX, 0, width, 32, 255);
  int noteLength = (int)map(mouseY, 0, height, 1, 500);

  myBus.sendNoteOn(note); // Send a Midi noteOn
  delay(noteLength);
  myBus.sendNoteOff(note); // Send a Midi nodeOff

  int number = 0;
  int value = 90;
  ControlChange change = new ControlChange(channel, number, velocity);

  //myBus.sendControllerChange(change); // Send a controllerChange
  delay((int)(60000/tempo));
  
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
