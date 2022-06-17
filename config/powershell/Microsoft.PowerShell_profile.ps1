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

