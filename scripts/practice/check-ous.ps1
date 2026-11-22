$departments = "HR", "IT", "Sales", "Finance"
foreach ($dept in $departments) {
    $ou = Get-ADOrganizationalUnit -Filter "Name -eq '$dept'"
    if ($ou) {
        Write-Host "[OK] OU found: $dept" -ForegroundColor Green
    } else {
        Write-Host "[MISSING] OU not found: $dept" -ForegroundColor Red
    }
}