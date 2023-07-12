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