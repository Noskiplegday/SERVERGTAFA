// Module/Security/Server_Log.pwn
// Ghi log server.

stock ServerLog_Init()
{
    ServerLog_Write("[Server] Server khoi dong.");
    print("[Security] ServerLog da san sang.");
    return 1;
}

stock ServerLog_Write(const text[])
{
    print(text);
    return 1;
}

stock ServerLog_PlayerAction(playerid, const action[])
{
    new msg[256];
    format(msg, sizeof(msg), "[Player] %s: %s", PlayerData[playerid][pName], action);
    ServerLog_Write(msg);
    return 1;
}
