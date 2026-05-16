// Core/HUD.pwn
// HUD nho gon hien thong tin nhan vat chinh.

new PlayerText:gHUDBox[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:gHUDTitle[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:gHUDInfo[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:gHUDAccent[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};

stock HUD_Show(playerid)
{
    HUD_Hide(playerid);

    gHUDBox[playerid] = CreatePlayerTextDraw(playerid, 430.0, 118.0, "_");
    PlayerTextDrawLetterSize(playerid, gHUDBox[playerid], 0.0, 6.6);
    PlayerTextDrawTextSize(playerid, gHUDBox[playerid], 622.0, 0.0);
    PlayerTextDrawUseBox(playerid, gHUDBox[playerid], true);
    PlayerTextDrawBoxColour(playerid, gHUDBox[playerid], 0x111827CC);
    PlayerTextDrawShow(playerid, gHUDBox[playerid]);

    gHUDAccent[playerid] = CreatePlayerTextDraw(playerid, 430.0, 118.0, "_");
    PlayerTextDrawLetterSize(playerid, gHUDAccent[playerid], 0.0, 0.35);
    PlayerTextDrawTextSize(playerid, gHUDAccent[playerid], 622.0, 0.0);
    PlayerTextDrawUseBox(playerid, gHUDAccent[playerid], true);
    PlayerTextDrawBoxColour(playerid, gHUDAccent[playerid], 0x00BFFFFF);
    PlayerTextDrawShow(playerid, gHUDAccent[playerid]);

    gHUDTitle[playerid] = CreatePlayerTextDraw(playerid, 438.0, 123.0, "VAN CANH CITY");
    PlayerTextDrawFont(playerid, gHUDTitle[playerid], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, gHUDTitle[playerid], 0.22, 1.0);
    PlayerTextDrawColour(playerid, gHUDTitle[playerid], 0x7DD3FCFF);
    PlayerTextDrawShow(playerid, gHUDTitle[playerid]);

    gHUDInfo[playerid] = CreatePlayerTextDraw(playerid, 438.0, 138.0, "_");
    PlayerTextDrawFont(playerid, gHUDInfo[playerid], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, gHUDInfo[playerid], 0.20, 0.92);
    PlayerTextDrawColour(playerid, gHUDInfo[playerid], 0xF8FAFCFF);
    PlayerTextDrawShow(playerid, gHUDInfo[playerid]);

    HUD_Update(playerid);
    return 1;
}

stock HUD_Hide(playerid)
{
    if(gHUDBox[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, gHUDBox[playerid]);
        gHUDBox[playerid] = PlayerText:INVALID_TEXT_DRAW;
    }
    if(gHUDAccent[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, gHUDAccent[playerid]);
        gHUDAccent[playerid] = PlayerText:INVALID_TEXT_DRAW;
    }
    if(gHUDTitle[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, gHUDTitle[playerid]);
        gHUDTitle[playerid] = PlayerText:INVALID_TEXT_DRAW;
    }
    if(gHUDInfo[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, gHUDInfo[playerid]);
        gHUDInfo[playerid] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}

stock HUD_Update(playerid)
{
    if(!PlayerData[playerid][pLoggedIn] || gHUDInfo[playerid] == PlayerText:INVALID_TEXT_DRAW) return 0;

    new job_name[32], info[256];
    HUD_GetJobName(PlayerData[playerid][pJob], job_name, sizeof(job_name));

    format(info, sizeof(info),
        "~b~%s~w~  Lv.%d~n~~w~CCCD: ~y~%s~n~~w~Mission: ~g~%s~n~~w~Job: ~p~%s",
        PlayerData[playerid][pName],
        PlayerData[playerid][pLevel],
        PlayerData[playerid][pCCCD],
        PlayerData[playerid][pMission],
        job_name);
    PlayerTextDrawSetString(playerid, gHUDInfo[playerid], info);
    return 1;
}

stock HUD_GetJobName(jobid, dest[], maxlen)
{
    switch(jobid)
    {
        case JOB_TAXI: format(dest, maxlen, "Tai xe Taxi");
        case JOB_BUS: format(dest, maxlen, "Tai xe Bus");
        case JOB_DELIVERY: format(dest, maxlen, "Giao hang");
        case JOB_GARBAGE: format(dest, maxlen, "Thu gom rac");
        case JOB_MINING: format(dest, maxlen, "Tho mo");
        default: format(dest, maxlen, "Chua co");
    }
    return 1;
}

forward HUD_Tick(playerid);
public HUD_Tick(playerid)
{
    if(!IsPlayerConnected(playerid) || !PlayerData[playerid][pLoggedIn]) return 1;
    HUD_Update(playerid);
    return 1;
}
