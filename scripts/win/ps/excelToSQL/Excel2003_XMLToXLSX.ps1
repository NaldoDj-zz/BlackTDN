function Excel2003_XMLToXLSX($folderpath){

    Add-Type -AssemblyName Microsoft.Office.Interop.Excel
    $xlFixedFormat=[Microsoft.Office.Interop.Excel.XlFileFormat]::xlOpenXMLWorkbook
    $filetype ="*.xml"
    $Row=0
    $files=@()

    ($items=Get-ChildItem -Path $folderpath -filter $filetype) | % `
    {

        $Row++
        Write-Progress -Activity "Excel2003_XMLToXLSX" -status "Convertendo $_" -percentComplete (($Row/$items.Length)*100) -ID 1

        $path=($_.fullname).substring(0,($_.FullName).lastindexOf("."))
        $path+=".xlsx"

        $excel=New-Object -ComObject excel.application
        $excel.visible=$true

        Try
        {
            $workbook=$excel.workbooks.openXML($_.fullname)
            if ([System.IO.File]::Exists($path)){
                Remove-Item $path -Force -ErrorAction SilentlyContinue
            }    
            $workbook.saveas($path,$xlFixedFormat)
            $files+="$($_.fullname) => $($path)"
            $oldFolder=$path.substring(0, $path.lastIndexOf("\")) + "\old"
            if(-not (test-path $oldFolder))
            {
                new-item $oldFolder -type directory -force
            }
            move-item $_.fullname $oldFolder -force
        }
        catch
        {
            write-host "Exception caught"
        }    
        Finally
        {
            $workbook.close()
            $excel.Quit()
            $excel=$null
            [gc]::collect()
            [gc]::WaitForPendingFinalizers()
        }
        
    }
    if ($files.Count -gt 0){
        $files | % { write-host $_ }
    }
    [gc]::collect()
    [gc]::WaitForPendingFinalizers()
}    
cls
$folderpath="c:\Users\marin\Downloads\old"
Excel2003_XMLToXLSX($folderpath)