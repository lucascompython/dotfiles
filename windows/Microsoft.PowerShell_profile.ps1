Invoke-Expression (&starship init powershell)

Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })


# Import-Module -Name Terminal-Icons

Import-Module PSReadLine
# Shows navigable menu of all options when hitting Tab
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete



Set-Alias update 'winget upgrade --all --include-unknown'
Set-Alias touch 'New-Item -Type File -Force'
# Set-Alias ls 'eza --group-directories-first --icons --git --color=always'

del alias:ls


function global:ls {
  param(
    [Parameter(Mandatory = $false)]
    [string] $path = '.'
  )

    eza --group-directories-first --long --icons --git --color=always $path
}


function global:which ([Parameter(Mandatory = $true)][string] $cmd) {

  $path = Get-Command $cmd 2> $null

  if ($null -eq $path) { 
    Write-Error "Command '$cmd' not found."
    return 
  }

  if ($path.Path.Length -gt 0) {
    return $path.Path
  }
  # if an alias get the location that the alias is pointing to
  return $path.Definition
}

function locate {
  Get-ChildItem -Recurse . @args -ErrorAction SilentlyContinue 
}
function global-locate {
  Get-ChildItem -Recurse / @args -ErrorAction SilentlyContinue
}

function clocate {
  cmd /C dir @args /s /b
}