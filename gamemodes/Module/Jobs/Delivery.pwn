// Module/Jobs/Delivery.pwn
// Job giao hang: nhan hang, cho den diem giao, nhan tien.

new Float:DeliveryPoints[][3] = {
    {2161.0, -2263.0, 13.3},
    {1555.0, -1675.0, 16.0},
    {2109.0, -1801.0, 13.5},
    {1366.0, -1280.0, 13.5},
    {1832.0, -1090.0, 23.8},
    {2352.0, -1170.0, 27.8},
    {500.0, -1360.0, 15.7},
    {1041.0, -1029.0, 31.7}
};

stock Delivery_StartWork(playerid)
{
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    PlayerData[playerid][pJobVehicle] = CreateVehicle(498, x + 3.0, y, z, a, 1, 1, -1);
    PutPlayerInVehicle(playerid, PlayerData[playerid][pJobVehicle], 0);

    SendClientMessage(playerid, COLOR_YELLOW, "[Delivery] Xe giao hang da san sang!");
    Delivery_NextPoint(playerid);
    return 1;
}

stock Delivery_NextPoint(playerid)
{
    new r = random(sizeof(DeliveryPoints));
    SetPlayerCheckpoint(playerid, DeliveryPoints[r][0], DeliveryPoints[r][1], DeliveryPoints[r][2], 4.0);
    SendClientMessage(playerid, COLOR_YELLOW, "[Delivery] Giao hang den diem danh dau.");
    return 1;
}

stock Delivery_OnCheckpoint(playerid)
{
    PlayerData[playerid][pJobStep]++;
    Job_GiveReward(playerid, 120 + random(130));

    if(PlayerData[playerid][pJobStep] >= 8)
    {
        SendClientMessage(playerid, COLOR_GREEN, "[Delivery] Da giao het hang! Ca lam viec ket thuc.");
        Job_StopWork(playerid);
        return 1;
    }

    Delivery_NextPoint(playerid);
    new msg[64];
    format(msg, sizeof(msg), "[Delivery] Giao hang %d/8 thanh cong!", PlayerData[playerid][pJobStep]);
    SendClientMessage(playerid, COLOR_YELLOW, msg);
    return 1;
}
