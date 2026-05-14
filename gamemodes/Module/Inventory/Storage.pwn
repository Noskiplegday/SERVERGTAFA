// Module/Inventory/Storage.pwn
// Xu ly storage chung (nha, xe).
// Logic chinh da nam trong House_Storage.pwn.
// File nay chua lenh /drop item.

stock InvStorage_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/drop", true, 5))
    {
        new params[32];
        strmid(params, cmdtext, 6, strlen(cmdtext), sizeof(params));
        new slot = strval(params) - 1;
        if(slot < 0 || slot >= MAX_INV_SLOTS)
        {
            SendClientMessage(playerid, COLOR_RED, "Dung: /drop [so slot 1-10]");
            return 1;
        }
        if(PlayerData[playerid][pInvItem][slot] == ITEM_NONE)
        {
            SendClientMessage(playerid, COLOR_RED, "Slot nay trong!");
            return 1;
        }

        new name[32];
        Item_GetName(PlayerData[playerid][pInvItem][slot], name, sizeof(name));
        new msg[128];
        format(msg, sizeof(msg), "Da bo %s x%d.", name, PlayerData[playerid][pInvAmount][slot]);
        SendClientMessage(playerid, COLOR_YELLOW, msg);

        PlayerData[playerid][pInvItem][slot] = ITEM_NONE;
        PlayerData[playerid][pInvAmount][slot] = 0;
        return 1;
    }
    return 0;
}
