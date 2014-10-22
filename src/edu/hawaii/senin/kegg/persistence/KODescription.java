package edu.hawaii.senin.kegg.persistence;

public class KODescription {

  private Integer id;
  private String ko_id;
  private String description;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getKo_id() {
    return ko_id;
  }

  public void setKo_id(String ko_id) {
    this.ko_id = ko_id;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

}
