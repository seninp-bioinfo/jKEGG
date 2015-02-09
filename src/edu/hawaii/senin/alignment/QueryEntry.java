package edu.hawaii.senin.alignment;

import java.util.ArrayList;
import edu.hawaii.senin.util.Interval;

public class QueryEntry {

  private ArrayList<Interval> hsps;
  private ArrayList<HitEntry> hits;

  public QueryEntry() {
    super();
    this.hsps = new ArrayList<Interval>();
    this.hits = new ArrayList<HitEntry>();
  }

  public void addHSP(HitEntry hitEntry) {
    Interval i = new Interval(hitEntry.getQueryStart(), hitEntry.getQueryEnd());
    if (i.getEnd() < i.getStart()) {
      i.swap();
    }
    hsps.add(i);
    hits.add(hitEntry);
  }

  public String getId() {
    return hits.get(0).getId();
  }

  public int[] getQueryAsCoverageInterval() {
    int startIdx = Integer.MAX_VALUE;
    int endIdx = Integer.MIN_VALUE;
    for (Interval i : this.hsps) {
      startIdx = (startIdx < i.getStart()) ? startIdx : i.getStart();
      endIdx = (endIdx > i.getEnd()) ? endIdx : i.getEnd();
    }
    int[] res = new int[endIdx - startIdx];
    for (Interval i : this.hsps) {
      for (int idx = i.getStart(); idx < i.getEnd(); idx++) {
        res[idx - startIdx] = res[idx - startIdx] + 1;
      }
    }
    return res;
  }
}
