ARCH            = $(shell uname -m | sed s,i[3456789]86,ia32,)

OBJS            = src/main.o
TARGET          = kernel.efi


EFIINC        = /usr/include/efi
EFIINCS       = -I$(EFIINC) -I$(EFIINC)/$(ARCH) -I$(EFIINC)/protocol
EFI_CRT_OBJS  = /usr/lib/crt0-efi-$(ARCH).o
EFI_LDS       = /usr/lib/elf_$(ARCH)_efi.lds


CFLAGS          = $(EFIINCS) -fno-stack-protector -fpic \
		  -fshort-wchar -mno-red-zone -Wall -DEFI_FUNCTION_WRAPPER
OVMF          = /usr/share/ovmf/ovmf_x64.bin


LDFLAGS       = -nostdlib -znocombreloc -T $(EFI_LDS) -shared -Bsymbolic -L /usr/lib $(EFI_CRT_OBJS)

all: $(TARGET)

boot: kernel.efi
	mkdir -p ./hda/EFI/BOOT
	cp kernel.efi ./hda/EFI/BOOT/BOOTx64.efi
	qemu-system-x86_64 -bios $(OVMF) -L . -hda fat:./hda

%.efi: %.so
	objcopy -j .text -j .sdata -j .data -j .dynamic \
		-j .dynsym  -j .rel -j .rela -j .reloc \
		--target=efi-app-$(ARCH) $^ $@


kernel.so: $(OBJS)
	ld $(LDFLAGS) $(OBJS) -o $@ -lefi -lgnuefi
