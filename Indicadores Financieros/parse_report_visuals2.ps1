$base = 'C:\Users\infor\Documents\prueba vscode\Indicadores Financieros\Indicadores Financieros Delegaciones.Report\definition\pages'
$results = @()
Get-ChildItem -Path $base -Directory | ForEach-Object {
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
                    $title = if ($vj.visual?.visualType) { $vj.visual.visualType } else { $vj.visualType }
                    $fields = @()
                    if ($vj.visual?.query?.queryState?.Values?.projections) {
                        foreach ($proj in $vj.visual.query.queryState.Values.projections) {
                            if ($proj.displayName) {
                                $fields += $proj.displayName
                            } elseif ($proj.queryRef) {
                                $fields += $proj.queryRef
                            } else {
                                $fields += ($proj.field.Measure.Property ?? $proj.field.Column.Property ?? 'Unknown')
                            }
                        }
                    } elseif ($vj.query?.queryState?.Values?.projections) {
                        foreach ($proj in $vj.query.queryState.Values.projections) {
                            if ($proj.displayName) { $fields += $proj.displayName } elseif ($proj.queryRef) { $fields += $proj.queryRef } else { $fields += ($proj.field.Measure.Property ?? $proj.field.Column.Property ?? 'Unknown') }
                        }
                    }
                    if ($fields.Count -eq 0 -and $vj.data?.roles) {
                        $vj.data.roles.PSObject.Properties | ForEach-Object {
                            $roleName = $_.Name
                            $values = @()
                            foreach ($val in $_.Value.values) {
                                if ($val.expr.Column) {
                                    $col = $val.expr.Column
                                    $values += "$($col.Expression.SourceRef.Entity).$($col.Property)"
                                } elseif ($val.expr.Measure) {
                                    $values += "Measure:$($val.expr.Measure.Name)"
                                }
                            }
                            if ($values.Count -gt 0) { $fields += "${roleName}: $($values -join ', ')" }
                        }
                    }
                    $results += [PSCustomObject]@{
                        Page = $pageName
                        VisualId = $_.Name
                        VisualType = $title
                        Fields = ($fields | Select-Object -Unique) -join '; '
                    }
                }
            }
        }
    }
}
$results | Sort-Object Page, VisualType | Format-Table -AutoSize | Out-String -Width 240 | Set-Content -Path 'C:\Users\infor\Documents\prueba vscode\Indicadores Financieros\visuals_report_output2.txt'
Write-Output 'Done'