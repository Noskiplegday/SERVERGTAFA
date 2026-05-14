// Core/Admin_System.pwn
// He thong admin: rank, kick/ban/warn/mute, tp, spectate, spawn vehicle.

stock Admin_Init()
{
    print("[Admin] He thong admin da san sang.");
    return 1;
}

stock Admin_OnCommand(playerid, cmdtext[])
{
    new cmd[32], params[128], idx;
    idx = 0;
    while(cmdtext[idx] && cmdtext[idx] != ' ') { if(idx < 31) cmd[idx] = cmdtext[idx]; idx++; }
    cmd[idx] = EOS;
    if(cmdtext[idx] == ' ') idx++;
    strmid(params, cmdtext, idx, strlen(cmdtext), sizeof(params));

    // /help
    if(!strcmp(cmd, "/help", true))
    {
        SendClientMessage(playerid, COLOR_ANNOUNCE, "=== VAN CANH CITY ===");
        SendClientMessage(playerid, COLOR_WHITE, "/stats /inventory /job /quitjob /work /stopwork");
        SendClientMessage(playerid, COLOR_WHITE, "/pay /balance /deposit /withdraw /transfer");
        SendClientMessage(playerid, COLOR_WHITE, "/buycar /mycars /lock /engine /fuel /park");
        SendClientMessage(playerid, COLOR_WHITE, "/buyhouse /sellhouse /houselock /enter /exit");
        SendClientMessage(playerid, COLOR_WHITE, "/faction /duty /radio /fmembers /promote /demote");
        SendClientMessage(playerid, COLOR_WHITE, "/call /sms /hangup /pickup /phone");
        SendClientMessage(playerid, COLOR_WHITE, "/me /do /s /b /w /ooc");
        SendClientMessage(playerid, COLOR_WHITE, "/buybiz /sellbiz /shop");
        if(PlayerData[playerid][pAdminLevel] >= 1)
            SendClientMessage(playerid, COLOR_ADMIN, "Admin: /kick /ban /unban /warn /mute /unmute /freeze /tp /goto /bring /spec /aveh /arepair /setadmin /setmoney /setskin");
        return 1;
    }

    // /stats
    if(!strcmp(cmd, "/stats", true))
    {
        new msg[256];
        format(msg, sizeof(msg), "=== Stats: %s ===", PlayerData[playerid][pName]);
        SendClientMessage(playerid, COLOR_ANNOUNCE, msg);
        format(msg, sizeof(msg), "Level: %d | EXP: %d | Tien: $%d | Ngan hang: $%d", PlayerData[playerid][pLevel], PlayerData[playerid][pExp], PlayerData[playerid][pMoney], PlayerData[playerid][pBankMoney]);
        SendClientMessage(playerid, COLOR_WHITE, msg);
        format(msg, sizeof(msg), "Job: %d | Faction: %d (Rank %d) | Admin: %d", PlayerData[playerid][pJob], PlayerData[playerid][pFaction], PlayerData[playerid][pFactionRank], PlayerData[playerid][pAdminLevel]);
        SendClientMessage(playerid, COLOR_WHITE, msg);
        format(msg, sizeof(msg), "Kills: %d | Deaths: %d | Hunger: %d | Thirst: %d", PlayerData[playerid][pKills], PlayerData[playerid][pDeaths], PlayerData[playerid][pHunger], PlayerData[playerid][pThirst]);
        SendClientMessage(playerid, COLOR_WHITE, msg);
        format(msg, sizeof(msg), "Phone: %d | House: %d | Business: %d | Warnings: %d", PlayerData[playerid][pPhoneNumber], PlayerData[playerid][pHouseID], PlayerData[playerid][pBusinessID], PlayerData[playerid][pWarnings]);
        SendClientMessage(playerid, COLOR_WHITE, msg);
        return 1;
    }

    // === ADMIN COMMANDS ===
    // /kick [id] [reason]
    if(!strcmp(cmd, "/kick", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 1) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new tid, reason[64];
        if(!Admin_ParseIDReason(params, tid, reason, sizeof(reason)))
        {
            SendClientMessage(playerid, COLOR_YELLOW, "Dung: /kick [id] [ly do]");
            return 1;
        }
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }

        new msg[256];
        format(msg, sizeof(msg), "[Admin] %s da kick %s. Ly do: %s", PlayerData[playerid][pName], PlayerData[tid][pName], reason);
        SendClientMessageToAll(COLOR_ADMIN, msg);
        ServerLog_Write(msg);
        SetTimerEx("Account_DelayKick", 500, false, "i", tid);
        return 1;
    }

    // /ban [id] [reason]
    if(!strcmp(cmd, "/ban", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 2) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen! (Can admin level 2)"); return 1; }
        new tid, reason[64];
        if(!Admin_ParseIDReason(params, tid, reason, sizeof(reason)))
        {
            SendClientMessage(playerid, COLOR_YELLOW, "Dung: /ban [id] [ly do]");
            return 1;
        }
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }

        Account_AddBan(PlayerData[tid][pName]);

        new msg[256];
        format(msg, sizeof(msg), "[Admin] %s da ban %s. Ly do: %s", PlayerData[playerid][pName], PlayerData[tid][pName], reason);
        SendClientMessageToAll(COLOR_ADMIN, msg);
        ServerLog_Write(msg);
        SetTimerEx("Account_DelayKick", 500, false, "i", tid);
        return 1;
    }

    // /unban [name]
    if(!strcmp(cmd, "/unban", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 2) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        if(strlen(params) < 1) { SendClientMessage(playerid, COLOR_YELLOW, "Dung: /unban [ten]"); return 1; }

        if(Account_RemoveBan(params))
        {
            new msg[128];
            format(msg, sizeof(msg), "[Admin] %s da unban %s.", PlayerData[playerid][pName], params);
            SendClientMessageToAll(COLOR_ADMIN, msg);
        }
        else
            SendClientMessage(playerid, COLOR_RED, "Khong tim thay nguoi bi ban voi ten nay.");
        return 1;
    }

    // /warn [id] [reason]
    if(!strcmp(cmd, "/warn", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 1) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new tid, reason[64];
        if(!Admin_ParseIDReason(params, tid, reason, sizeof(reason)))
        {
            SendClientMessage(playerid, COLOR_YELLOW, "Dung: /warn [id] [ly do]");
            return 1;
        }
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }

        PlayerData[tid][pWarnings]++;
        new msg[256];
        format(msg, sizeof(msg), "[Admin] %s da canh cao %s (%d/3). Ly do: %s", PlayerData[playerid][pName], PlayerData[tid][pName], PlayerData[tid][pWarnings], reason);
        SendClientMessageToAll(COLOR_ADMIN, msg);
        ServerLog_Write(msg);

        if(PlayerData[tid][pWarnings] >= 3)
        {
            Account_AddBan(PlayerData[tid][pName]);
            format(msg, sizeof(msg), "[Admin] %s da bi ban tu dong (3 canh cao).", PlayerData[tid][pName]);
            SendClientMessageToAll(COLOR_ADMIN, msg);
            SetTimerEx("Account_DelayKick", 500, false, "i", tid);
        }
        return 1;
    }

    // /mute [id]
    if(!strcmp(cmd, "/mute", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 1) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new tid = strval(params);
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }
        PlayerData[tid][pMuted] = true;
        new msg[128];
        format(msg, sizeof(msg), "[Admin] %s da cam chat %s.", PlayerData[playerid][pName], PlayerData[tid][pName]);
        SendClientMessageToAll(COLOR_ADMIN, msg);
        return 1;
    }

    // /unmute [id]
    if(!strcmp(cmd, "/unmute", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 1) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new tid = strval(params);
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }
        PlayerData[tid][pMuted] = false;
        new msg[128];
        format(msg, sizeof(msg), "[Admin] %s da bo cam chat %s.", PlayerData[playerid][pName], PlayerData[tid][pName]);
        SendClientMessageToAll(COLOR_ADMIN, msg);
        return 1;
    }

    // /freeze [id]
    if(!strcmp(cmd, "/freeze", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 1) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new tid = strval(params);
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }
        TogglePlayerControllable(tid, false);
        SendClientMessage(playerid, COLOR_ADMIN, "Da dong bang player.");
        SendClientMessage(tid, COLOR_ADMIN, "Ban da bi dong bang boi admin.");
        return 1;
    }

    // /unfreeze [id]
    if(!strcmp(cmd, "/unfreeze", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 1) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new tid = strval(params);
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }
        TogglePlayerControllable(tid, true);
        SendClientMessage(playerid, COLOR_ADMIN, "Da bo dong bang player.");
        SendClientMessage(tid, COLOR_ADMIN, "Ban da duoc bo dong bang.");
        return 1;
    }

    // /goto [id]
    if(!strcmp(cmd, "/goto", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 1) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new tid = strval(params);
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }
        new Float:x, Float:y, Float:z;
        GetPlayerPos(tid, x, y, z);
        SetPlayerPos(playerid, x + 1.0, y, z);
        SetPlayerInterior(playerid, GetPlayerInterior(tid));
        SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(tid));
        SendClientMessage(playerid, COLOR_ADMIN, "Da teleport den player.");
        return 1;
    }

    // /bring [id]
    if(!strcmp(cmd, "/bring", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 1) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new tid = strval(params);
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerPos(tid, x + 1.0, y, z);
        SetPlayerInterior(tid, GetPlayerInterior(playerid));
        SetPlayerVirtualWorld(tid, GetPlayerVirtualWorld(playerid));
        SendClientMessage(playerid, COLOR_ADMIN, "Da keo player den.");
        SendClientMessage(tid, COLOR_ADMIN, "Ban da bi admin keo den.");
        return 1;
    }

    // /tp [x] [y] [z]
    if(!strcmp(cmd, "/tp", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 1) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new Float:x, Float:y, Float:z;
        new p1[16], p2[16], p3[16], pi = 0, ci = 0;
        while(params[pi] && params[pi] != ' ') { if(ci < 15) p1[ci] = params[pi]; ci++; pi++; }
        p1[ci] = EOS;
        if(params[pi] == ' ') pi++;
        ci = 0;
        while(params[pi] && params[pi] != ' ') { if(ci < 15) p2[ci] = params[pi]; ci++; pi++; }
        p2[ci] = EOS;
        if(params[pi] == ' ') pi++;
        ci = 0;
        while(params[pi]) { if(ci < 15) p3[ci] = params[pi]; ci++; pi++; }
        p3[ci] = EOS;

        x = floatstr(p1);
        y = floatstr(p2);
        z = floatstr(p3);
        SetPlayerPos(playerid, x, y, z);
        SendClientMessage(playerid, COLOR_ADMIN, "Da teleport.");
        return 1;
    }

    // /spec [id]
    if(!strcmp(cmd, "/spec", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 2) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new tid = strval(params);
        if(tid == playerid)
        {
            TogglePlayerSpectating(playerid, false);
            SendClientMessage(playerid, COLOR_ADMIN, "Da tat spectate.");
            return 1;
        }
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }
        TogglePlayerSpectating(playerid, true);
        PlayerSpectatePlayer(playerid, tid);
        SendClientMessage(playerid, COLOR_ADMIN, "Dang spectate player. Dung /spec [id cua ban] de thoat.");
        return 1;
    }

    // /aveh [model]
    if(!strcmp(cmd, "/aveh", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 2) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new model = strval(params);
        if(model < 400 || model > 611) { SendClientMessage(playerid, COLOR_RED, "Model xe tu 400 den 611."); return 1; }
        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        new vid = CreateVehicle(model, x + 3.0, y, z, a, -1, -1, -1);
        PutPlayerInVehicle(playerid, vid, 0);
        SendClientMessage(playerid, COLOR_ADMIN, "Da tao xe admin.");
        return 1;
    }

    // /arepair
    if(!strcmp(cmd, "/arepair", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 1) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new vid = GetPlayerVehicleID(playerid);
        if(!vid) { SendClientMessage(playerid, COLOR_RED, "Ban phai ngoi trong xe!"); return 1; }
        RepairVehicle(vid);
        SendClientMessage(playerid, COLOR_ADMIN, "Da sua xe.");
        return 1;
    }

    // /setadmin [id] [level]
    if(!strcmp(cmd, "/setadmin", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 5) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen! (Can admin level 5)"); return 1; }
        new tid, lvl;
        new p1[8], p2[8], pi = 0, ci = 0;
        while(params[pi] && params[pi] != ' ') { if(ci < 7) p1[ci] = params[pi]; ci++; pi++; }
        p1[ci] = EOS;
        if(params[pi] == ' ') pi++;
        ci = 0;
        while(params[pi]) { if(ci < 7) p2[ci] = params[pi]; ci++; pi++; }
        p2[ci] = EOS;
        tid = strval(p1);
        lvl = strval(p2);
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }
        if(lvl < 0 || lvl > 5) { SendClientMessage(playerid, COLOR_RED, "Level tu 0 den 5."); return 1; }
        PlayerData[tid][pAdminLevel] = lvl;
        new msg[128];
        format(msg, sizeof(msg), "[Admin] %s da set admin level %d cho %s.", PlayerData[playerid][pName], lvl, PlayerData[tid][pName]);
        SendClientMessageToAll(COLOR_ADMIN, msg);
        PlayerData_Save(tid);
        return 1;
    }

    // /setmoney [id] [amount]
    if(!strcmp(cmd, "/setmoney", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 3) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new p1[8], p2[16], pi = 0, ci = 0;
        while(params[pi] && params[pi] != ' ') { if(ci < 7) p1[ci] = params[pi]; ci++; pi++; }
        p1[ci] = EOS;
        if(params[pi] == ' ') pi++;
        ci = 0;
        while(params[pi]) { if(ci < 15) p2[ci] = params[pi]; ci++; pi++; }
        p2[ci] = EOS;
        new tid = strval(p1), amount = strval(p2);
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }
        Economy_SetMoney(tid, amount);
        new msg[128];
        format(msg, sizeof(msg), "[Admin] %s da set tien cho %s: $%d", PlayerData[playerid][pName], PlayerData[tid][pName], amount);
        SendClientMessage(playerid, COLOR_ADMIN, msg);
        return 1;
    }

    // /setskin [id] [skinid]
    if(!strcmp(cmd, "/setskin", true))
    {
        if(PlayerData[playerid][pAdminLevel] < 2) { SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!"); return 1; }
        new p1[8], p2[8], pi = 0, ci = 0;
        while(params[pi] && params[pi] != ' ') { if(ci < 7) p1[ci] = params[pi]; ci++; pi++; }
        p1[ci] = EOS;
        if(params[pi] == ' ') pi++;
        ci = 0;
        while(params[pi]) { if(ci < 7) p2[ci] = params[pi]; ci++; pi++; }
        p2[ci] = EOS;
        new tid = strval(p1), skin = strval(p2);
        if(!IsPlayerConnected(tid)) { SendClientMessage(playerid, COLOR_RED, "Player khong ton tai!"); return 1; }
        if(skin < 0 || skin > 311) { SendClientMessage(playerid, COLOR_RED, "Skin tu 0 den 311."); return 1; }
        SetPlayerSkin(tid, skin);
        PlayerData[tid][pSkin] = skin;
        new msg[128];
        format(msg, sizeof(msg), "[Admin] Da set skin %d cho %s.", skin, PlayerData[tid][pName]);
        SendClientMessage(playerid, COLOR_ADMIN, msg);
        return 1;
    }

    return 0;
}

stock Admin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused playerid, dialogid, response, listitem, inputtext
    return 0;
}

stock Admin_ParseIDReason(params[], &tid, reason[], maxreason)
{
    new p1[8], pi = 0, ci = 0;
    while(params[pi] && params[pi] != ' ') { if(ci < 7) p1[ci] = params[pi]; ci++; pi++; }
    p1[ci] = EOS;
    if(params[pi] == ' ') pi++;
    strmid(reason, params, pi, strlen(params), maxreason);
    if(strlen(p1) == 0 || strlen(reason) == 0) return 0;
    tid = strval(p1);
    return 1;
}
