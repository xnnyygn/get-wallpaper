package in.xnnyygn.getwallpaper;

import java.io.File;

import org.junit.Before;
import org.junit.Test;

public class AutoRefreshableRemoteDataModelWrapperTest {

  private AutoRefreshableRemoteDataModelWrapper wrapper =
      new AutoRefreshableRemoteDataModelWrapper();

  @Before
  public void setUp() throws Exception {
    // wrapper.setFilePath(new File(System.getProperty("java.io.tmpdir"),
    // "p.dat")
    // .getAbsolutePath());
    wrapper.setFilePath("/tmp/p.dat");
    wrapper.setSourceUrl("http://localhost:3000/wallpapers/preferences");
    wrapper.init(false);
  }

  @Test
  public void testRefresh() {
    wrapper.refresh();
    wrapper.refresh();
  }

}
