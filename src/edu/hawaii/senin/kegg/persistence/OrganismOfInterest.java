package edu.hawaii.senin.kegg.persistence;

public class OrganismOfInterest {

  private String tag;
  private String code;
  private String tnum;
  private Integer organism_idx;
  private String name;
  private String lineage;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getLineage() {
    return lineage;
  }

  public void setLineage(String lineage) {
    this.lineage = lineage;
  }

  public String getTag() {
    return tag;
  }

  public void setTag(String tag) {
    this.tag = tag;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getTnum() {
    return tnum;
  }

  public void setTnum(String tnum) {
    this.tnum = tnum;
  }

  public Integer getOrganism_idx() {
    return organism_idx;
  }

  public void setOrganism_idx(Integer organism_idx) {
    this.organism_idx = organism_idx;
  }

}
