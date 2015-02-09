package edu.hawaii.senin.util;

public class Interval {

  private int start;
  private int end;

  public Interval(int start, int end) {
    this.start = start;
    this.end = end;
  }

  public Interval(Integer start, Integer end) {
    this.start = start.intValue();
    this.end = end.intValue();
  }

  public Interval() {
    this.start = -1;
    this.end = -1;
  }

  public boolean overlaps(Interval intervalB) {
    if ((this.start <= intervalB.getEnd()) && (this.end >= intervalB.getStart())) {
      return true;
    }
    return false;
  }

  public int getStart() {
    return this.start;
  }

  public int getEnd() {
    return this.end;
  }

  public Double overlapInPercent(Interval otherInterval) {
    if (this.overlaps(otherInterval)) {
      int overlapStart = Math.max(this.start, otherInterval.start);
      int overlapEnd = Math.min(this.end, otherInterval.end);
      return Double.valueOf((Integer.valueOf(overlapEnd).doubleValue() - Integer.valueOf(
          overlapStart).doubleValue())
          / Integer.valueOf(Math.abs(this.end - this.start)).doubleValue());
    }
    return 0D;
  }

  public int basesInsideOverlap(Interval otherInterval) {
    int res = 0;
    if (this.overlaps(otherInterval)) {
      int overlapStart = Math.max(this.start, otherInterval.start);
      int overlapEnd = Math.min(this.end, otherInterval.end);
      res = Math.abs(overlapEnd - overlapStart);
    }
    return res;
  }

  public int basesOutsideOverlap(Interval otherInterval) {
    int res = 0;
    if (this.overlaps(otherInterval)) {
      int overlapStart = Math.max(this.start, otherInterval.start);
      int overlapEnd = Math.min(this.end, otherInterval.end);
      res = res + Math.abs(overlapStart - this.start)
          + Math.abs(overlapStart - otherInterval.start);

      res = res + Math.abs(overlapEnd - this.end) + Math.abs(overlapEnd - otherInterval.end);
    }
    return res;
  }

  public int extendsLeft(Interval other) {
    return other.start - this.start;
  }

  public int extendsRight(Interval other) {
    return this.end - other.end;
  }

  public void swap() {
    int tmp = this.end;
    this.end = this.start;
    this.start = tmp;
  }
}
