package edu.hawaii.senin.kegg.evaluation;

import java.util.Comparator;
import edu.hawaii.senin.kegg.persistence.AlnEntry;

public class AlignmentBitScoreComparator implements Comparator<AlnEntry> {

  @Override
  public int compare(AlnEntry o1, AlnEntry o2) {
    return o1.getScore().compareTo(o2.getScore());
  }

}
