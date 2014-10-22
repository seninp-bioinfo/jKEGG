package edu.hawaii.senin.kegg.persistence;

public class KOMAP {

  private String ko_id;
  private String map_id;
  private Integer ko_idx;
  private Integer map_idx;

  public String getKo_id() {
    return ko_id;
  }

  public void setKo_id(String ko_id) {
    this.ko_id = ko_id;
  }

  public String getMap_id() {
    return map_id;
  }

  public void setMap_id(String map_id) {
    this.map_id = map_id;
  }

  public Integer getKo_idx() {
    return ko_idx;
  }

  public void setKo_idx(Integer ko_idx) {
    this.ko_idx = ko_idx;
  }

  public Integer getMap_idx() {
    return map_idx;
  }

  public void setMap_idx(Integer map_idx) {
    this.map_idx = map_idx;
  }

}
