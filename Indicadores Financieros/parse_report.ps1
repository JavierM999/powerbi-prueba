$root = 'C:\Users\infor\Documents\prueba vscode\Indicadores Financieros\Indicadores Financieros Delegaciones.Report\definition\pages'
Get-ChildItem -Path $root -Directory | ForEach-Object {
    $pageJsonPath = Join-Path $_.FullName 'page.json'
    if (-Not (Test-Path $pageJsonPath)) { return }
    $page = Get-Content -Path $pageJsonPath -Raw | ConvertFrom-Json
    Write-Host "PAGE $($page.name) TITLE $($page.displayName)"
    if ($page.filterConfig.filters) {
        Write-Host "  page filters $($page.filterConfig.filters.Count)"
        foreach ($f in $page.filterConfig.filters) {
            if ($f.field.Column) {
                Write-Host "    filter $($f.field.Column.Expression.SourceRef.Entity) $($f.field.Column.Property) type $($f.type)"
            }
        }
    }
    $visDir = Join-Path $_.FullName 'visuals'
    if (-Not (Test-Path $visDir)) { return }
    Get-ChildItem -Path $visDir -Directory | ForEach-Object {
        $visJsonPath = Join-Path $_.FullName 'visual.json'
        if (-Not (Test-Path $visJsonPath)) { return }
        $vis = Get-Content -Path $visJsonPath -Raw | ConvertFrom-Json
        $vtype = $vis.visual.visualType
        Write-Host "   visual $($vis.name) type $vtype"
        if ($vtype -eq 'slicer') {
            $projs = $vis.visual.query.queryState.Values.projections
            foreach ($pr in $projs) {
                if ($pr.field.Column) {
                    Write-Host "     uses $($pr.field.Column.Expression.SourceRef.Entity) $($pr.field.Column.Property)"
                }
            }
            try { $title = $vis.visual.objects.header[0].properties.text.expr.Literal.Value; Write-Host "     title $title" } catch {}
        } else {
            $queryState = $vis.visual.query.queryState
            if ($queryState -is [System.Management.Automation.PSCustomObject]) {
                foreach ($prop in $queryState.PSObject.Properties) {
                    $val = $prop.Value
                    if ($val -and $val.projections) {
                        foreach ($pr in $val.projections) {
                            if ($pr.field.Column) {
                                Write-Host "     uses $($pr.field.Column.Expression.SourceRef.Entity) $($pr.field.Column.Property)"
                            } elseif ($pr.field.Measure) {
                                Write-Host "     uses measure $($pr.field.Measure.Expression.SourceRef.Entity) $($pr.field.Measure.Property)"
                            }
                        }
                    }
                }
            }
        }
        if ($vis.filterConfig.filters) {
            foreach ($f in $vis.filterConfig.filters) {
                if ($f.field.Column) {
                    Write-Host "     visual filter $($f.field.Column.Expression.SourceRef.Entity) $($f.field.Column.Property) type $($f.type)"
                }
            }
        }
    }
    Write-Host ''
}
