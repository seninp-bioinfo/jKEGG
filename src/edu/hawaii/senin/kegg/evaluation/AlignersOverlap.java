package edu.hawaii.senin.kegg.evaluation;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.Collections;
import java.util.List;
import org.slf4j.LoggerFactory;
import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import edu.hawaii.senin.kegg.db.KEGGDB;
import edu.hawaii.senin.kegg.db.KEGGDBManager;
import edu.hawaii.senin.kegg.persistence.AlnEntry;

public class AlignersOverlap {

  private static final String CR = "\n";

  private static KEGGDB db;

  private static Logger consoleLogger;
  private static Level LOGGING_LEVEL = Level.INFO;

  static {
    consoleLogger = (Logger) LoggerFactory.getLogger(AlignersOverlap.class);
    consoleLogger.setLevel(LOGGING_LEVEL);
  }

  public static void main(String[] args) throws Exception {

    BufferedWriter bw = new BufferedWriter(new FileWriter(new File("output.txt")));

    db = KEGGDBManager.getProductionInstance();

    List<String> tags = db.getAlignerTags();

    consoleLogger.info("Discovered " + tags.size() + " distinct tags.");

    for (String tag : tags) {
      System.out.println(" - processing tag " + tag);
      List<String> distinctQueries = db.getAlignerDistinctQueries(tag);
      System.out.println("  - distinct queries: " + distinctQueries.size());
      for (String query : distinctQueries) {
        List<AlnEntry> alignments = db.getAlignerAlignments(tag, query);
        // System.out.println("    - alignments for: " + query + " " + alignments.size());

        // Collections.sort(alignments, new AlignmentBitScoreComparator());
        Collections.sort(alignments, new AlignmentSimilarityComparator());

        AlnEntry topHit = alignments.get(alignments.size() - 1);
        // AlnEntry lastHit = alignments.get(0);
        // System.out.println("      - top hit: " + topHit.getQuery_id() + ", score: "
        // + topHit.getScore() + ", similarity: " + topHit.getIdentity());
        // System.out.println("      - last hit: " + lastHit.getQuery_id() + ", score: "
        // + lastHit.getScore() + ", similarity: " + lastHit.getIdentity());
        bw.write(topHit.toString() + CR);
        alignments = null;
      }
      db.getSession().clearCache();

    }
    bw.close();

  }

}
