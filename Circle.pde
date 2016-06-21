import geomerative.*;

class Circle {
  public  float   x;
  public  float   y;
  private int   speed;
  private int     curInd; // current index into the path/points
  private float   dia;
  private float   multiplier;
  private boolean bFill;
  private boolean bAlive; // only dead when past the end index

  Circle(RPoint[] points, int d, int s, int h, float m, boolean f) {
    x = points[h].x;
    y = points[h].y;
    dia = d;
    speed = s;
    curInd = h;

    multiplier = m;
    
    bFill = f;
    bAlive = true;
  }

  public void update(RPoint[] points) {
    if (curInd > points.length - 1) { // if past the end index of the path
      bAlive = false;
      return;
    }
    if (bAlive) {
      x = points[curInd].x;
      y = points[curInd].y;
      curInd += speed;
    }
  }

  public void draw( PApplet p ) {
    if (bFill) {
      p.fill(25, 127);
    } else {
      p.noFill();
      p.stroke(25, 127);
    }
    p.ellipse( x, y, dia, dia );
  }

  public boolean isAlive() {
    return bAlive;
  }

  public void updateDia() {
    dia *= multiplier;
  }
}
