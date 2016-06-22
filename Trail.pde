import java.util.LinkedList;

class Trail {

  private LinkedList trail;
  private boolean    bAlive;
  private int        speed;
  private int        head;
  private int        capacity;
  // private int        currentCap;
  private float      multiplier;
  private boolean    fill;

  Trail(int s, int h, int c, boolean f) {
    trail = new LinkedList();
    bAlive = true;
    speed = s;
    head = h;
    capacity = c;
    // currentCap = 0;
    fill = f;
    // hardcoded empirical numbers, 10 ~< x^c ~< 50
    if (capacity >= 150) {
      multiplier = random(1.012, 1.025);
    } else if (capacity < 150 && capacity >= 100) {
      multiplier = random(1.015, 1.03);
    } else if (capacity < 100 && capacity >= 50) {
      multiplier = random(1.027, 1.05);
    } else {
      multiplier = random(1.04, 1.08);
    }
  }

  public int getSpeed() { return speed; }
  public int getHead() { return head; }
  public float getMultiplier() { return multiplier; }
  public boolean getFill() { return fill; }

  public void add(Circle circ) { 
    trail.add(circ); 
    capacity--;
  }
  public void remove(Circle circ) { trail.remove(circ); }
  public Object get(int i) { return trail.get(i); }
  public int size() { return trail.size(); }

  public boolean isAlive() { return bAlive; }
  public boolean bMaxCapReached() { return capacity == 0; }
  public void die() { bAlive = false; }
}
