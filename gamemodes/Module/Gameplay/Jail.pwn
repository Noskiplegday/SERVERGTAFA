// Module/Gameplay/Jail.pwn
// He thong tu (jail/unjail).

new Float:JailPos[] = {197.0, 175.0, 1003.0};

stock Jail_Init()
{
    print("[Jail] He thong tu da san sang.");
    return 1;
}

stock Jail_ApplyJail(playerid)
{
    SetPlayerPos(playerid, JailPos[0], JailPos[1], JailPos[2]);
    SetPlayerInterior(playerid, 3);
    SetPlayerVirtualWorld(playerid, playerid + 2000);
    TogglePlayerControllable(playerid, false);

    new msg[128];
    format(msg, sizeof(msg), "Ban dang ngoi tu. Con %d giay.", PlayerData[playerid][pJailTime]);
    SendClientMessage(playerid, COLOR_RED, msg);

    if(PlayerData[playerid][pJailTimerID])
        KillTimer(PlayerData[playerid][pJailTimerID]);
    PlayerData[playerid][pJailTimerID] = SetTimerEx("Jail_Timer", 1000, true, "i", playerid);
    return 1;
}

stock Jail_JailPlayer(playerid, seconds)
{
    PlayerData[playerid][pJailed] = true;
    PlayerData[playerid][pJailTime] = seconds;
    Jail_ApplyJail(playerid);
    return 1;
}

stock Jail_UnjailPlayer(playerid)
{
    PlayerData[playerid][pJailed] = false;
    PlayerData[playerid][pJailTime] = 0;

    if(PlayerData[playerid][pJailTimerID])
    {
        KillTimer(PlayerData[playerid][pJailTimerID]);
        PlayerData[playerid][pJailTimerID] = 0;
    }

    TogglePlayerControllable(playerid, true);
    SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);

    SendClientMessage(playerid, COLOR_GREEN, "Ban da duoc tha! Hay song tot hon.");
    return 1;
}

forward Jail_Timer(playerid);
public Jail_Timer(playerid)
{
    if(!IsPlayerConnected(playerid) || !Session_IsLoggedIn(playerid))
    {
        KillTimer(PlayerData[playerid][pJailTimerID]);
        PlayerData[playerid][pJailTimerID] = 0;
        return 1;
    }

    PlayerData[playerid][pJailTime]--;
    if(PlayerData[playerid][pJailTime] <= 0)
    {
        Jail_UnjailPlayer(playerid);
        return 1;
    }

    if(PlayerData[playerid][pJailTime] % 30 == 0)
    {
        new msg[64];
        format(msg, sizeof(msg), "Con %d giay nua ban se duoc tha.", PlayerData[playerid][pJailTime]);
        SendClientMessage(playerid, COLOR_YELLOW, msg);
    }
    return 1;
}

stock Jail_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/jail", true, 5))
    {
        if(PlayerData[playerid][pAdminLevel] < 1 &&
           (PlayerData[playerid][pFaction] != FACTION_LSPD || !PlayerData[playerid][pOnDuty]))
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen! (Admin hoac LSPD on duty)");
            return 1;
        }

        new params[64];
        strmid(params, cmdtext, 6, strlen(cmdtext), sizeof(params));

        new p1[8], p2[8], pi = 0, ci = 0;
        while(params[pi] && params[pi] != ' ') { if(ci < 7) p1[ci] = params[pi]; ci++; pi++; }
        p1[ci] = EOS;
        if(params[pi] == ' ') pi++;
        ci = 0;
        while(params[pi]) { if(ci < 7) p2[ci] = params[pi]; ci++; pi++; }
        p2[ci] = EOS;

        new tid = strval(p1), seconds = strval(p2);
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }
        if(seconds <= 0) seconds = 60;
        if(seconds > 3600) seconds = 3600;

        Jail_JailPlayer(tid, seconds);

        new msg[128];
        format(msg, sizeof(msg), "%s da bo tu %s trong %d giay.", PlayerData[playerid][pName], PlayerData[tid][pName], seconds);
        SendClientMessageToAll(COLOR_ADMIN, msg);
        return 1;
    }

    if(!strcmp(cmdtext, "/unjail", true, 7))
    {
        if(PlayerData[playerid][pAdminLevel] < 1) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }

        new params[16];
        strmid(params, cmdtext, 8, strlen(cmdtext), sizeof(params));
        new tid = strval(params);
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }

        Jail_UnjailPlayer(tid);

        new msg[128];
        format(msg, sizeof(msg), "%s da tha %s ra khoi tu.", PlayerData[playerid][pName], PlayerData[tid][pName]);
        SendClientMessageToAll(COLOR_ADMIN, msg);
        return 1;
    }

    return 0;
}
