import controlP5.*;
import geomerative.*;

RShape shp;
RShape shp2;
RPoint[] points;
RPoint[] tangents;

boolean bIgnoreStyles = true;

int NUM_POINTS = 50;

ControlP5 cp5;
int v1;

void setup(){
  size(600, 600);
  smooth();

  // VERY IMPORTANT: Allways initialize the library before using it
  RG.init(this);
  RG.ignoreStyles(bIgnoreStyles);
  
  shp = RG.loadShape("A-alt.svg");
  shp2 = RG.loadShape("B-alt.svg");
  shp = RG.centerIn(shp, g, 50);
  shp2 = RG.centerIn(shp2, g, 50);

  if (shp.children!=null) println(shp.children); else println("children null");
  // Fields inherited from class geomerative.RGeomElem
  // if (shp.COMMAND!=null) println(shp.COMMAND); else println("COMMAND null");
  println(shp.COMMAND);
  // if (shp.CONTOUR!=null) println(shp.CONTOUR); else println("CONTOUR null");
  println(shp.CONTOUR);
  // if (shp.GROUP!=null) println(shp.GROUP); else println("GROUP null");
  println(shp.GROUP);
  // if (shp.height!=null) println(shp.height); else println("height null");
  println(shp.height);
  // if (shp.MESH!=null) println(shp.MESH); else println("MESH null");
  println(shp.MESH);
  if (shp.name!=null) println(shp.name); else println("name null");
  // if (shp.POLYGON!=null) println(shp.POLYGON); else println("POLYGON null");
  println(shp.POLYGON);
  // if (shp.SHAPE!=null) println(shp.SHAPE); println("SHAPE null");
  println(shp.SHAPE);
  // if (shp.SUBSHAPE!=null) println(shp.SUBSHAPE); else println("SUBSHAPE null");
  println(shp.SUBSHAPE);
  // if (shp.TRISTRIP!=null) println(shp.TRISTRIP); else println("TRISTRIP null");
  println(shp.TRISTRIP);
  // if (shp.width!=null) println(shp.width); else println("width null");
  println(shp.width);
  // println(shp.paths); // NullPointerException

  cp5 = new ControlP5(this);
  cp5.addSlider("NUM_POINTS")
    .setPosition(0, 0)
    .setSize(100, 15)
    .setRange(1, 100)
    .setValue(50)
    .setColorCaptionLabel(color(20, 20, 20));
}

void draw(){
  background(#2D4D83);
  noFill();
  stroke(255, 100);

  pushMatrix();

    // translate(mouseX, mouseY);
    translate(width/2, height/2);
    shp.adapt(shp2);
    RG.shape(shp);
    // RG.shape(shp2);
    
    // TREATMENT  
    points = null;
    tangents = null;
    
    for (int i = 0; i < NUM_POINTS; i++) {
      RPoint point = shp.getPoint(float(i) / float(NUM_POINTS));
      RPoint tangent = shp.getTangent(float(i) / float(NUM_POINTS));
      if (points == null) {
        points = new RPoint[1];
        tangents = new RPoint[1];
        
        points[0] = point;
        tangents[0] = tangent;
      } else {
        points = (RPoint[])append(points, point);
        tangents = (RPoint[])append(tangents, tangent);
      }
    }
    
    for (int i=0;i<points.length;i++) {
      pushMatrix();
      translate(points[i].x, points[i].y);
      // ellipse(0, 0, 10, 10);
      line(0, 0, tangents[i].x, tangents[i].y);
      popMatrix();  
    }

  popMatrix();
}

void mousePressed(){
  bIgnoreStyles = !bIgnoreStyles;
  RG.ignoreStyles(bIgnoreStyles);
}