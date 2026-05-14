// Core/Session.pwn
// Quan ly trang thai dang nhap, timer auto-save va reset session.

stock Session_Reset(playerid)
{
    PlayerData[playerid][pLoggedIn] = false;
    PlayerData[playerid][pID] = 0;
    PlayerData[playerid][pPassword][0] = EOS;
    PlayerData[playerid][pLoginAttempts] = 0;
    PlayerData[playerid][pSaveTimerID] = 0;
    PlayerData[playerid][pPaycheckTimerID] = 0;
    PlayerData[playerid][pJailTimerID] = 0;
    PlayerData[playerid][pHungerTimerID] = 0;
    PlayerData[playerid][pJobTimerID] = 0;
    PlayerData[playerid][pCallingTo] = INVALID_PLAYER_ID;
    PlayerData[playerid][pInCall] = false;
    PlayerData[playerid][pOnJob] = false;
    PlayerData[playerid][pOnDuty] = false;
    PlayerData[playerid][pACWarnings] = 0;
    return 1;
}

stock Session_Login(playerid)
{
    PlayerData[playerid][pLoggedIn] = true;

    PlayerData[playerid][pSaveTimerID] = SetTimerEx("Session_AutoSave", gAutoSaveInterval * 1000, true, "i", playerid);
    PlayerData[playerid][pPaycheckTimerID] = SetTimerEx("Session_Paycheck", gPaycheckInterval * 1000, true, "i", playerid);
    PlayerData[playerid][pHungerTimerID] = SetTimerEx("Session_HungerThirst", 60000, true, "i", playerid);
    return 1;
}

stock bool:Session_IsLoggedIn(playerid)
{
    return PlayerData[playerid][pLoggedIn];
}

stock Session_Cleanup(playerid)
{
    if(PlayerData[playerid][pSaveTimerID])
    {
        KillTimer(PlayerData[playerid][pSaveTimerID]);
        PlayerData[playerid][pSaveTimerID] = 0;
    }
    if(PlayerData[playerid][pPaycheckTimerID])
    {
        KillTimer(PlayerData[playerid][pPaycheckTimerID]);
        PlayerData[playerid][pPaycheckTimerID] = 0;
    }
    if(PlayerData[playerid][pJailTimerID])
    {
        KillTimer(PlayerData[playerid][pJailTimerID]);
        PlayerData[playerid][pJailTimerID] = 0;
    }
    if(PlayerData[playerid][pHungerTimerID])
    {
        KillTimer(PlayerData[playerid][pHungerTimerID]);
        PlayerData[playerid][pHungerTimerID] = 0;
    }
    if(PlayerData[playerid][pJobTimerID])
    {
        KillTimer(PlayerData[playerid][pJobTimerID]);
        PlayerData[playerid][pJobTimerID] = 0;
    }
    Session_Reset(playerid);
    return 1;
}

forward Session_AutoSave(playerid);
public Session_AutoSave(playerid)
{
    if(!IsPlayerConnected(playerid) || !Session_IsLoggedIn(playerid)) return 1;
    PlayerData_Save(playerid);
    return 1;
}

forward Session_Paycheck(playerid);
public Session_Paycheck(playerid)
{
    if(!IsPlayerConnected(playerid) || !Session_IsLoggedIn(playerid)) return 1;
    Economy_Paycheck(playerid);
    return 1;
}

forward Session_HungerThirst(playerid);
public Session_HungerThirst(playerid)
{
    if(!IsPlayerConnected(playerid) || !Session_IsLoggedIn(playerid)) return 1;

    if(PlayerData[playerid][pHunger] > 0)
        PlayerData[playerid][pHunger]--;
    if(PlayerData[playerid][pThirst] > 0)
        PlayerData[playerid][pThirst]--;

    if(PlayerData[playerid][pHunger] <= 10)
    {
        SendClientMessage(playerid, COLOR_RED, "Ban dang rat doi! Hay an gi do.");
        new Float:hp;
        GetPlayerHealth(playerid, hp);
        if(hp > 10.0)
            SetPlayerHealth(playerid, hp - 5.0);
    }

    if(PlayerData[playerid][pThirst] <= 10)
    {
        SendClientMessage(playerid, COLOR_RED, "Ban dang rat khat! Hay uong gi do.");
        new Float:hp;
        GetPlayerHealth(playerid, hp);
        if(hp > 10.0)
            SetPlayerHealth(playerid, hp - 5.0);
    }
    return 1;
}
