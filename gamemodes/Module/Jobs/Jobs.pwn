// Module/Jobs/Jobs.pwn
// He thong cong viec: join/leave job, quan ly trang thai lam viec.

new Float:JobLocations[][3] = {
    {0.0, 0.0, 0.0},
    {1073.0, -1780.0, 13.5},
    {1181.0, -1310.0, 13.5},
    {2161.0, -2263.0, 13.3},
    {-42.0, -1556.0, 10.0},
    {605.0, 869.0, -42.4}
};

new JobNames[6][32] = {
    "Khong co",
    "Tai xe Taxi",
    "Tai xe Bus",
    "Giao hang",
    "Thu gom rac",
    "Tho mo"
};

new JobPickups[6];

stock Job_Init()
{
    for(new i = 1; i <= 5; i++)
    {
        JobPickups[i] = CreatePickup(1239, 1, JobLocations[i][0], JobLocations[i][1], JobLocations[i][2], -1);
        new label[128];
        format(label, sizeof(label), "Viec lam: %s\n/job de xin viec", JobNames[i]);
        Create3DTextLabel(label, COLOR_YELLOW, JobLocations[i][0], JobLocations[i][1], JobLocations[i][2] + 0.5, 20.0, 0, 0);
    }
    print("[Jobs] He thong cong viec da san sang.");
    return 1;
}

stock Job_OnCommand(playerid, cmdtext[])
{
    new cmd[32], params[128], idx;
    idx = 0;
    while(cmdtext[idx] && cmdtext[idx] != ' ') { if(idx < 31) cmd[idx] = cmdtext[idx]; idx++; }
    cmd[idx] = EOS;
    if(cmdtext[idx] == ' ') idx++;
    strmid(params, cmdtext, idx, strlen(cmdtext), sizeof(params));

    if(!strcmp(cmd, "/job", true))
    {
        if(PlayerData[playerid][pJob] != JOB_NONE)
        {
            new msg[128];
            format(msg, sizeof(msg), "Viec hien tai: %s. Dung /quitjob de nghi viec.", JobNames[PlayerData[playerid][pJob]]);
            SendClientMessage(playerid, COLOR_YELLOW, msg);
            return 1;
        }

        for(new i = 1; i <= 5; i++)
        {
            if(GetPlayerDistanceFromPoint(playerid, JobLocations[i][0], JobLocations[i][1], JobLocations[i][2]) < 5.0)
            {
                PlayerData[playerid][pJob] = i;
                new msg[128];
                format(msg, sizeof(msg), "Ban da xin viec thanh cong: %s! Dung /work de bat dau lam viec.", JobNames[i]);
                SendClientMessage(playerid, COLOR_GREEN, msg);
                return 1;
            }
        }
        SendClientMessage(playerid, COLOR_RED, "Ban phai dung tai diem tuyen dung de xin viec!");
        return 1;
    }

    if(!strcmp(cmd, "/quitjob", true))
    {
        if(PlayerData[playerid][pJob] == JOB_NONE)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong co viec lam!");
            return 1;
        }
        if(PlayerData[playerid][pOnJob])
        {
            Job_StopWork(playerid);
        }
        new msg[128];
        format(msg, sizeof(msg), "Ban da nghi viec: %s.", JobNames[PlayerData[playerid][pJob]]);
        SendClientMessage(playerid, COLOR_YELLOW, msg);
        PlayerData[playerid][pJob] = JOB_NONE;
        return 1;
    }

    if(!strcmp(cmd, "/work", true))
    {
        if(PlayerData[playerid][pJob] == JOB_NONE)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban chua co viec lam! Dung /job de xin viec.");
            return 1;
        }
        if(PlayerData[playerid][pOnJob])
        {
            SendClientMessage(playerid, COLOR_RED, "Ban dang lam viec roi!");
            return 1;
        }

        PlayerData[playerid][pOnJob] = true;
        PlayerData[playerid][pJobStep] = 0;
        PlayerData[playerid][pJobEarned] = 0;

        switch(PlayerData[playerid][pJob])
        {
            case JOB_TAXI: Taxi_StartWork(playerid);
            case JOB_BUS: Bus_StartWork(playerid);
            case JOB_DELIVERY: Delivery_StartWork(playerid);
            case JOB_GARBAGE: Garbage_StartWork(playerid);
            case JOB_MINING: Mining_StartWork(playerid);
        }
        return 1;
    }

    if(!strcmp(cmd, "/stopwork", true))
    {
        if(!PlayerData[playerid][pOnJob])
        {
            SendClientMessage(playerid, COLOR_RED, "Ban dang khong lam viec!");
            return 1;
        }
        Job_StopWork(playerid);
        SendClientMessage(playerid, COLOR_YELLOW, "Ban da ngung lam viec.");
        return 1;
    }

    // /atm
    if(!strcmp(cmd, "/atm", true))
    {
        if(!ATM_IsNearby(playerid))
        {
            SendClientMessage(playerid, COLOR_RED, "Ban phai dung gan ATM!");
            return 1;
        }
        ShowPlayerDialog(playerid, DIALOG_ATM_MENU, DIALOG_STYLE_LIST,
            "ATM",
            "Gui tien\nRut tien\nXem so du",
            "Chon",
            "Dong");
        return 1;
    }

    return 0;
}

stock Job_StopWork(playerid)
{
    PlayerData[playerid][pOnJob] = false;
    DisablePlayerCheckpoint(playerid);

    if(PlayerData[playerid][pJobVehicle] != 0)
    {
        DestroyVehicle(PlayerData[playerid][pJobVehicle]);
        PlayerData[playerid][pJobVehicle] = 0;
    }

    if(PlayerData[playerid][pJobTimerID])
    {
        KillTimer(PlayerData[playerid][pJobTimerID]);
        PlayerData[playerid][pJobTimerID] = 0;
    }

    if(PlayerData[playerid][pJobEarned] > 0)
    {
        Economy_GiveMoney(playerid, PlayerData[playerid][pJobEarned]);
        new msg[128];
        format(msg, sizeof(msg), "Ban da kiem duoc $%d tu ca lam viec.", PlayerData[playerid][pJobEarned]);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        PlayerData[playerid][pJobEarned] = 0;
    }

    PlayerData[playerid][pJobStep] = 0;
    return 1;
}

stock Job_OnCheckpoint(playerid)
{
    if(!PlayerData[playerid][pOnJob]) return 0;

    switch(PlayerData[playerid][pJob])
    {
        case JOB_TAXI: Taxi_OnCheckpoint(playerid);
        case JOB_BUS: Bus_OnCheckpoint(playerid);
        case JOB_DELIVERY: Delivery_OnCheckpoint(playerid);
        case JOB_GARBAGE: Garbage_OnCheckpoint(playerid);
        case JOB_MINING: Mining_OnCheckpoint(playerid);
    }
    return 1;
}

stock Job_GiveReward(playerid, amount)
{
    PlayerData[playerid][pJobEarned] += amount;
    PlayerData[playerid][pExp] += 2;

    new msg[64];
    format(msg, sizeof(msg), "+$%d (Tong ca: $%d)", amount, PlayerData[playerid][pJobEarned]);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}
