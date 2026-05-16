// Module/Business/Business.pwn
// He thong business - mua ban shop.

stock Business_Init()
{
    Business_LoadAll();
    if(TotalBusinesses == 0)
    {
        Business_Create("24/7 Store LS", 50000, -28.0, -89.0, 1003.5, 17, -25.0, -139.0, 1003.5);
        Business_Create("Binco Clothing", 60000, 207.0, -111.0, 1005.1, 15, 207.0, -138.0, 1005.1);
        Business_Create("Cluckin Bell", 40000, 365.0, -11.0, 1001.8, 9, 365.0, -73.0, 1001.8);
        Business_Create("Pizza Stack", 45000, 372.0, -133.0, 1001.4, 5, 372.0, -188.0, 1001.4);
        Business_Create("Ammunation", 80000, 296.0, -40.0, 1001.5, 1, 296.0, -108.0, 1001.5);
    }
    print("[Business] He thong business da san sang.");
    return 1;
}

stock Business_Create(const name[], price, Float:ix, Float:iy, Float:iz, interior,
    Float:ex, Float:ey, Float:ez)
{
    if(TotalBusinesses >= MAX_BUSINESSES) return 0;
    new b = TotalBusinesses;

    strcat((BusinessData[b][bName][0] = EOS, BusinessData[b][bName]), name, 32);
    BusinessData[b][bPrice] = price;
    BusinessData[b][bOwnerID] = -1;
    BusinessData[b][bEnterX] = ex;
    BusinessData[b][bEnterY] = ey;
    BusinessData[b][bEnterZ] = ez;
    BusinessData[b][bInteriorX] = ix;
    BusinessData[b][bInteriorY] = iy;
    BusinessData[b][bInteriorZ] = iz;
    BusinessData[b][bInterior] = interior;
    BusinessData[b][bLocked] = false;
    BusinessData[b][bIncome] = 0;

    Business_CreatePickup(b);
    TotalBusinesses++;
    Business_SaveOne(b);
    return 1;
}

stock Business_CreatePickup(b)
{
    new pickupmodel = (BusinessData[b][bOwnerID] == -1) ? 1273 : 1272;
    CreatePickup(pickupmodel, 1, BusinessData[b][bEnterX], BusinessData[b][bEnterY], BusinessData[b][bEnterZ], -1);

    new label[128];
    if(BusinessData[b][bOwnerID] == -1)
        format(label, sizeof(label), "%s\nGia: $%d\n/buybiz", BusinessData[b][bName], BusinessData[b][bPrice]);
    else
        format(label, sizeof(label), "%s\nChu so huu: ID %d\n/benter", BusinessData[b][bName], BusinessData[b][bOwnerID]);
    Create3DTextLabel(label, COLOR_YELLOW, BusinessData[b][bEnterX], BusinessData[b][bEnterY], BusinessData[b][bEnterZ] + 0.5, 20.0, 0, 0);
}

stock Business_LoadAll()
{
    TotalBusinesses = 0;
    print("[Business] Database load business chua migrate, dung default businesses.");
    return 1;
}

stock Business_SaveOne(b)
{
    #pragma unused b
    return 1;
}

stock Business_SaveAll()
{
    for(new i = 0; i < TotalBusinesses; i++) Business_SaveOne(i);
}

stock Business_FindNearby(playerid)
{
    for(new i = 0; i < TotalBusinesses; i++)
    {
        if(GetPlayerDistanceFromPoint(playerid, BusinessData[i][bEnterX], BusinessData[i][bEnterY], BusinessData[i][bEnterZ]) < 5.0)
            return i;
    }
    return -1;
}

stock Business_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/buybiz", true, 7))
    {
        new b = Business_FindNearby(playerid);
        if(b == -1) { SendClientMessage(playerid, COLOR_RED, "Khong co shop nao gan day!"); return 1; }
        if(BusinessData[b][bOwnerID] != -1) { SendClientMessage(playerid, COLOR_RED, "Shop nay da co chu!"); return 1; }
        if(!Economy_HasMoney(playerid, BusinessData[b][bPrice])) { SendClientMessage(playerid, COLOR_RED, "Khong du tien!"); return 1; }

        Economy_TakeMoney(playerid, BusinessData[b][bPrice]);
        BusinessData[b][bOwnerID] = playerid;
        Business_SaveOne(b);

        new msg[128];
        format(msg, sizeof(msg), "Ban da mua %s voi gia $%d!", BusinessData[b][bName], BusinessData[b][bPrice]);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }

    if(!strcmp(cmdtext, "/sellbiz", true, 8))
    {
        new b = Business_FindNearby(playerid);
        if(b == -1) { SendClientMessage(playerid, COLOR_RED, "Khong co shop nao gan day!"); return 1; }
        if(BusinessData[b][bOwnerID] != playerid) { SendClientMessage(playerid, COLOR_RED, "Day khong phai shop cua ban!"); return 1; }

        new refund = BusinessData[b][bPrice] / 2;
        Economy_GiveMoney(playerid, refund);
        BusinessData[b][bOwnerID] = -1;
        BusinessData[b][bIncome] = 0;
        Business_SaveOne(b);

        new msg[64];
        format(msg, sizeof(msg), "Da ban shop. Nhan lai $%d.", refund);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }

    if(!strcmp(cmdtext, "/benter", true, 7))
    {
        new b = Business_FindNearby(playerid);
        if(b == -1) { SendClientMessage(playerid, COLOR_RED, "Khong co shop nao gan day!"); return 1; }
        if(BusinessData[b][bLocked] && BusinessData[b][bOwnerID] != playerid)
        {
            SendClientMessage(playerid, COLOR_RED, "Shop nay dang khoa!");
            return 1;
        }

        SetPlayerPos(playerid, BusinessData[b][bInteriorX], BusinessData[b][bInteriorY], BusinessData[b][bInteriorZ]);
        SetPlayerInterior(playerid, BusinessData[b][bInterior]);
        SetPlayerVirtualWorld(playerid, b + 1000);
        SendClientMessage(playerid, COLOR_GREEN, "Ban da vao shop. /bexit de ra.");
        return 1;
    }

    if(!strcmp(cmdtext, "/bexit", true, 6))
    {
        new vw = GetPlayerVirtualWorld(playerid);
        if(vw < 1000 || vw >= 1000 + MAX_BUSINESSES)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong dang trong shop nao!");
            return 1;
        }
        new b = vw - 1000;
        SetPlayerPos(playerid, BusinessData[b][bEnterX], BusinessData[b][bEnterY], BusinessData[b][bEnterZ]);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        return 1;
    }

    if(!strcmp(cmdtext, "/block", true, 6))
    {
        new b = Business_FindNearby(playerid);
        if(b == -1) { SendClientMessage(playerid, COLOR_RED, "Khong co shop nao!"); return 1; }
        if(BusinessData[b][bOwnerID] != playerid) { SendClientMessage(playerid, COLOR_RED, "Khong phai shop cua ban!"); return 1; }

        BusinessData[b][bLocked] = !BusinessData[b][bLocked];
        Business_SaveOne(b);
        SendClientMessage(playerid, COLOR_GREEN, BusinessData[b][bLocked] ? "Da khoa shop." : "Da mo khoa shop.");
        return 1;
    }

    if(!strcmp(cmdtext, "/bincome", true, 8))
    {
        for(new i = 0; i < TotalBusinesses; i++)
        {
            if(BusinessData[i][bOwnerID] == playerid)
            {
                new msg[128];
                format(msg, sizeof(msg), "%s - Thu nhap: $%d", BusinessData[i][bName], BusinessData[i][bIncome]);
                SendClientMessage(playerid, COLOR_GREEN, msg);
            }
        }
        return 1;
    }

    return 0;
}

stock Business_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused playerid, dialogid, response, listitem, inputtext
    return 0;
}
