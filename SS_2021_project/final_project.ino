// 핀번호 할당
int trigPin = 24;  // 초음파 정보 출력
int echoPin = 22;  // 초음파 정보 입력
int sw = 52;       // 스위치
int led = 6;       // 100cm 안에 들어왔을 때 탐지
int buzz = 11;     // 100cm 안에 들어왔을 때 피에조 부저
int vib = 7;       // 진동모터(세기 조절)

// 스위치 작동 관련
int state = LOW;   // 현재 on/off 나타내는 상태(실제 작동 결정)
int reading;       // 스위치 상태
int previous = LOW;// state 이전 상태
long time = 0;        // LED가 ON/OFF 토글된 마지막 시간
long debounce = 100;  // 100 ms Debounce 타임 설정(적정시간)
 

void setup() {
  Serial.begin(9600); // 시리얼 속도 설정
  pinMode(trigPin, OUTPUT);// 트리거 핀을 출력으로 설정
  pinMode(echoPin, INPUT); // 에코 핀을 입력으로 설정
  pinMode(sw, INPUT_PULLUP);
  pinMode(led, OUTPUT);
  pinMode(buzz, OUTPUT);
  pinMode(vib, OUTPUT);

}

void loop() {
  
  //1. 스위치 작동 조절
  reading = digitalRead(sw);  // 스위치 상태 읽음
    //스위치가 눌려졌고 스위치 토글 눌림 경과시간이 Debounce 시간보다 크면 실행
  if (reading == HIGH && previous == LOW && millis() - time > debounce) 
  {
    if (state == HIGH)    // state 가 HIGH 면 LOW 로 바꿔준다.
      state = LOW;
    else                  // state 가 LOW 면 HIGH 로 바꿔준다.
      state = HIGH;
    time = millis();      // 시간 저장
  }
  previous = reading;

  //2. 초음파 센서 
  // 초음파를 보내며, 다 보내면 echo가 HIGH(신호받기)상태로 대기
  digitalWrite(trigPin, HIGH);
  delay(10);// 10ms간 상태 유지
  digitalWrite(trigPin,LOW);

  //echoPin 이 HIGH를 유지한 시간 = 초음파가 보냈다가 다시 돌아온 시간
  float duration = pulseIn(echoPin, HIGH); //us단위로 들어옴
  float distance = ((float)(340 * duration) / 1000) / 2;
  
  // 시리얼 모니터에서 확인 
  Serial.print("\nDuration: ");
  Serial.print(duration);
  Serial.print("\nDistance: ");
  Serial.print(distance);
  Serial.println("mm\n\n");

  // 3. led, 피에조 부저, 진동모터 조절
  if ( (distance <= 1000) && (state == HIGH))
  {
     digitalWrite(led, HIGH);
     Serial.print("\nled on\n");
     tone(buzz, 261); //261Hz
     if (distance <= 200) 
     {
      analogWrite(vib, 255); 
     }
     else if (distance <= 400)
     {
      analogWrite(vib, 200); 
     }
     else if (distance <= 600)
     {
      analogWrite(vib, 150);
     }
     else if (distance <= 800)
     {
      analogWrite(vib, 100);
     }
     else if (distance <= 1000)
     {
      analogWrite(vib, 50);
     }
     
     delay(50);

  }
  else
  {
    digitalWrite(led, LOW);
    Serial.print("\nled off\n");
    noTone(buzz);  
    analogWrite(vib, 0);
    delay(50);
    
  }
}
