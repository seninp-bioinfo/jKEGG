package edu.hawaii.senin.kegg.persistence;

public class KoOfInteest {

  private Integer id;
  private Integer ko_idx;
  private String ko_id;
  private String tag;
  private String description;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Integer getKo_idx() {
    return ko_idx;
  }

  public void setKo_idx(Integer ko_idx) {
    this.ko_idx = ko_idx;
  }

  public String getKo_id() {
    return ko_id;
  }

  public void setKo_id(String ko_id) {
    this.ko_id = ko_id;
  }

  public String getTag() {
    return tag;
  }

  public void setTag(String tag) {
    this.tag = tag;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

}
