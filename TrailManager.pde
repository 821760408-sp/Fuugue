import java.util.LinkedList;

class TrailManager {

  private LinkedList trails;
  private boolean    bTrailAlive;
  public  int        speed;
  public  int        head;
  public  int        num;
  public  boolean    fill;

  TrailManager(int s, int i, int n, boolean f) {
    trails = new LinkedList();
    bTrailAlive = true;
    speed = s;
    head = i;
    num = n;
    fill = f;
  }

  public void add(Trail trail) {
    trails.add(trail);
  }

  public void remove(Trail trail) {
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
