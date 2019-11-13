void setup() {
  Serial.begin(9600);
}

bool shift = false;

char chars[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15};

void loop() {
  delay(1000);
  int data = receiveData();
  if (data != -1) {
    sendData(data, false);
  }
}

void sendData(char c, bool shift) {
  Serial.write(0x80 | (shift ? 0b1 : 0b0));
  Serial.write(c);
  Serial.write(0);
}

int receiveData() {
  if (Serial.available() > 0) {
    return Serial.read();
  }
  return -1;
}
