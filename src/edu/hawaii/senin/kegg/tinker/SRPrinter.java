package edu.hawaii.senin.kegg.tinker;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map.Entry;
import java.util.concurrent.Callable;
import java.util.concurrent.CompletionService;
import java.util.concurrent.ExecutorCompletionService;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import org.slf4j.LoggerFactory;
import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import edu.hawaii.senin.kegg.db.KEGGDB;
import edu.hawaii.senin.kegg.db.KEGGDBManager;
import edu.hawaii.senin.kegg.persistence.HitTag;
import edu.hawaii.senin.kegg.persistence.KODescription;
import edu.hawaii.senin.kegg.persistence.MapTitle;
import edu.hawaii.senin.util.StackTrace;

public class SRPrinter {

  // num of threads to use
  //
  private static final int THREADS_NUM = 5;

  private static final String OUTFNAME = "test_SR_ext_threaded2.csv";

  private static final String COMMA = "\t";

  private static final String CR = "\n";

  private static KEGGDB db;

  private static Logger consoleLogger;
  private static Level LOGGING_LEVEL = Level.INFO;

  static {
    consoleLogger = (Logger) LoggerFactory.getLogger(SRPrinter.class);
    consoleLogger.setLevel(LOGGING_LEVEL);
  }

  public static void main(String[] args) throws Exception {

    db = KEGGDBManager.getProductionInstance();

    LinkedHashMap<HitTag, HashMap<String, Integer>> counts = new LinkedHashMap<HitTag, HashMap<String, Integer>>();
    LinkedHashMap<HitTag, HashMap<String, String>> organisms = new LinkedHashMap<HitTag, HashMap<String, String>>();

    List<HitTag> tags = db.getHitTags();

    // oxidizers
    //
    int ctr = 0;
    for (HitTag tag : tags) {
      consoleLogger.info("processing tag " + tag.getId() + ", " + tag.getTag_description());

      Integer tagIdx = tag.getId();

      HashMap<String, Integer> tagRes = db.getKoSummarySR(tagIdx);

      counts.put(tag, tagRes);

      // ctr++;
      // if (ctr > 2) {
      // break;
      // }

    }

    // all the unique KOs
    StringBuffer header = new StringBuffer();
    LinkedHashSet<String> kos = new LinkedHashSet<String>();
    for (Entry<HitTag, HashMap<String, Integer>> e : counts.entrySet()) {
      header.append(e.getKey().getTag_description()).append(COMMA).append("top_organism_for_")
          .append(e.getKey().getTag_description()).append(COMMA);
      for (Entry<String, Integer> ei : e.getValue().entrySet()) {
        kos.add(ei.getKey());
      }
    }

    // threading setup
    //
    ExecutorService executorService = Executors.newFixedThreadPool(THREADS_NUM);
    CompletionService<HashMap<String, Object>> completionService = new ExecutorCompletionService<HashMap<String, Object>>(
        executorService);
    int totalTaskCounter = 0;

    // getting tops
    //
    for (Entry<HitTag, HashMap<String, Integer>> e : counts.entrySet()) {
      for (Entry<String, Integer> ei : e.getValue().entrySet()) {
        SRCountJob job = new SRCountJob(db, e.getKey().getId(), ei.getKey());
        completionService.submit((Callable<HashMap<String, Object>>) job);
        totalTaskCounter++;
      }
    }

    // waiting for completion, shutdown pool disabling new tasks from being submitted
    executorService.shutdown();
    consoleLogger.info("Submitted " + totalTaskCounter + " jobs, shutting down the pool");

    // waiting for jobs to finish
    //
    //
    try {

      while (totalTaskCounter > 0) {
        //
        // poll with a wait up to FOUR hours
        Future<HashMap<String, Object>> finished = completionService.poll(128, TimeUnit.HOURS);
        if (null == finished) {
          // something went wrong - break from here
          System.err.println("Breaking POLL loop after 128 HOURS of waiting...");
          break;
        }
        else {

          HashMap<String, Object> res = finished.get();

          HitTag tag = (HitTag) res.get("tag");
          String ko_id = (String) res.get("ko_id");

          HashMap<String, String> map = organisms.get(tag);
          if (null == map) {
            map = new HashMap<String, String>();
            organisms.put(tag, map);
          }

          map.put(ko_id, res.get("code") + " | " + res.get("name") + " | " + res.get("lineage")
              + " | " + res.get("cnt"));

          totalTaskCounter--;
        }
      }
      consoleLogger.info("All jobs completed.");

    }
    catch (Exception e) {
      System.err.println("Error while waiting results: " + StackTrace.toString(e));
    }
    finally {
      // wait at least 1 more hour before terminate and fail
      try {
        if (!executorService.awaitTermination(1, TimeUnit.HOURS)) {
          executorService.shutdownNow(); // Cancel currently executing tasks
          if (!executorService.awaitTermination(30, TimeUnit.MINUTES))
            System.err.println("Pool did not terminate... FATAL ERROR");
        }
      }
      catch (InterruptedException ie) {
        System.err.println("Error while waiting interrupting: " + StackTrace.toString(ie));
        // (Re-)Cancel if current thread also interrupted
        executorService.shutdownNow();
        // Preserve interrupt status
        Thread.currentThread().interrupt();
      }

    }

    // output file
    BufferedWriter bw = new BufferedWriter(new FileWriter(new File(OUTFNAME)));
    db.refreshSession();

    // making a table
    bw.write("ko_id" + COMMA + "ko_description" + COMMA + "pathway1" + COMMA + "pathway2" + COMMA
        + "pathway3" + COMMA + "pathway4" + COMMA + "pathway5" + COMMA + "pathway6" + COMMA
        + "pathway7" + COMMA + "pathway8" + COMMA + "pathway9" + COMMA + "pathway10" + COMMA
        + header.delete(header.length() - 1, header.length()).append(CR).toString());
    //
    for (String koId : kos) {
      StringBuffer line = new StringBuffer(koId + COMMA + getKODesc(koId) + COMMA);
      for (Entry<HitTag, HashMap<String, Integer>> e : counts.entrySet()) {
        Integer count = 0;
        String topOrganism = "";
        if (e.getValue().containsKey(koId)) {
          count = e.getValue().get(koId);
          topOrganism = organisms.get(e.getKey()).get(koId);
        }
        line.append(count).append(COMMA).append(topOrganism).append(COMMA);
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
