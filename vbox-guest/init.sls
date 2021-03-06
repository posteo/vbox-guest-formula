{% if grains['os_family']=="Debian" %}

vbox-guest.additions-requirements:
  pkg.installed:
    - pkgs:
      - build-essential
      - module-assistant
      - linux-headers-amd64
      - dkms

vbox-guest.additions-mounted:
  mount.mounted:
    - name: /mnt/vboxcdrom
    - device: {{ salt['pillar.get']('vbox-guest:iso','/root/VBoxGuestAdditions.iso') }}
    - user: root
    - opts: loop
    - fstype: iso9660
    - mkmnt: True

vbox-guest.additions-installed:
  cmd.run:
    - name: sh /mnt/vboxcdrom/VBoxLinuxAdditions.run ; umount /mnt/vboxcdrom
    - user: root
    - require:
      - pkg: vbox-guest.additions-requirements
      - mount: vbox-guest.additions-mounted

vbox-guest.service:
  service.running:
    - name: vboxadd-service
    - enable: True
    - require:
      - cmd: vbox-guest.additions-installed
{% endif %} #END: os = debian

{% if grains['os_family']=="Gentoo" %}
vbox-guest.additions-installed:
  pkg.installed:
    - name: app-emulation/virtualbox-guest-additions

vbox-guest.service:
  service.running:
    - name: virtualbox-guest-additions
    - enable: True
    - require:
      - pkg: app-emulation/virtualbox-guest-additions
{% endif %} #END: os = gentoo

{% for user in salt.pillar.get('vbox-guest:users',[]) %}
vbox-guest.shared-folder-access-granted-to-{{ user }}:
  vbox_guest.grant_access_to_shared_folders_to:
    - name: {{ user }}
    - require:
      - user: {{ user }}
      - cmd: vbox-guest.additions-installed
      - service: vbox-guest.service
{% endfor %}