# cp ~./.config/yasb/{config.yaml;styles.css} ./windows/yasb/

# copy those two files to the windows directory
Copy-Item -Path "$HOME/.config/yasb/config.yaml" -Destination "./windows/yasb/config.yaml" -Force
Copy-Item -Path "$HOME/.config/yasb/styles.css" -Destination "./windows/yasb/styles.css" -Force

Copy-Item -Path "$HOME/.config/whkdrc" -Destination "./windows/whkdrc" -Force

Copy-Item -Path "$HOME/komorebi.json" -Destination "./windows/komorebi.json" -Force

Copy-Item -Path "$PROFILE" -Destination "./windows/Microsoft.PowerShell_profile.ps1" -Force
