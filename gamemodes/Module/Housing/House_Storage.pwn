// Module/Housing/House_Storage.pwn
// Luu tru do vat trong nha.

stock HouseStorage_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/hstorage", true, 9))
    {
        new h = PlayerData[playerid][pHouseID];
        if(h < 0) { SendClientMessage(playerid, COLOR_RED, "Ban khong co nha!"); return 1; }

        new vw = GetPlayerVirtualWorld(playerid);
        if(vw != h + 100) { SendClientMessage(playerid, COLOR_RED, "Ban phai o trong nha!"); return 1; }

        new dialog[512], line[64];
        dialog[0] = EOS;
        for(new i = 0; i < MAX_HOUSE_STORAGE; i++)
        {
            if(HouseData[h][hStorage][i] != ITEM_NONE)
            {
                format(line, sizeof(line), "Slot %d: Item %d x%d\n", i, HouseData[h][hStorage][i], HouseData[h][hStorageAmt][i]);
                strcat(dialog, line, sizeof(dialog));
            }
            else
            {
                format(line, sizeof(line), "Slot %d: Trong\n", i);
                strcat(dialog, line, sizeof(dialog));
            }
        }

        ShowPlayerDialog(playerid, DIALOG_HOUSE_STORAGE, DIALOG_STYLE_LIST,
            "KHO NHA",
            dialog,
            "Lay",
            "Dong");
        return 1;
    }

    return 0;
}

stock HouseStorage_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid == DIALOG_HOUSE_STORAGE)
    {
        if(!response) return 1;
        new h = PlayerData[playerid][pHouseID];
        if(h < 0) return 1;
        if(listitem < 0 || listitem >= MAX_HOUSE_STORAGE) return 1;

        if(HouseData[h][hStorage][listitem] == ITEM_NONE)
        {
            SendClientMessage(playerid, COLOR_RED, "Slot nay trong!");
            return 1;
        }

        if(!Inventory_AddItem(playerid, HouseData[h][hStorage][listitem], HouseData[h][hStorageAmt][listitem]))
        {
            SendClientMessage(playerid, COLOR_RED, "Inventory day!");
            return 1;
        }

        new msg[64];
        format(msg, sizeof(msg), "Da lay item %d x%d tu kho nha.", HouseData[h][hStorage][listitem], HouseData[h][hStorageAmt][listitem]);
        SendClientMessage(playerid, COLOR_GREEN, msg);

        HouseData[h][hStorage][listitem] = ITEM_NONE;
        HouseData[h][hStorageAmt][listitem] = 0;
        return 1;
    }

    return 0;
}
