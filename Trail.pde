import java.util.LinkedList;

class Trail {

  private LinkedList trail;
  private boolean    bTrailAlive;
  public  int        speed;
  public  int        head;
  public  int        num;
  public  float      multiplier;
  public  boolean    fill;

  Trail(int s, int h, int n, boolean f) {
    trail = new LinkedList();
    bTrailAlive = true;
    speed = s;
    head = h;
    num = n;
    fill = f;
    // hardcoded empirical numbers, 10 ~< x^n ~< 50
    if (n >= 150) {
      // multiplier = random(1.012, 1.02);
      multiplier = random(1.012, 1.025);
    } else if (n < 150 && n >= 100) {
      // multiplier = random(1.015, 1.027);
      multiplier = random(1.015, 1.032);
    } else if (n < 100 && n >= 50) {
      // multiplier = random(1.027, 1.04);
      multiplier = random(1.027, 1.05);
    } else {
      // multiplier = random(1.04, 1.07);
      multiplier = random(1.04, 1.075);
    }
  }

  public void add(Circle circ) {
    trail.add(circ);
  }

  public void remove(Circle circ) {
    trail.remove(circ);
  }

  public Object get(int i) {
    return trail.get(i);
  }

  public int size() {
    return trail.size();
  }

  public boolean isTrailAlive() {
    return bTrailAlive;
  }

  public void killTrail() {
    bTrailAlive = false;
  }
}
