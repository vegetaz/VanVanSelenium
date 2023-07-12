using namespace System.Collections.Generic

function Set-ImplicitWait {
    param(
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.Internal.PSObject]$driver,

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

function Enter-ElementIdByJavaScript {
    param(
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.Internal.PSObject]$driver,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.Internal.PSObject]$elementId
    )

    $script = "arguments[0].click();"
    $driver.ExecuteScript($script, @($elementId))
}

function Enter-ElementXpathByJavaScript {
    param(
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.Internal.PSObject]$driver,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.Internal.PSObject]$elementXpath
    )

    $script = "arguments[0].click();"
    $driver.ExecuteScript($script, @($elementXpath))
}

function Stop-WebDriver {
    param(
        [Parameter(Mandatory=$true)]
        [System.Object]$driver
    )

    $driver.Quit()
    Write-Host "Closing WebDriver"
    $driver.Dispose()
}