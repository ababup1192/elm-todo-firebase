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

import java.util.List;

import static junit.framework.TestCase.assertEquals;
import static junit.framework.TestCase.assertTrue;


public class BasicStepDefs {

    WebDriver driver = null;

    @Given("^TODO アプリを開く$")
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

    @When("^エンターキーを押し$")
    public void エンターキーを押すと() throws Throwable {
        final WebElement newTodoInput = driver.switchTo().activeElement();

        Thread.sleep(1000);

        newTodoInput.sendKeys(Keys.ENTER);
    }

    @When("^新しく追加されたタスクアイテムにチェックを入れる$")
    public void 新しく追加されたタスクアイテムにチェックを入れる() throws Throwable {
        final List<WebElement> todoList = driver.findElements(By.cssSelector("ul.todo-list > li"));
        final WebElement lastListItem = todoList.get(todoList.size() - 1);
        final WebElement toggle = lastListItem.findElement(By.tagName("input"));

        toggle.click();
    }

    @Then("^すると、TODOリストは空である$")
    public void TODOリストは空である() throws Throwable {
        final List<WebElement> todoList = driver.findElements(By.cssSelector("ul.todo-list > li"));

        assertEquals(0, todoList.size());
        driver.quit();
    }

    @Then("^フッターは空である$")
    public void フッターは空である() throws Throwable {
        final WebElement footer = driver.findElement(By.cssSelector("footer.footer"));

        assertTrue(!footer.isDisplayed());
        driver.quit();
    }

    @Then("^すると、入力フォームから入力内容は消える$")
    public void 入力フォームから入力内容は消える() throws Throwable {
        final WebElement newTodoInput = driver.switchTo().activeElement();

        Thread.sleep(1000);

        assertEquals("", newTodoInput.getAttribute("value"));
        driver.quit();
    }

    @Then("^すると、TODOリストの最後に、内容が\"([^\"]*)\"のActiveなタスクが追加される$")
    public void TODOリストの最後に_内容が_のActiveなタスクが追加される(String newTodoContent) throws Throwable {
        final List<WebElement> todoList = driver.findElements(By.cssSelector("ul.todo-list > li"));
        final WebElement lastListItem = todoList.get(todoList.size() - 1);
        final WebElement itemCheckbox = lastListItem.findElement(By.tagName("input"));
        final WebElement itemLabel = lastListItem.findElement(By.tagName("label"));

        final String expected = "li-class=\"\", input-checked=null, label-text=\"" + newTodoContent + "\"";
        final String actual =
                "li-class=\"" + lastListItem.getAttribute("class") + "\", " +
                        "input-checked=" + itemCheckbox.getAttribute("checked") + ", " +
                        "label-text=\"" + itemLabel.getText() + "\"";

        Thread.sleep(1000);

        assertEquals(expected, actual);
        driver.quit();
    }

    @Then("^すると、TODOリストの最後に、内容が\"([^\"]*)\"のまま、取り消し線が入る$")
    public void すると_TODOリストの最後に_内容が_のまま_取り消し線が入る(String newTodoContent) throws Throwable {
        final List<WebElement> todoList = driver.findElements(By.cssSelector("ul.todo-list > li"));
        final WebElement lastListItem = todoList.get(todoList.size() - 1);
        final WebElement itemCheckbox = lastListItem.findElement(By.tagName("input"));
        final WebElement itemLabel = lastListItem.findElement(By.tagName("label"));

        final String expected = "li-class=\"completed\", input-checked=true, label-text=\"" + newTodoContent + "\"";
        final String actual =
                "li-class=\"" + lastListItem.getAttribute("class") + "\", " +
                        "input-checked=" + itemCheckbox.getAttribute("checked") + ", " +
                        "label-text=\"" + itemLabel.getText() + "\"";

        Thread.sleep(1000);

        assertEquals(expected, actual);
        driver.quit();
    }


}
