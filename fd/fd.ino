#include <Servo.h>

Servo servo1;
Servo servo2;

const int pin1 = 9;
const int pin2 = 10;

int pos1 = 90;
int pos2 = 90;

void setup() {
  servo1.attach(pin1, 500, 2500);
  servo2.attach(pin2, 500, 2500);
  Serial.begin(115200);
  
  // 初期位置にゆっくり移動
  int startPos = 0;
  int stepDelay = 20; // 各ステップ間の遅延（ミリ秒）
  
  for (int angle = startPos; angle <= pos1; angle++) {
    servo1.write(angle);
    delay(stepDelay);
  }
  
  for (int angle = startPos; angle <= pos2; angle++) {
    servo2.write(angle);
    delay(stepDelay);
  }
  
  Serial.println("READY");
}

void loop() {
  if (Serial.available() > 0) {
    int servoID = Serial.parseInt();
    int targetAngle = Serial.parseInt();

    while (Serial.available() > 0) {
      Serial.read();
    }

    if (targetAngle < 0 || targetAngle > 180) {
      Serial.println("ERROR");
      return;
    }

    if (servoID == 1) {
      servo1.write(targetAngle);
      pos1 = targetAngle;
      Serial.print("POS:");
      Serial.print(pos1);
      Serial.print(",");
      Serial.println(pos2);
    } else if (servoID == 2) {
      servo2.write(targetAngle);
      pos2 = targetAngle;
      Serial.print("POS:");
      Serial.print(pos1);
      Serial.print(",");
      Serial.println(pos2);
    } else if (servoID == 0) {
      Serial.print("POS:");
      Serial.print(pos1);
      Serial.print(",");
      Serial.println(pos2);
    } else {
      Serial.println("ERROR");
    }
  }
}
