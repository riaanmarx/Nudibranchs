<#
.SYNOPSIS
    Read all values from the last column of a table (ListObject) in an Excel workbook and write them to a text file (one value per line).

.PARAMETER ExcelPath
    Path to the .xlsx/.xls file.

.PARAMETER OutputPath
    Path to write the output .txt file.

.PARAMETER TableName
    Optional: name of the ListObject (table). If not supplied, the first table found is used.

.PARAMETER WorksheetName
    Optional: worksheet name to look for the table. If not supplied, searches all sheets.

.PARAMETER SkipBlanks
    Switch: remove empty/null values from output.

.EXAMPLE
    .\ReGen.ps1 -ExcelPath C:\data\file.xlsx -OutputPath C:\out\lastcol.txt
#>

# Configurable parameters
$ExcelPath = "C:\Projects_Personal\Personal-Nudibranchs\Source\site generator tool\NudibranchListV3.xlsx"
$TableName = "Nudibranchdata"
$ColumnName = "js"
#$OutputPath = "C:\Projects_Personal\Personal-Nudibranchs\Source\site generator tool\out.txt"
$OutputPath = "C:\Projects_Personal\Personal-Nudibranchs\Source\websites\Nudibranchs\js\AddSpecies.js"
$excelFull = (Resolve-Path -Path $ExcelPath).Path
$excel = New-Object -ComObject Excel.Application
$excel.DisplayAlerts = $false
$excel.Visible = $false

$wb = $null
try {
        # Open workbook
        $wb = $excel.Workbooks.Open($excelFull, $null, $true)  # Open read-only
        
        # find table
        $targetTable = $null
        foreach ($sh in $wb.Worksheets) {
            try {
                $t = $sh.ListObjects.Item($TableName)
                if ($t) { $targetTable = $t; break }
            } catch {}
        }
        
        foreach ($column in $targetTable.ListColumns) {
            if ($column.Name -eq $columnName) {
                $index = $column.Index
                break
            }
        }
        # use DataBodyRange to exclude header/footer
        $dataBody = $targetTable.DataBodyRange
        $lastCol = $dataBody.Columns[$index] # .Item($dataBody.Columns.Count)

        # extract values from column with header=$ColumnName
        $output = [System.Collections.Generic.List[string]]::new()
        $output.Add("function addSpecies(template) {")  # add header
        $rowCount = $lastCol.Rows.Count
        for ($r = 1; $r -le $rowCount; $r++) {
            $val = $lastCol.Cells.Item($r).Text
            $output.Add("    $val")
        }
        $output.Add("}")  # add header

        #write all the values to output file
        $output | Set-Content -Path $OutputPath -Encoding UTF8  



} finally {
        if ($wb) { $wb.Close($false) | Out-Null; [System.Runtime.InteropServices.Marshal]::ReleaseComObject($wb) | Out-Null }
        if ($excel) { $excel.Quit(); [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null }
        [GC]::Collect(); [GC]::WaitForPendingFinalizers()
}