Write-Host "=== Start ===" -ForegroundColor Cyan

git checkout main -f
git pull origin main
$fromLine = 86
$toLine = 1120
$currentBase = "main"

foreach ($i in $fromLine..$toLine) {
    $branchName = "feature/auto-line-$i"
    
    if (git branch --list $branchName) {
        git branch -D $branchName
    }
    
    git checkout -b $branchName $currentBase
    
    $newLine = "`nLine $i added by unbroken chain automation."
    Add-Content -Path "docs\research\TEST-LOG.md" -Value $newLine
    
    git add docs\research\TEST-LOG.md
    git commit -m "feat: auto add line $i"
    git push origin $branchName -f
    
    gh pr create --head $branchName --base main --title "Auto PR Line $i" --body "Unbroken chain test $i"
    gh pr merge --auto --merge --delete-branch
    
    $currentBase = $branchName
    
    Start-Sleep -Seconds 3
}

git checkout main -f
Write-Host "`n=== Finish ===" -ForegroundColor Green
