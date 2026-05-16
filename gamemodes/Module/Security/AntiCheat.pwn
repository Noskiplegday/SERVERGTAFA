// Module/Security/AntiCheat.pwn
// Chong gian lan co ban.

stock AntiCheat_Init()
{
    print("[Security] AntiCheat da san sang.");
    return 1;
}

stock AntiCheat_OnUpdate(playerid)
{
    if(!Session_IsLoggedIn(playerid)) return 1;

    new Float:hp, Float:arm;
    GetPlayerHealth(playerid, hp);
    GetPlayerArmour(playerid, arm);

    if(hp > 100.0)
    {
        SetPlayerHealth(playerid, 100.0);
        PlayerData[playerid][pACWarnings]++;
        AntiCheat_Warn(playerid, "HP hack");
    }

    if(arm > 100.0)
    {
        SetPlayerArmour(playerid, 100.0);
        PlayerData[playerid][pACWarnings]++;
        AntiCheat_Warn(playerid, "Armor hack");
    }

    new money = GetPlayerMoney(playerid);
    if(money != PlayerData[playerid][pMoney])
    {
        ResetPlayerMoney(playerid);
        GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);

        if(money > PlayerData[playerid][pMoney])
        {
            PlayerData[playerid][pACWarnings]++;
            AntiCheat_Warn(playerid, "Money hack");
        }
    }

    if(GetPlayerWeapon(playerid) == 38) // Minigun
    {
        ResetPlayerWeapons(playerid);
        PlayerData[playerid][pACWarnings]++;
        AntiCheat_Warn(playerid, "Weapon hack (Minigun)");
    }

    if(PlayerData[playerid][pACWarnings] >= 5)
    {
        new msg[128];
        format(msg, sizeof(msg), "[AntiCheat] %s da bi kick (5 canh bao gian lan).", PlayerData[playerid][pName]);
        SendClientMessageToAll(COLOR_ADMIN, msg);
        ServerLog_Write(msg);
        SetTimerEx("Account_DelayKick", 500, false, "i", playerid);
    }
    return 1;
}

stock AntiCheat_Warn(playerid, const cheat[])
{
    new msg[128];
    format(msg, sizeof(msg), "[AC] Phat hien gian lan: %s (Canh bao %d/5)", cheat, PlayerData[playerid][pACWarnings]);
    SendClientMessage(playerid, COLOR_RED, msg);

    new log[256];
    format(log, sizeof(log), "[AntiCheat] %s: %s (Warning %d)", PlayerData[playerid][pName], cheat, PlayerData[playerid][pACWarnings]);
    ServerLog_Write(log);
}
