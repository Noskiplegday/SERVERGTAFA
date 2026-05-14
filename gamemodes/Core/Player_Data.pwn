// Core/Player_Data.pwn
// Load/save du lieu player bang MySQL.

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

stock PlayerData_LoadFromCache(playerid)
{
    cache_get_value_name_int(0, "id", PlayerData[playerid][pID]);
    cache_get_value_name(0, "username", PlayerData[playerid][pName], MAX_PLAYER_NAME);
    cache_get_value_name(0, "password_hash", PlayerData[playerid][pPassword], 65);
    cache_get_value_name(0, "email", PlayerData[playerid][pEmail], 80);
    cache_get_value_name_int(0, "money", PlayerData[playerid][pMoney]);
    cache_get_value_name_int(0, "bank_money", PlayerData[playerid][pBankMoney]);
    cache_get_value_name_int(0, "skin", PlayerData[playerid][pSkin]);
    cache_get_value_name_int(0, "level", PlayerData[playerid][pLevel]);
    cache_get_value_name_int(0, "exp", PlayerData[playerid][pExp]);
    cache_get_value_name_float(0, "pos_x", PlayerData[playerid][pSpawnX]);
    cache_get_value_name_float(0, "pos_y", PlayerData[playerid][pSpawnY]);
    cache_get_value_name_float(0, "pos_z", PlayerData[playerid][pSpawnZ]);
    cache_get_value_name_float(0, "angle", PlayerData[playerid][pSpawnA]);
    cache_get_value_name_int(0, "job_id", PlayerData[playerid][pJob]);
    cache_get_value_name_int(0, "faction", PlayerData[playerid][pFaction]);
    cache_get_value_name_int(0, "faction_rank", PlayerData[playerid][pFactionRank]);
    cache_get_value_name_int(0, "admin_level", PlayerData[playerid][pAdminLevel]);
    cache_get_value_name_int(0, "warnings", PlayerData[playerid][pWarnings]);
    cache_get_value_name_int(0, "hunger", PlayerData[playerid][pHunger]);
    cache_get_value_name_int(0, "thirst", PlayerData[playerid][pThirst]);

    new jailed;
    cache_get_value_name_int(0, "jailed", jailed);
    PlayerData[playerid][pJailed] = jailed ? true : false;

    cache_get_value_name_int(0, "jail_time", PlayerData[playerid][pJailTime]);
    cache_get_value_name_int(0, "deaths", PlayerData[playerid][pDeaths]);
    cache_get_value_name_int(0, "kills", PlayerData[playerid][pKills]);
    cache_get_value_name_int(0, "phone", PlayerData[playerid][pPhoneNumber]);
    cache_get_value_name_int(0, "house", PlayerData[playerid][pHouseID]);
    cache_get_value_name_int(0, "business", PlayerData[playerid][pBusinessID]);
    cache_get_value_name_int(0, "playtime", PlayerData[playerid][pPlaytime]);
    return 1;
}

stock PlayerData_Save(playerid)
{
    if(!Session_IsLoggedIn(playerid) || PlayerData[playerid][pID] <= 0) return 0;

    new query[1024];
    mysql_format(g_SQL, query, sizeof(query),
        "UPDATE users SET money=%d, bank_money=%d, skin=%d, level=%d, exp=%d, pos_x=%f, pos_y=%f, pos_z=%f, angle=%f, job_id=%d, faction=%d, faction_rank=%d, admin_level=%d, warnings=%d, hunger=%d, thirst=%d, jailed=%d, jail_time=%d, deaths=%d, kills=%d, phone=%d, house=%d, business=%d, playtime=%d WHERE id=%d",
        PlayerData[playerid][pMoney],
        PlayerData[playerid][pBankMoney],
        PlayerData[playerid][pSkin],
        PlayerData[playerid][pLevel],
        PlayerData[playerid][pExp],
        PlayerData[playerid][pSpawnX],
        PlayerData[playerid][pSpawnY],
        PlayerData[playerid][pSpawnZ],
        PlayerData[playerid][pSpawnA],
        PlayerData[playerid][pJob],
        PlayerData[playerid][pFaction],
        PlayerData[playerid][pFactionRank],
        PlayerData[playerid][pAdminLevel],
        PlayerData[playerid][pWarnings],
        PlayerData[playerid][pHunger],
        PlayerData[playerid][pThirst],
        PlayerData[playerid][pJailed] ? 1 : 0,
        PlayerData[playerid][pJailTime],
        PlayerData[playerid][pDeaths],
        PlayerData[playerid][pKills],
        PlayerData[playerid][pPhoneNumber],
        PlayerData[playerid][pHouseID],
        PlayerData[playerid][pBusinessID],
        PlayerData[playerid][pPlaytime],
        PlayerData[playerid][pID]);
    mysql_tquery(g_SQL, query);
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
