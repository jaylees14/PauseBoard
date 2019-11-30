const size_t KEYS = 4;

char inputPins[KEYS] = {A0, A1, A2, A3};
char controlPins[KEYS] = {9, 10, 11, 6};

void setResistance(int resistance) {
  int pwm = 155 + 1 * min(resistance, 100);
  for (int i = 0; i < KEYS; i++) {
    analogWrite(controlPins[i], pwm);
  }
}

void setup() {
  Serial.begin(9600);
  for (int i = 0; i < KEYS; i++) {
    pinMode(inputPins[i], INPUT);
    pinMode(controlPins[i], OUTPUT);
  }
  setResistance(0);
}

bool shift = false;

const int threshold = 200;
const long repeat = 300;
const long firstRepeatDelay = 300;
char chars[KEYS] = {'A', 'B', 'C', 'D'};
long lastPressed[KEYS] = {0};

void loop() {
  delay(100);
  int data = receiveData();
  if (data >= 0) {
    setResistance(data);
  }
  for (int i = 0; i < KEYS; i++)
    handleKey(i);
}

void handleKey(int i) {
  if (analogRead(inputPins[i]) > threshold) {
    if (lastPressed[i] == 0) {
      lastPressed[i] = millis() + firstRepeatDelay;
    } else if (lastPressed[i] > millis() + repeat) {
      return;
    } else {
      lastPressed[i] = millis();
    }
    // Serial.write(analogRead(inputPins[i]));
    sendData(i, false);
  } else {
    lastPressed[i] = 0;
  }
}

void sendData(char c, bool shift) {
  Serial.write(0x80 | (shift ? 0b1 : 0b0));
  Serial.write(c + 1);
  Serial.write(0);
}

int receiveData() {
  if (Serial.available() > 0) {
    return Serial.read();
  }
  return -1;
}
