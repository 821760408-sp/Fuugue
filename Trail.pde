import geomerative.*;

// int MAX_NUM_TRAILS = 100;

class Trail {
  public  float   x;
  public  float   y;
  private int   speed;
  private int     curInd; // current index into the path (points)
  private float   dia;
  private float   multiplier;
  private boolean bFill;
  private boolean bAlive; // only dead when past the end index

  Trail(RPoint[] points, int d, int s, int i, int n, boolean f) {
    x = points[i].x; // TODO:use random var to replace magic number 0
    y = points[i].y;
    dia = d;
    speed = s;
    curInd = i;
    multiplier = n;
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
      p.fill(127, 127);
    } else {
      p.noFill();
      p.stroke(127, 127);
    }
    p.ellipse( x, y, dia, dia );
  }

  public boolean isAlive() {
    return bAlive;
  }

  public void updateDia() {
    dia *= 1.04; // TODO:use random var in p to replace magic number.
  }
}
