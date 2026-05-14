// Module/Gameplay/Death.pwn
// Xu ly chet, killfeed.

stock Death_OnPlayerDeath(playerid, killerid, reason)
{
    #pragma unused reason

    PlayerData[playerid][pDeaths]++;

    if(killerid != INVALID_PLAYER_ID && IsPlayerConnected(killerid))
    {
        PlayerData[killerid][pKills]++;
        PlayerData[killerid][pExp] += 3;

        new msg[128];
        format(msg, sizeof(msg), "%s da bi giet boi %s.", PlayerData[playerid][pName], PlayerData[killerid][pName]);
        SendClientMessageToAll(COLOR_RED, msg);

        new log[256];
        format(log, sizeof(log), "[Kill] %s killed %s", PlayerData[killerid][pName], PlayerData[playerid][pName]);
        ServerLog_Write(log);
    }

    SendClientMessage(playerid, COLOR_YELLOW, "Ban da chet. Dang duoc chuyen den benh vien...");

    PlayerData[playerid][pSpawnX] = 1172.0;
    PlayerData[playerid][pSpawnY] = -1323.0;
    PlayerData[playerid][pSpawnZ] = 15.4;
    return 1;
}
