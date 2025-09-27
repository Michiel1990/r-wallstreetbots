# Git Project Prerequisites
This document outlines the essential hardware and configuration requirements needed to start the Git project, focusing on a **Raspberry Pi 5** as the primary development environment accessed remotely.

## 1. Hardware
* **Raspberry Pi 5:** The core computing device for the project.

## 2. Operating System & Access
* **OS:** **Raspberry Pi OS Lite (64-bit)**
    * This is a **Debian/UNIX-based** operating system.
    * **No Desktop GUI** is provided; it's a command-line-only environment.
* **Access:** **"Headless" Access via SSH**
    * Remote shell access is configured exclusively through the **SSH protocol**.
    * Authentication uses **SSH Key-Pairs** for enhanced security.

---

## 3. GitHub Configuration

* **GitHub SSH Access:** Configured to allow secure, passwordless interaction with remote repositories.
    * **MacBook:** An **encrypted SSH Key** is set up for local interaction and management.
    * **Raspberry Pi 5:** A dedicated **SSH Key** is configured for operations directly from the device.