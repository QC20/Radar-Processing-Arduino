// Ultrasonic Sensor and Servo Control

#include <Servo.h> // Include the Servo library

// Define pins for Ultrasonic Sensor
const int trigPin = 10;
const int echoPin = 11;

// Variables for distance measurement
long duration;
int distance;

Servo myServo; // Create a servo object for controlling the servo motor

void setup() {
  pinMode(trigPin, OUTPUT); // Set the trigPin as an Output
  pinMode(echoPin, INPUT);  // Set the echoPin as an Input
  Serial.begin(9600);  // Initialize serial communication
  myServo.attach(12);  // Attach the servo motor to pin 12
}

void loop() {
  // Rotate the servo motor from 15 to 165 degrees
  for (int i = 15; i <= 165; i++) {
    myServo.write(i); // Move the servo to the current angle
    delay(30); // Delay for stability
    distance = calculateDistance(); // Measure the distance using the ultrasonic sensor
    
    // Send angle and distance data to serial port
    Serial.print(i); // Send the current degree
    Serial.print(","); // Send a delimiter
    Serial.print(distance); // Send the distance value
    Serial.print("."); // Send a delimiter
  }

  // Rotate the servo motor from 165 to 15 degrees in reverse
  for (int i = 165; i > 15; i--) {
    myServo.write(i); // Move the servo to the current angle
    delay(30); // Delay for stability
    distance = calculateDistance(); // Measure the distance using the ultrasonic sensor
    
    // Send angle and distance data to serial port
    Serial.print(i); // Send the current degree
    Serial.print(","); // Send a delimiter
    Serial.print(distance); // Send the distance value
    Serial.print("."); // Send a delimiter
  }
}

// Function to calculate distance using the Ultrasonic Sensor
int calculateDistance() {
  digitalWrite(trigPin, LOW); // Set the trigger pin to low
  delayMicroseconds(2); // Wait for 2 microseconds

  // Set the trigger pin to high for 10 microseconds to trigger the sensor
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH); // Read the echo pin to measure the duration
  distance = duration * 0.034 / 2; // Calculate the distance in centimeters
  return distance; // Return the calculated distance
}
