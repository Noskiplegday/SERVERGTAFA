// Module/Jobs/Taxi.pwn
// Job tai xe taxi: don khach, cho den diem, nhan tien.

new Float:TaxiCheckpoints[][3] = {
    {1479.0, -1717.0, 13.5},
    {2096.0, -1708.0, 13.5},
    {2376.0, -1916.0, 13.5},
    {1229.0, -1812.0, 16.0},
    {1805.0, -1580.0, 13.5},
    {2028.0, -1420.0, 17.2},
    {1283.0, -1312.0, 13.5},
    {2473.0, -1316.0, 24.0},
    {1636.0, -1024.0, 23.8},
    {2146.0, -1073.0, 25.5}
};

stock Taxi_StartWork(playerid)
{
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    PlayerData[playerid][pJobVehicle] = CreateVehicle(420, x + 3.0, y, z, a, 6, 1, -1);
    PutPlayerInVehicle(playerid, PlayerData[playerid][pJobVehicle], 0);

    SendClientMessage(playerid, COLOR_YELLOW, "[Taxi] Xe taxi da san sang! Hay chay den diem don khach.");
    Taxi_NextCheckpoint(playerid);
    return 1;
}

stock Taxi_NextCheckpoint(playerid)
{
    new r = random(sizeof(TaxiCheckpoints));
    SetPlayerCheckpoint(playerid, TaxiCheckpoints[r][0], TaxiCheckpoints[r][1], TaxiCheckpoints[r][2], 4.0);
    SendClientMessage(playerid, COLOR_YELLOW, "[Taxi] Hay chay den diem danh dau tren ban do.");
    return 1;
}

stock Taxi_OnCheckpoint(playerid)
{
    PlayerData[playerid][pJobStep]++;
    Job_GiveReward(playerid, 100 + random(150));

    if(PlayerData[playerid][pJobStep] >= 10)
    {
        SendClientMessage(playerid, COLOR_GREEN, "[Taxi] Ca lam viec hoan tat!");
        Job_StopWork(playerid);
        return 1;
    }

    Taxi_NextCheckpoint(playerid);
    new msg[64];
    format(msg, sizeof(msg), "[Taxi] Chuyen %d/10 hoan tat!", PlayerData[playerid][pJobStep]);
    SendClientMessage(playerid, COLOR_YELLOW, msg);
    return 1;
}
