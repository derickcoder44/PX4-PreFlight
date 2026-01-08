#!/bin/bash
# Test all PX4-PreFlight workflows locally using act
# Install act: https://github.com/nektos/act
# macOS: brew install act
# Linux: curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

set -e

echo "=== Testing PX4-PreFlight All Workflows Locally ==="
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

# Create artifacts directory for videos and logs
mkdir -p /tmp/act-artifacts

echo "Running all workflows locally..."
echo ""
echo "NOTE: This will use Docker to run all workflows including:"
echo "  - Full integration test (PX4+ROS2 integration)"
echo "  - Code quality checks (type checking, linting, auto-review)"
echo "  - Flight test with video recording"
echo ""
echo "This may take a while (30-60 minutes) as it will:"
echo "  - Install dependencies (ROS 2, Gazebo, DDS Agent)"
echo "  - Clone and build PX4 Autopilot"
echo "  - Build ROS 2 workspace"
echo "  - Run PX4 SITL simulation"
echo "  - Test ROS 2 topic communication"
echo "  - Run code quality checks"
echo "  - Record flight test video"
echo ""
echo "Artifacts (videos, logs) will be saved to: /tmp/act-artifacts/"
echo ""

# Run the main integration workflow with all jobs
echo "=== Running Full Integration Workflow ==="
act -W .github/workflows/full_integration.yml \
    --container-architecture linux/arm64 \
    --artifact-server-path /tmp/act-artifacts \
    --verbose

echo ""
echo "=== Running Flight Test with Video Recording ==="
cd ros-px4-bridge-docker
act -W .github/workflows/test-flight.yml \
    --container-architecture linux/arm64 \
    --artifact-server-path /tmp/act-artifacts \
    --verbose
cd ..

echo ""
echo "=== All workflows completed! ==="
echo "Check /tmp/act-artifacts/ for videos and logs"
echo "Video should be at: /tmp/act-artifacts/flight-test-video/flight_test.mp4"
