[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [Parameter(Mandatory = $true)]
  [string]$RepoOwner,

  [Parameter(Mandatory = $true)]
  [string]$RepoName,

  [Parameter(Mandatory = $true)]
  [string]$BaseBranch,

  [Parameter(Mandatory = $true)]
  [string]$PROwner,

  [Parameter(Mandatory = $true)]
  [string]$PRBranch,

  [Parameter(Mandatory = $true)]
  [string]$AuthToken,

  [Parameter(Mandatory = $true)]
  [string]$PRTitle,

  [Parameter(Mandatory = $false)]
  [string]$PRBody = $PRTitle,

  [string]$PRLabels,

  [string]$UserReviewers,

  [string]$TeamReviewers,

  [string]$Assignees,

  [boolean]$CloseAfterOpenForTesting=$false,

  [boolean]$OpenAsDraft=$false
)

Set-PsDebug -Trace 1
$SourceRepo = '${{ repo.key }}'
$SourceBranch = '${{ repo.value.Branch }}'
if (-not (Test-Path ${{ repo.key }})) {
  New-Item -Path ${{ repo.key }} -ItemType Directory -Force
  Set-Location $SourceRepo
  git init
  git remote add Source "https://${{ parameters.GH_TOKEN }}@github.com/${SourceRepo}.git"
} else {
  Set-Location $SourceRepo
}

# Check the default branch
if (!$SourceBranch) {
  $defaultBranch = (git remote show Source | Out-String) -replace "(?ms).*HEAD branch: (\w+).*", '$1'
  Write-Host "No source branch. Fetch default branch $defaultBranch."
  $SourceBranch = $defaultBranch
}

git fetch --no-tags Source $SourceBranch
if ($LASTEXITCODE -ne 0) {
  Write-Host "#`#vso[task.logissue type=error]Failed to fetch ${SourceRepo}:${SourceBranch}"
  exit 1
}

git checkout -B source_branch "refs/remotes/Source/${SourceBranch}"

$SourceBranch = '${{ repo.value.Branch }}'
$TargetRepo = '${{ target.key }}'
$TargetBranch = '${{ coalesce(target.value.Branch, repo.value.Branch) }}'

Function FailOnError([string]$ErrorMessage, $CleanUpScripts = 0) {
  if ($LASTEXITCODE -ne 0) {
    Write-Host "#`#vso[task.logissue type=error]$ErrorMessage"
    if ($CleanUpScripts -ne 0) { Invoke-Command $CleanUpScripts }
    exit 1
  }
}

try {
  git remote add Target "https://${{ parameters.GH_TOKEN }}@github.com/${TargetRepo}.git"

  $defaultBranch = (git remote show Target | Out-String) -replace "(?ms).*HEAD branch: (\w+).*", '$1'
  if (!$SourceBranch) {
    $SourceBranch = $defaultBranch
  }
  if (!$TargetBranch) {
    $TargetBranch = $defaultBranch
  }
  Write-Host ${{ target.value.Rebase }}
  if (-not '${{ target.value.Rebase }}') {
    git checkout -B target_branch source_branch
    git push --force Target "target_branch:refs/heads/${TargetBranch}"
    FailOnError "Failed to push to ${TargetRepo}:${TargetBranch}"

  } else {
    git fetch --no-tags Target $TargetBranch
    FailOnError "Failed to fetch TargetBranch ${TargetBranch}."

    git checkout -B target_branch "refs/remotes/Target/${TargetBranch}"
    git -c user.name="azure-sdk" -c user.email="azuresdk@microsoft.com" rebase --strategy-option=theirs source_branch
    FailOnError "Failed to rebase for ${TargetRepo}:${TargetBranch}" {
      git status
      git diff
      git rebase --abort
    }

    git push --force Target "target_branch:refs/heads/${TargetBranch}"
    FailOnError "Failed to push to ${TargetRepo}:${TargetBranch}"
  }
} finally {
  git remote remove Target
}

Set-PsDebug -Off
