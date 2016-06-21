import java.io.PrintStream;
import java.util.LinkedList;
import processing.pdf.*;
import controlP5.*;
import geomerative.*;

RShape     logo;
RPoint[][] pointsInPaths; // holds the extracted points
LinkedList trailManagerList;

int SEG_LENGTH       = 2; // default is 2
int MIN_DIAMETER     = 1;
int MIN_NUM_CIRCLE   = 50;
int MAX_NUM_CIRCLE   = 200;
int CHANCE_NEW_CIRCL = 5;
int MIN_SPEED        = 1;
int MAX_SPEED        = 6;

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

  logo = RG.loadShape("TASAN.svg");
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
  int handleW = 10;
  cp5.addSlider("MAX_NUM_CIRCLE")
    .setPosition(0, 0)
    .setSize(sliderW, sliderH)
    .setRange(MIN_NUM_CIRCLE, MAX_NUM_CIRCLE)
    .setValue(75)
    .setSliderMode(Slider.FLEXIBLE)
    .setHandleSize(handleW)
    .setColorCaptionLabel(color(127));

  cp5.addSlider("CHANCE_NEW_CIRCL")
    .setPosition(0, boxH)
    .setSize(sliderW, sliderH)
    .setRange(1, 10)
    .setValue(5)
    .setSliderMode(Slider.FLEXIBLE)
    .setHandleSize(handleW)
    .setColorCaptionLabel(color(127));

  cp5.addSlider("MIN_SPEED")
    .setPosition(0, 2*boxH)
    .setSize(sliderW, sliderH)
    .setRange(1, 3)
    .setValue(1)
    .setSliderMode(Slider.FLEXIBLE)
    .setHandleSize(handleW)
    .setColorCaptionLabel(color(127));

  cp5.addSlider("MAX_SPEED")
    .setPosition(0, 3*boxH)
    .setSize(sliderW, sliderH)
    .setRange(4, 6)
    .setValue(4)
    .setSliderMode(Slider.FLEXIBLE)
    .setHandleSize(handleW)
    .setColorCaptionLabel(color(127));
}

void draw() {
  // begin recording to PDF
  if (bSaveOneFrame) {
    beginRecord(PDF, "UsingGeomerative-" + timestamp() + ".pdf");
  }

  background(255, 127);

  pushMatrix();
    translate(width/2, height/2);
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    for (int i = 0; i < pointsInPaths.length; i++) {
      RPoint[] points = pointsInPaths[i];
      LinkedList trailManager = (LinkedList) trailManagerList.get(i);
      //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if (random(1) < CHANCE_NEW_CIRCL / 100.0) {
        int     speed = int(random(MIN_SPEED, MAX_SPEED));
        int     head  = int(random(0, points.length/3));
        int     num   = int(random(MAX_NUM_CIRCLE/10, MAX_NUM_CIRCLE));
        boolean fill  = random(1) > 0.5 ? true : false;
        trailManager.add(new Trail(speed, head, num, fill));
      }
      for (int j = 0; j < trailManager.size(); j++) {
        Trail trail = (Trail) trailManager.get(j);

        for (int k = 0; k < trail.size(); k++) {
          Circle circ = (Circle) trail.get(k);
          if (!circ.isAlive()) {
            trail.remove(circ);
          } else {
            circ.draw(this);
            circ.update(points);
          }
        }
        // Keep adding new circles if maximum number of circles not reached
        // TODO: combine conditiosn into an update method of Trail
        if (trail.size() < trail.num && trail.isTrailAlive()) {
          for (int k = 0; k < trail.size(); k++) {
            Circle circ = (Circle) trail.get(k);
            circ.updateDia();
          }
          trail.add(new Circle(points, MIN_DIAMETER, trail.speed, trail.head, trail.multiplier, trail.fill));
        } else if (trail.isTrailAlive()) {
          trail.killTrail();
        } else if (trail.size() == 0) {
          trailManager.remove(trail);
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

void mousePressed(){
  bIgnoreStyles = !bIgnoreStyles;
  RG.ignoreStyles(bIgnoreStyles);
}

String timestamp() {
  return year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
}
