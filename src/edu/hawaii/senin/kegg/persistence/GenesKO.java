package edu.hawaii.senin.kegg.persistence;

public class GenesKO {

  private String ene_id;
  private String ko_id;
  private Integer ko_idx;
  private Integer gene_idx;

  public String getEne_id() {
    return ene_id;
  }

  public void setEne_id(String ene_id) {
    this.ene_id = ene_id;
  }

  public String getKo_id() {
    return ko_id;
  }

  public void setKo_id(String ko_id) {
    this.ko_id = ko_id;
  }

  public Integer getKo_idx() {
    return ko_idx;
  }

  public void setKo_idx(Integer ko_idx) {
    this.ko_idx = ko_idx;
  }

  public Integer getGene_idx() {
    return gene_idx;
  }

  public void setGene_idx(Integer gene_idx) {
    this.gene_idx = gene_idx;
  }

}
