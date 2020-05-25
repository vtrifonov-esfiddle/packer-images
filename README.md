# packer-images

## ubuntu-base

Creates base image from ubuntu server .iso. To be used for other images.
Based on: https://github.com/boxcutter/ubuntu

## ubuntu-desktop

Creates ubuntu desktop image from ubuntu-base image.

## ubuntu-server

Creates ubuntu server image from ubuntu-base image.

## Build

1. navigate to the base directory of the chosen image e.g:
```
cd .\ubuntu-base\
```
2. Build either interactively or using env variables
#### Interactively

```
.\Build.ps1
```

#### Using Env Variables
```
$env:PACKER_USERNAME = "user"; `
$env:PACKER_PASSWORD = "password"; `
$env:IMAGE_OUTPUT_DIRECTORY = "."; `
.\Build.ps1
```
