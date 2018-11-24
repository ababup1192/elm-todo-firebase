package gradle.cucumber;

import cucumber.api.PendingException;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import static junit.framework.TestCase.assertTrue;


public class BasicStepDefs {

    WebDriver driver = null;

    @Given("^TODO アプリを開き$")
    public void TODO_アプリを開き() throws Throwable {
        System.setProperty("webdriver.chrome.driver", "Driver/chromedriver");
        driver = new ChromeDriver();
        driver.get("http://localhost:8080/");
    }

    @When("^オートフォーカスされている入力フォームに、\"([^\"]*)\"と入力し、$")
    public void オートフォーカスされている入力フォームに_と入力し(String newTodoContent) throws Throwable {
        final WebElement newTodoInput = driver.switchTo().activeElement();
        newTodoInput.sendKeys(newTodoContent);
    }

    @When("^エンターキーを押すと$")
    public void エンターキーを押すと() throws Throwable {
        Thread.sleep(1000);
        final WebElement newTodoInput = driver.switchTo().activeElement();
        newTodoInput.sendKeys(Keys.ENTER);
    }

    @Then("^入力フォームから入力内容は消える$")
    public void 入力フォームから入力内容は消える() throws Throwable {
        Thread.sleep(1000);
        final WebElement newTodoInput = driver.switchTo().activeElement();
        System.out.println(newTodoInput.getAttribute("value"));
        assertTrue(newTodoInput.getAttribute("value").isEmpty());
        driver.quit();
    }
}
