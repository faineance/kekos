#include <efi.h>
#include <efilib.h>

EFI_STATUS
efi_main (EFI_HANDLE image, EFI_SYSTEM_TABLE *systab)
{
    InitializeLib(image, systab);
    uefi_call_wrapper(ST->ConOut->SetAttribute, 2, ST->ConOut, EFI_GREEN | EFI_BACKGROUND_BLACK);
    uefi_call_wrapper(ST->ConOut->ClearScreen, 1, ST->ConOut);



    Print(L"██╗  ██╗███████╗██╗  ██╗     ██████╗ ███████╗\n"
           "██║ ██╔╝██╔════╝██║ ██╔╝    ██╔═══██╗██╔════╝\n"
           "█████╔╝ █████╗  █████╔╝     ██║   ██║███████╗\n"
           "██╔═██╗ ██╔══╝  ██╔═██╗     ██║   ██║╚════██║\n"
           "██║  ██╗███████╗██║  ██╗    ╚██████╔╝███████║\n"
           "╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝     ╚═════╝ ╚══════╝\n");
    uefi_call_wrapper(ST->ConOut->OutputString,2,ST->ConOut, ST->FirmwareVendor);
    Print(L"\n\n\nPress any key to exit\n");
    WaitForSingleEvent(ST->ConIn->WaitForKey, 0);
    return EFI_SUCCESS;
}

