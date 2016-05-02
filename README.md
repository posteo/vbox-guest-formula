# VBox - Guest - Formula

This salt formula installs the VirtualBox Guest Additions from an ISO file for you. It takes care of automatically mounting the ISO file as a loop device. You can define, which users should automatically be added to the shared folders user group. It complements the standard salt vbox_guest module, which only supports installing Guest Additions from an already mounted CD-ROM.

## Supported Operating Systems

This module has been tested on Debian 7/8.

If you successfully use it on a different operating system, please open a pull request that updates this Readme. If you have problems running this module under your specific operating system, please consider contributing a fix for your operating system as a pull request.

## Usage

### Available states
`vbox-guest`
* mounts a specific ISO file (default: /root/VBoxGuestAdditions.iso, which is the default place at which the virtualbox builders of packer.io place the ISO)
* installs the Guest Additions and their dependencies (only Debian implemented so far)
* adds users specified in the pillar to the shared folder user group

### Defining dependencies to available states

If you want to use the standard salt state to add shared folder access rights to users, you can do the following to ensure vbox-guest additions have been installed before (from an ISO file):
```yaml
vbox_guest.grant_access_to_shared_folders_to:
  - name: user1
  - require:
    - cmd: vbox-guest.additions-installed
```

## Contributing

If you
* fixed a problem
* improved the documentation
* extended this module (e.g. supporting more operating systems, more pillar examples, ...)
please submit your contribution as a pull request.

Thank you very much for your interest and contributions!