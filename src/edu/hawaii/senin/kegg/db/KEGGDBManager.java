package edu.hawaii.senin.kegg.db;

import java.io.IOException;
import org.slf4j.LoggerFactory;
import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;

/**
 * Manages StackDB instances preventing multiple objects instantiation.
 * 
 * @author psenin
 * 
 */
public class KEGGDBManager {

  private static KEGGDB productionInstance;

  /**
   * Get production DB instance.
   * 
   * @return production DB instance.
   * @throws IOException if error occurs.
   */
  public static KEGGDB getProductionInstance() throws IOException {
    
    org.apache.ibatis.logging.LogFactory.useSlf4jLogging();
    
    Logger logger = (Logger) LoggerFactory
        .getLogger(org.apache.ibatis.datasource.pooled.PooledDataSource.class);
    logger.setLevel(Level.ERROR);

    if (null == productionInstance) {
      productionInstance = new KEGGDB(KEGGDB.PRODUCTION_INSTANCE);
    }
    return productionInstance;
  }

}
