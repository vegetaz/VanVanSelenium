using namespace System.Collections.Generic

function Set-ImplicitWait {
    param(
        [Parameter(Mandatory=$true)]
        [int]$timeoutSeconds
    )

    $driver.Manage().Timeouts().ImplicitWait = [System.TimeSpan]::FromSeconds($timeoutSeconds)
}

function Get-URL {
    param (
        $url
    )
    try {
        $driver.Navigate().GoToUrl($url)
        Write-Host "Opening the $url website" -Verbose
    }
    catch [OpenQA.Selenium.WebDriverException] {
        $driver.Navigate().Refresh()
    }
}

function Set-ElementValueById {
    param(
        [Parameter(Mandatory=$true)]
        [string]$elementId,

        [Parameter(Mandatory=$true)]
        [string]$value
    )

    try {
        $element = $driver.FindElement([OpenQA.Selenium.By]::Id($elementId))
        $element.Clear()
        $element.SendKeys($value)
        Write-Host "Putting the value to $elementId element id."
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Enter-ElementIdByJavaScript {
    param(
        [Parameter(Mandatory=$true)]
        [System.Object]$elementId
    )

    try {
        $script = "document.getElementById('$elementId').click();"
        $driver.ExecuteScript($script)
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Enter-ElementXpathByJavaScript {
    param(
        [Parameter(Mandatory=$true)]
        [System.Object]$elementXpath
    )

    try {
        $script = "document.evaluate(`"$elementXpath`", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();"
        $driver.ExecuteScript($script)
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Switch-ToIframe {
    param(
        [Parameter(Mandatory=$true)]
        [string]$iframeIdOrName
    )

    try {
        $driver.SwitchTo().Frame($IframeIdOrName) | Out-Null
    }
    catch [OpenQA.Selenium.NoSuchElementException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Stop-WebDriver {
    try {
        $driver.Close()
        Write-Host "Closing WebDriver"
    }
    catch [OpenQA.Selenium.NoSuchElementException] {
        Write-Error -Message "$_.Exception.Message"
    }
    finally {
        $driver.Quit()
        $driver.Dispose()
    }
}