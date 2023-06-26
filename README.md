# nocap
`nocap` short for no capslock, is an eBPF based application which allows complete control over the `input_event` function.

## Why?
<p align="center">
  <img src="./assets/IBM.png"/>
  <i>IBM Model F Keyboard, Observe that the ctrl key is besides the A key. They took this from you.</i>
</p>

Remap ctrl over the capslock key in a way that does not depend on input read from `/dev/input*` (or libinput), meaning your remapped ctrl will stay remapped, even when using a kvm guest, or when using the linux console.

# Using:
To make this work we require a custom Kernel.

## Building:
TODO:

### Busybox
```shell
$ make defconfig
$ make menuconfig
```
Navigate to: Busybox Settings > Build Options > Build BusyBox as a static binary (no shared libs) > yes

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
