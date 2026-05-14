// Module/World/Dynamic_Faction.pwn
// Tao them faction dong (admin cmd).

stock DynFaction_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/createfaction", true, 14))
    {
        if(PlayerData[playerid][pAdminLevel] < 5)
        {
            SendClientMessage(playerid, COLOR_RED, "Can admin level 5!");
            return 1;
        }
        new params[64];
        strmid(params, cmdtext, 15, strlen(cmdtext), sizeof(params));

        new p1[32], p2[8], pi = 0, ci = 0;
        while(params[pi] && params[pi] != ' ') { if(ci < 31) p1[ci] = params[pi]; ci++; pi++; }
        p1[ci] = EOS;
        if(params[pi] == ' ') pi++;
        ci = 0;
        while(params[pi]) { if(ci < 7) p2[ci] = params[pi]; ci++; pi++; }
        p2[ci] = EOS;

        new fid = strval(p2);
        if(fid <= 0) fid = TotalFactions + 1;

        new Float:px, Float:py, Float:pz;
        GetPlayerPos(playerid, px, py, pz);

        Faction_Create(p1, fid, px, py, pz);

        new msg[128];
        format(msg, sizeof(msg), "Da tao faction '%s' (ID %d) tai vi tri hien tai.", p1, fid);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }
    return 0;
}
