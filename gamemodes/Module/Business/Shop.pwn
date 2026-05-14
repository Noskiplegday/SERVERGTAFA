// Module/Business/Shop.pwn
// Mua do tai shop (24/7, v.v.).

stock Shop_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/buy", true, 4) || !strcmp(cmdtext, "/shop", true, 5))
    {
        new vw = GetPlayerVirtualWorld(playerid);
        if(vw < 1000 || vw >= 1000 + MAX_BUSINESSES)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban phai vao shop truoc! (/benter)");
            return 1;
        }

        ShowPlayerDialog(playerid, DIALOG_SHOP, DIALOG_STYLE_LIST,
            "CUA HANG",
            "Thuc an ($50)\nNuoc ($30)\nThuoc ($200)\nAo giap ($500)\nDien thoai ($300)\nGPS ($100)",
            "Mua",
            "Dong");
        return 1;
    }
    return 0;
}

stock Shop_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid == DIALOG_SHOP)
    {
        if(!response) return 1;

        new itemid, price;
        switch(listitem)
        {
            case 0: { itemid = ITEM_FOOD; price = 50; }
            case 1: { itemid = ITEM_WATER; price = 30; }
            case 2: { itemid = ITEM_MEDKIT; price = 200; }
            case 3: { itemid = ITEM_ARMOR; price = 500; }
            case 4: { itemid = ITEM_PHONE; price = 300; }
            case 5: { itemid = ITEM_GPS; price = 100; }
            default: return 1;
        }

        if(!Economy_HasMoney(playerid, price))
        {
            SendClientMessage(playerid, COLOR_RED, "Khong du tien!");
            return 1;
        }

        if(!Inventory_AddItem(playerid, itemid, 1))
        {
            SendClientMessage(playerid, COLOR_RED, "Inventory day!");
            return 1;
        }

        Economy_TakeMoney(playerid, price);
        new name[32], msg[128];
        Item_GetName(itemid, name, sizeof(name));
        format(msg, sizeof(msg), "Da mua %s voi gia $%d.", name, price);
        SendClientMessage(playerid, COLOR_GREEN, msg);

        new vw = GetPlayerVirtualWorld(playerid);
        new b = vw - 1000;
        if(b >= 0 && b < TotalBusinesses && BusinessData[b][bOwnerID] != -1)
        {
            BusinessData[b][bIncome] += price / 10;
        }
        return 1;
    }
    return 0;
}
