// Module/Jobs/Garbage.pwn
// Job thu gom rac: chay theo tuyen, thu rac, nhan tien.

new Float:GarbagePoints[][3] = {
    {-42.0, -1556.0, 10.0},
    {185.0, -1470.0, 10.0},
    {620.0, -1505.0, 14.5},
    {854.0, -1545.0, 13.5},
    {1120.0, -1450.0, 15.8},
    {1361.0, -1560.0, 13.5},
    {1582.0, -1610.0, 13.5},
    {1800.0, -1560.0, 13.5},
    {1230.0, -1750.0, 13.5},
    {700.0, -1700.0, 13.5}
};

stock Garbage_StartWork(playerid)
{
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    PlayerData[playerid][pJobVehicle] = CreateVehicle(408, x + 3.0, y, z, a, 3, 3, -1);
    PutPlayerInVehicle(playerid, PlayerData[playerid][pJobVehicle], 0);

    SendClientMessage(playerid, COLOR_YELLOW, "[Garbage] Xe rac da san sang! Chay den diem thu gom.");
    PlayerData[playerid][pJobStep] = 0;
    Garbage_NextPoint(playerid);
    return 1;
}

stock Garbage_NextPoint(playerid)
{
    new stop = PlayerData[playerid][pJobStep] % sizeof(GarbagePoints);
    SetPlayerCheckpoint(playerid, GarbagePoints[stop][0], GarbagePoints[stop][1], GarbagePoints[stop][2], 5.0);
    new msg[64];
    format(msg, sizeof(msg), "[Garbage] Diem thu gom %d/%d", stop + 1, sizeof(GarbagePoints));
    SendClientMessage(playerid, COLOR_YELLOW, msg);
    return 1;
}

stock Garbage_OnCheckpoint(playerid)
{
    PlayerData[playerid][pJobStep]++;
    Job_GiveReward(playerid, 90 + random(80));

    if(PlayerData[playerid][pJobStep] >= sizeof(GarbagePoints))
    {
        SendClientMessage(playerid, COLOR_GREEN, "[Garbage] Da thu gom xong! Ca lam viec ket thuc.");
        Job_StopWork(playerid);
        return 1;
    }

    Garbage_NextPoint(playerid);
    return 1;
}
