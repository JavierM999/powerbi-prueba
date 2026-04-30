$base = 'C:\Users\infor\Documents\prueba vscode\Indicadores Financieros\Indicadores Financieros Delegaciones.Report\definition\pages'
$results = @()
Get-ChildItem -Path $base -Directory | ForEach-Object {
    $page = $_.Name
    $pageJson = Join-Path $_.FullName 'page.json'
    if (Test-Path $pageJson) {
        $pj = Get-Content $pageJson -Raw | ConvertFrom-Json
        $pageName = $pj.displayName
        $visualFolder = Join-Path $_.FullName 'visuals'
        if (Test-Path $visualFolder) {
            Get-ChildItem -Path $visualFolder -Directory | ForEach-Object {
                $vfile = Join-Path $_.FullName 'visual.json'
                if (Test-Path $vfile) {
                    $vj = Get-Content $vfile -Raw | ConvertFrom-Json
                    $title = if ($vj.displayName) { $vj.displayName } elseif ($vj.visualType) { $vj.visualType } else { 'Unknown' }
                    $fields = @()
                    if ($vj.data?.roles) {
                        $vj.data.roles.PSObject.Properties | ForEach-Object {
                            $roleName = $_.Name
                            $values = @()
                            foreach ($val in $_.Value.values) {
                                if ($val.expr) {
                                    if ($val.expr.Column) {
                                        $col = $val.expr.Column
                                        $values += "$(($col.Expression.SourceRef.Entity)).$($col.Property)"
                                    } elseif ($val.expr.Measure) {
                                        $values += "Measure:$($val.expr.Measure.Name)"
                                    } elseif ($val.expr.Property) {
                                        $values += $val.expr.Property
                                    }
                                } elseif ($val.value) {
                                    $values += $val.value
                                }
                            }
                            if ($values.Count -gt 0) {
                                $fields += "${roleName}: $($values -join ', ')"
                            }
                        }
                    }
                    $results += [PSCustomObject]@{
                        Page = $pageName
                        VisualId = $_.Name
                        VisualTitle = $title
                        VisualType = $vj.visualType
                        Fields = $fields -join ' | '
                    }
                }
            }
        }
    }
}
$results | Sort-Object Page, VisualType | Format-Table -AutoSize | Out-String -Width 200 | Set-Content -Path 'C:\Users\infor\Documents\prueba vscode\Indicadores Financieros\visuals_report_output.txt'
Write-Output 'Done'