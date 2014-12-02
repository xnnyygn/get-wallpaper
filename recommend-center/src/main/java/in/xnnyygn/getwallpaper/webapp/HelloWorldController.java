/**
 * 
 */
package in.xnnyygn.getwallpaper.webapp;

import java.io.PrintWriter;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Hello World Controller. Just print out {@code Hello, world!} message.
 * 
 * @author xnnyygn
 */
@Controller
public class HelloWorldController {

  @RequestMapping("/helloworld")
  public void handleRequest(PrintWriter writer) {
    writer.write("Hello, world!");
  }

}
