#!/bin/bash
# Pulls the latest OpenRCT2 nightly from Git, then builds from source.

# If Effective User ID isn't 0 (root), prompt for sudoer password
if [ "$EUID" != 0 ]; then

    # Execute sudo on all parameters (none in this case other than the script itself, but following convention and best practice).
    # This will allow sudo to be called in other parts of the script without requiring additional user password input.
    sudo "$0" "$@"

    # Check to see if a Git directory exists for OpenRCT2.
    # If not, create it under ~/Git/OpenRCT2, also creating a build directory.
    if [ ! -d "~/Git/OpenRCT2" ]; then
        echo -e "OpenRCT2 Git directory not found.\n"

        # Clone the OpenRCT2 main repo.
        echo -e "Cloning OpenRCT2 repo into ~/Git/OpenRCT2...\n"
        git clone https://github.com/OpenRCT2/OpenRCT2.git ~/Git/OpenRCT2
        mkdir ~/Git/OpenRCT2/build

    else
        echo -e "OpenRCT2 Git directory found, proceeding...\n"
    fi

    # Change to the Git directory for OpenRCT2
    cd ~/Git/OpenRCT2

    # Get the latest nightly code updates
    echo -e "Pulling latest OpenRCT2 nightly...\n"
    git pull --ff-only

    # Change to the build directory
    cd build

    # Perform pre-build config with cmake
    echo -e "Prebuild config with cmake...\n"
    cmake ..

    # Build from source
    echo -e "Building from source...\n"
    make

    # Install to /usr/local/bin
    echo -e "Installing...\n"
    sudo make install

    echo -e "Done.\n"
    exit $?

fi