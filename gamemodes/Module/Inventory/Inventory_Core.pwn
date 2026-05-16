// Module/Inventory/Inventory_Core.pwn
// Logic inventory co ban dung chung cho UI/shop/storage.

stock Inventory_Init()
{
    print("[Inventory] He thong inventory da san sang.");
    return 1;
}

stock Inventory_HasItem(playerid, itemid)
{
    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        if(PlayerData[playerid][pInvItem][i] == itemid && PlayerData[playerid][pInvAmount][i] > 0)
            return 1;
    }
    return 0;
}

stock Inventory_AddItem(playerid, itemid, amount)
{
    if(amount <= 0) return 0;

    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        if(PlayerData[playerid][pInvItem][i] == itemid)
        {
            PlayerData[playerid][pInvAmount][i] += amount;
            return 1;
        }
    }

    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        if(PlayerData[playerid][pInvItem][i] == ITEM_NONE || PlayerData[playerid][pInvAmount][i] <= 0)
        {
            PlayerData[playerid][pInvItem][i] = itemid;
            PlayerData[playerid][pInvAmount][i] = amount;
            return 1;
        }
    }
    return 0;
}

stock Inventory_RemoveItem(playerid, itemid, amount)
{
    if(amount <= 0) return 0;

    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        if(PlayerData[playerid][pInvItem][i] == itemid && PlayerData[playerid][pInvAmount][i] >= amount)
        {
            PlayerData[playerid][pInvAmount][i] -= amount;
            if(PlayerData[playerid][pInvAmount][i] <= 0)
            {
                PlayerData[playerid][pInvItem][i] = ITEM_NONE;
                PlayerData[playerid][pInvAmount][i] = 0;
            }
            return 1;
        }
    }
    return 0;
}

stock Inventory_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/inv", true) || !strcmp(cmdtext, "/inventory", true))
    {
        Inventory_ShowDialog(playerid);
        return 1;
    }
    return 0;
}

stock Inventory_ShowDialog(playerid)
{
    new body[512];
    body[0] = EOS;

    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        new line[48];
        if(PlayerData[playerid][pInvItem][i] == ITEM_NONE || PlayerData[playerid][pInvAmount][i] <= 0)
            format(line, sizeof(line), "Slot %d: Trong\n", i + 1);
        else
        {
            new item_name[32];
            Item_GetName(PlayerData[playerid][pInvItem][i], item_name, sizeof(item_name));
            format(line, sizeof(line), "Slot %d: %s x%d\n", i + 1, item_name, PlayerData[playerid][pInvAmount][i]);
        }
        strcat(body, line, sizeof(body));
    }

    ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "{00BFFF}HANH LY", body, "Dong", "");
    return 1;
}

stock Inventory_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused playerid
    #pragma unused dialogid
    #pragma unused response
    #pragma unused listitem
    #pragma unused inputtext
    return 0;
}
