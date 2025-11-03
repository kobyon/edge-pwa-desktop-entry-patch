#!/bin/bash

DESKTOP_DIR="${XDG_DATA_HOME}/applications"
PROFILE_NAME="Default"

# Find and loopo trough all matching .desktop files
find "${DESKTOP_DIR}" -type f -name "msedge-*-${PROFILE_NAME}.desktop" | while read -r file; do
    echo "Processing: ${file}"

    id=$(basename "${file}" | sed -E "s/msedge-(.*)-${PROFILE_NAME}\.desktop/\1/")

    # Replace StartupWMClass with the correct value (msedge-_<id>-<profile name>)
    wmclass_value="msedge-_${id}-${PROFILE_NAME}"
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
    new_name="${DESKTOP_DIR}/com.microsoft.${id}.desktop"
    mv "${file}" "${new_name}"
    echo "Renamed to: ${new_name}"
done
