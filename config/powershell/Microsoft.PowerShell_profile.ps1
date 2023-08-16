Clear-Host # To remove the annoying initial text when openning pwsh
oh-my-posh init pwsh --config C:\Users\lucas\AppData\Local\Programs\oh-my-posh\themes/1_shell.omp.json | Invoke-Expression

Import-Module -Name Terminal-Icons

Import-Module PSReadLine
# Shows navigable menu of all options when hitting Tab
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
# Autocompletion with arroy keys
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
#CLICK F2 to change the view
Set-PSReadLineOption -EditMode Windows

Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell --cmd cd | Out-String)
})

# Save the current line in the history but doesn't execute it
Set-PSReadLineKeyHandler -Key Alt+w `
                         -BriefDescription "SaveInHistoy" `
                         -LongDescription "Save the current line in the history but do not execute" `
                         -ScriptBlock {
                            param($key, $arg)

                            $line = $null
                            $cursor = $null
                            [Microsoft.Powershell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
                            [Microsoft.Powershell.PSConsoleReadLine]::AddToHistory($line)
                            [Microsoft.Powershell.PSConsoleReadLine]::RevertLine()
                         }
Set-Alias python3 py
Set-Alias nodejs node
Set-Alias python py
Set-Alias csi "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\bin\Roslyn\csi.exe"
Set-Alias fsi "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\FSharp\Tools\fsi.exe"
Set-Alias csc "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\bin\Roslyn\csc.exe"
Set-Alias fsc "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\FSharp\Tools\fsc.exe"
Set-Alias which get-command


function yta-mp3 {
  yt-dlp --extract-audio --audio-format mp3 $args

}




# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

