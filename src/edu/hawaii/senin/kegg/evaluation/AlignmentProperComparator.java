package edu.hawaii.senin.kegg.evaluation;

import java.util.Comparator;
import edu.hawaii.senin.kegg.persistence.AlnEntry;

public class AlignmentProperComparator implements Comparator<AlnEntry> {

  @Override
  public int compare(AlnEntry o1, AlnEntry o2) {
    if (o1.getScore().equals(o2.getScore())) {
      return o1.getIdentity().compareTo(o2.getIdentity());
    }
    return o1.getScore().compareTo(o2.getScore());
  }

}
