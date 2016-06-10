import java.io.PrintStream;
import java.util.LinkedList;
import processing.pdf.*;
import controlP5.*;
import geomerative.*;

RShape     shapeA;
RShape     shapeB;
RPoint[][] pointsInPaths; // holds the extracted points
LinkedList trails;
LinkedList listOfTrails;
LinkedList listOfPaths;

int SEG_LENGTH       = 2;
int MIN_DIAMETER     = 1;
// int   MAX_DIAMETER = 10;
int MAX_NUM_TRAILS   = 100;
int CHANCE_NEW_TRAIL = 5;
int MIN_SPEED        = 1;
int MAX_SPEED        = 6;

boolean bSaveOneFrame = false;
boolean bIgnoreStyles = true;

ControlP5 cp5;

void setup(){
  size(1280, 720, P2D);
  smooth();

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // VERY IMPORTANT: Allways initialize the library before using it
  RG.init(this);
  RG.ignoreStyles(bIgnoreStyles);

  shapeA = RG.loadShape("A-alt.svg");
  shapeB = RG.loadShape("B-alt.svg");
  shapeA = RG.centerIn(shapeA, g, 50);
  shapeB = RG.centerIn(shapeB, g, 50);

  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  // Use SEG_LENGTH to set number of points in a path
  RCommand.setSegmentLength(SEG_LENGTH);
  // extract paths and points from the base shape using the above Segmentator settings
  // pointsInPaths = shapeA.getPointsInPaths();
  pointsInPaths = shapeB.getPointsInPaths();

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  cp5 = new ControlP5(this);
  cp5.addSlider("MAX_NUM_TRAILS")
    .setPosition(0, 0)
    .setSize(200, 15)
    .setRange(1, 200)
    .setValue(100)
    .setColorCaptionLabel(color(64));
  cp5.addSlider("CHANCE_NEW_TRAIL")
    .setPosition(0, 20)
    .setSize(200, 15)
    .setRange(1, 10)
    .setValue(5)
    .setColorCaptionLabel(color(64));
  cp5.addSlider("MIN_SPEED")
    .setPosition(0, 40)
    .setSize(200, 15)
    .setRange(1, 3)
    .setValue(1)
    .setColorCaptionLabel(color(64));
  cp5.addSlider("MAX_SPEED")
    .setPosition(0, 60)
    .setSize(200, 15)
    .setRange(4, 6)
    .setValue(4)
    .setColorCaptionLabel(color(64));

  trails       = new LinkedList();
  listOfTrails = new LinkedList();
  listOfPaths  = new LinkedList();
}

void draw(){
  // begin recording to PDF
  if (bSaveOneFrame) {
    beginRecord(PDF, "UsingGeomerative-" + timestamp() + ".pdf");
  }

  // background(#2D4D83);
  background(5);

  pushMatrix();
    translate(width/2, height/2);
    //++++++++++++++++++++++++++++++++++++++++++++++
    for (RPoint[] points : pointsInPaths) {

      if (random(1) < CHANCE_NEW_TRAIL / 100.0) {
        int     speed = int(random(MIN_SPEED, MAX_SPEED));
        int     head  = int(random(0, points.length/2));
        int     num   = int(random(MAX_NUM_TRAILS/10, MAX_NUM_TRAILS));
        boolean fill  = random(1) > 0.5 ? true : false;
        listOfTrails.add(new TrailManager(speed, head, num, fill));
      }
      for (int i = 0; i < listOfTrails.size(); i++) {
        TrailManager trailMan = (TrailManager) listOfTrails.get(i);

        for (int j = 0; j < trailMan.size(); j++) {
          Trail trail = (Trail) trailMan.get(j);
          if (!trail.isAlive()) {
            trailMan.remove(trail);
          } else {
            trail.draw(this);
            trail.update(points);
          }
        }
        // Keep adding new trails if maximum number of trails not reached
        if (trailMan.isTrailAlive() && trailMan.size() < trailMan.num) {
          for (int j = 0; j < trailMan.size(); j++) {
            Trail trail = (Trail) trailMan.get(j);
            trail.updateDia();
          }
          trailMan.add(new Trail(points, MIN_DIAMETER, trailMan.speed, trailMan.head, trailMan.num, trailMan.fill));
        } else {
          trailMan.killTrail();
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
