# VanVanSelenium
Van Van Nguyen Selenium PowerShell Script = VanVanSelenium = Vans

## Example
```
# Your working directory
$workingPath = '..\testSPS'

[System.Reflection.Assembly]::LoadFrom("$($workingPath)\WebDriver.dll")
[System.Reflection.Assembly]::LoadFrom("$($workingPath)\WebDriver.Support.dll")

# Get Vans script from GitHub
$scriptVans = Invoke-WebRequest 'https://raw.githubusercontent.com/vegetaz/VanVanSelenium/master/Vans.psm1'
Invoke-Expression $($scriptVans.Content)

$options = New-Object OpenQA.Selenium.Firefox.FirefoxOptions
$driver = New-Object OpenQA.Selenium.Firefox.FirefoxDriver($options)
$driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds(29)

# Launch a browser and go to URL
# $driver.Navigate().GoToURL('https://powershell.org')
Get-URL -url "https://powershell.org"
```