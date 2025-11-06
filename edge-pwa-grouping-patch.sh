#!/bin/bash

desktop_dir="${XDG_DATA_HOME}/applications"
profile_name="Default"

# Find and loopo trough all matching .desktop files
find "${desktop_dir}" -type f -name "msedge-*-${profile_name}.desktop" | while read -r file; do
    echo "Processing: ${file}"

    id=$(basename "${file}" | sed -E "s/msedge-(.*)-${profile_name}\.desktop/\1/")

    # Replace StartupWMClass with the correct value (msedge-_<id>-<profile name>)
    wmclass_value="msedge-_${id}-${profile_name}"
    if grep -q '^StartupWMClass=' "${file}"; then
        sed -i "s/^StartupWMClass=.*/StartupWMClass=${wmclass_value}/" "${file}"
    else
        echo "StartupWMClass=${wmclass_value}" >> "${file}"
    fi

    # Append SingleMainWindow to end of file
    # This might not be nessesary
    echo "SingleMainWindow=true" >> "${file}"
    echo "X-GNOME-SingleWindow=true" >> "${file}"

    # Rename the file
    new_name="${desktop_dir}/com.microsoft.${id}.desktop"
    mv "${file}" "${new_name}"
    echo "Renamed to: ${new_name}"
done

if [ -d "${HOME}/.gnome" ]; then
    echo "Renamed all files.  Now deleting deprecated ~/.gnome folder."
    rm -rf "${HOME}/.gnome" 
fi
