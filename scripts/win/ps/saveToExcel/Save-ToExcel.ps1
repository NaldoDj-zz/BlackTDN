<#
.SYNOPSIS
Save Powershell output objects as Excel file.
.DESCRIPTION
Save Powershell cmdlet output objects as Excel file.
In order to overcome performance issue of writting to Excel row by row in Powershell.
This function uses trick to improve performance and that is to save Powershell objects from pipe into temporary .csv file first and later to use that file to create and format Excel file fast.
.PARAMETER InputObject
Any object that will be saved as Excel file. Send through PowerShell pipeline.
.PARAMETER ExcelFileName
Prefix of Excel file name. File name has Time stamp at the and in name with date and time.
.PARAMETER title
Title property of Excel workbook.
.PARAMETER author
Author property of Excel woorkbook.
.PARAMETER WorkSheetName
Name of Excel Worksheet.
.PARAMETER errorlog
write to error log or not.
.PARAMETER client
OK - O client
BK - B client
.PARAMETER solution
FIN - Financial 
HR - Humane Resource 
.PARAMETER sendemail
Turns on or off sending of emails from this CmdLet.
.EXAMPLE
Get-OSInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Save-ToExcel -ExcelFileName "OS_Info" -title "OS Info for servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "OS Info" -client "OK" -solution "FIN" 
.EXAMPLE
Get-Printer -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Save-ToExcel -ExcelFileName "Printers_With_Error" -title "Printers with errors on servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "Printers with errors" -client "OK" -solution "FIN" 
.EXAMPLE
Get-Printer -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Save-ToExcel -ExcelFileName "Printers_With_Error" -title "Printers with errors on servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "Printers with errors" -sendemail -client "OK" -solution "FIN" 
.EXAMPLE
Get-DiskFreeSpace -filename "OKFINservers.txt" -client "OK" -solution "FIN" -Verbose -errorlog | Save-ToExcel -ExcelFileName "Free_disk_space" -title "Free disk space on servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "Free disk space" -sendemail -client "OK" -solution "FIN" 
.EXAMPLE
Get-ErrorFromEventLog -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -days 3 -Verbose | Save-ToExcel -ExcelFileName "Get-ErrorsInEventLogs" -title "Get errors from Event Logs on servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "Errors from Event Logs" -sendemail -client "OK" -solution "FIN" 
.EXAMPLE
Get-ErrorFromEventLog -filename "OKFINkursservers.txt" -errorlog -client "OK" -solution "FIN" -days 3 -Verbose | Save-ToExcel -ExcelFileName "Get-ErrorsInEventLogs" -title "Get errors from Event Logs on servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "Errors from Event Logs" -client "OK" -solution "FIN" 

.INPUTS
System.Management.Automation.PSCustomObject

InputObjects parameter pipeline both by Value and by Property Name value. 

.OUTPUTS
System.Boolen

.NOTES
FunctionName : Save-ToExcel
Created by   : Dejan Mladenovic
Date Coded   : 10/31/2018 19:06:41
More info    : https://improvescripting.com/

.LINK 
Export-Csv
New-Object -ComObject
#>
Function Save-ToExcel {
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true,
                ValueFromPipeline=$true, 
                HelpMessage="Input rows to be saved as Excel file.")] 
    [PSobject[]]$InputObject,
    
    [Parameter(Mandatory=$true, 
                HelpMessage="Excel file name.")]
    [string]$ExcelFileName,
    
    [Parameter(Mandatory=$true, 
                HelpMessage="Excel workbook title.")]
    [string]$title,
    
    [Parameter(Mandatory=$true, 
                HelpMessage="Excel workbook author.")]
    [string]$author,
    
    [Parameter(Mandatory=$true, 
                HelpMessage="Excel worksheet name.")]
    [string]$WorkSheetName,
    
    [Parameter(HelpMessage="Write to error log file or not.")]
    [switch]$errorlog,
    
    [Parameter( HelpMessage="Send email.")]
    [switch]$sendemail,
    
    [Parameter(Mandatory=$true, 
                HelpMessage="Client for example OK = O client, BK = B client")]
    [string]$client,
     
    [Parameter(Mandatory=$true,
                HelpMessage="Solution, for example FIN = Financial solution, HR = Humane Resource solution")]
    [string]$solution
    
    
)
BEGIN { 
    
    #Creat an empty array
    $objects = @()

    $reportsfolder = "$home\Documents\PSreports"
        
        if  ( !( Test-Path -Path $reportsfolder -PathType "Container" ) ) {
            
            Write-Verbose "Create reports folder in: $reportsfolder"
            New-Item -Path $reportsfolder -ItemType "Container" -ErrorAction Stop
        }
        
}
PROCESS { 

    $objects += $InputObject
    
}
END { 

    $date = Get-Date -UFormat "%Y-%m-%d_%H-%M-%S"

    $excelFile = "$home\Documents\PSreports\$ExcelFileName" + "-" + "$client" + "-" + "$solution" + "-" + $date + ".xlsx"

    try {
        
        #Write Excel file only if there are some Input objects!!!!!
        if ( $objects ) {

            [System.Threading.Thread]::CurrentThread.CurrentCulture = "en-US"

            #Temporary .csv file with GUID name has been created first.
            $temporaryCsvFile = ($env:temp + "\" + ([System.Guid]::NewGuid()).ToString() + ".csv") 
            #Delimiter ";" helps that result is parsed correctly. Comma delimiter parses incorrectly.
            $objects | Export-Csv -ErrorAction Stop -path $temporaryCsvFile -noTypeInformation -Delimiter ";"
            Write-Verbose "Temporary csv file saved: $temporaryCsvFile"
        
            $excelObject = New-Object -ComObject Excel.Application -ErrorAction Stop
            Write-Verbose "Excel sheet created."
            $excelObject.Visible = $false    

            $workbookObject = $excelObject.Workbooks.Open($temporaryCsvFile)  
            $workbookObject.Title = ("$title " + (Get-Date -Format D)) 
            $workbookObject.Author = "$author"
        
            $worksheetObject = $workbookObject.Worksheets.Item(1) 
        
            #Method TextToColumns is important to convert .csv file data into right columns in Excel file.
            $colA=$worksheetObject.range("A1").EntireColumn
            $colrange=$worksheetObject.range("A1")
            $xlDelimited = 1
            $xlTextQualifier = 1
            $colA.TextToColumns($colrange,$xlDelimited,$xlTextQualifier,$false,$false,$false,$true)
     
            $worksheetObject.UsedRange.Columns.Autofit() | Out-Null
            $worksheetObject.Name = "$WorkSheetName"
        
            #Style of table in Excel worksheet.
            $xlSrcRange = 1
            $XlYes = 1
            #Syntax - expression.Add(SourceType, Source, LinkSource, HasHeaders, Destination)
            $listObject = $worksheetObject.ListObjects.Add($xlSrcRange, $worksheetObject.UsedRange, $null, $XlYes, $null) 
            $listObject.Name = "User Table"
            $listObject.TableStyle = "TableStyleMedium6" # Style Cheat Sheet in French/English: http://msdn.microsoft.com/fr-fr/library/documentformat.openxml.spreadsheet.tablestyle.aspx   

            $workbookObject.SaveAs($excelFile,51) # http://msdn.microsoft.com/en-us/library/bb241279.aspx 
            $workbookObject.Saved = $true
            $workbookObject.Close() 
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbookObject) | Out-Null  

            $excelObject.Quit() 
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excelObject) | Out-Null
            [System.GC]::Collect() 
            [System.GC]::WaitForPendingFinalizers()    
            Write-Verbose "Excel application process deleted from the system."
        
            if(Test-Path -path $temporaryCsvFile) { 
                Remove-Item -path $temporaryCsvFile -ErrorAction Stop
                Write-Verbose "Temporary csv file deleted: $temporaryCsvFile" 
            }
        
            if ( $sendemail ) {
        
                $errorlogfile = "$home\Documents\PSlogs\Error_Log.txt"
                $attachments = "$errorlogfile","$excelFile"
            
                Write-Verbose "Sending email."
                Send-Email -Attachments $attachments -Priority "Normal" -errorlog -client $client -solution $solution
                Write-Verbose "Email sendt."
             }
        
        }
    } catch {
        Write-Warning "SaveToExcel function failed"
        Write-Warning "Error message: $_"

        if ( $errorlog ) {

            $errormsg = $_.ToString()
            $exception = $_.Exception
            $stacktrace = $_.ScriptStackTrace
            $failingline = $_.InvocationInfo.Line
            $positionmsg = $_.InvocationInfo.PositionMessage
            $pscommandpath = $_.InvocationInfo.PSCommandPath
            $failinglinenumber = $_.InvocationInfo.ScriptLineNumber
            $scriptname = $_.InvocationInfo.ScriptName

            Write-Verbose "Start writing to Error log."
            Write-ErrorLog -hostname "SaveToExcel has failed" -errormsg $errormsg -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $stacktrace
            Write-Verbose "Finish writing to Error log."
        } 
    } 
}


}
#region Execution examples
#Get-OSInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Save-ToExcel -ExcelFileName "OS_Info" -title "OS Info for servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "OS Info" -client "OK" -solution "FIN" -errorlog -Verbose

#Get-Printer -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Save-ToExcel -ExcelFileName "Printers_With_Error" -title "Printers with errors on servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "Printers with errors" -client "OK" -solution "FIN" 

#Get-Printer -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Save-ToExcel -ExcelFileName "Printers_With_Error" -title "Printers with errors on servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "Printers with errors" -sendemail -client "OK" -solution "FIN" 

#Get-DiskFreeSpace -filename "OKFINservers.txt" -client "OK" -solution "FIN" -Verbose -errorlog | Save-ToExcel -ExcelFileName "Free_disk_space" -title "Free disk space on servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "Free disk space" -sendemail -client "OK" -solution "FIN" 

#Get-ErrorFromEventLog -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -days 3 -Verbose | Save-ToExcel -ExcelFileName "Get-ErrorsInEventLogs" -title "Get errors from Event Logs on servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "Errors from Event Logs" -sendemail -client "OK" -solution "FIN" 

#Get-ErrorFromEventLog -filename "OKFINkursservers.txt" -errorlog -client "OK" -solution "FIN" -days 3 -Verbose | Save-ToExcel -ExcelFileName "Get-ErrorsInEventLogs" -title "Get errors from Event Logs on servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "Errors from Event Logs" -client "OK" -solution "FIN" 

#Get-CPUInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Save-ToExcel -ExcelFileName "Get-CPUinfo" -title "Get CPU info of servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "CPU Info" -client "OK" -solution "FIN" 

#Get-CPUInfo -computers "localhost" -errorlog -client "OK" -solution "FIN" -Verbose | Save-ToExcel -ExcelFileName "Get-CPUinfo" -title "Get CPU info of servers in Financial solution for " -author "ImproveScripting.com With Dejan" -WorkSheetName "CPU Info" -client "OK" -solution "FIN" 

#endregion