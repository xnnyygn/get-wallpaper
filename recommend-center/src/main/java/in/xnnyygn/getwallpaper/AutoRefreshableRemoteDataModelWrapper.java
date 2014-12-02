package in.xnnyygn.getwallpaper;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.MultiThreadedHttpConnectionManager;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.params.HttpConnectionManagerParams;
import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.mahout.cf.taste.impl.model.file.FileDataModel;
import org.apache.mahout.cf.taste.model.DataModel;

public class AutoRefreshableRemoteDataModelWrapper implements Runnable {

  private static final Log logger = LogFactory
      .getLog(AutoRefreshableRemoteDataModelWrapper.class);
  private String sourceUrl;
  private String filePath;
  private int period = 60;

  private ScheduledFuture<?> task;
  private HttpClient client;
  private DataModel dataModel;

  public void init(boolean autoStartRefreshTask) {
    MultiThreadedHttpConnectionManager httpConnectionManager =
        new MultiThreadedHttpConnectionManager();
    HttpConnectionManagerParams httpConnectionManagerParams =
        new HttpConnectionManagerParams();
    httpConnectionManagerParams.setConnectionTimeout(5000);
    httpConnectionManager.setParams(httpConnectionManagerParams);

    client = new HttpClient(httpConnectionManager);

    if (autoStartRefreshTask) {
      ScheduledExecutorService executorService =
          Executors.newScheduledThreadPool(1);
      task =
          executorService.scheduleAtFixedRate(this, period, period,
              TimeUnit.SECONDS);
    }
  }

  public void destroy() {
    task.cancel(false);
  }

  public void refresh() throws DataModelRefreshException {
    logger.info("refresh data model");

    // refresh file
    GetMethod method = new GetMethod(sourceUrl);
    boolean dataUpdated = false;
    try {
      client.executeMethod(method);
      int statusCode = method.getStatusCode();
      if (statusCode == HttpServletResponse.SC_OK) {
        IOUtils.write(method.getResponseBodyAsString(), new FileOutputStream(
            filePath));
        dataUpdated = true;
      } else {
        logger
            .warn("failed to retreive latest data file, server reply error, status code ["
                + statusCode + "]");
      }
    } catch (IOException e) {
      logger.warn("failed to retrieve latest data file, io error", e);
    } finally {
      method.releaseConnection();
    }

    if (!dataUpdated) return;
    logger.info("reload data model");

    // refresh data model
    if (dataModel == null) {
      try {
        dataModel = new FileDataModel(new File(filePath));
      } catch (IOException e) {
        throw new DataModelRefreshException("failed to load data model", e);
      }
    } else {
      dataModel.refresh(null);
    }
  }

  public DataModel getDataModel() {
    if (dataModel == null) {
      init(true);
      refresh();
    }
    return dataModel;
  }

  @Override
  public void run() {
    refresh();
  }

  public void setFilePath(String filePath) {
    this.filePath = filePath;
  }

  public void setPeriod(int period) {
    this.period = period;
  }

  public void setSourceUrl(String sourceUrl) {
    this.sourceUrl = sourceUrl;
  }

}
