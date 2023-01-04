# Project Template

This repository serves as a reasonable template for Kubernetes controller-runtime based projects.

## How to use this

1. [Generate a new repository from the template](https://github.com/joelanford/project-template/generate) and clone the new repository locally.
2. Change the go module path

   ```console
   modulePath="example.com/myorg/myrepo"
   find . -type f -exec sed -i "s|github.com/joelanford/project-template|$modulePath|g" {} \;
   ```

3. Change the container image repository

   ```console
   imageOrg="registry.example.com/myorg"
   find . -type f -exec sed -i "s|quay.io/joelanford|${imageOrg}|g" {} \;
   ```

## Features

### Makefile
### GitHub workflows
### GoReleaser
### Multi-arch container image builds
### Git-based version number injection
### Golang CI Lint
### go-apidiff
