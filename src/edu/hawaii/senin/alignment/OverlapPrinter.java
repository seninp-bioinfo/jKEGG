package edu.hawaii.senin.alignment;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map.Entry;

public class OverlapPrinter {

  public static void main(String[] args) throws IOException {

    // the map like QueryReference - list of entries
    HashMap<String, QueryEntry> overlaps = new HashMap<String, QueryEntry>();

    BufferedReader br = new BufferedReader(new FileReader(new File(
        "/home/psenin/tmp/fm/tblastx_test.out")));

    String str = null;
    while ((str = br.readLine()) != null) {

      // System.out.println(str);

      HitEntry hitEntry = new HitEntry(str);
      QueryEntry existingQueryEntry = overlaps.get(hitEntry.getId());

      if (null == existingQueryEntry) {
        QueryEntry queryEntry = new QueryEntry();
        queryEntry.addHSP(hitEntry);
        overlaps.put(queryEntry.getId(), queryEntry);
      }
      else {
        existingQueryEntry.addHSP(hitEntry);
      }

      // QueryEntry controlEntry = overlaps.get(hitEntry.getId());
      // int[] coverage = controlEntry.getQueryAsCoverageInterval();
      // System.out.println(hitEntry.getId() + ", length " + coverage.length + ": "
      // + Arrays.toString(coverage));

    }
    br.close();

    BufferedWriter bw = new BufferedWriter(new FileWriter(new File(
        "/home/psenin/tmp/fm/tblastx_test.overlaps")));
    System.out.println("subject\tquery\toverlap\tgap");
    
    for (Entry<String, QueryEntry> e : overlaps.entrySet()) {
      
      int[] coverage = e.getValue().getQueryAsCoverageInterval();
      int zeros = 0;
      for (int c : coverage) {
        if (0 == c) {
          zeros++;
        }
      }

      String line = e.getKey().replace(HitEntry.DELIMETER, "\t") + "\t" + coverage.length + "\t"
          + zeros;
      System.out.println(line);
      bw.write(line + "\n");
    }

    bw.close();

  }
}
