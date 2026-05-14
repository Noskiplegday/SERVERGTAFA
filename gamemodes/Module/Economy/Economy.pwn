// Module/Economy/Economy.pwn
// He thong tien: give/take money, paycheck, luong.

stock Economy_Init()
{
    print("[Economy] He thong kinh te da san sang.");
    return 1;
}

stock Economy_GiveMoney(playerid, amount)
{
    PlayerData[playerid][pMoney] += amount;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
    return 1;
}

stock Economy_TakeMoney(playerid, amount)
{
    PlayerData[playerid][pMoney] -= amount;
    if(PlayerData[playerid][pMoney] < 0) PlayerData[playerid][pMoney] = 0;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
    return 1;
}

stock Economy_SetMoney(playerid, amount)
{
    PlayerData[playerid][pMoney] = amount;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
    return 1;
}

stock bool:Economy_HasMoney(playerid, amount)
{
    return PlayerData[playerid][pMoney] >= amount;
}

stock Economy_Paycheck(playerid)
{
    new paycheck = 500;

    switch(PlayerData[playerid][pJob])
    {
        case JOB_TAXI: paycheck += 200;
        case JOB_BUS: paycheck += 250;
        case JOB_DELIVERY: paycheck += 300;
        case JOB_GARBAGE: paycheck += 200;
        case JOB_MINING: paycheck += 350;
    }

    paycheck += PlayerData[playerid][pLevel] * 50;

    if(PlayerData[playerid][pFaction] != FACTION_NONE && PlayerData[playerid][pOnDuty])
    {
        paycheck += 300 + (PlayerData[playerid][pFactionRank] * 100);
    }

    PlayerData[playerid][pBankMoney] += paycheck;
    PlayerData[playerid][pExp] += 5;

    if(PlayerData[playerid][pExp] >= PlayerData[playerid][pLevel] * 100)
    {
        PlayerData[playerid][pLevel]++;
        PlayerData[playerid][pExp] = 0;
        SetPlayerScore(playerid, PlayerData[playerid][pLevel]);
        new msg[128];
        format(msg, sizeof(msg), "Chuc mung! Ban da len level %d!", PlayerData[playerid][pLevel]);
        SendClientMessage(playerid, COLOR_GREEN, msg);
    }

    new msg[128];
    format(msg, sizeof(msg), "=== PAYCHECK === Luong: $%d | Da chuyen vao ngan hang. So du: $%d", paycheck, PlayerData[playerid][pBankMoney]);
    SendClientMessage(playerid, COLOR_YELLOW, msg);
    return 1;
}

stock Economy_OnCommand(playerid, cmdtext[])
{
    new cmd[32], params[128], idx;
    idx = 0;
    while(cmdtext[idx] && cmdtext[idx] != ' ') { if(idx < 31) cmd[idx] = cmdtext[idx]; idx++; }
    cmd[idx] = EOS;
    if(cmdtext[idx] == ' ') idx++;
    strmid(params, cmdtext, idx, strlen(cmdtext), sizeof(params));

    // /pay [id] [amount]
    if(!strcmp(cmd, "/pay", true))
    {
        new p1[8], p2[16], pi = 0, ci = 0;
        while(params[pi] && params[pi] != ' ') { if(ci < 7) p1[ci] = params[pi]; ci++; pi++; }
        p1[ci] = EOS;
        if(params[pi] == ' ') pi++;
        ci = 0;
        while(params[pi]) { if(ci < 15) p2[ci] = params[pi]; ci++; pi++; }
        p2[ci] = EOS;

        new tid = strval(p1), amount = strval(p2);
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }
        if(tid == playerid) { SendClientMessage(playerid, COLOR_RED, "Khong the tra tien cho chinh minh!"); return 1; }
        if(amount <= 0) { SendClientMessage(playerid, COLOR_RED, "So tien phai lon hon 0!"); return 1; }
        if(!Economy_HasMoney(playerid, amount)) { SendClientMessage(playerid, COLOR_RED, "Ban khong du tien!"); return 1; }

        new Float:px, Float:py, Float:pz, Float:tx, Float:ty, Float:tz;
        GetPlayerPos(playerid, px, py, pz);
        GetPlayerPos(tid, tx, ty, tz);
        if(GetPlayerDistanceFromPoint(playerid, tx, ty, tz) > 10.0)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban phai dung gan nguoi nhan!");
            return 1;
        }

        Economy_TakeMoney(playerid, amount);
        Economy_GiveMoney(tid, amount);

        new msg[128];
        format(msg, sizeof(msg), "Ban da tra $%d cho %s.", amount, PlayerData[tid][pName]);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        format(msg, sizeof(msg), "%s da tra $%d cho ban.", PlayerData[playerid][pName], amount);
        SendClientMessage(tid, COLOR_GREEN, msg);
        return 1;
    }

    // /balance
    if(!strcmp(cmd, "/balance", true))
    {
        new msg[128];
        format(msg, sizeof(msg), "Tien mat: $%d | Ngan hang: $%d | Tong: $%d",
            PlayerData[playerid][pMoney], PlayerData[playerid][pBankMoney],
            PlayerData[playerid][pMoney] + PlayerData[playerid][pBankMoney]);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }

    return 0;
}

stock Economy_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    // Bank dialogs
    if(dialogid == DIALOG_BANK_MENU)
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0: // Gui tien
                ShowPlayerDialog(playerid, DIALOG_BANK_DEPOSIT, DIALOG_STYLE_INPUT,
                    "NGAN HANG - GUI TIEN",
                    "Nhap so tien muon gui:",
                    "Gui",
                    "Huy");
            case 1: // Rut tien
                ShowPlayerDialog(playerid, DIALOG_BANK_WITHDRAW, DIALOG_STYLE_INPUT,
                    "NGAN HANG - RUT TIEN",
                    "Nhap so tien muon rut:",
                    "Rut",
                    "Huy");
            case 2: // Chuyen tien
                ShowPlayerDialog(playerid, DIALOG_BANK_TRANSFER, DIALOG_STYLE_INPUT,
                    "NGAN HANG - CHUYEN TIEN",
                    "Nhap ID nguoi nhan:",
                    "Tiep",
                    "Huy");
            case 3: // So du
            {
                new msg[128];
                format(msg, sizeof(msg), "So du ngan hang: $%d", PlayerData[playerid][pBankMoney]);
                SendClientMessage(playerid, COLOR_GREEN, msg);
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_BANK_DEPOSIT)
    {
        if(!response) return 1;
        new amount = strval(inputtext);
        if(amount <= 0 || !Economy_HasMoney(playerid, amount))
        {
            SendClientMessage(playerid, COLOR_RED, "So tien khong hop le hoac ban khong du tien mat!");
            return 1;
        }
        Economy_TakeMoney(playerid, amount);
        PlayerData[playerid][pBankMoney] += amount;
        new msg[128];
        format(msg, sizeof(msg), "Da gui $%d vao ngan hang. So du: $%d", amount, PlayerData[playerid][pBankMoney]);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }

    if(dialogid == DIALOG_BANK_WITHDRAW)
    {
        if(!response) return 1;
        new amount = strval(inputtext);
        if(amount <= 0 || PlayerData[playerid][pBankMoney] < amount)
        {
            SendClientMessage(playerid, COLOR_RED, "So tien khong hop le hoac so du khong du!");
            return 1;
        }
        PlayerData[playerid][pBankMoney] -= amount;
        Economy_GiveMoney(playerid, amount);
        new msg[128];
        format(msg, sizeof(msg), "Da rut $%d. So du con lai: $%d", amount, PlayerData[playerid][pBankMoney]);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }

    if(dialogid == DIALOG_BANK_TRANSFER)
    {
        if(!response) return 1;
        new tid = strval(inputtext);
        if(!IsPlayerConnected(tid) || tid == playerid)
        {
            SendClientMessage(playerid, COLOR_RED, "ID nguoi nhan khong hop le!");
            return 1;
        }
        PlayerData[playerid][pCallingTo] = tid;
        ShowPlayerDialog(playerid, DIALOG_BANK_TRANSFER_AMT, DIALOG_STYLE_INPUT,
            "NGAN HANG - SO TIEN CHUYEN",
            "Nhap so tien muon chuyen:",
            "Chuyen",
            "Huy");
        return 1;
    }

    if(dialogid == DIALOG_BANK_TRANSFER_AMT)
    {
        if(!response) return 1;
        new amount = strval(inputtext);
        new tid = PlayerData[playerid][pCallingTo];
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Nguoi nhan da ngat ket noi!"); return 1; }
        if(amount <= 0 || PlayerData[playerid][pBankMoney] < amount)
        {
            SendClientMessage(playerid, COLOR_RED, "So tien khong hop le hoac so du khong du!");
            return 1;
        }
        PlayerData[playerid][pBankMoney] -= amount;
        PlayerData[tid][pBankMoney] += amount;
        new msg[128];
        format(msg, sizeof(msg), "Da chuyen $%d cho %s.", amount, PlayerData[tid][pName]);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        format(msg, sizeof(msg), "%s da chuyen $%d vao ngan hang cua ban.", PlayerData[playerid][pName], amount);
        SendClientMessage(tid, COLOR_GREEN, msg);
        return 1;
    }

    // ATM dialogs
    if(dialogid == DIALOG_ATM_MENU)
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0:
                ShowPlayerDialog(playerid, DIALOG_ATM_DEPOSIT, DIALOG_STYLE_INPUT,
                    "ATM - GUI TIEN",
                    "Nhap so tien muon gui:",
                    "Gui",
                    "Huy");
            case 1:
                ShowPlayerDialog(playerid, DIALOG_ATM_WITHDRAW, DIALOG_STYLE_INPUT,
                    "ATM - RUT TIEN",
                    "Nhap so tien muon rut:",
                    "Rut",
                    "Huy");
            case 2:
            {
                new msg[128];
                format(msg, sizeof(msg), "So du: $%d", PlayerData[playerid][pBankMoney]);
                SendClientMessage(playerid, COLOR_GREEN, msg);
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_ATM_DEPOSIT)
    {
        if(!response) return 1;
        new amount = strval(inputtext);
        if(amount <= 0 || !Economy_HasMoney(playerid, amount))
        {
            SendClientMessage(playerid, COLOR_RED, "So tien khong hop le!");
            return 1;
        }
        Economy_TakeMoney(playerid, amount);
        PlayerData[playerid][pBankMoney] += amount;
        new msg[128];
        format(msg, sizeof(msg), "ATM: Da gui $%d. So du: $%d", amount, PlayerData[playerid][pBankMoney]);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }

    if(dialogid == DIALOG_ATM_WITHDRAW)
    {
        if(!response) return 1;
        new amount = strval(inputtext);
        if(amount <= 0 || PlayerData[playerid][pBankMoney] < amount)
        {
            SendClientMessage(playerid, COLOR_RED, "So tien khong hop le!");
            return 1;
        }
        PlayerData[playerid][pBankMoney] -= amount;
        Economy_GiveMoney(playerid, amount);
        new msg[128];
        format(msg, sizeof(msg), "ATM: Da rut $%d. So du: $%d", amount, PlayerData[playerid][pBankMoney]);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }

    return 0;
}
