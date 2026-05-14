// Module/Housing/House_Interior.pwn
// Vao/ra nha, teleport interior.

stock HouseInterior_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/enter", true, 6))
    {
        new h = House_FindNearby(playerid);
        if(h == -1)
        {
            new b = Business_FindNearby(playerid);
            if(b != -1)
            {
                if(BusinessData[b][bLocked] && BusinessData[b][bOwnerID] != playerid)
                {
                    SendClientMessage(playerid, COLOR_RED, "Cua hang dang khoa!");
                    return 1;
                }
                SetPlayerPos(playerid, BusinessData[b][bInteriorX], BusinessData[b][bInteriorY], BusinessData[b][bInteriorZ]);
                SetPlayerInterior(playerid, BusinessData[b][bInterior]);
                SetPlayerVirtualWorld(playerid, b + 1000);
                SendClientMessage(playerid, COLOR_GREEN, "Ban da vao cua hang. /exit de ra.");
                return 1;
            }
            SendClientMessage(playerid, COLOR_RED, "Khong co nha hoac cua hang nao gan day!");
            return 1;
        }
        if(HouseData[h][hLocked] && strcmp(HouseData[h][hOwner], PlayerData[playerid][pName], true))
        {
            SendClientMessage(playerid, COLOR_RED, "Nha da khoa!");
            return 1;
        }
        SetPlayerPos(playerid, HouseData[h][hExitX], HouseData[h][hExitY], HouseData[h][hExitZ]);
        SetPlayerInterior(playerid, HouseData[h][hInterior]);
        SetPlayerVirtualWorld(playerid, h + 100);

        new msg[64];
        format(msg, sizeof(msg), "Ban da vao nha #%d. Dung /exit de ra.", h);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }

    if(!strcmp(cmdtext, "/exit", true, 5))
    {
        new vw = GetPlayerVirtualWorld(playerid);

        if(vw >= 100 && vw < 100 + MAX_HOUSES)
        {
            new h = vw - 100;
            if(h >= 0 && h < TotalHouses)
            {
                SetPlayerPos(playerid, HouseData[h][hEnterX], HouseData[h][hEnterY], HouseData[h][hEnterZ]);
                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
                SendClientMessage(playerid, COLOR_GREEN, "Ban da ra khoi nha.");
                return 1;
            }
        }

        if(vw >= 1000 && vw < 1000 + MAX_BUSINESSES)
        {
            new b = vw - 1000;
            if(b >= 0 && b < TotalBusinesses)
            {
                SetPlayerPos(playerid, BusinessData[b][bEnterX], BusinessData[b][bEnterY], BusinessData[b][bEnterZ]);
                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
                SendClientMessage(playerid, COLOR_GREEN, "Ban da ra khoi cua hang.");
                return 1;
            }
        }

        new interior = GetPlayerInterior(playerid);
        if(interior > 0)
        {
            SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            return 1;
        }

        SendClientMessage(playerid, COLOR_RED, "Ban khong o trong nha/cua hang!");
        return 1;
    }

    return 0;
}
