using namespace System.Collections.Generic

function Expand-FolderCategory {
    param (
        [Parameter(Mandatory=$true)]
        [string]$examFolderName
    )

    $examFolderNamePrefix = "//a[contains(text(),"
    $examFolderNameSuffix = ")]"
    $examFolderNameXPath = $examFolderNamePrefix + '"' + $examFolderName + '"' + $examFolderNameSuffix
    try {
        Enter-ElementXpathByJavaScript('//*[@class="jstree-icon ui-icon ui-icon-plus"]')
        Write-Host "Clicking to expand folders category"

        Start-Sleep -Seconds 3

        if ($driver.FindElement([OpenQA.Selenium.By]::XPath($ExamFolderNameXPath))) {
            Enter-ElementXPath($ExamFolderNameXPath)
            Write-Host "Entering $ExamFolderName exam folder"
        }
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
        $driver.Navigate().Refresh()
    }
}

function Enter-ITW {
    param (
        [Parameter(Mandatory=$true)]
        [string]$itw,
        [Parameter(Mandatory=$true)]
        [string]$username,
        [Parameter(Mandatory=$true)]
        [SecureString]$password
    )

    Get-URL($itw)
    Set-ElementValueById -elementId 'uname' -value $username
    Set-ElementValueById -elementId 'pass' -value $password
    Enter-ElementIdByJavaScript -elementId 'btnlogin'
    Start-Sleep -Seconds 3
    Enter-ElementXpathByJavaScript('//*[@id="header_headerlinksContent"]/button')
    Start-Sleep -Seconds 3
}