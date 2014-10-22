package edu.hawaii.senin.kegg.tinker;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import org.slf4j.LoggerFactory;
import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import edu.hawaii.senin.kegg.db.KEGGDB;
import edu.hawaii.senin.kegg.db.KEGGDBManager;
import edu.hawaii.senin.kegg.persistence.HitTag;
import edu.hawaii.senin.kegg.persistence.OrganismOfInterest;

public class SRSOPrinter {

  private static final String SULFATE_OXIDIZERS = "sulfur_cycle_SO";

  private static KEGGDB db;

  private static Logger consoleLogger;
  private static Level LOGGING_LEVEL = Level.INFO;

  static {
    consoleLogger = (Logger) LoggerFactory.getLogger(SRSOPrinter.class);
    consoleLogger.setLevel(LOGGING_LEVEL);
  }

  public static void main(String[] args) throws Exception {

    db = KEGGDBManager.getProductionInstance();

    List<HitTag> tags = db.getHitTags();

    // oxidizers
    //
    Map<String, Integer> res = db.getKoSummary(1, SULFATE_OXIDIZERS);

    for (Entry<String, Integer> e : res.entrySet()) {
      System.out.println(e.getKey() + " -> " + e.getValue());
    }

    // List<OrganismOfInterest> oxidizers = db.getOrganismOfInterest("sulfur_cycle_SO");
    // for (OrganismOfInterest o : oxidizers) {
    // System.out.println(o.getTnum());
    // }

    // reducers
    //
    // List<OrganismOfInterest> reducers = db.getOrganismOfInterest("sulfur_cycle_SR");
    // for (OrganismOfInterest o : reducers) {
    // System.out.println(o.getTnum());
    // }

  }
}
