package edu.hawaii.senin.kegg.evaluation;

import java.util.Comparator;
import edu.hawaii.senin.kegg.persistence.AlnEntry;

public class AlignmentSimilarityComparator implements Comparator<AlnEntry> {

  @Override
  public int compare(AlnEntry o1, AlnEntry o2) {
    return o1.getIdentity().compareTo(o2.getIdentity());
  }

}
