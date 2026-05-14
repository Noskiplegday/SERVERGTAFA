// Module/World/Dynamic_Business.pwn
// Tao them business dong (admin cmd).

stock DynBusiness_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/createbiz", true, 10))
    {
        if(PlayerData[playerid][pAdminLevel] < 5)
        {
            SendClientMessage(playerid, COLOR_RED, "Can admin level 5!");
            return 1;
        }
        new params[128];
        strmid(params, cmdtext, 11, strlen(cmdtext), sizeof(params));

        new p1[32], p2[16], pi = 0, ci = 0;
        while(params[pi] && params[pi] != ' ') { if(ci < 31) p1[ci] = params[pi]; ci++; pi++; }
        p1[ci] = EOS;
        if(params[pi] == ' ') pi++;
        ci = 0;
        while(params[pi]) { if(ci < 15) p2[ci] = params[pi]; ci++; pi++; }
        p2[ci] = EOS;

        new price = strval(p2);
        if(price <= 0) price = 50000;

        new Float:px, Float:py, Float:pz;
        GetPlayerPos(playerid, px, py, pz);

        Business_Create(p1, price, -28.0, -89.0, 1003.5, 17, px, py, pz);

        new msg[128];
        format(msg, sizeof(msg), "Da tao business '%s' (Gia: $%d) tai vi tri hien tai.", p1, price);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }
    return 0;
}
