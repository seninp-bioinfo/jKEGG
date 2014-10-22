package edu.hawaii.senin.kegg.persistence;

public class HitTag {

  private Integer id;
  private String tag_description;
  private Integer raw_reads;
  private Integer aligned_R1;
  private Integer aligned_R2;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getTag_description() {
    return tag_description;
  }

  public void setTag_description(String tag_description) {
    this.tag_description = tag_description;
  }

  public Integer getRaw_reads() {
    return raw_reads;
  }

  public void setRaw_reads(Integer raw_reads) {
    this.raw_reads = raw_reads;
  }

  public Integer getAligned_R1() {
    return aligned_R1;
  }

  public void setAligned_R1(Integer aligned_R1) {
    this.aligned_R1 = aligned_R1;
  }

  public Integer getAligned_R2() {
    return aligned_R2;
  }

  public void setAligned_R2(Integer aligned_R2) {
    this.aligned_R2 = aligned_R2;
  }

}
