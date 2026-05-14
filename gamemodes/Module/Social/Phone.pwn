// Module/Social/Phone.pwn
// Goi dien thoai.

stock Phone_OnCommand(playerid, cmdtext[])
{
    new cmd[32], params[64], idx;
    idx = 0;
    while(cmdtext[idx] && cmdtext[idx] != ' ') { if(idx < 31) cmd[idx] = cmdtext[idx]; idx++; }
    cmd[idx] = EOS;
    if(cmdtext[idx] == ' ') idx++;
    strmid(params, cmdtext, idx, strlen(cmdtext), sizeof(params));

    if(!strcmp(cmd, "/call", true))
    {
        if(!Inventory_HasItem(playerid, ITEM_PHONE))
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong co dien thoai!");
            return 1;
        }
        if(PlayerData[playerid][pInCall])
        {
            SendClientMessage(playerid, COLOR_RED, "Ban dang trong cuoc goi!");
            return 1;
        }

        new number = strval(params);
        new tid = Phone_FindByNumber(number);
        if(tid == INVALID_PLAYER_ID || !IsPlayerConnected(tid))
        {
            SendClientMessage(playerid, COLOR_RED, "So dien thoai khong ton tai hoac offline!");
            return 1;
        }
        if(tid == playerid) { SendClientMessage(playerid, COLOR_RED, "Khong the goi cho chinh minh!"); return 1; }
        if(PlayerData[tid][pInCall])
        {
            SendClientMessage(playerid, COLOR_RED, "Nguoi nay dang ban!");
            return 1;
        }

        PlayerData[playerid][pCallingTo] = tid;
        PlayerData[tid][pCallingTo] = playerid;

        SendClientMessage(playerid, COLOR_YELLOW, "Dang goi... Cho nguoi nhan /pickup.");
        new msg[128];
        format(msg, sizeof(msg), "Co cuoc goi den tu %s (so %d). Dung /pickup de tra loi.", PlayerData[playerid][pName], PlayerData[playerid][pPhoneNumber]);
        SendClientMessage(tid, COLOR_YELLOW, msg);
        return 1;
    }

    if(!strcmp(cmd, "/pickup", true))
    {
        if(PlayerData[playerid][pCallingTo] == INVALID_PLAYER_ID)
        {
            SendClientMessage(playerid, COLOR_RED, "Khong co cuoc goi nao!");
            return 1;
        }

        new tid = PlayerData[playerid][pCallingTo];
        PlayerData[playerid][pInCall] = true;
        PlayerData[tid][pInCall] = true;

        SendClientMessage(playerid, COLOR_GREEN, "Da ket noi! Chat de noi chuyen. /hangup de ket thuc.");
        SendClientMessage(tid, COLOR_GREEN, "Nguoi nhan da tra loi! Chat de noi chuyen. /hangup de ket thuc.");
        return 1;
    }

    if(!strcmp(cmd, "/hangup", true))
    {
        new tid = PlayerData[playerid][pCallingTo];
        if(tid != INVALID_PLAYER_ID && IsPlayerConnected(tid))
        {
            PlayerData[tid][pInCall] = false;
            PlayerData[tid][pCallingTo] = INVALID_PLAYER_ID;
            SendClientMessage(tid, COLOR_YELLOW, "Cuoc goi da ket thuc.");
        }

        PlayerData[playerid][pInCall] = false;
        PlayerData[playerid][pCallingTo] = INVALID_PLAYER_ID;
        SendClientMessage(playerid, COLOR_YELLOW, "Da ket thuc cuoc goi.");
        return 1;
    }

    if(!strcmp(cmd, "/phone", true))
    {
        new msg[64];
        format(msg, sizeof(msg), "So dien thoai cua ban: %d", PlayerData[playerid][pPhoneNumber]);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }

    return 0;
}

stock Phone_FindByNumber(number)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && Session_IsLoggedIn(i) && PlayerData[i][pPhoneNumber] == number)
            return i;
    }
    return INVALID_PLAYER_ID;
}

stock Phone_OnText(playerid, text[])
{
    if(!PlayerData[playerid][pInCall]) return 0;

    new tid = PlayerData[playerid][pCallingTo];
    if(tid == INVALID_PLAYER_ID || !IsPlayerConnected(tid)) return 0;

    new msg[256];
    format(msg, sizeof(msg), "[Phone] %s: %s", PlayerData[playerid][pName], text);
    SendClientMessage(tid, COLOR_YELLOW, msg);
    SendClientMessage(playerid, COLOR_YELLOW, msg);
    return 1;
}
