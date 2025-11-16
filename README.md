# Docker Cleanup Pro (Windows Edition)

Version: 1.0  
Author: Matheus Nevoa  
Windows adaptation: Mateus Pontes  
Original Repository (Linux): https://github.com/matheusnevoa/docker-cleanup-pro

Docker Cleanup Pro is a professional and interactive script designed to clean and optimize Docker environments on Windows.  
It is ideal for developers and administrators who use Docker or Portainer and want to free disk space, remove unused resources, and keep their environment clean and efficient.

---

## What this script does

The tool provides three cleanup levels:

1. Basic Cleanup
   - Removes stopped containers
   - Removes unused networks
   - Removes dangling images

2. Advanced Cleanup
   - Includes everything in Basic Cleanup
   - Removes orphaned volumes
   - Removes unused images
   - Clears build cache

3. Total Cleanup
   - Removes all unused resources
   - Containers, images, volumes, and networks

Additionally, the script can generate a disk usage report showing Docker data usage and system storage information.

---

## Installation (Windows)

You can install Docker Cleanup Pro using the automatic Windows installer script.

### Automatic installation

Run the following PowerShell command:

```ps1
irm https://raw.githubusercontent.com/mtpontes/docker-cleanup-pro/refs/heads/main/install.ps1 | iex
