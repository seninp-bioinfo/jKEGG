package edu.hawaii.senin.kegg.db;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.slf4j.LoggerFactory;
import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import edu.hawaii.senin.kegg.persistence.HitTag;
import edu.hawaii.senin.kegg.persistence.KODescription;
import edu.hawaii.senin.kegg.persistence.MapTitle;
import edu.hawaii.senin.kegg.persistence.OrganismOfInterest;

/**
 * Implements database mapper.
 * 
 * @author psenin
 * 
 */
public class KEGGDB {

  /** The mapper instance key. */
  public static final String PRODUCTION_INSTANCE = "production";

  /** The db configuration constants. */
  private static final String STACK_DB_CONFIGNAME = "mybatis-funnymat.xml";
  private static final String STACK_DB_ENVIRONMENT = "production_pooled";

  /** Test database SQL factory. */
  private SqlSessionFactory sessionFactory;

  @SuppressWarnings("unused")
  private String instanceType;

  /** Mapper config file location. */
  private String dbConfigFileName;
  private String dbEnvironmentKey;

  // the session
  private SqlSession session;

  private static Logger consoleLogger;
  private static Level LOGGING_LEVEL = Level.INFO;

  static {
    consoleLogger = (Logger) LoggerFactory.getLogger(KEGGDB.class);
    consoleLogger.setLevel(LOGGING_LEVEL);
  }

  /**
   * Constructor.
   * 
   * @param isTestInstance The test instance semaphore.
   * @throws IOException if error occurs.
   */
  protected KEGGDB(String instanceType) throws IOException {
    this.instanceType = instanceType;
    initialize();
  }

  /**
   * Lazy initialization, takes care about set-up.
   * 
   * @throws IOException if error occurs.
   */
  private void initialize() throws IOException {

    this.dbConfigFileName = STACK_DB_CONFIGNAME;
    this.dbEnvironmentKey = STACK_DB_ENVIRONMENT;

    consoleLogger.info("Getting connected to the database, myBATIS config: " + dbConfigFileName
        + ", environment key: " + dbEnvironmentKey);

    // do check for the file existence
    //

    InputStream in = this.getClass().getClassLoader().getResourceAsStream(this.dbConfigFileName);
    if (null == in) {
      throw new RuntimeException("Unable to locate " + this.dbConfigFileName);

    }

    // proceed with configuration
    //
    this.sessionFactory = new SqlSessionFactoryBuilder().build(in, this.dbEnvironmentKey);

    this.session = this.sessionFactory.openSession(ExecutorType.REUSE);

    consoleLogger.info("Connected to database.");

  }

  /**
   * Get the session factory used.
   * 
   * @return The session factory used in this instance.
   */
  public synchronized SqlSessionFactory getSessionFactory() {
    return this.sessionFactory;
  }

  /**
   * Get the session.
   * 
   * @return The active SQL session.
   */
  public synchronized SqlSession getSession() {
    return this.sessionFactory.openSession();
  }

  /**
   * Commits and closes the open session.
   */
  public synchronized void shutDown() {
    this.session.commit(true);
    this.session.close();
  }

  /**
   * Commit pending transactions.
   */
  public synchronized void commit() {
    this.session.commit(true);
  }

  /**
   * Gets all distinct tags from the DB.
   * 
   * @return list of all distinct tags.
   */
  public List<HitTag> getHitTags() {
    return this.session.selectList("getHitTags");
  }

  /**
   * Gets the list of organisms of interest by their tag.
   * 
   * @param tag The tag.
   * @return the list of organisms that correspond to that tag.
   */
  public List<OrganismOfInterest> getOrganismOfInterest(String tag) {
    return this.session.selectList("getOrganismsOfInterest", tag);
  }

  public HashMap<String, Integer> getKoSummarySR(Integer tag) {
    HashMap<String, Object> params = new HashMap<String, Object>();
    params.put("sample_tag", tag);
    List<HashMap<String, Object>> set = this.session.selectList("getKOsummarySR", params);
    HashMap<String, Integer> res = new HashMap<String, Integer>();
    for (HashMap<String, Object> e : set) {
      res.put((String) e.get("ko_id"), ((Long) e.get("count")).intValue());
    }
    return res;
  }

  public HashMap<String, Integer> getKoSummarySO(Integer tag) {
    HashMap<String, Object> params = new HashMap<String, Object>();
    params.put("sample_tag", tag);
    List<HashMap<String, Object>> set = this.session.selectList("getKOsummarySO", params);
    HashMap<String, Integer> res = new HashMap<String, Integer>();
    for (HashMap<String, Object> e : set) {
      res.put((String) e.get("ko_id"), ((Long) e.get("count")).intValue());
    }
    return res;
  }

  public KODescription getKO(String koId) {
    return session.selectOne("selectKObyName", koId);
  }

  public List<MapTitle> getKOMaps(Integer koIdx) {
    return session.selectList("selectMapsByKO", koIdx);
  }

  public HashMap<String, Object> getTopOrganismSR(String koId, Integer tagId) {
    HashMap<String, Object> params = new HashMap<String, Object>();
    params.put("tag_id", tagId);
    params.put("ko_id", koId);
    HashMap<String, Object> set = session.selectOne("selectTopOrganismSR", params);
    return set;
  }

  public synchronized void refreshSession() {
    this.session = this.sessionFactory.openSession(ExecutorType.REUSE);
  }

}
