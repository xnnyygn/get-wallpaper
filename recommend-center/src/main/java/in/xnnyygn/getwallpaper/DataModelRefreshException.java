package in.xnnyygn.getwallpaper;

public class DataModelRefreshException extends RuntimeException {

  private static final long serialVersionUID = -1638207920310441186L;

  public DataModelRefreshException() {
  }

  public DataModelRefreshException(String message) {
    super(message);
  }

  public DataModelRefreshException(Throwable throwable) {
    super(throwable);
  }

  public DataModelRefreshException(String message, Throwable throwable) {
    super(message, throwable);
  }

}
