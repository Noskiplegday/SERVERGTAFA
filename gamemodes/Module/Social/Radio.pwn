// Module/Social/Radio.pwn
// Radio chat cho faction.

stock Radio_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/radio", true, 6) || !strcmp(cmdtext, "/r", true, 2))
    {
        if(PlayerData[playerid][pFaction] == FACTION_NONE)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong thuoc to chuc nao!");
            return 1;
        }
        if(!PlayerData[playerid][pOnDuty])
        {
            SendClientMessage(playerid, COLOR_RED, "Ban phai on duty de su dung radio!");
            return 1;
        }

        new params[128];
        new start = (!strcmp(cmdtext, "/r ", true, 3)) ? 3 : 7;
        strmid(params, cmdtext, start, strlen(cmdtext), sizeof(params));

        if(strlen(params) < 1)
        {
            SendClientMessage(playerid, COLOR_RED, "Dung: /radio [noi dung]");
            return 1;
        }

        new msg[256];
        format(msg, sizeof(msg), "[Radio] %s: %s", PlayerData[playerid][pName], params);

        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(!IsPlayerConnected(i) || !Session_IsLoggedIn(i)) continue;
            if(PlayerData[i][pFaction] == PlayerData[playerid][pFaction] && PlayerData[i][pOnDuty])
            {
                SendClientMessage(i, COLOR_RADIO, msg);
            }
        }
        return 1;
    }
    return 0;
}
