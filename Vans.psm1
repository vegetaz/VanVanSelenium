using namespace System.Collections.Generic

<#
Approved Verbs for PowerShell Commands
https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-5.1
#>

<# function Set-WebBrowser {
    param (
        [Parameter(Mandatory = $true)]
        [string]$webBrowser
    )

    try {
        switch ($webBrowser) {
            'Chrome' { 
                $options = New-Object OpenQA.Selenium.Chrome.ChromeOptions
                $driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($options)
            }
            'Firefox' {
                $options = New-Object OpenQA.Selenium.Firefox.FirefoxOptions
                $driver = New-Object OpenQA.Selenium.Firefox.FirefoxDriver($options)
            }
            Default {
                $options = New-Object OpenQA.Selenium.Chrome.ChromeOptions
                $driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($options)
            }
        } 
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
} #>

function Set-ImplicitWait {
    param(
        [Parameter(Mandatory = $true)]
        [int]$timeoutSeconds
    )

    $driver.Manage().Timeouts().ImplicitWait = [System.TimeSpan]::FromSeconds($timeoutSeconds)
}

function Get-URL {
    param (
        [Parameter(Mandatory = $true)]
        [string]$url
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
        [Parameter(Mandatory = $true)]
        [string]$elementId,

        [Parameter(Mandatory = $true)]
        [string]$value
    )

    try {
        $element = $driver.FindElement([OpenQA.Selenium.By]::Id($elementId))
        $element.Clear()
        Write-Host "Putting the value to $elementId element id"
        $element.SendKeys($value)        
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Send-KeysToElement {
    param (
        [Parameter(Mandatory = $true)]
        [System.Object]$elementXpath,

        [Parameter(Mandatory = $true)]
        [string]$value
    )
    
    try {
        $driver.FindElement([OpenQA.Selenium.By]::XPath($elementXpath)).Clear()
        Start-Sleep -Seconds 1
        $driver.FindElement([OpenQA.Selenium.By]::XPath($elementXpath)).SendKeys($value)
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Enter-ElementId {
    param (
        [Parameter(Mandatory = $true)]
        [System.Object]$elementId
    )
    
    try {
        $element = $driver.FindElement([OpenQA.Selenium.By]::ID($elementId))
        $element.Click()
        Write-Host "Clicking to $elementId element Id"
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Wait-EnterElementId {
    param (
        [Parameter(Mandatory = $true)]
        [int]$timeOut,
        [Parameter(Mandatory = $true)]
        [string]$elementId
    )

    $wait = New-Object OpenQA.Selenium.Support.UI.WebDriverWait($driver, [TimeSpan]::FromSeconds($timeOut))
    $condition = {
        param($driver)
        $element = $driver.FindElement([OpenQA.Selenium.By]::ID($elementId))
        if ($element.Displayed) {
            Start-Sleep -Seconds 3
            return $true
        }
        else {
            return $false
        }
    }

    # Wait for the element to be displayed
    $wait.Until([System.Func[Object, Boolean]]$condition) | Out-Null

    # Perform some action on the element
    try {
        $element = $driver.FindElement([OpenQA.Selenium.By]::ID($elementId))
        $element.Click()
        Write-Host "Clicking to $elementId element Id"
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Enter-ElementIdByJavaScript {
    param(
        [Parameter(Mandatory = $true)]
        [System.Object]$elementId
    )

    try {
        $script = "document.getElementById('$elementId').click();"
        Write-Host "Clicking to $elementId element id"
        $driver.ExecuteScript($script)
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Enter-ElementXpath {
    param (
        [Parameter(Mandatory = $true)]
        [System.Object]$elementXpath
    )
    
    try {
        $element = $driver.FindElement([OpenQA.Selenium.By]::XPath($elementXpath))
        $element.Click()
        Write-Host "Clicking to $elementXpath element Xpath"
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Enter-ElementXpathByJavaScript {
    param(
        [Parameter(Mandatory = $true)]
        [System.Object]$elementXpath
    )

    try {
        $script = "document.evaluate('$elementXpath', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();"
        Write-Host "Clicking to $elementXpath element xpath"
        $driver.ExecuteScript($script)
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Switch-ToIframe {
    param(
        [Parameter(Mandatory = $true)]
        [string]$iframeIdOrName
    )

    try {
        $driver.SwitchTo().Frame($IframeIdOrName) | Out-Null
        Write-Host "Switching to $iframeIdOrName iframe"
    }
    catch [OpenQA.Selenium.NoSuchElementException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Switch-ToDefaultContent {
    try {
        $driver.SwitchTo().DefaultContent() | Out-Null
        Write-Host "Switching to default content"
    }
    catch [OpenQA.Selenium.NoSuchElementException] {
        Write-Error -Message "$_.Exception.Message"
    }    
}

function Get-ScreenshotWithHighlight {
    param (
        [Parameter(Mandatory = $true)]
        [System.Object]$driver,
        [Parameter(Mandatory = $true)]
        [string]$elementXpath,
        [Parameter(Mandatory = $true)]
        [string]$locationPathSaveImage
    )
    
    $element = $driver.FindElement([OpenQA.Selenium.By]::XPath($elementXpath))
    # Store the original style of the element
    $originalStyle = $element.GetAttribute("style")
    # Add a red dashed border to the element
    $driver.ExecuteScript("arguments[0].setAttribute('style', arguments[1]);", $element, "border: 2px solid red; border-style: dashed;")
    try {
        Set-Location $locationPathSaveImage
        $fileName = Join-Path (Get-Location).Path "_ScreenshotWithHighlight_.png"
        $screenshot = $driver.GetScreenshot()
        $screenshot.SaveAsFile($fileName, [OpenQA.Selenium.ScreenshotImageFormat]::Png)
        Write-Host -ForegroundColor DarkGreen "Successfully taken screenshot with highlight"
        Start-Sleep -Milliseconds 1000
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
    # Restore the original style of the element
    $driver.ExecuteScript("arguments[0].setAttribute('style', arguments[1]);", $element, $originalStyle)
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