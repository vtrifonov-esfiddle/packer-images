# packer-images

# Build ubuntu-desktop

run the build script with admin priviledges

## Interactively

```
.\ubuntu-desktop\Build.ps1
```

## Using Env Variables
```
$env:PACKER_USERNAME = "user"; `
$env:PACKER_PASSWORD = "password"; `
$env:VM_OUTPUT_DIRECTORY = "."; `
.\ubuntu-desktop\Build.ps1
```
