/**
 * 
 */
package in.xnnyygn.getwallpaper.webapp;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.mahout.cf.taste.common.TasteException;
import org.apache.mahout.cf.taste.recommender.RecommendedItem;
import org.apache.mahout.cf.taste.recommender.Recommender;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.google.common.collect.ImmutableMap;

/**
 * ITEM CF controller.
 * 
 * @author xnnyygn
 */
@Controller
public class ItemCfController {

  private static final Log logger = LogFactory.getLog(ItemCfController.class);
  private Recommender recommender;

  @RequestMapping("/recommend-wallpaper")
  public void handleRequest(HttpServletRequest request,
      HttpServletResponse response) throws IOException {
    try {
      List<RecommendedItem> items =
          recommender.recommend(getUserId(request), getMax(request));
      render(response, HttpServletResponse.SC_OK, successfulJson(items));
    } catch (IllegalArgumentException e) {
      render(response, HttpServletResponse.SC_BAD_REQUEST,
          failedJson(e.getMessage()));
    } catch (TasteException e) {
      logger.warn("failed to recommend", e);
      render(
          response,
          HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
          failedJson("failed to recommend, nested exception is ["
              + e.getMessage() + "]"));
    }
  }

  private String successfulJson(List<RecommendedItem> items) {
    List<Long> itemIds = new ArrayList<Long>();
    for (RecommendedItem item : items) {
      itemIds.add(item.getItemID());
    }
    return new JSONObject(ImmutableMap.of("success", true, "item_ids", itemIds))
        .toString();
  }

  /**
   * Get user id from request.
   * 
   * @param request request
   * @return user id
   */
  private long getUserId(HttpServletRequest request)
      throws IllegalArgumentException {
    String userIdString = request.getParameter("user_id");

    // user id should not be blank
    if (StringUtils.isBlank(userIdString)) {
      throw new IllegalArgumentException("user id should not be blank");
    }

    try {
      return Long.parseLong(userIdString);
    } catch (NumberFormatException e) {
      throw new IllegalArgumentException("illegal user id, not a number, ["
          + userIdString + "]");
    }
  }

  /**
   * Get max from request. If max is not present, use default max. If max is not
   * a number, use default max. Max should not larger than 100. Default max is
   * 20.
   * 
   * @param request request
   * @return max
   */
  private int getMax(HttpServletRequest request) {
    String maxString = request.getParameter("max");
    if (StringUtils.isNotBlank(maxString)) {
      int max = -1;
      try {
        max = Integer.parseInt(maxString);
      } catch (NumberFormatException e) {
        logger.warn("illegal max [" + maxString + "], use default max");
      }

      if (max > 100) {
        return 100;
      } else if (max > 0) {
        return max;
      }
    }
    // no max, illegal max, max <= 0
    return 20;
  }

  private String failedJson(String reason) {
    return new JSONObject(ImmutableMap.of("success", false, "message", reason))
        .toString();
  }

  private void render(HttpServletResponse response, int statusCode,
      String content) throws IOException {
    response.setStatus(statusCode);
    response.getWriter().write(content);
  }

  @Autowired
  public void setRecommender(Recommender recommender) {
    this.recommender = recommender;
  }

}
