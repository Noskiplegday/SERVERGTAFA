// Module/World/Dynamic_House.pwn
// Tao them nha dong (admin cmd).

stock DynHouse_Init()
{
    print("[World] Dynamic houses da san sang.");
    return 1;
}

stock DynHouse_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/createhouse", true, 12))
    {
        if(PlayerData[playerid][pAdminLevel] < 5)
        {
            SendClientMessage(playerid, COLOR_RED, "Can admin level 5!");
            return 1;
        }
        new params[64];
        strmid(params, cmdtext, 13, strlen(cmdtext), sizeof(params));

        new p1[16], p2[8], pi = 0, ci = 0;
        while(params[pi] && params[pi] != ' ') { if(ci < 15) p1[ci] = params[pi]; ci++; pi++; }
        p1[ci] = EOS;
        if(params[pi] == ' ') pi++;
        ci = 0;
        while(params[pi]) { if(ci < 7) p2[ci] = params[pi]; ci++; pi++; }
        p2[ci] = EOS;

        new price = strval(p1), interior = strval(p2);
        if(price <= 0) price = 50000;
        if(interior < 0 || interior > 18) interior = 0;

        new Float:px, Float:py, Float:pz;
        GetPlayerPos(playerid, px, py, pz);

        new h = House_Add(px, py, pz, 223.0, 1289.0, 1082.1, interior, price);
        if(h == -1) { SendClientMessage(playerid, COLOR_RED, "Da dat gioi han nha!"); return 1; }

        House_SaveOne(h);

        new msg[128];
        format(msg, sizeof(msg), "Da tao nha #%d tai vi tri hien tai. Gia: $%d, Interior: %d", h, price, interior);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }
    return 0;
}
