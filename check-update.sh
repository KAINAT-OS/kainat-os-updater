#!/bin/bash

# Check if the file exists and is accessible
if curl -s -o /dev/null -w "%{http_code}\n" https://raw.githubusercontent.com/KAINAT-OS/kainat-os-updater/refs/heads/main/Packages.sh | grep -q '200'; then
    # Fetch the content of the file and store it in a variable
    Packages=$(curl -s https://raw.githubusercontent.com/KAINAT-OS/kainat-os-updater/refs/heads/main/Packages.sh)

    # Check if the Dependencies variable exists in the file
    if echo "$Packages" | grep -q 'Dependencies='; then
        # Source the content of the Packages variable
        echo "$Packages" | bash

        # Split the Dependencies variable into an array using comma as the delimiter
        IFS=',' read -ra Dependencies_array <<< "$Dependencies"

        # Loop through the array and print each package name
        for package in "${Dependencies_array[@]}"; do
            echo "$package"
        done
    else
        echo "Error: Dependencies variable not found in Packages.sh"
    fi
else
    echo "Error: Packages.sh not found or inaccessible."
fi










#K-SETTINGS
# source the online version
source <(curl -s https://raw.githubusercontent.com/KAINAT-OS/K-SETTINGS/refs/heads/main/version.sh)
# source the offline version
source /usr/share/binary-updater/K-SETTINGS/version.sh
if [ "$offline_version" != "$VERSION" ]; then
    export K_update_avil="$K_update_avil:K-SETTINGS"
fi



#checking
if [ -z "$K_update_avil" ] && [ "$K_update_avil" = "" ]; then
    :
else
    kdialog --title "Update Notification" --yesno "Updates are available do you want to update now?"
    if [ $? = 0 ]; then
        export PASSWORD=$(kdialog --password "Enter the password")
        bash -c "$(curl -sL https://raw.githubusercontent.com/KAINAT-OS/K-SETTINGS/refs/heads/main/install.sh)"
    fi
fi
