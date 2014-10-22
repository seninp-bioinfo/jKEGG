package edu.hawaii.senin.kegg.persistence;

public class KEGGHits {

  private Integer tag;
  private String hit_id;
  private Integer organism_idx;
  private Integer gene_idx;
  private Integer identity;
  private Integer score;

  public Integer getTag() {
    return tag;
  }

  public void setTag(Integer tag) {
    this.tag = tag;
  }

  public String getHit_id() {
    return hit_id;
  }

  public void setHit_id(String hit_id) {
    this.hit_id = hit_id;
  }

  public Integer getOrganism_idx() {
    return organism_idx;
  }

  public void setOrganism_idx(Integer organism_idx) {
    this.organism_idx = organism_idx;
  }

  public Integer getGene_idx() {
    return gene_idx;
  }

  public void setGene_idx(Integer gene_idx) {
    this.gene_idx = gene_idx;
  }

  public Integer getIdentity() {
    return identity;
  }

  public void setIdentity(Integer identity) {
    this.identity = identity;
  }

  public Integer getScore() {
    return score;
  }

  public void setScore(Integer score) {
    this.score = score;
  }

}
