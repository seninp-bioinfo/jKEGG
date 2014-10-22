package edu.hawaii.senin.kegg.persistence;

public class Organism {

  private Integer id;
  private String code;
  private String tnum;
  private String name;
  private String lineage;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
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

}
