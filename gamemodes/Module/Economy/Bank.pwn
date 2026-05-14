// Module/Economy/Bank.pwn
// He thong ngan hang: gui, rut, chuyen tien.

new Float:BankPos[] = {1460.0, -1011.0, 26.8};

stock Bank_ShowMenu(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_BANK_MENU, DIALOG_STYLE_LIST,
        "NGAN HANG VAN CANH CITY",
        "Gui tien\nRut tien\nChuyen tien\nXem so du",
        "Chon",
        "Dong");
}

stock Bank_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/deposit", true, 8))
    {
        ShowPlayerDialog(playerid, DIALOG_BANK_DEPOSIT, DIALOG_STYLE_INPUT,
            "GUI TIEN",
            "Nhap so tien muon gui vao ngan hang:",
            "Gui",
            "Huy");
        return 1;
    }

    if(!strcmp(cmdtext, "/withdraw", true, 9))
    {
        ShowPlayerDialog(playerid, DIALOG_BANK_WITHDRAW, DIALOG_STYLE_INPUT,
            "RUT TIEN",
            "Nhap so tien muon rut:",
            "Rut",
            "Huy");
        return 1;
    }

    if(!strcmp(cmdtext, "/transfer", true, 9))
    {
        ShowPlayerDialog(playerid, DIALOG_BANK_TRANSFER, DIALOG_STYLE_INPUT,
            "CHUYEN TIEN",
            "Nhap ID nguoi nhan:",
            "Tiep",
            "Huy");
        return 1;
    }

    return 0;
}
