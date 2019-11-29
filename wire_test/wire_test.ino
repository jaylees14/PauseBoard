const int pin = 10;

void setup() { pinMode(pin, OUTPUT); }

void loop() {
  static int i = 0;
  analogWrite(10, (i++ % 16) * 16);
  delay(5000);
}
