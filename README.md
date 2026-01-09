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
├── .github/workflows/
│   ├── full_integration.yml      - Main CI/CD orchestrator
│   └── px4_ros_integration.yml   - Reusable PX4+ROS2 test workflow
└── run_all_workflows_local.sh    - Local testing script (using act)
```

### Components

**[ros-px4-bridge-docker](https://github.com/derickcoder44/ros-px4-bridge-docker)** (Submodule)
- Containerized PX4 SITL simulation environment
- ROS 2 Humble + Gazebo Garden + Micro XRCE-DDS Agent
- Build and runtime scripts for PX4 and ROS 2
- Python-based flight test script (takeoff, hover, land)
- Reusable in any project requiring PX4 simulation

## Quick Start

### Clone with Submodules

```bash
# Clone the repository with submodules
git clone --recursive https://github.com/derickcoder44/PX4-PreFlight.git

# Or if already cloned, initialize submodules
git submodule update --init --recursive
```

### Using ros-px4-bridge-docker Independently

The Docker environment can be used as a standalone submodule in other projects:

```bash
# Add to your project
git submodule add https://github.com/derickcoder44/ros-px4-bridge-docker.git

# Use the scripts
cd ros-px4-bridge-docker
./scripts/install_dependencies.sh
./scripts/build_px4.sh
./scripts/run_simulation.sh
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

## Updating Submodule

```bash
# Update ros-px4-bridge-docker to latest
git submodule update --remote ros-px4-bridge-docker

# Commit submodule update
git add ros-px4-bridge-docker
git commit -m "Update ros-px4-bridge-docker to latest version"
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

Contributions are welcome! The ros-px4-bridge-docker submodule has its own repository:
- Contribute to [ros-px4-bridge-docker](https://github.com/derickcoder44/ros-px4-bridge-docker)

## License

See LICENSE file for details.

## Resources

- [PX4 Autopilot](https://github.com/PX4/PX4-Autopilot)
- [ROS 2 Documentation](https://docs.ros.org/en/humble/)
- [Gazebo](https://gazebosim.org/)
