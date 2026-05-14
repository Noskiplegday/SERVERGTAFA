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
    new File:f = fopen("server_log.txt", io_append);
    if(!f) return 0;

    new year, month, day, hour, minute, second;
    getdate(year, month, day);
    gettime(hour, minute, second);

    new line[512];
    format(line, sizeof(line), "[%04d-%02d-%02d %02d:%02d:%02d] %s\n",
        year, month, day, hour, minute, second, text);
    fwrite(f, line);
    fclose(f);
    return 1;
}

stock ServerLog_PlayerAction(playerid, const action[])
{
    new msg[256];
    format(msg, sizeof(msg), "[Player] %s: %s", PlayerData[playerid][pName], action);
    ServerLog_Write(msg);
    return 1;
}
