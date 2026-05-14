// Module/Inventory/Inventory.pwn
// He thong inventory: xem, dung, bo, them item.

stock Inventory_Init()
{
    print("[Inventory] He thong inventory da san sang.");
    return 1;
}

stock bool:Inventory_AddItem(playerid, itemid, amount)
{
    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        if(PlayerData[playerid][pInvItem][i] == itemid)
        {
            PlayerData[playerid][pInvAmount][i] += amount;
            return true;
        }
    }

    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        if(PlayerData[playerid][pInvItem][i] == ITEM_NONE)
        {
            PlayerData[playerid][pInvItem][i] = itemid;
            PlayerData[playerid][pInvAmount][i] = amount;
            return true;
        }
    }
    return false;
}

stock bool:Inventory_RemoveItem(playerid, itemid, amount)
{
    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        if(PlayerData[playerid][pInvItem][i] == itemid)
        {
            PlayerData[playerid][pInvAmount][i] -= amount;
            if(PlayerData[playerid][pInvAmount][i] <= 0)
            {
                PlayerData[playerid][pInvItem][i] = ITEM_NONE;
                PlayerData[playerid][pInvAmount][i] = 0;
            }
            return true;
        }
    }
    return false;
}

stock bool:Inventory_HasItem(playerid, itemid)
{
    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        if(PlayerData[playerid][pInvItem][i] == itemid && PlayerData[playerid][pInvAmount][i] > 0)
            return true;
    }
    return false;
}

stock Inventory_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/inventory", true, 10) || !strcmp(cmdtext, "/inv", true, 4))
    {
        new dialog[1024], line[64], name[32];
        dialog[0] = EOS;

        for(new i = 0; i < MAX_INV_SLOTS; i++)
        {
            if(PlayerData[playerid][pInvItem][i] != ITEM_NONE)
            {
                Item_GetName(PlayerData[playerid][pInvItem][i], name, sizeof(name));
                format(line, sizeof(line), "Slot %d: %s x%d\n", i + 1, name, PlayerData[playerid][pInvAmount][i]);
            }
            else
            {
                format(line, sizeof(line), "Slot %d: Trong\n", i + 1);
            }
            strcat(dialog, line, sizeof(dialog));
        }

        ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST,
            "INVENTORY",
            dialog,
            "Dung",
            "Dong");
        return 1;
    }
    return 0;
}

stock Inventory_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid == DIALOG_INVENTORY)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= MAX_INV_SLOTS) return 1;
        if(PlayerData[playerid][pInvItem][listitem] == ITEM_NONE)
        {
            SendClientMessage(playerid, COLOR_RED, "Slot nay trong!");
            return 1;
        }

        Inventory_UseItem(playerid, listitem);
        return 1;
    }
    return 0;
}

stock Inventory_UseItem(playerid, slot)
{
    new itemid = PlayerData[playerid][pInvItem][slot];

    switch(itemid)
    {
        case ITEM_FOOD:
        {
            PlayerData[playerid][pHunger] += 30;
            if(PlayerData[playerid][pHunger] > 100) PlayerData[playerid][pHunger] = 100;
            Inventory_RemoveItem(playerid, ITEM_FOOD, 1);
            SendClientMessage(playerid, COLOR_GREEN, "Ban da an. Do doi +30.");
        }
        case ITEM_WATER:
        {
            PlayerData[playerid][pThirst] += 30;
            if(PlayerData[playerid][pThirst] > 100) PlayerData[playerid][pThirst] = 100;
            Inventory_RemoveItem(playerid, ITEM_WATER, 1);
            SendClientMessage(playerid, COLOR_GREEN, "Ban da uong. Do khat +30.");
        }
        case ITEM_MEDKIT:
        {
            new Float:hp;
            GetPlayerHealth(playerid, hp);
            SetPlayerHealth(playerid, hp + 50.0);
            Inventory_RemoveItem(playerid, ITEM_MEDKIT, 1);
            SendClientMessage(playerid, COLOR_GREEN, "Da dung thuoc. HP +50.");
        }
        case ITEM_ARMOR:
        {
            SetPlayerArmour(playerid, 100.0);
            Inventory_RemoveItem(playerid, ITEM_ARMOR, 1);
            SendClientMessage(playerid, COLOR_GREEN, "Da mac ao giap.");
        }
        case ITEM_PHONE:
        {
            new msg[64];
            format(msg, sizeof(msg), "So dien thoai: %d", PlayerData[playerid][pPhoneNumber]);
            SendClientMessage(playerid, COLOR_GREEN, msg);
        }
        default:
        {
            SendClientMessage(playerid, COLOR_YELLOW, "Khong the su dung item nay truc tiep.");
        }
    }
    return 1;
}
