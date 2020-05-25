# packer-images

Ubuntu and Windows Packer images for Hyper-V builder

## Prerequisites

- Windows 10 Pro/Server with enabled [Hyper-V](https://docs.microsoft.com/en-gb/archive/blogs/canitpro/step-by-step-enabling-hyper-v-for-use-on-windows-10)
- [Packer](https://www.packer.io/)

## Ubuntu

### ubuntu-base

- creates base image from ubuntu server .iso
- uses packer [Hyper-V ISO builder](https://www.packer.io/docs/builders/hyperv/iso/)
  - creates [Generation 2](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn282285(v=ws.11)) Images
- boots to installer using [preseed config](https://help.ubuntu.com/lts/installation-guide/armhf/apbs02.html)
- username and password is setup in the boot command passing `ssh_username` and `ssh_password` packer template variables
  - you can provide either interactively or using environment variables when calling the build script `.\ubuntu\Build.ps1`
- use as baseline for other images.
- based on: https://github.com/boxcutter/ubuntu
  - made sure the template creates Geneneration 2 VM
  - made sure the template does not contantain hard-coded username, password and other sensitive environment variables
  - generate the answer ISO automatically on build

### ubuntu-server

- creates ubuntu server image from ubuntu-base image
- adds the Host SSD Public key to the image so you can ssh without password
- adds `ssh_username` to the `sudoers` so you can sudo without password

### ubuntu-desktop

Creates ubuntu desktop image from ubuntu-base image.

### customize

- [vmcx](https://www.packer.io/docs/builders/hyperv/vmcx/) images that can be used on top of `ubuntu-server`. You can also use `vmcx` images on top of other `vmcx` images - see `.\ubuntu\customize\ExampleBuilds\BuildGithubAgentDocker.ps1`
- images include
  - docker
  - github agent
  - k3s
  - microk8s
  - ansible

### Example base, server and desktop Builds

1. run powershell as local admin
2.  ```
    cd .\ubuntu\ExampleBuilds\
    ```
3. run an example build e.g.
    ```
    BuildUbuntuBase.ps1
    ```

### Example customize Builds

1. run powershell as local admin
2.  ```
    cd .\ubuntu\customize\ExampleBuilds\
    ```
3. run an example build e.g.
    ```
    BuildUbuntuDocker.ps1
    ```

### Import ubuntu Images to Hyper-V

1. Run powershell as local admin
2.  ```
    cd .\ubuntu
    ```
3. Run `ImportVM.ps1` providing `TemplateName` that matches one from `.\ubuntu\ImagesOutput\`. Optionally provide VM name e.g:
    ```
    ImportVM.ps1 -TemplateName ubuntu-server -VmName my-test-server
    ```

## Windows

### Windows base

- base images for Windows 
  - 10
  - Server 2016
  - Serer 2019
- start from .ISOs
- create [Generation 2](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn282285(v=ws.11)) Images
  - floppy disks are not avialable there so we are forced to create Answer ISO instead that is used for the unattended install
  - to do this is used [mkisofts.exe](http://sourceforge.net/projects/tumagcc/files/schily-cdrtools-3.02a05.7z/download)
    - the generated ISO is passed to the packer image via `secondary_iso_images`
  - the main script that generates the iso is `.\windows\base\baseAnswerIso\GenerateBaseAnswerIso.ps1`
    - it generates `Autounattend.xml` populating the image username, password and other environment specific variables passed to `GenerateBaseAnswerIso.ps1` 
    - copies the helper files used in `Autounattend.xml` durring the unattended windows install
- based on: https://github.com/StefanScherer/packer-windows
  - made sure the templates create Geneneration 2 VMs
  - made sure templates do not contantain hard-coded username, password and other sensitive environment variables
  - generate the answer ISO automatically on build

#### Windows base - Example builds

1. run powershell as local admin
2.  ```
    cd .\windows\base\ExampleBuilds\
    ```
3. run an example build e.g.
    ```
    BuildWin2019Core.ps1
    ```
### Windows customize

- example [vmcx](https://www.packer.io/docs/builders/hyperv/vmcx/) customization image that installs IIS
- depends on AnswerIso to provide `SysprepUnattend.xml` to generalize the image
  - see `.\windows\answerIso\GenerateSysprepAnswerIso.ps1`

### Windows customize - Example Build

1. run powershell as local admin
2.  ```
    cd .\windows\customize\
    ```
3. run an example build e.g.
    ```
    ExampleBuildIis.ps1
    ```

### Import Windows Images to Hyper-V

1. Run powershell as local admin
2.  ```
    cd .\windows
    ```
3. Run `ImportVM.ps1` providing `TemplateName` that matches one from `.\windows\ImagesOutput\`. Optionally provide VM name e.g:
    ```
    ImportVM.ps1 -TemplateName win2019-base -VmName my-win2019
    ```