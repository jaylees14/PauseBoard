void setup() { Serial.begin(9600); }

bool shift = false;

char chars[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15};

void loop() {
  delay(1000);
  Serial.write(0x80 | (shift ? 0b1 : 0b0));
  Serial.write(chars[rand() % sizeof(chars)]);
  Serial.write(0);
}
