package edu.hawaii.senin.kegg.persistence;

public class GenesDescription {

  private Integer id;
  private String gene_id;
  private Integer organism_idx;
  private String description;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getGene_id() {
    return gene_id;
  }

  public void setGene_id(String gene_id) {
    this.gene_id = gene_id;
  }

  public Integer getOrganism_idx() {
    return organism_idx;
  }

  public void setOrganism_idx(Integer organism_idx) {
    this.organism_idx = organism_idx;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

}
