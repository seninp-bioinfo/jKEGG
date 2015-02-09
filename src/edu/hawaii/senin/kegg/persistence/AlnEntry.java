package edu.hawaii.senin.kegg.persistence;

public class AlnEntry {
  private static final String TAB = "\t";
  private String tag;
  private String query_id;
  private String hit_id;
  private Integer identity;
  private Float score;
  private Integer aln_length;
  private Integer gaps;
  private Float evalue;

  public String getTag() {
    return tag;
  }

  public void setTag(String tag) {
    this.tag = tag;
  }

  public String getQuery_id() {
    return query_id;
  }

  public void setQuery_id(String query_id) {
    this.query_id = query_id;
  }

  public String getHit_id() {
    return hit_id;
  }

  public void setHit_id(String hit_id) {
    this.hit_id = hit_id;
  }

  public Integer getIdentity() {
    return identity;
  }

  public void setIdentity(Integer identity) {
    this.identity = identity;
  }

  public Float getScore() {
    return score;
  }

  public void setScore(Float score) {
    this.score = score;
  }

  public Integer getAln_length() {
    return aln_length;
  }

  public void setAln_length(Integer aln_length) {
    this.aln_length = aln_length;
  }

  public Integer getGaps() {
    return gaps;
  }

  public void setGaps(Integer gaps) {
    this.gaps = gaps;
  }

  public Float getEvalue() {
    return evalue;
  }

  public void setEvalue(Float evalue) {
    this.evalue = evalue;
  }

  @Override
  public String toString() {
    StringBuffer sb = new StringBuffer();
    sb.append(this.tag).append(TAB);
    sb.append(this.query_id).append(TAB);
    sb.append(this.hit_id).append(TAB);
    sb.append(this.identity).append(TAB);
    sb.append(this.score).append(TAB);
    sb.append(this.aln_length).append(TAB);
    sb.append(this.gaps).append(TAB);
    sb.append(this.evalue);
    return sb.toString();
  }

}
