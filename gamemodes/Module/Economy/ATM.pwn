// Module/Economy/ATM.pwn
// He thong ATM: vi tri ATM, pickup, menu rut/gui tien.

stock ATM_Init()
{
    ATM_AddLocation(1929.0, -1773.0, 13.5);
    ATM_AddLocation(2104.0, -1806.0, 13.5);
    ATM_AddLocation(1460.0, -1011.0, 26.8);
    ATM_AddLocation(1315.0, -897.0, 39.5);
    ATM_AddLocation(2291.0, -1679.0, 14.0);
    ATM_AddLocation(1836.0, -1682.0, 13.4);
    ATM_AddLocation(2139.0, -1162.0, 24.0);
    ATM_AddLocation(580.0, -1240.0, 17.9);

    print("[ATM] Da tao cac diem ATM.");
    return 1;
}

stock ATM_AddLocation(Float:x, Float:y, Float:z)
{
    if(TotalATMs >= MAX_ATM_LOCATIONS) return 0;

    ATMLocations[TotalATMs][0] = x;
    ATMLocations[TotalATMs][1] = y;
    ATMLocations[TotalATMs][2] = z;
    ATMPickups[TotalATMs] = CreatePickup(1274, 1, x, y, z, -1);
    Create3DTextLabel("ATM\nNhan /atm de su dung", COLOR_GREEN, x, y, z + 0.5, 15.0, 0, 0);
    TotalATMs++;
    return 1;
}

stock ATM_OnPickup(playerid, pickupid)
{
    for(new i = 0; i < TotalATMs; i++)
    {
        if(pickupid == ATMPickups[i])
        {
            SendClientMessage(playerid, COLOR_GREEN, "Ban dang o ATM. Dung /atm de giao dich.");
            return 1;
        }
    }
    return 0;
}

stock ATM_IsNearby(playerid)
{
    for(new i = 0; i < TotalATMs; i++)
    {
        if(GetPlayerDistanceFromPoint(playerid, ATMLocations[i][0], ATMLocations[i][1], ATMLocations[i][2]) < 5.0)
            return 1;
    }
    return 0;
}
