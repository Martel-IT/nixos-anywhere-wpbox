# NixOS Anywhere WPBox

This repo contains the **Infrastructure as Code (IaC)** configuration for partitiong, mounting and deploying NixOS, managed via **Nix Flakes** and **Disko**.

The project is designed to manage multiple nodes (x86 and ARM/Graviton) with declarative storage configurations, allowing the installation of the entire operating system on a fresh machine (or overwriting an existing OS) with a single command.


## Documentation

Complete documentation is available in the docs/ directory. Below is a quick index:



1. **[Introduction and Philosophy][intro]**
    * Why NixOS and Flakes?
    * What is NixOS Anywhere?
    * What is Disko?
2. **[Project Architecture][architecture]**
    * Node Structure (aarch64, x86, devm)
    * Storage Configuration (Disko)
3. **[Deployment Guide][deployment]**
    * Prerequisites
    * Commands for macOS (Apple Silicon) and Linux
    * Troubleshooting common errors


[intro]: docs/01-introduction.md
[architecture]: docs/02-architecture.md
[deployment]: docs/03-deployment.md