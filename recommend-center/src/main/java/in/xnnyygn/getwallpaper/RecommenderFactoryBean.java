package in.xnnyygn.getwallpaper;

import org.apache.mahout.cf.taste.impl.recommender.GenericItemBasedRecommender;
import org.apache.mahout.cf.taste.impl.similarity.PearsonCorrelationSimilarity;
import org.apache.mahout.cf.taste.model.DataModel;
import org.apache.mahout.cf.taste.recommender.Recommender;
import org.apache.mahout.cf.taste.similarity.ItemSimilarity;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.annotation.Autowired;

public class RecommenderFactoryBean implements FactoryBean<Recommender> {

  private AutoRefreshableRemoteDataModelWrapper dataModelWrapper;

  @Override
  public Recommender getObject() throws Exception {
    DataModel dataModel = dataModelWrapper.getDataModel();
    ItemSimilarity similarity = new PearsonCorrelationSimilarity(dataModel);
    return new GenericItemBasedRecommender(dataModel, similarity);
  }

  @Override
  public Class<? extends Recommender> getObjectType() {
    return Recommender.class;
  }

  @Override
  public boolean isSingleton() {
    return true;
  }

  @Autowired
  public void setDataModelWrapper(
      AutoRefreshableRemoteDataModelWrapper dataModelWrapper) {
    this.dataModelWrapper = dataModelWrapper;
  }

}
