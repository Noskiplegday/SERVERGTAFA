// Module/Housing/Housing.pwn
// He thong nha: mua, ban. Persist database se lam o phase Housing.

stock House_Init()
{
    House_LoadAll();
    House_CreateDefaults();
    print("[Housing] He thong nha da san sang.");
    return 1;
}

stock House_CreateDefaults()
{
    if(TotalHouses > 0) return 1;
    House_Add(1260.0, -785.0, 92.5, 223.0, 1527.0, -11.0, 0, 50000);
    House_Add(2496.0, -1692.0, 14.5, 2527.0, -1679.0, 1013.5, 3, 80000);
    House_Add(1523.0, -1455.0, 13.5, 235.0, 1189.0, 1080.2, 3, 40000);
    House_Add(2236.0, -1337.0, 24.0, 2365.0, -1135.0, 1050.8, 8, 65000);
    House_Add(1402.0, -1713.0, 16.0, 2807.0, -1173.0, 1025.5, 8, 35000);
    House_SaveAll();
    return 1;
}

stock House_Add(Float:ex, Float:ey, Float:ez, Float:ix, Float:iy, Float:iz, interior, price)
{
    if(TotalHouses >= MAX_HOUSES) return -1;
    new h = TotalHouses;

    HouseData[h][hID] = h;
    HouseData[h][hOwner][0] = EOS;
    HouseData[h][hPrice] = price;
    HouseData[h][hLocked] = 0;
    HouseData[h][hEnterX] = ex;
    HouseData[h][hEnterY] = ey;
    HouseData[h][hEnterZ] = ez;
    HouseData[h][hExitX] = ix;
    HouseData[h][hExitY] = iy;
    HouseData[h][hExitZ] = iz;
    HouseData[h][hInterior] = interior;

    for(new i = 0; i < MAX_HOUSE_STORAGE; i++)
    {
        HouseData[h][hStorage][i] = ITEM_NONE;
        HouseData[h][hStorageAmt][i] = 0;
    }

    House_CreatePickup(h);
    TotalHouses++;
    return h;
}

stock House_CreatePickup(h)
{
    new label[128];
    if(HouseData[h][hOwner][0] != EOS)
        format(label, sizeof(label), "Nha cua %s\n/enter", HouseData[h][hOwner]);
    else
        format(label, sizeof(label), "Nha ban - $%d\n/buyhouse", HouseData[h][hPrice]);

    HouseData[h][hPickupID] = CreatePickup(HouseData[h][hOwner][0] != EOS ? 1272 : 1273, 1,
        HouseData[h][hEnterX], HouseData[h][hEnterY], HouseData[h][hEnterZ], -1);
    HouseData[h][hLabelID] = _:Create3DTextLabel(label, COLOR_GREEN,
        HouseData[h][hEnterX], HouseData[h][hEnterY], HouseData[h][hEnterZ] + 0.5, 20.0, 0, 0);
}

stock House_LoadAll()
{
    TotalHouses = 0;
    print("[Housing] Database load nha chua migrate, dung default houses.");
    return 1;
}

stock House_SaveOne(h)
{
    #pragma unused h
    return 1;
}

stock House_SaveAll()
{
    for(new i = 0; i < TotalHouses; i++)
        House_SaveOne(i);
}

stock House_FindNearby(playerid)
{
    for(new i = 0; i < TotalHouses; i++)
    {
        if(GetPlayerDistanceFromPoint(playerid, HouseData[i][hEnterX], HouseData[i][hEnterY], HouseData[i][hEnterZ]) < 5.0)
            return i;
    }
    return -1;
}

stock House_OnPickup(playerid, pickupid)
{
    for(new i = 0; i < TotalHouses; i++)
    {
        if(pickupid == HouseData[i][hPickupID])
        {
            if(HouseData[i][hOwner][0] == EOS)
                SendClientMessage(playerid, COLOR_GREEN, "Nha dang ban. Dung /buyhouse de mua.");
            else
            {
                new msg[128];
                format(msg, sizeof(msg), "Nha cua %s. Dung /enter de vao.", HouseData[i][hOwner]);
                SendClientMessage(playerid, COLOR_YELLOW, msg);
            }
            return 1;
        }
    }
    return 0;
}

stock House_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/buyhouse", true, 9))
    {
        new h = House_FindNearby(playerid);
        if(h == -1) { SendClientMessage(playerid, COLOR_RED, "Khong co nha nao gan day!"); return 1; }
        if(HouseData[h][hOwner][0] != EOS) { SendClientMessage(playerid, COLOR_RED, "Nha nay da co chu!"); return 1; }
        if(PlayerData[playerid][pHouseID] >= 0) { SendClientMessage(playerid, COLOR_RED, "Ban da co nha roi!"); return 1; }
        if(!Economy_HasMoney(playerid, HouseData[h][hPrice])) { SendClientMessage(playerid, COLOR_RED, "Khong du tien!"); return 1; }

        Economy_TakeMoney(playerid, HouseData[h][hPrice]);
        strcat((HouseData[h][hOwner][0] = EOS, HouseData[h][hOwner]), PlayerData[playerid][pName], MAX_PLAYER_NAME);
        PlayerData[playerid][pHouseID] = h;
        House_SaveOne(h);

        new msg[128];
        format(msg, sizeof(msg), "Ban da mua nha voi gia $%d!", HouseData[h][hPrice]);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }

    if(!strcmp(cmdtext, "/sellhouse", true, 10))
    {
        new h = PlayerData[playerid][pHouseID];
        if(h < 0 || h >= TotalHouses) { SendClientMessage(playerid, COLOR_RED, "Ban khong co nha!"); return 1; }

        new refund = HouseData[h][hPrice] / 2;
        Economy_GiveMoney(playerid, refund);
        HouseData[h][hOwner][0] = EOS;
        PlayerData[playerid][pHouseID] = -1;
        House_SaveOne(h);

        new msg[128];
        format(msg, sizeof(msg), "Da ban nha. Nhan lai $%d.", refund);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }

    if(!strcmp(cmdtext, "/houselock", true, 10))
    {
        new h = PlayerData[playerid][pHouseID];
        if(h < 0) { SendClientMessage(playerid, COLOR_RED, "Ban khong co nha!"); return 1; }
        if(GetPlayerDistanceFromPoint(playerid, HouseData[h][hEnterX], HouseData[h][hEnterY], HouseData[h][hEnterZ]) > 10.0)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban phai dung gan nha!");
            return 1;
        }
        HouseData[h][hLocked] = !HouseData[h][hLocked];
        SendClientMessage(playerid, HouseData[h][hLocked] ? COLOR_RED : COLOR_GREEN,
            HouseData[h][hLocked] ? "Da khoa nha." : "Da mo khoa nha.");
        House_SaveOne(h);
        return 1;
    }

    return 0;
}

stock House_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused playerid, dialogid, response, listitem, inputtext
    return 0;
}
