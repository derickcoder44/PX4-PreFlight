# PX4-PreFlight

Integration testing suite for PX4 Autopilot with ROS 2, featuring containerized simulation and automated workflows.

## Overview

PX4-PreFlight provides a complete testing framework for PX4 Autopilot development with ROS 2 integration. It includes Docker-based PX4 simulation infrastructure and GitHub Actions workflows for continuous integration testing.

## Architecture

```
PX4-PreFlight/
├── ros-px4-bridge-docker/        (Submodule) - ROS 2 + PX4 Docker environment
│   ├── scripts/                  - Setup and runtime scripts
│   ├── Dockerfile                - Container definition
│   └── .github/workflows/        - Docker build workflow
├── px4-sim-docker/               (Submodule) - PX4 SITL + Gazebo simulation
│   ├── Dockerfile                - Container definition (builds on ros-px4-bridge-docker)
│   ├── .github/workflows/        - Docker build workflow
│   └── README.md                 - Documentation
├── px4-flight-test-docker/       (Submodule) - Automated flight testing
│   ├── scripts/                  - Flight test scripts
│   ├── Dockerfile                - Container definition (builds on px4-sim-docker)
│   └── .github/workflows/        - Flight test workflow
├── .github/workflows/
│   ├── full_integration.yml      - Main CI/CD orchestrator
│   └── px4_ros_integration.yml   - Reusable PX4+ROS2 test workflow
└── run_all_workflows_local.sh    - Local testing script (using act)
```

### Components

The project uses a **layered Docker architecture** where each image builds on the previous one:

**[ros-px4-bridge-docker](https://github.com/derickcoder44/ros-px4-bridge-docker)** (Submodule - Base Layer)
- Foundation Docker image with ROS 2 Humble + Micro XRCE-DDS Agent
- PX4 ROS 2 interface packages (px4_msgs, px4_ros_com)
- Build and runtime scripts for PX4 and ROS 2
- Reusable in any project requiring PX4-ROS 2 communication

**[px4-sim-docker](https://github.com/derickcoder44/px4-sim-docker)** (Submodule - Simulation Layer)
- Builds FROM ros-px4-bridge-docker base image
- Adds PX4 Autopilot SITL (Software-In-The-Loop) build
- Gazebo Garden simulator with PX4 models
- Ready-to-run simulation environment for testing

**[px4-flight-test-docker](https://github.com/derickcoder44/px4-flight-test-docker)** (Submodule - Testing Layer)
- Builds FROM px4-sim-docker simulation image
- Adds automated flight testing scripts (takeoff, hover, land)
- Video recording capabilities for CI/CD
- Python-based test orchestration

## Quick Start

### Clone with Submodules

```bash
# Clone the repository with submodules
git clone --recursive https://github.com/derickcoder44/PX4-PreFlight.git

# Or if already cloned, initialize submodules
git submodule update --init --recursive
```

### Using Docker Images Independently

Each Docker image can be pulled from GitHub Container Registry and used standalone:

```bash
# Use the base ROS 2 + DDS Agent image
docker pull ghcr.io/derickcoder44/ros-px4-bridge-docker:latest

# Use the PX4 SITL simulation image
docker pull ghcr.io/derickcoder44/px4-sim-docker:latest

# Use the flight test image
docker pull ghcr.io/derickcoder44/px4-flight-test-docker:latest
```

Or add as submodules to your project:

```bash
# Add base layer
git submodule add https://github.com/derickcoder44/ros-px4-bridge-docker.git

# Add simulation layer
git submodule add https://github.com/derickcoder44/px4-sim-docker.git

# Add testing layer
git submodule add https://github.com/derickcoder44/px4-flight-test-docker.git
```

## Features

- **Docker-Based Simulation**: Containerized PX4 SITL with Gazebo Garden
- **ROS 2 Integration**: Full ROS 2 Humble support with px4_msgs and px4_ros_com
- **Automated Testing**: CI/CD workflows for PX4+ROS 2 integration testing
- **Flight Testing**: Python script for automated takeoff, hover, and landing tests
- **Local Testing**: Test GitHub Actions workflows locally with `act`
- **Reusable Workflows**: Modular workflow design for use in other projects

## Development Workflow

### Running Tests Locally

```bash
# Test all workflows locally using act
./run_all_workflows_local.sh

# This will:
# - Run full integration tests
# - Execute flight tests with video recording
# - Save artifacts to /tmp/act-artifacts/
```

### Setting Up PX4 Environment

```bash
# Install dependencies (in container or local)
cd ros-px4-bridge-docker
./scripts/install_dependencies.sh
./scripts/install_gazebo.sh
./scripts/install_dds_agent.sh

# Prepare workspace
./scripts/prepare_workspace.sh

# Build PX4 and ROS
./scripts/build_px4.sh
./scripts/build_ros2.sh

# Run simulation
./scripts/run_dds_agent.sh      # Terminal 1
./scripts/run_simulation.sh     # Terminal 2
```

## CI/CD Integration

The repository includes GitHub Actions workflows that run automatically on push and pull requests.

### Workflow Structure

**full_integration.yml** - Main orchestrator workflow that:
- Builds Docker images (ros-bridge and px4-sim)
- Runs PX4+ROS 2 integration tests
- Executes flight tests with takeoff, hover, and landing
- Uploads artifacts (logs, videos) on failure

**px4_ros_integration.yml** - Reusable workflow that:
- Pulls pre-built container images from GHCR
- Starts DDS agent and PX4 SITL simulation
- Verifies ROS 2 topic communication
- Tests sensor data streaming from PX4 to ROS 2

## Updating Submodules

```bash
# Update all submodules to latest
git submodule update --remote --recursive

# Or update individual submodules:
git submodule update --remote ros-px4-bridge-docker
git submodule update --remote px4-sim-docker
git submodule update --remote px4-flight-test-docker

# Commit submodule updates
git add ros-px4-bridge-docker px4-sim-docker px4-flight-test-docker
git commit -m "Update submodules to latest versions"
```

## Use Cases

### For PX4 Developers
- Test PX4 Autopilot changes with ROS 2 integration
- Verify SITL simulation with Gazebo
- Validate DDS communication between PX4 and ROS 2

### For ROS 2 Developers
- Test ROS 2 nodes with PX4 simulation
- Develop autonomous flight algorithms
- Prototype drone control systems

### For CI/CD Integration
- Use reusable workflows in other repositories
- Automate PX4+ROS 2 testing in your projects
- Leverage Docker-based testing infrastructure

## Contributing

Contributions are welcome! The submodules have their own repositories:
- Contribute to [ros-px4-bridge-docker](https://github.com/derickcoder44/ros-px4-bridge-docker)
- Contribute to [px4-sim-docker](https://github.com/derickcoder44/px4-sim-docker)
- Contribute to [px4-flight-test-docker](https://github.com/derickcoder44/px4-flight-test-docker)

## License

See LICENSE file for details.

## Resources

- [PX4 Autopilot](https://github.com/PX4/PX4-Autopilot)
- [ROS 2 Documentation](https://docs.ros.org/en/humble/)
- [Gazebo](https://gazebosim.org/)
