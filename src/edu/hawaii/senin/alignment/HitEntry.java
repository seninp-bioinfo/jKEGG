package edu.hawaii.senin.alignment;

public class HitEntry {

  public static final String DELIMETER = "@";

  private String queryName;
  private String subjectName;
  private Double percentIdentities;
  private int alignedLength;
  private int mismatches;
  private int gaps;
  private int queryStart;
  private int queryEnd;
  private int subjectStart;
  private int subjectEnd;
  private Double evalue;
  private int score;

  public HitEntry(String str) {
    // Atribacteria_bacterium_SCGC_AAA255-N14_(SAK_001_136) D325_revised_scaffold92105_1 51.75 143
    // 69 0 46 474 511 83 5e-43 177
    String[] split = str.split("\\t");
    this.queryName = split[0];
    this.subjectName = split[1];
    this.percentIdentities = Double.valueOf(split[2]);
    this.alignedLength = Double.valueOf(split[3]).intValue();
    this.mismatches = Double.valueOf(split[4]).intValue();
    this.gaps = Double.valueOf(split[5]).intValue();
    this.queryStart = Double.valueOf(split[6]).intValue();
    this.queryEnd = Double.valueOf(split[7]).intValue();
    this.subjectStart = Double.valueOf(split[8]).intValue();
    this.subjectEnd = Double.valueOf(split[9]).intValue();
    this.evalue = Double.valueOf(split[10]);
    this.score = Double.valueOf(split[11]).intValue();
  }

  public String getId() {
    return this.queryName.concat(DELIMETER.concat(this.subjectName));
  }

  public String getQueryName() {
    return queryName;
  }

  public void setQueryName(String queryName) {
    this.queryName = queryName;
  }

  public String getSubjectName() {
    return subjectName;
  }

  public void setSubjectName(String subjectName) {
    this.subjectName = subjectName;
  }

  public Double getPercentIdentities() {
    return percentIdentities;
  }

  public void setPercentIdentities(Double percentIdentities) {
    this.percentIdentities = percentIdentities;
  }

  public int getAlignedLength() {
    return alignedLength;
  }

  public void setAlignedLength(int alignedLength) {
    this.alignedLength = alignedLength;
  }

  public int getMismatches() {
    return mismatches;
  }

  public void setMismatches(int mismatches) {
    this.mismatches = mismatches;
  }

  public int getGaps() {
    return gaps;
  }

  public void setGaps(int gaps) {
    this.gaps = gaps;
  }

  public int getQueryStart() {
    return queryStart;
  }

  public void setQueryStart(int queryStart) {
    this.queryStart = queryStart;
  }

  public int getQueryEnd() {
    return queryEnd;
  }

  public void setQueryEnd(int queryEnd) {
    this.queryEnd = queryEnd;
  }

  public int getSubjectStart() {
    return subjectStart;
  }

  public void setSubjectStart(int subjectStart) {
    this.subjectStart = subjectStart;
  }

  public int getSubjectEnd() {
    return subjectEnd;
  }

  public void setSubjectEnd(int subjectEnd) {
    this.subjectEnd = subjectEnd;
  }

  public Double getEvalue() {
    return evalue;
  }

  public void setEvalue(Double evalue) {
    this.evalue = evalue;
  }

  public int getScore() {
    return score;
  }

  public void setScore(int score) {
    this.score = score;
  }

}
