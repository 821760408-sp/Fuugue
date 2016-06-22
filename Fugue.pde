import java.io.PrintStream;
import java.util.LinkedList;
import processing.pdf.*;
import controlP5.*;
import geomerative.*;

RShape     logo;
RPoint[][] pointsInPaths; // holds the extracted points
LinkedList trailManagerList;

int SEG_LENGTH       = 2; // default is 2
int MIN_DIAMETER     = 1; // default is 1
int CHANCE_NEW_CIRCL = 5;
int MIN_SPEED        = 4;
int MAX_SPEED        = 10;

boolean bSaveOneFrame = false;
boolean bIgnoreStyles = true;

ControlP5 cp5;

void setup() {
  size(1920, 1200, P2D);
  smooth();

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // VERY IMPORTANT: Allways initialize the library before using it
  RG.init(this);
  RG.ignoreStyles(bIgnoreStyles);

  logo = RG.loadShape("A.svg");
  logo = RG.centerIn(logo, g, 50);

  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  // Use SEG_LENGTH to set number of points in a path
  RCommand.setSegmentLength(SEG_LENGTH);
  // extract paths and points from the base shape using the above Segmentator settings
  pointsInPaths = logo.getPointsInPaths();
  trailManagerList = new LinkedList();
  for (int i = 0; i < pointsInPaths.length; i++) {
    trailManagerList.add(new LinkedList());
  }

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  cp5 = new ControlP5(this);
  int sliderW = 200;
  int sliderH = 40;
  int boxH    = sliderH + 5;

  cp5.addSlider("CHANCE_NEW_CIRCL")
    .setPosition(0, boxH)
    .setSize(sliderW, sliderH)
    .setRange(1, 10)
    .setValue(5)
    .setColorCaptionLabel(color(127));

  cp5.addSlider("MIN_SPEED")
    .setPosition(0, 2*boxH)
    .setSize(sliderW, sliderH)
    .setRange(MIN_SPEED, 6)
    .setValue(MIN_SPEED)
    .setColorCaptionLabel(color(127));

  cp5.addSlider("MAX_SPEED")
    .setPosition(0, 3*boxH)
    .setSize(sliderW, sliderH)
    .setRange(6, MAX_SPEED)
    .setValue(MAX_SPEED)
    .setColorCaptionLabel(color(127));
}

void draw() {
  // begin recording to PDF
  if (bSaveOneFrame) {
    beginRecord(PDF, "UsingGeomerative-" + timestamp() + ".pdf");
  }

  background(5);

  pushMatrix();
    translate(width/2, height/2);
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    for (int i = 0; i < pointsInPaths.length; i++) {
      RPoint[] points = pointsInPaths[i];
      LinkedList trailManager = (LinkedList) trailManagerList.get(i);
      //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if (random(1) < CHANCE_NEW_CIRCL / 100.0) {
        int     speed    = int(random(MIN_SPEED, MAX_SPEED));
        int     head     = int(random(0, points.length / 3));
        int     capacity = int(map(random(points.length / 10, points.length / 2), points.length / 10, points.length / 2, 50, 200));
        boolean fill     = random(1) > 0.5 ? true : false;
        trailManager.add(new Trail(speed, head, capacity, fill));
      }

      for (int j = 0; j < trailManager.size(); j++) {
        Trail trail = (Trail) trailManager.get(j);

        if (trail.isAlive()) { // "Alive" means 1, keep adding new circle and 2, update diameters
          // If a trail is still "alive", add one more circle to the head of the trail
          trail.add(new Circle(points, MIN_DIAMETER, trail.getSpeed(), trail.getHead(), trail.getMultiplier(), trail.getFill()));
          for (int k = 0; k < trail.size(); k++) {
            Circle circ = (Circle) trail.get(k);
            // We rely on the circle itself to tell us whether it's still alive
            if (!circ.isAlive()) {
              trail.remove(circ);
            } else {
              circ.draw(this);
              circ.updatePos();
              circ.updateDia();
            }
          }
          // Test the size of trail to decide whether it should be killed
          if (trail.bMaxCapReached()) {
            trail.die();
          }
        } else {
          for (int k = 0; k < trail.size(); k++) {
            Circle circ = (Circle) trail.get(k);
            // We rely on the circle itself to tell us whether it's still alive
            if (!circ.isAlive()) {
              trail.remove(circ);
            } else {
              circ.draw(this);
              circ.updatePos();
            }
          }
          if (trail.size() == 0) {
            trailManager.remove(trail);
          }
        }
      }
    }

    // end recording to PDF
    if (bSaveOneFrame) {
      endRecord();
      bSaveOneFrame = false;
    }

  popMatrix();
}

void keyPressed() {
  if (key == 's') {
    bSaveOneFrame = true;
  }
}

void mousePressed() {
  bIgnoreStyles = !bIgnoreStyles;
  RG.ignoreStyles(bIgnoreStyles);
}

String timestamp() {
  return year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
}
