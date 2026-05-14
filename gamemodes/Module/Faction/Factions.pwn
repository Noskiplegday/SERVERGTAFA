// Module/Faction/Factions.pwn
// He thong to chuc: LSPD, EMS, Gov, Gang.

new FactionNames[5][32] = {
    "Khong co",
    "LSPD (Canh Sat)",
    "EMS (Y Te)",
    "Government",
    "Gang/Mafia"
};

stock Faction_Init()
{
    Faction_LoadAll();
    if(TotalFactions == 0)
    {
        Faction_Create("LSPD", FACTION_LSPD, 1545.0, -1675.0, 13.5);
        Faction_Create("EMS", FACTION_EMS, 1172.0, -1323.0, 15.4);
        Faction_Create("Government", FACTION_GOV, 1481.0, -1772.0, 18.8);
        Faction_Create("Gang", FACTION_GANG, 2495.0, -1691.0, 14.0);
    }
    print("[Faction] He thong to chuc da san sang.");
    return 1;
}

stock Faction_Create(const name[], id, Float:x, Float:y, Float:z)
{
    if(TotalFactions >= MAX_FACTIONS) return 0;
    new f = TotalFactions;

    FactionData[f][fID] = id;
    strcat((FactionData[f][fName][0] = EOS, FactionData[f][fName]), name, 32);
    FactionData[f][fHQX] = x;
    FactionData[f][fHQY] = y;
    FactionData[f][fHQZ] = z;

    CreatePickup(1239, 1, x, y, z, -1);
    new label[128];
    format(label, sizeof(label), "%s HQ\n/faction", name);
    Create3DTextLabel(label, COLOR_BLUE, x, y, z + 0.5, 20.0, 0, 0);

    TotalFactions++;
    Faction_SaveOne(f);
    return 1;
}

stock Faction_LoadAll()
{
    TotalFactions = 0;
    new path[64], line[512], key[64], value[128];

    for(new i = 0; i < MAX_FACTIONS; i++)
    {
        format(path, sizeof(path), "Factions/%d.json", i);
        if(!fexist(path)) continue;

        new File:f = fopen(path, io_read);
        if(!f) continue;

        new idx = TotalFactions;
        while(fread(f, line))
        {
            if(!JSON_ParseLine(line, key, sizeof(key), value, sizeof(value))) continue;
            if(!strcmp(key, "id")) FactionData[idx][fID] = strval(value);
            else if(!strcmp(key, "name")) strcat((FactionData[idx][fName][0] = EOS, FactionData[idx][fName]), value, 32);
            else if(!strcmp(key, "hq_x")) FactionData[idx][fHQX] = floatstr(value);
            else if(!strcmp(key, "hq_y")) FactionData[idx][fHQY] = floatstr(value);
            else if(!strcmp(key, "hq_z")) FactionData[idx][fHQZ] = floatstr(value);
        }
        fclose(f);

        CreatePickup(1239, 1, FactionData[idx][fHQX], FactionData[idx][fHQY], FactionData[idx][fHQZ], -1);
        new label[128];
        format(label, sizeof(label), "%s HQ\n/faction", FactionData[idx][fName]);
        Create3DTextLabel(label, COLOR_BLUE, FactionData[idx][fHQX], FactionData[idx][fHQY], FactionData[idx][fHQZ] + 0.5, 20.0, 0, 0);

        TotalFactions++;
    }
}

stock Faction_SaveOne(idx)
{
    new path[64];
    format(path, sizeof(path), "Factions/%d.json", idx);
    new File:f = fopen(path, io_write);
    if(!f) return 0;

    JSON_WriteHeader(f);
    JSON_WriteInt(f, "id", FactionData[idx][fID]);
    JSON_WriteString(f, "name", FactionData[idx][fName]);
    JSON_WriteFloat(f, "hq_x", FactionData[idx][fHQX]);
    JSON_WriteFloat(f, "hq_y", FactionData[idx][fHQY]);
    JSON_WriteFloat(f, "hq_z", FactionData[idx][fHQZ], true);
    JSON_WriteFooter(f);
    fclose(f);
    return 1;
}

stock Faction_FindByID(fid)
{
    for(new i = 0; i < TotalFactions; i++)
    {
        if(FactionData[i][fID] == fid) return i;
    }
    return -1;
}

stock Faction_OnCommand(playerid, cmdtext[])
{
    new cmd[32], params[128], idx;
    idx = 0;
    while(cmdtext[idx] && cmdtext[idx] != ' ') { if(idx < 31) cmd[idx] = cmdtext[idx]; idx++; }
    cmd[idx] = EOS;
    if(cmdtext[idx] == ' ') idx++;
    strmid(params, cmdtext, idx, strlen(cmdtext), sizeof(params));

    if(!strcmp(cmd, "/faction", true))
    {
        if(PlayerData[playerid][pFaction] == FACTION_NONE)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong thuoc to chuc nao!");
            return 1;
        }
        new fidx = Faction_FindByID(PlayerData[playerid][pFaction]);
        if(fidx == -1) return 1;

        new msg[256];
        format(msg, sizeof(msg), "=== %s === | Rank: %d | Duty: %s",
            FactionData[fidx][fName],
            PlayerData[playerid][pFactionRank],
            PlayerData[playerid][pOnDuty] ? "ON" : "OFF");
        SendClientMessage(playerid, COLOR_BLUE, msg);
        return 1;
    }

    if(!strcmp(cmd, "/fmembers", true))
    {
        if(PlayerData[playerid][pFaction] == FACTION_NONE)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong thuoc to chuc nao!");
            return 1;
        }
        SendClientMessage(playerid, COLOR_BLUE, "=== THANH VIEN ONLINE ===");
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i) && PlayerData[i][pLoggedIn] && PlayerData[i][pFaction] == PlayerData[playerid][pFaction])
            {
                new msg[128];
                format(msg, sizeof(msg), "%s - Rank %d - %s", PlayerData[i][pName], PlayerData[i][pFactionRank],
                    PlayerData[i][pOnDuty] ? "On Duty" : "Off Duty");
                SendClientMessage(playerid, COLOR_WHITE, msg);
            }
        }
        return 1;
    }

    if(!strcmp(cmd, "/promote", true))
    {
        if(PlayerData[playerid][pFaction] == FACTION_NONE || PlayerData[playerid][pFactionRank] < 5)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen (can rank >= 5)!");
            return 1;
        }
        new tid = strval(params);
        if(!IsPlayerConnected(tid) || PlayerData[tid][pFaction] != PlayerData[playerid][pFaction])
        {
            SendClientMessage(playerid, COLOR_RED, "Player khong hop le hoac khong cung faction!");
            return 1;
        }
        if(PlayerData[tid][pFactionRank] >= 10) { SendClientMessage(playerid, COLOR_RED, "Da dat rank toi da!"); return 1; }

        PlayerData[tid][pFactionRank]++;
        new msg[128];
        format(msg, sizeof(msg), "%s da thang cap %s len rank %d.", PlayerData[playerid][pName], PlayerData[tid][pName], PlayerData[tid][pFactionRank]);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        SendClientMessage(tid, COLOR_GREEN, msg);
        return 1;
    }

    if(!strcmp(cmd, "/demote", true))
    {
        if(PlayerData[playerid][pFaction] == FACTION_NONE || PlayerData[playerid][pFactionRank] < 5)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong co quyen!");
            return 1;
        }
        new tid = strval(params);
        if(!IsPlayerConnected(tid) || PlayerData[tid][pFaction] != PlayerData[playerid][pFaction])
        {
            SendClientMessage(playerid, COLOR_RED, "Player khong hop le!");
            return 1;
        }
        if(PlayerData[tid][pFactionRank] <= 1) { SendClientMessage(playerid, COLOR_RED, "Khong the giam hon!"); return 1; }

        PlayerData[tid][pFactionRank]--;
        new msg[128];
        format(msg, sizeof(msg), "%s da giam cap %s xuong rank %d.", PlayerData[playerid][pName], PlayerData[tid][pName], PlayerData[tid][pFactionRank]);
        SendClientMessage(playerid, COLOR_YELLOW, msg);
        SendClientMessage(tid, COLOR_YELLOW, msg);
        return 1;
    }

    return 0;
}

stock Faction_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused playerid, dialogid, response, listitem, inputtext
    return 0;
}
