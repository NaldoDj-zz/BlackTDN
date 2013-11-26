############################################BTDNdoc2pdf.ps1############################################
# BTDNdoc2pdf.ps1                                                                                     #
# Autor      : Marinaldo de Jesus (http://www.blacktdn.com.br)                                        #
# Data       : 26/06/2013                                                                             #
# powershell.exe -command "&'.\ps2exe.ps1' -inputFile 'BTDNdoc2pdf.ps1' -outputfile 'BTDNdoc2pdf.exe'"#
#######################################################################################################
function BTDNdoc2pdf()
{
    param(
            [string]$source     = $(Throw "You have to specify a source path."),
            [string]$log        = $(join-path . "BTDNdoc2pdf.log"),
            [string]$PDFPrinter = $(""),
            $oWord              = $(new-object -ComObject "word.application"),
            $oPDFCreator        = $NULL
        
    )
    $extensionSize = 3
    if ($source.EndsWith("docx")){
      $extensionSize = 4
    }
    $msg          = "`n`n[$(get-date)]BTDNdoc2pdf has started. File: $source"
    add-content -force $log -value $msg
    $destiny      = $source.Substring(0,$source.Length-$extensionSize)+"pdf"
    $saveaspath   = $destiny
    $formatPDF    = 17
    try{
        $process       = Get-Process winword -ErrorAction SilentlyContinue
        $oWord.Visible = $false
        try{
            $oWord.DisplayAlerts = "wdAlertsNone"
        }
        catch [system.exception]{ 
        }
        finally{
        }
        try{
            $oWord.AutomationSecurity = "msoAutomationSecurityForceDisable"
        }
        catch [system.exception]{ 
        }
        finally{
        }
        $doc = $oWord.documents.Open($source)
        try{ 
            #PDFCreator (PDFPrinter,etc...)
            if ($PDFPrinter.Trim().Length -eq 0 ){
                throw "The PDFPrinter is required."
            }
            try{
                if ($PDFPrinter.ToUpper().Contains("PDFCREATOR")){
                    If( $oPDFCreator -eq $NULL ){
                        throw "Could not connect to PDFCreator via COM to set options"
                    }
                    $PDFPath = $(Split-Path $saveaspath)
                    $oPDFCreator.cOption("AutosaveFormat") = 0
                    $oPDFCreator.cOption("UseAutosaveDirectory") = 1
                    $oPDFCreator.cOption("AutosaveDirectory") = $PDFPath
                    $oPDFCreator.cOption("AutosaveFilename")  = $saveaspath.Replace($PDFPath,"").Substring(1)
                    $oPDFCreator.cOption("AutosaveStartStandardProgram") = 0
                    $oPDFCreator.cPrinterStop = $false        
                }
            }
            catch [system.exception]{
            }
            finally{
            }
            $oWord.ActivePrinter  = $PDFPrinter.Value
            $msg = "converting: $source using $PDFPrinter. Wait..."
            add-content -force $log -value $msg
            write-host -fore yellow $msg
            $background = $false
            try{
                $doc.PrintOut([ref]$background)
            }
            catch [system.exception]{  
                $doc.PrintOut($background)
            }
            finally{
            }
        }
        catch [system.exception]{       
            try{
                write-host $_                
                #Office 7
                $msg = "converting: $source using MSOffice Word 7. Wait..."
                add-content -force $log -value $msg
                write-host -fore yellow $msg
                $doc.SaveAs($saveaspath,$formatPDF)
                $msg = "Converted using MSOffice Word 7. file: $source"
                add-content -force $log -value $msg
                write-host -fore green $msg
            }
            catch [system.exception]{
                write-host $_                
                try{
                    #Office 10
                    $msg = "converting: $source using MSOffice Word 10. Wait..."
                    add-content -force $log -value $msg
                    write-host -fore yellow $msg
                    $doc.SaveAs([ref]$saveaspath,[ref]$formatPDF)
                    $msg = "Converted using MSOffice Word 10. file: $source"
                    add-content -force $log -value $msg
                    write-host -fore green $msg
                }
                catch [system.exception]{
                    $msg = "Caught a system exception. File: $source UNCONVERTED using MSOffice Word 7 or 10"
                    add-content -force $log -value $msg
                    write-host -fore red $msg                
                    write-host $_                
                }
                finally{
                }
            }
        }
        try{
            $doc.close([ref]$false)
        }
        catch [system.exception]{
            $doc.close($false)
        }
        finally{
        }
    }
    catch [system.exception]{
        $msg = "Caught a system exception. File: $source UNCONVERTED"
        add-content -force $log -value $msg
        write-host -fore red $msg
        write-host $_                
    }
    finally{
        $msg = "End of script. File: $source"
        add-content -force $log -value $msg
        write-host -fore white $msg
    }
}
############################################BTDNdoc2pdf.ps1############################################
# Autor      : Marinaldo de Jesus (http://www.blacktdn.com.br)                                        #
# Data       : 26/06/2013                                                                             #
#######################################################################################################
function Get-PDFPrinters {
    $Printers = (Get-WmiObject -class win32_printer) | Select -Expand Name | ForEach {
        if ( $_.ToUpper().Contains("PDF") ){
            $oListBox.items.add($_)|Out-Null
        }
    }
}
############################################BTDNdoc2pdf.ps1############################################
# Autor      : Marinaldo de Jesus (http://www.blacktdn.com.br)                                        #
# Data       : 26/06/2013                                                                             #
#######################################################################################################
function Select-PDFPrinter($PDFPrinters){

    [String]$PrinterSelected = ""
    
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")|Out-Null

    $oWinform      = New-Object Windows.Forms.Form
    $oWinform.Text = "BlackTDN :: doc2pdf : select the virtual printer"
    $oWinform.Size = New-Object Drawing.Size(400,150)

    $oSelectButton          = New-Object Windows.Forms.Button
    $oSelectButton.Location = New-Object Drawing.Size(220,10)
    $oSelectButton.Text     = "OK"
    $oWinform.Controls.Add($oSelectButton)

    $oListBox          = New-Object Windows.Forms.ListBox
    $oListBox.Location = New-Object Drawing.Size(10,10)
    $oListBox.Size     = New-Object Drawing.Size(200,100)
    $oWinform.Controls.Add($oListBox)
    
    for ($i=0; $i -lt $PDFPrinters.Count; $i++) {
        $oListBox.items.add($PDFPrinters[$i])|Out-Null
    }

    $oWinform.add_shown($oWinform.Activate())
  
    $oSelectButton.add_Click(
        {
           if ( $oListBox.SelectedIndex -ne -1 ){
               try{
                    $PrinterSelected=$oListBox.SelectedItem.Clone()
                }catch [system.exception]{}finally{}    
           }    
           $this.Parent.Close()
        }
    )

    $oWinform.StartPosition  = "CenterScreen"
    
    [void]$oWinform.showdialog()|Out-Null    
    
    Return( $PrinterSelected )
}
############################################BTDNdoc2pdf.ps1############################################
# Autor      : Marinaldo de Jesus (http://www.blacktdn.com.br)                                        #
# Data       : 26/06/2013                                                                             #
#######################################################################################################
function Get-PDFPrinters(){
    $PDFPrinters = New-Object Collections.Generic.List[String]
    $ALLPrinters = (Get-WmiObject -class win32_printer) | Select -Expand Name | ForEach{
        if ( $_.ToUpper().Contains("PDF") ){
            $PDFPrinters.add($_) |Out-Null
        }
    }
    Return($PDFPrinters)
}

############################################BTDNdoc2pdf.ps1############################################
# Autor      : Marinaldo de Jesus (http://www.blacktdn.com.br)                                        #
# Data       : 26/06/2013                                                                             #
#######################################################################################################
$log = join-path . "BTDNdoc2pdf.log"
if ( test-path $log ){
    $tempLog = get-item $log
    if ( $tempLog.Length -ge 61440 ){
        $tempLog.Delete()
    }
}
[bool]$ExistPrint=$false
[array]$PDFPrinters = Get-PDFPrinters
if ($PDFPrinters.Count -gt 0){
    [void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089") |Out-Null
    $Answer=[System.Windows.Forms.MessageBox]::Show("Convert using a virtual printer?","BTDNdoc2pdf",[Windows.Forms.MessageBoxButtons]::YesNo,[Windows.Forms.MessageBoxIcon]::Question)
    [bool]$MsgYesNo=($Answer -eq [Windows.Forms.DialogResult]::Yes)
    if ($MsgYesNo){
        [String]$PDFPrinter = Select-PDFPrinter($PDFPrinters)
        $ExistPrint=($PDFPrinter.Trim().Length -gt 0)
    }    
}    
Get-Process|?{$_.Name.ToUpper().Contains("WINWORD")}|ForEach{
    try{
            $_.Kill()|Out-Null
    }
    catch [system.exception]{
    }
    finally{
    }
}            
$oWord = new-object -ComObject "word.application"
if ($ExistPrint){
    $DefPrinter=(Get-WmiObject -Query "Select * from win32_printer where Default='True'")
    $SetPrinter=(Get-WmiObject -Query "Select * from win32_printer where Name='$PDFPrinter'")
    $Dummy=($SetPrinter.SetDefaultPrinter())
    $oPDFCreator = $NULL
    if ($PDFPrinter.ToUpper().Contains("PDFCREATOR")){
        Get-Process|?{$_.Name.ToUpper().Contains("PDFCREATOR")}|ForEach{
            try{
                $_.Kill()|Out-Null
            }
            catch [system.exception]{
            }
            finally{
            }
        }
        try{
            $oPDFCreator = New-Object -ComObject "PDFCreator.clsPDFCreator"
            If(!($oPDFCreator.cStart("/NoProcessingAtStartup"))){
                throw "Could not connect to PDFCreator via COM to set options"
            }
        }
        catch{
            $oPDFCreator = $NULL
        }
        finally{
        }
    }
    ls . *.doc* -Recurse | %{ BTDNdoc2pdf $_.fullname $log $PDFPrinter $oWord $oPDFCreator }
    $Dummy=($DefPrinter.SetDefaultPrinter())
    if (!($oPDFCreator -eq $NULL)){
        $oPDFCreator.cClose()|Out-Null
        ([System.Runtime.InteropServices.Marshal]::ReleaseComObject($oPDFCreator)-gt0)|Out-Null
        $oPDFCreator=$NULL
        if ($PDFPrinter.ToUpper().Contains("PDFCREATOR")){
            Get-Process|?{$_.Name.ToUpper().Contains("PDFCREATOR")}|ForEach{
                try{
                    $_.Kill()|Out-Null
                }
                catch [system.exception]{
                }
                finally{
                }
            }            
        }    
        try{
            $oPDFCreator = New-Object -ComObject "PDFCreator.clsPDFCreator"
            If(!($oPDFCreator.cStart("/NoProcessingAtStartup"))){
                throw "Could not connect to PDFCreator via COM to set options"
            }
        }
        catch{
            $oPDFCreator = $NULL
        }
        finally{
        }
      }
    Start-Sleep -seconds 5
    while ( $true ){
        write-host "."
        $PrinterStatus=(Get-WmiObject win32_printer|where{$_.Name.toUpper().Contains($PDFPrinter.toUpper())}|%{$_.PrinterStatus})
        if ( $PrinterStatus -ne 4 ){
            break
        }
       Start-Sleep -seconds 5
    }    
}
else{
    ls . *.doc* -Recurse | %{ BTDNdoc2pdf $_.fullname $log "" $oWord }
}
try{$oWord.Quit()}catch{}finally{}    
Get-Process|?{$_.Name.ToUpper().Contains("WINWORD")}|ForEach{
    try{
            $_.Kill()|Out-Null
    }
    catch [system.exception]{
    }
    finally{
    }
}