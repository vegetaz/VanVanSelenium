using namespace System.Collections.Generic

function Enter-ITW {
    param (
        [Parameter(Mandatory = $true)]
        [string]$itw,
        [Parameter(Mandatory = $true)]
        [string]$username,
        [Parameter(Mandatory = $true)]
        [SecureString]$securePassword
    )

    Get-URL($itw)    
    $plainTextPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))
    
    try {
        Set-ElementValueById -elementId 'uname' -value $username
        Start-Sleep -Seconds 1
        Set-ElementValueById -elementId 'pass' -value $plainTextPassword
        Start-Sleep -Seconds 1
        Enter-ElementIdByJavaScript -elementId 'btnlogin'
        Start-Sleep -Seconds 5
        Enter-ElementXpathByJavaScript('//*[@id="header_headerlinksContent"]/button')
        Start-Sleep -Seconds 3
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Expand-FolderCategory {
    param (
        [Parameter(Mandatory = $true)]
        [string]$examFolderName
    )

    $examFolderNamePrefix = "//a[contains(text(),"
    $examFolderNameSuffix = ")]"
    $examFolderNameXPath = $examFolderNamePrefix + '"' + $examFolderName + '"' + $examFolderNameSuffix
    
    try {
        if ($driver.FindElement([OpenQA.Selenium.By]::XPath('//*[@id="foldercategory_1"]/ins'))) {
            Enter-ElementId('foldercategory_1')
            Enter-ElementXpath('//*[@class="jstree-icon ui-icon ui-icon-plus"]')
            Write-Host "The Testing folder category expanded!"
        }

        if ($driver.FindElement([OpenQA.Selenium.By]::XPath('//*[@id="foldercategory_4"]/ins'))) {
            Enter-ElementId('foldercategory_4')
            Enter-ElementXpath('//*[@class="jstree-icon ui-icon ui-icon-plus"]')
            Write-Host "The MBS folder category expanded!"
        }

        if ($driver.FindElement([OpenQA.Selenium.By]::XPath('//*[@id="foldercategory_5"]/ins'))) {
            Enter-ElementId('foldercategory_5')
            Enter-ElementXpath('//*[@class="jstree-icon ui-icon ui-icon-plus"]')
            Write-Host "The MTA folder category expanded!"
        }

        if ($driver.FindElement([OpenQA.Selenium.By]::XPath('//*[@id="foldercategory_21"]/ins'))) {
            Enter-ElementId('foldercategory_21')
            # Enter-ElementXpath('//*[@class="jstree-icon ui-icon ui-icon-plus"]')
            Write-Host "The MCP_RoleBased folder category expanded!"
        }

        Start-Sleep -Seconds 3

        if ($driver.FindElement([OpenQA.Selenium.By]::XPath($ExamFolderNameXPath))) {
            Enter-ElementXpath($ExamFolderNameXPath)
            Write-Host "Entering $ExamFolderName exam folder"
        }
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
        $driver.Navigate().Refresh()
    }
}

function Get-ScreenshotITWByFirefox {
    param (
        [Parameter(Mandatory = $true)]
        [string]$locationPathSaveImage,
        [Parameter(Mandatory = $true)]
        [string]$examTarget
    )

    try {
        Set-Location $locationPathSaveImage
        $fileName = Join-Path (Get-Location).Path "$examTarget-Detail.png"
        $screenshot = $driver.GetFullPageScreenshot()
        $screenshotBase64 = $screenshot.AsBase64EncodedString
        [System.IO.File]::WriteAllBytes($fileName, [System.Convert]::FromBase64String($screenshotBase64))
        Write-Host "Successfully taken screenshot for $examTarget" -Verbose
        Start-Sleep -Milliseconds 1000
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Enter-ExamGetScreenshot {
    param (
        [Parameter(Mandatory = $true)]
        [string]$examTarget,
        [Parameter(Mandatory = $true)]
        [string]$locationPathSaveImage
    )
    
    $examTargetPrefix = "//a[contains(text(),"
    $examTargetSuffix = ")]"
    $examTargetXPath = $examTargetPrefix + '"' + $examTarget + '"' + $examTargetSuffix

    try {
        Enter-ElementXpathByJavaScript($examTargetXPath)
        Start-Sleep -Milliseconds 1000
        $driver.Navigate().Refresh()
        Write-Host "Refreshing Web browser to bypass: Browsing context has been discarded"
        Start-Sleep -Milliseconds 1000
        Enter-ElementIdByJavaScript('testDetailTab')
        Start-Sleep -Milliseconds 1000
        Get-ScreenshotITWByFirefox -locationPathSaveImage $locationPathSaveImage -examTarget $examTarget
        Start-Sleep -Milliseconds 1000
        Enter-ElementID('header_folders')
        Start-Sleep -Milliseconds 1000
        if ($driver.FindElement([OpenQA.Selenium.By]::XPath('//iframe[@id="home_iframe"]'))) {
            Switch-ToIframe('home_iframe')
        }
        Start-Sleep -Milliseconds 1000
    }
    catch [OpenQA.Selenium.WebDriverException] {
        Write-Error -Message "$_.Exception.Message"
    }
}

function Enter-ITWGetScreenshot {
    param (
        [Parameter(Mandatory = $true)]
        [string]$itw,
        [Parameter(Mandatory = $true)]
        [string]$username,
        [Parameter(Mandatory = $true)]
        [SecureString]$securePassword,
        [Parameter(Mandatory = $true)]
        [string]$examFolderName,
        [Parameter(Mandatory = $true)]
        [array]$listExams,
        [Parameter(Mandatory = $true)]
        [string]$locationPathSaveImage
    )
    
    Enter-ITW -itw $itw -username $username -securePassword $securePassword
    Expand-FolderCategory -examFolderName $examFolderName
    Switch-ToIframe('home_iframe')
    Start-Sleep -Seconds 1
    Enter-ElementXpath('//*[contains(text(),"Tests")]')
    Start-Sleep -Seconds 5
    foreach ($examTarget in $listExams) {
        Enter-ExamGetScreenshot -examTarget $examTarget -locationPathSaveImage $locationPathSaveImage
    }
    Start-Sleep -Seconds 1
    Write-Host "Take screenshot completed!" -ForegroundColor DarkGreen
    Start-Sleep -Seconds 1
    Stop-WebDriver
    Stop-Process -Name "geckodriver" -Force -ErrorAction SilentlyContinue
    Invoke-Item $locationPathSaveImage
}