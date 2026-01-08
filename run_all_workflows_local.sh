#!/bin/bash
# Test the full PX4-PreFlight integration workflow locally using act
# Install act: https://github.com/nektos/act
# macOS: brew install act
# Linux: curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

set -e

echo "=== Testing PX4-PreFlight Full Integration Locally ==="
echo ""

# Check if act is installed
if ! command -v act &> /dev/null; then
    echo "ERROR: 'act' is not installed."
    echo ""
    echo "To install act:"
    echo "  macOS:  brew install act"
    echo "  Linux:  curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash"
    echo ""
    echo "More info: https://github.com/nektos/act"
    exit 1
fi

# Check if submodules are initialized
if [ ! -f "px4-github-workflows/.github/workflows/px4_ros_ci.yml" ]; then
    echo "Submodules not initialized. Initializing now..."
    git submodule update --init --recursive
fi

echo "Running full integration test workflow locally..."
echo ""
echo "NOTE: This will use Docker to run the workflow in the same container image"
echo "      as GitHub Actions (ghcr.io/sloretz/ros:humble-desktop-full)"
echo ""
echo "This may take a while (15-30 minutes) as it will:"
echo "  - Install dependencies (ROS 2, Gazebo, DDS Agent)"
echo "  - Clone and build PX4 Autopilot"
echo "  - Build ROS 2 workspace"
echo "  - Run PX4 SITL simulation"
echo "  - Test ROS 2 topic communication"
echo ""

# Run the workflow with act
# --container-architecture linux/amd64: Ensure consistent architecture
# -j px4-ros-integration: Run the PX4+ROS integration job
# --verbose: Show detailed output
act -j px4-ros-integration \
    --container-architecture linux/amd64 \
    --verbose
