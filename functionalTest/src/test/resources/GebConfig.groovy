import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.firefox.FirefoxDriver
import org.openqa.selenium.remote.DesiredCapabilities
import org.openqa.selenium.remote.RemoteWebDriver

environments {
    chrome {
        driver = {
            new ChromeDriver()
        }
    }

    firefox {
        driver = {
            new FirefoxDriver()
        }
    }

    grid_chrome {
        driver = {
            new RemoteWebDriver(new URL(System.getProperty("geb.build.hubUrl").toString()), DesiredCapabilities.chrome())
        }
    }

    grid_firefox {
        driver = {
            new RemoteWebDriver(new URL(System.getProperty("geb.build.hubUrl").toString()), DesiredCapabilities.firefox())
        }
    }
}

waiting {
    timeout = 15
    retryInterval = 1
}

atCheckWaiting = true
baseNavigatorWaiting = true
