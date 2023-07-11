# nocap
Kernel patch series, and stuff, to allow eBPF programs to control input events.

## Why?
<p align="center">
  <img src="./assets/IBM.png"/ width="75%" height="75%">
  <p align="center">
      <i>IBM Model F Keyboard, Observe that the ctrl key is beside the A key. <b>They took this from you.</b></i>
  </p>
</p>

Remap `ctrl` over the caps lock key in a way that does not depend on the input read from evdev -- `/dev/input/eventX`, meaning your remapped `ctrl` will stay remapped, even when using a KVM guest, or when using the Linux console -- I think. The goal is to also allow for home-row mods, or anything really you can come up that respects the limitations of eBPF programs.

Something similar exists under HID-BPF, but, it will only work for HID devices -- USB devices. My ThinkPad still uses i8042.

# Using:
TODO:

## Building:
To make this work we require a custom Kernel.

### Busybox
```shell
$ make defconfig
$ make menuconfig
```
Navigate to: Busybox Settings --> Build Options --> Build BusyBox as a static binary (no shared libs) --> yes
```shell
$ make
$ make install
```

### Linux:
Copy the `nocap_defconfig` to `arch/x86/config/`
```shell
$ cp nocap_defconfig linux/arch/x86/config/
```

### zstd
If your distro comes with `libzstd.a` skip this.
```
$ make
```

#### Patching:
TODO:

Build the Kernel (you will need the usual dependencies):
```shell
$ make allnoconfig
$ make nocap_defconfig
$ make
$ make headers_install
```

## Generating ramfs:
```shell
$ usr/gen_initramfs.sh -o ../ramfs ../busybox/_install/ ../cpio
```
NOTE: `gen_initramfs.sh` needs to be ran from the Linux tree.

## Running qemu:
```
$ qemu-system-x86_64 -nographic -append -kernel linux/arch/x86_64/boot/bzImage -initrd ramfs "console=ttyS0" -enable-kvm
```
