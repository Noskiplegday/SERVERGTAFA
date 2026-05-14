// Module/Security/AntiCrash.pwn
// Bao ve server khoi crash.

stock AntiCrash_Init()
{
    print("[Security] AntiCrash da san sang.");
    return 1;
}

stock AntiCrash_OnRconLogin(playerid, ip[], success)
{
    #pragma unused playerid
    if(!success)
    {
        new log[128];
        format(log, sizeof(log), "[AntiCrash] RCON login that bai tu IP: %s", ip);
        ServerLog_Write(log);
    }
    return 1;
}
