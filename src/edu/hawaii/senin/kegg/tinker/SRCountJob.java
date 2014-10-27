package edu.hawaii.senin.kegg.tinker;

import java.util.HashMap;
import java.util.concurrent.Callable;
import org.apache.ibatis.session.SqlSession;
import edu.hawaii.senin.kegg.db.KEGGDB;
import edu.hawaii.senin.kegg.persistence.HitTag;

public class SRCountJob implements Callable<HashMap<String, Object>> {

  private KEGGDB db;
  private Integer tagId;
  private String koId;

  public SRCountJob(KEGGDB db, Integer id, String key) {
    this.db = db;
    this.tagId = id;
    this.koId = key;
  }

  @Override
  public HashMap<String, Object> call() throws Exception {

    HashMap<String, Object> params = new HashMap<String, Object>();
    params.put("tag_id", this.tagId);
    params.put("ko_id", this.koId);

    SqlSession session = db.getSession();
    HashMap<String, Object> set = session.selectOne("selectTopOrganismSR", params);
    HitTag tag = session.selectOne("selectHitTag", this.tagId);
    session.close();

    set.put("tag", tag);
    set.put("ko_id", this.koId);

    return set;
  }

}
