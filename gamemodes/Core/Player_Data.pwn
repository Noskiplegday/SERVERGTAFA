// Core/Player_Data.pwn
// Load/save du lieu player bang JSON file.

stock PlayerData_SetDefaults(playerid)
{
    PlayerData[playerid][pMoney] = 5000;
    PlayerData[playerid][pBankMoney] = 0;
    PlayerData[playerid][pSkin] = 0;
    PlayerData[playerid][pLevel] = 1;
    PlayerData[playerid][pExp] = 0;
    PlayerData[playerid][pSpawnX] = 1958.3783;
    PlayerData[playerid][pSpawnY] = 1343.1572;
    PlayerData[playerid][pSpawnZ] = 15.3746;
    PlayerData[playerid][pSpawnA] = 269.1425;
    PlayerData[playerid][pJob] = JOB_NONE;
    PlayerData[playerid][pFaction] = FACTION_NONE;
    PlayerData[playerid][pFactionRank] = 0;
    PlayerData[playerid][pAdminLevel] = 0;
    PlayerData[playerid][pWarnings] = 0;
    PlayerData[playerid][pMuted] = false;
    PlayerData[playerid][pHunger] = 100;
    PlayerData[playerid][pThirst] = 100;
    PlayerData[playerid][pJailed] = false;
    PlayerData[playerid][pJailTime] = 0;
    PlayerData[playerid][pDeaths] = 0;
    PlayerData[playerid][pKills] = 0;
    PlayerData[playerid][pPhoneNumber] = 1000 + playerid;
    PlayerData[playerid][pHouseID] = -1;
    PlayerData[playerid][pBusinessID] = -1;
    PlayerData[playerid][pPlaytime] = 0;
    PlayerData[playerid][pJobEarned] = 0;

    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        PlayerData[playerid][pInvItem][i] = ITEM_NONE;
        PlayerData[playerid][pInvAmount][i] = 0;
    }

    PlayerData[playerid][pInvItem][0] = ITEM_PHONE;
    PlayerData[playerid][pInvAmount][0] = 1;
    return 1;
}

stock PlayerData_GetFilePath(playerid, dest[], maxlen)
{
    format(dest, maxlen, "Users/%s.json", PlayerData[playerid][pName]);
}

stock bool:PlayerData_FileExists(playerid)
{
    new path[64];
    PlayerData_GetFilePath(playerid, path, sizeof(path));
    return fexist(path) ? true : false;
}

stock PlayerData_Load(playerid)
{
    new path[64];
    PlayerData_GetFilePath(playerid, path, sizeof(path));

    if(!fexist(path)) return 0;

    new File:f = fopen(path, io_read);
    if(!f) return 0;

    new line[512], key[64], value[256];
    while(fread(f, line))
    {
        if(!JSON_ParseLine(line, key, sizeof(key), value, sizeof(value))) continue;

        if(!strcmp(key, "password")) strcat((PlayerData[playerid][pPassword][0] = EOS, PlayerData[playerid][pPassword]), value, 65);
        else if(!strcmp(key, "money")) PlayerData[playerid][pMoney] = strval(value);
        else if(!strcmp(key, "bank")) PlayerData[playerid][pBankMoney] = strval(value);
        else if(!strcmp(key, "skin")) PlayerData[playerid][pSkin] = strval(value);
        else if(!strcmp(key, "level")) PlayerData[playerid][pLevel] = strval(value);
        else if(!strcmp(key, "exp")) PlayerData[playerid][pExp] = strval(value);
        else if(!strcmp(key, "spawn_x")) PlayerData[playerid][pSpawnX] = floatstr(value);
        else if(!strcmp(key, "spawn_y")) PlayerData[playerid][pSpawnY] = floatstr(value);
        else if(!strcmp(key, "spawn_z")) PlayerData[playerid][pSpawnZ] = floatstr(value);
        else if(!strcmp(key, "spawn_a")) PlayerData[playerid][pSpawnA] = floatstr(value);
        else if(!strcmp(key, "job")) PlayerData[playerid][pJob] = strval(value);
        else if(!strcmp(key, "faction")) PlayerData[playerid][pFaction] = strval(value);
        else if(!strcmp(key, "faction_rank")) PlayerData[playerid][pFactionRank] = strval(value);
        else if(!strcmp(key, "admin")) PlayerData[playerid][pAdminLevel] = strval(value);
        else if(!strcmp(key, "warnings")) PlayerData[playerid][pWarnings] = strval(value);
        else if(!strcmp(key, "hunger")) PlayerData[playerid][pHunger] = strval(value);
        else if(!strcmp(key, "thirst")) PlayerData[playerid][pThirst] = strval(value);
        else if(!strcmp(key, "jailed")) PlayerData[playerid][pJailed] = strval(value) ? true : false;
        else if(!strcmp(key, "jail_time")) PlayerData[playerid][pJailTime] = strval(value);
        else if(!strcmp(key, "deaths")) PlayerData[playerid][pDeaths] = strval(value);
        else if(!strcmp(key, "kills")) PlayerData[playerid][pKills] = strval(value);
        else if(!strcmp(key, "phone")) PlayerData[playerid][pPhoneNumber] = strval(value);
        else if(!strcmp(key, "house")) PlayerData[playerid][pHouseID] = strval(value);
        else if(!strcmp(key, "business")) PlayerData[playerid][pBusinessID] = strval(value);
        else if(!strcmp(key, "playtime")) PlayerData[playerid][pPlaytime] = strval(value);
        else
        {
            new ikey[32];
            for(new i = 0; i < MAX_INV_SLOTS; i++)
            {
                format(ikey, sizeof(ikey), "inv_%d", i);
                if(!strcmp(key, ikey)) { PlayerData[playerid][pInvItem][i] = strval(value); break; }
                format(ikey, sizeof(ikey), "inv_%d_amt", i);
                if(!strcmp(key, ikey)) { PlayerData[playerid][pInvAmount][i] = strval(value); break; }
            }
        }
    }
    fclose(f);
    return 1;
}

stock PlayerData_Save(playerid)
{
    new path[64];
    PlayerData_GetFilePath(playerid, path, sizeof(path));

    new File:f = fopen(path, io_write);
    if(!f) return 0;

    JSON_WriteHeader(f);
    JSON_WriteString(f, "password", PlayerData[playerid][pPassword]);
    JSON_WriteInt(f, "money", PlayerData[playerid][pMoney]);
    JSON_WriteInt(f, "bank", PlayerData[playerid][pBankMoney]);
    JSON_WriteInt(f, "skin", PlayerData[playerid][pSkin]);
    JSON_WriteInt(f, "level", PlayerData[playerid][pLevel]);
    JSON_WriteInt(f, "exp", PlayerData[playerid][pExp]);
    JSON_WriteFloat(f, "spawn_x", PlayerData[playerid][pSpawnX]);
    JSON_WriteFloat(f, "spawn_y", PlayerData[playerid][pSpawnY]);
    JSON_WriteFloat(f, "spawn_z", PlayerData[playerid][pSpawnZ]);
    JSON_WriteFloat(f, "spawn_a", PlayerData[playerid][pSpawnA]);
    JSON_WriteInt(f, "job", PlayerData[playerid][pJob]);
    JSON_WriteInt(f, "faction", PlayerData[playerid][pFaction]);
    JSON_WriteInt(f, "faction_rank", PlayerData[playerid][pFactionRank]);
    JSON_WriteInt(f, "admin", PlayerData[playerid][pAdminLevel]);
    JSON_WriteInt(f, "warnings", PlayerData[playerid][pWarnings]);
    JSON_WriteInt(f, "hunger", PlayerData[playerid][pHunger]);
    JSON_WriteInt(f, "thirst", PlayerData[playerid][pThirst]);
    JSON_WriteInt(f, "jailed", PlayerData[playerid][pJailed] ? 1 : 0);
    JSON_WriteInt(f, "jail_time", PlayerData[playerid][pJailTime]);
    JSON_WriteInt(f, "deaths", PlayerData[playerid][pDeaths]);
    JSON_WriteInt(f, "kills", PlayerData[playerid][pKills]);
    JSON_WriteInt(f, "phone", PlayerData[playerid][pPhoneNumber]);
    JSON_WriteInt(f, "house", PlayerData[playerid][pHouseID]);
    JSON_WriteInt(f, "business", PlayerData[playerid][pBusinessID]);
    JSON_WriteInt(f, "playtime", PlayerData[playerid][pPlaytime]);

    new ikey[32];
    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        format(ikey, sizeof(ikey), "inv_%d", i);
        JSON_WriteInt(f, ikey, PlayerData[playerid][pInvItem][i]);
        format(ikey, sizeof(ikey), "inv_%d_amt", i);
        if(i == MAX_INV_SLOTS - 1)
            JSON_WriteInt(f, ikey, PlayerData[playerid][pInvAmount][i], true);
        else
            JSON_WriteInt(f, ikey, PlayerData[playerid][pInvAmount][i]);
    }

    JSON_WriteFooter(f);
    fclose(f);
    return 1;
}

stock PlayerData_ApplyAfterLogin(playerid)
{
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
    SetPlayerScore(playerid, PlayerData[playerid][pLevel]);
    SetSpawnInfo(playerid, 0, PlayerData[playerid][pSkin],
        PlayerData[playerid][pSpawnX],
        PlayerData[playerid][pSpawnY],
        PlayerData[playerid][pSpawnZ],
        PlayerData[playerid][pSpawnA],
        WEAPON_FIST, 0, WEAPON_FIST, 0, WEAPON_FIST, 0);
    return 1;
}

stock PlayerData_ApplySpawn(playerid)
{
    SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
    SetPlayerPos(playerid,
        PlayerData[playerid][pSpawnX],
        PlayerData[playerid][pSpawnY],
        PlayerData[playerid][pSpawnZ]);
    SetPlayerFacingAngle(playerid, PlayerData[playerid][pSpawnA]);
    return 1;
}
