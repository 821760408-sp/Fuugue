import geomerative.*;

class Circle {
  private float    x;
  private float    y;
  private int      speed;
  private int      curInd; // current index into the path/points
  private float    dia;
  private float    multiplier;
  private boolean  bFill;
  private boolean  bAlive; // only dead when past the end index
  private RPoint[] points;

  Circle(RPoint[] p, int d, int s, int h, float m, boolean f) {
    points = p;
    x = points[h].x;
    y = points[h].y;
    dia = d;
    speed = s;
    curInd = h;

    multiplier = m;
    
    bFill = f;
    bAlive = true;
  }

  public void updatePos() {
    curInd += speed;
    if (curInd <= points.length - 1) {
      x = points[curInd].x;
      y = points[curInd].y;
    } else {
      bAlive = false;
    }
  }

  public void updateDia() { dia *= multiplier; }

  public void draw( PApplet p ) {
    if (bFill) {
      p.fill(255, 127);
    } else {
      p.noFill();
      p.stroke(255, 127);
    }
    p.ellipse( x, y, dia, dia );
  }

  public boolean isAlive() { return bAlive; }
}
