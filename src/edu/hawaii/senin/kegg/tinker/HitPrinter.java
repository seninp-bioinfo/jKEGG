package edu.hawaii.senin.kegg.tinker;

import java.util.List;
import org.slf4j.LoggerFactory;
import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import edu.hawaii.senin.kegg.db.KEGGDB;
import edu.hawaii.senin.kegg.db.KEGGDBManager;
import edu.hawaii.senin.kegg.persistence.HitTag;

public class HitPrinter {

  private static KEGGDB db;

  private static Logger consoleLogger;
  private static Level LOGGING_LEVEL = Level.INFO;

  static {
    consoleLogger = (Logger) LoggerFactory.getLogger(HitPrinter.class);
    consoleLogger.setLevel(LOGGING_LEVEL);
  }

  public static void main(String[] args) throws Exception {

    db = KEGGDBManager.getProductionInstance();

    List<HitTag> tags = db.getHitTags();

    for (HitTag tag : tags) {
      System.out.println(tag.getId() + ": " + tag.getTag_description());
    }

  }
}
