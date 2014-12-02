package in.xnnyygn.getwallpaper.webapp;

import static org.junit.Assert.assertFalse;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

public class ItemCfControllerTest {

  private ItemCfController controller;

  @Before
  public void setUp() throws Exception {
    controller = new ItemCfController();
  }

  @Test
  public void test() throws IOException, JSONException {
    MockHttpServletRequest request = new MockHttpServletRequest();
    MockHttpServletResponse response = new MockHttpServletResponse();
    controller.handleRequest(request, response);
    JSONObject responseJson = new JSONObject(response.getContentAsString());
    assertFalse(responseJson.getBoolean("success"));
  }

}
