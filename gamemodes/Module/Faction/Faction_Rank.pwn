// Module/Faction/Faction_Rank.pwn
// He thong rank faction - xu ly trong Factions.pwn /promote /demote.
// File nay chua them lenh /setfaction (admin).

stock FactionRank_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/setfaction", true, 11))
    {
        if(PlayerData[playerid][pAdminLevel] < 3) { SendClientMessage(playerid, COLOR_RED, "Can admin level 3!"); return 1; }
        new params[128];
        strmid(params, cmdtext, 12, strlen(cmdtext), sizeof(params));

        new p1[8], p2[8], p3[8], pi = 0, ci = 0;
        while(params[pi] && params[pi] != ' ') { if(ci < 7) p1[ci] = params[pi]; ci++; pi++; }
        p1[ci] = EOS;
        if(params[pi] == ' ') pi++;
        ci = 0;
        while(params[pi] && params[pi] != ' ') { if(ci < 7) p2[ci] = params[pi]; ci++; pi++; }
        p2[ci] = EOS;
        if(params[pi] == ' ') pi++;
        ci = 0;
        while(params[pi]) { if(ci < 7) p3[ci] = params[pi]; ci++; pi++; }
        p3[ci] = EOS;

        new tid = strval(p1), fid = strval(p2), rank = strval(p3);
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }

        PlayerData[tid][pFaction] = fid;
        PlayerData[tid][pFactionRank] = rank;
        PlayerData_Save(tid);

        new msg[128];
        format(msg, sizeof(msg), "Da set faction %d rank %d cho %s.", fid, rank, PlayerData[tid][pName]);
        SendClientMessage(playerid, COLOR_ADMIN, msg);
        return 1;
    }
    return 0;
}
