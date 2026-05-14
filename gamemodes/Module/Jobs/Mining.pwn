// Module/Jobs/Mining.pwn
// Job tho mo: dao quang, ban quang, nhan tien.

new Float:MiningPoints[][3] = {
    {605.0, 869.0, -42.4},
    {612.0, 878.0, -42.4},
    {590.0, 880.0, -42.4},
    {598.0, 860.0, -42.4},
    {615.0, 855.0, -42.4},
    {585.0, 870.0, -42.4}
};

new Float:MiningSellPoint[] = {620.0, 850.0, -42.4};

stock Mining_StartWork(playerid)
{
    SetPlayerPos(playerid, MiningPoints[0][0], MiningPoints[0][1], MiningPoints[0][2]);
    SetPlayerInterior(playerid, 0);

    SendClientMessage(playerid, COLOR_YELLOW, "[Mining] Chay den diem dao quang!");
    PlayerData[playerid][pJobStep] = 0;
    Mining_NextPoint(playerid);
    return 1;
}

stock Mining_NextPoint(playerid)
{
    if(PlayerData[playerid][pJobStep] >= 5)
    {
        SetPlayerCheckpoint(playerid, MiningSellPoint[0], MiningSellPoint[1], MiningSellPoint[2], 3.0);
        SendClientMessage(playerid, COLOR_YELLOW, "[Mining] Da dao du! Chay den diem ban quang.");
        return 1;
    }

    new r = random(sizeof(MiningPoints));
    SetPlayerCheckpoint(playerid, MiningPoints[r][0], MiningPoints[r][1], MiningPoints[r][2], 3.0);
    new msg[64];
    format(msg, sizeof(msg), "[Mining] Dao quang %d/5", PlayerData[playerid][pJobStep] + 1);
    SendClientMessage(playerid, COLOR_YELLOW, msg);
    return 1;
}

stock Mining_OnCheckpoint(playerid)
{
    PlayerData[playerid][pJobStep]++;

    if(PlayerData[playerid][pJobStep] > 5)
    {
        new reward = 500 + random(300);
        Job_GiveReward(playerid, reward);
        SendClientMessage(playerid, COLOR_GREEN, "[Mining] Da ban quang! Ca lam viec ket thuc.");
        Job_StopWork(playerid);
        return 1;
    }

    Job_GiveReward(playerid, 50 + random(50));
    Mining_NextPoint(playerid);
    return 1;
}
