// Radar Visualization Sketch

// Import necessary libraries
import processing.serial.*;
import processing.opengl.*;
import toxi.geom.*;
import toxi.processing.*;

// Initialize ToxiclibsSupport for graphics
ToxiclibsSupport gfx;

// Declare variables for serial communication
Serial port;
String serialAngle;
String serialDistance;
String serialData;
float objectDistance;
int radarAngle, radarDistance;
int index = 0;

void setup() {
  size(1280, 720);  // Set the canvas size
  gfx = new ToxiclibsSupport(this);  // Initialize ToxiclibsSupport for graphics
  smooth();
  
  // Connect to the serial port (modify the portName accordingly)
  String portName = "COM4";
  port = new Serial(this, portName, 9600);
  
  port.bufferUntil('#');  // Buffer until '#' character is received
}

void draw() {
  background(0);  // Set background color
  
  // Draw radar arcs and lines
  pushMatrix();
  translate(width / 2, height - 54);  // Translate to the center bottom of the canvas
  noFill();
  strokeWeight(2);
  stroke(10, 255, 10);  
  arc(0, 0, 1200, 1200, PI, TWO_PI);
  arc(0, 0, 934, 934, PI, TWO_PI);
  arc(0, 0, 666, 666, PI, TWO_PI);
  arc(0, 0, 400, 400, PI, TWO_PI);
  strokeWeight(4);
  line(-width / 2, 0, width / 2, 0);
  line(0, 0, -554, -320);
  line(0, 0, -320, -554);
  line(0, 0, 0, -640);
  line(0, 0, 320, -554);
  line(0, 0, 554, -320);
  popMatrix();
 
  // Draw ultrasonic lines
  pushMatrix();
  translate(width / 2, height - 54);  // Translate to the center bottom of the canvas
  strokeWeight(5);
  stroke(10, 255, 10);
  line(0, 0, 640 * cos(radians(radarAngle)), -640 * sin(radians(radarAngle)));
  popMatrix();

  // Draw object detection lines
  pushMatrix();
  translate(width / 2, height - 54);  // Translate to the center bottom of the canvas
  strokeWeight(5);
  stroke(255, 10, 10);  // Red color
  
  // Calculate object distance based on radar distance
  objectDistance = radarDistance * 15;
  
  if (radarDistance < 40) {
    // Draw object detection line
    line(objectDistance * cos(radians(radarAngle)), -objectDistance * sin(radians(radarAngle)),
         633 * cos(radians(radarAngle)), -633 * sin(radians(radarAngle)));
  }
  popMatrix();
}

void serialEvent(Serial port) {
  serialData = port.readStringUntil('#');  // Read serial data until '#' character
  serialData = serialData.substring(0, serialData.length() - 1);  // Remove trailing '#' character
  
  // Find the index of '*' character to separate angle and distance data
  index = serialData.indexOf("*");
  
  // Extract angle and distance data from serial data
  serialAngle = serialData.substring(0, index);
  serialDistance = serialData.substring(index + 1, serialData.length());
  
  // Convert angle and distance data to integers
  radarAngle = int(serialAngle);
  radarDistance = int(serialDistance);
}
