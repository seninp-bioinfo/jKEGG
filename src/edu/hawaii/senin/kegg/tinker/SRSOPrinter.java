package edu.hawaii.senin.kegg.tinker;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map.Entry;
import org.slf4j.LoggerFactory;
import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import edu.hawaii.senin.kegg.db.KEGGDB;
import edu.hawaii.senin.kegg.db.KEGGDBManager;
import edu.hawaii.senin.kegg.persistence.HitTag;
import edu.hawaii.senin.kegg.persistence.KODescription;
import edu.hawaii.senin.kegg.persistence.KOMAP;
import edu.hawaii.senin.kegg.persistence.MapTitle;

public class SRSOPrinter {

  private static final String OUTFNAME = "test.csv";

  private static final String COMMA = "\t";

  private static final String CR = "\n";

  private static KEGGDB db;

  private static Logger consoleLogger;
  private static Level LOGGING_LEVEL = Level.INFO;

  static {
    consoleLogger = (Logger) LoggerFactory.getLogger(SRSOPrinter.class);
    consoleLogger.setLevel(LOGGING_LEVEL);
  }

  public static void main(String[] args) throws Exception {

    db = KEGGDBManager.getProductionInstance();

    LinkedHashMap<HitTag, HashMap<String, Integer>> res = new LinkedHashMap<HitTag, HashMap<String, Integer>>();

    List<HitTag> tags = db.getHitTags();

    // oxidizers
    //
    int ctr = 0;
    for (HitTag tag : tags) {
      consoleLogger.info("processing tag " + tag.getId() + ", " + tag.getTag_description());

      Integer tagIdx = tag.getId();

      HashMap<String, Integer> tagRes = db.getKoSummarySR(tagIdx);

      res.put(tag, tagRes);

      ctr++;
      // if (ctr > 2) {
      // break;
      // }
    }

    BufferedWriter bw = new BufferedWriter(new FileWriter(new File(OUTFNAME)));

    // all the unique KOs
    StringBuffer header = new StringBuffer();
    LinkedHashSet<String> kos = new LinkedHashSet<String>();
    for (Entry<HitTag, HashMap<String, Integer>> e : res.entrySet()) {
      header.append(e.getKey().getTag_description()).append(COMMA);
      for (Entry<String, Integer> ei : e.getValue().entrySet()) {
        kos.add(ei.getKey());
      }
    }

    // making a table
    bw.write("ko_id" + COMMA + "ko_description" + COMMA + "pathway1" + COMMA + "pathway2" + COMMA
        + "pathway3" + COMMA + "pathway4" + COMMA + "pathway5" + COMMA + "pathway6" + COMMA
        + "pathway7" + COMMA + "pathway8" + COMMA + "pathway9" + COMMA + "pathway10" + COMMA
        + header.delete(header.length() - 1, header.length()).append(CR).toString());
    //
    for (String koId : kos) {
      StringBuffer line = new StringBuffer(koId + COMMA + getKODesc(koId) + COMMA);
      for (Entry<HitTag, HashMap<String, Integer>> e : res.entrySet()) {
        Integer count = 0;
        if (e.getValue().containsKey(koId)) {
          count = e.getValue().get(koId);
        }
        line.append(count).append(COMMA);
      }
      bw.write(line.delete(line.length() - 1, line.length()).append(CR).toString());
    }

    bw.close();

  }

  private static String getKODesc(String koId) {

    KODescription koDesc = db.getKO(koId);

    List<MapTitle> koMaps = db.getKOMaps(koDesc.getId());

    return koDesc.getDescription() + COMMA + firstTen(koMaps);
  }

  private static String firstTen(List<MapTitle> koMaps) {
    StringBuffer res = new StringBuffer();
    for (int i = 0; i < 10; i++) {
      String cs = "";
      if (koMaps.size() > i) {
        cs = koMaps.get(i).getTitle();
      }
      res.append(cs).append(COMMA);
    }
    return res.delete(res.length() - 1, res.length()).toString();
  }
}
