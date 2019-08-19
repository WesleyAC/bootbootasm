# bootbootasm

This is a simple test of building and booting a [BOOTBOOT](https://gitlab.com/bztsrc/bootboot)-compatible kernel written in assembly in a completely automated way.

It uses BIOS, since OVMF seems to be pretty buggy. However, you should be able to create a EFI image using basically the same technique.

It currently relies on the prebuilt `bootboot.bin` file in the bootboot repo, which is imported as a submodule. It should be easy to set it up so that it builds from source, but I haven't tried yet (there's already some recursive make involved to build the `mkboot` tool).

To build the image, type `make image` - this creates `out/outer.img`, which should be bootable.

To run in qemu, type `make run`.

Dependencies:

* `mtools`
* `parted`
* `qemu-system-x86_64`
* `nasm`
* `ld`
* `gzip`
* `cpio`
* `dd`
