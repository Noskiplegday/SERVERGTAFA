// Module/Jobs/Bus.pwn
// Job tai xe bus: chay theo tuyen, dung tram, nhan tien.

new Float:BusStops[][3] = {
    {1200.0, -1781.0, 13.5},
    {1530.0, -1640.0, 13.5},
    {1834.0, -1838.0, 13.5},
    {2109.0, -1786.0, 13.5},
    {2399.0, -1895.0, 13.5},
    {2169.0, -1677.0, 13.5},
    {1788.0, -1594.0, 13.5},
    {1391.0, -1274.0, 13.5}
};

stock Bus_StartWork(playerid)
{
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    PlayerData[playerid][pJobVehicle] = CreateVehicle(431, x + 3.0, y, z, a, 6, 6, -1);
    PutPlayerInVehicle(playerid, PlayerData[playerid][pJobVehicle], 0);

    SendClientMessage(playerid, COLOR_YELLOW, "[Bus] Xe bus da san sang! Chay den tram dau tien.");
    PlayerData[playerid][pJobStep] = 0;
    Bus_SetStop(playerid);
    return 1;
}

stock Bus_SetStop(playerid)
{
    new stop = PlayerData[playerid][pJobStep] % sizeof(BusStops);
    SetPlayerCheckpoint(playerid, BusStops[stop][0], BusStops[stop][1], BusStops[stop][2], 5.0);
    new msg[64];
    format(msg, sizeof(msg), "[Bus] Tram tiep theo: %d/%d", stop + 1, sizeof(BusStops));
    SendClientMessage(playerid, COLOR_YELLOW, msg);
    return 1;
}

stock Bus_OnCheckpoint(playerid)
{
    PlayerData[playerid][pJobStep]++;
    Job_GiveReward(playerid, 80 + random(100));

    if(PlayerData[playerid][pJobStep] >= sizeof(BusStops) * 2)
    {
        SendClientMessage(playerid, COLOR_GREEN, "[Bus] Da hoan tat 2 vong! Ca lam viec ket thuc.");
        Job_StopWork(playerid);
        return 1;
    }

    Bus_SetStop(playerid);
    return 1;
}
