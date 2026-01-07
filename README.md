# PX4-PreFlight

Complete integration testing suite for PX4 Autopilot with modular, reusable components.

## Overview

PX4-PreFlight is a comprehensive testing framework that orchestrates multiple specialized modules for PX4 development and testing. It uses a modular architecture with git submodules, allowing individual components to be inherited and reused across different projects.

## Architecture

This repository follows a modular design where each component is maintained as an independent submodule:

```
PX4-PreFlight/                    (Orchestrator)
├── ros-px4-bridge-docker/        (Submodule) - ROS 2 + PX4 Docker bridge
├── px4-github-workflows/         (Submodule) - CI/CD workflows
├── code-checker/                 (Submodule) - Code quality tools
└── .github/workflows/            (Orchestrator workflows)
```

### Submodules

1. **[ros-px4-bridge-docker](https://github.com/derickcoder44/ros-px4-birdge-docker)**
   - ROS 2 + PX4 Docker bridge functionality
   - Build scripts, simulation runners, DDS agent setup
   - Reusable in any project needing PX4 simulation

2. **[px4-github-workflows](https://github.com/derickcoder44/px4-github-workflows)**
   - Reusable GitHub Actions workflows for PX4+ROS 2
   - CI/CD templates and local testing utilities
   - Can be inherited by other repos for automated testing

3. **[code-checker](https://github.com/derickcoder44/code-checker)**
   - Type checking, linting, and auto-review tools
   - Language-agnostic code quality enforcement
   - Reusable across any codebase

## Quick Start

### Clone with Submodules

```bash
# Clone the repository with all submodules
git clone --recursive https://github.com/derickcoder44/PX4-PreFlight.git

# Or if already cloned, initialize submodules
git submodule update --init --recursive
```

### Using Individual Modules

Each submodule can be used independently:

```bash
# Use just the ROS 2 + PX4 Docker bridge
git submodule add https://github.com/derickcoder44/ros-px4-birdge-docker.git

# Use just the workflows
git submodule add https://github.com/derickcoder44/px4-github-workflows.git

# Use just the code checker
git submodule add https://github.com/derickcoder44/code-checker.git
```

## Features

- **Modular Design**: Each component is independent and reusable
- **Automated Testing**: Complete CI/CD pipeline for PX4+ROS 2 integration
- **Code Quality**: Automated type checking, linting, and reviews
- **Docker Support**: Containerized PX4 simulation environment
- **Local Testing**: Test GitHub Actions workflows locally with `act`

## Development Workflow

### Running Tests Locally

```bash
# Test PX4+ROS2 workflow locally
cd px4-github-workflows
./test_workflow.sh

# Run code quality checks
cd code-checker
./scripts/run_linters.sh .
./scripts/run_type_check.sh .
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

The repository includes orchestrator workflows that combine all submodule capabilities. These run automatically on push and pull requests.

### Workflow Structure

- **Full Integration Test**: Tests PX4+ROS 2 integration using workflows from `px4-github-workflows`
- **Code Quality Checks**: Runs type checking and linting from `code-checker`
- **Simulation Validation**: Uses scripts from `ros-px4-bridge-docker` for environment setup

## Updating Submodules

```bash
# Update all submodules to latest
git submodule update --remote

# Update specific submodule
git submodule update --remote ros-px4-bridge-docker

# Commit submodule updates
git add .
git commit -m "Update submodules to latest versions"
```

## Use Cases

### For PX4 Developers
Use the complete suite for comprehensive testing of PX4 changes.

### For ROS 2 Developers
Include `ros-px4-bridge-docker` and `px4-github-workflows` for PX4 integration testing.

### For General Projects
Use `code-checker` independently for code quality enforcement.

## Contributing

Each submodule has its own repository and can be improved independently:
- Contribute to [ros-px4-bridge-docker](https://github.com/derickcoder44/ros-px4-birdge-docker)
- Contribute to [px4-github-workflows](https://github.com/derickcoder44/px4-github-workflows)
- Contribute to [code-checker](https://github.com/derickcoder44/code-checker)

## License

See LICENSE file for details.

## Resources

- [PX4 Autopilot](https://github.com/PX4/PX4-Autopilot)
- [ROS 2 Documentation](https://docs.ros.org/en/humble/)
- [Gazebo](https://gazebosim.org/)
