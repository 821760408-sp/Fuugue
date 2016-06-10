import java.util.LinkedList;

class CircleManager {

  private LinkedList trails;
  private boolean    bTrailAlive;
  public  int        speed;
  public  int        head;
  public  int        num;
  public  float      multiplier;
  public  boolean    fill;

  CircleManager(int s, int i, int n, boolean f) {
    trails = new LinkedList();
    bTrailAlive = true;
    speed = s;
    head = i;
    num = n;
    fill = f;
    // hardcoded empirical numbers, 10 ~< x^n ~< 50
    if (n >= 150) {
      multiplier = random(1.012, 1.02);
    } else if (n < 150 && n >= 100) {
      multiplier = random(1.015, 1.027);
    } else if (n < 100 && n >= 50) {
      multiplier = random(1.027, 1.04);
    } else {
      multiplier = random(1.04, 1.07);
    }
  }

  public void add(Circle trail) {
    trails.add(trail);
  }

  public void remove(Circle trail) {
    trails.remove(trail);
  }

  public Object get(int i) {
    return trails.get(i);
  }

  public int size() {
    return trails.size();
  }

  public boolean isTrailAlive() {
    return bTrailAlive;
  }

  public void killTrail() {
    bTrailAlive = false;
  }
}
