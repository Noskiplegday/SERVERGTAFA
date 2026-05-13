// Core/Player_Data.pwn
// Load/save va ap dung du lieu nhan vat cua player.

stock PlayerData_SetDefaults(playerid)
{
    PlayerData[playerid][pMoney] = 5000;
    PlayerData[playerid][pSkin] = 0;
    PlayerData[playerid][pLevel] = 1;
    PlayerData[playerid][pExp] = 0;
    PlayerData[playerid][pSpawnX] = 1958.3783;
    PlayerData[playerid][pSpawnY] = 1343.1572;
    PlayerData[playerid][pSpawnZ] = 15.3746;
    PlayerData[playerid][pSpawnA] = 269.1425;
    PlayerData[playerid][pJob] = 0;
    return 1;
}

stock PlayerData_LoadFromCache(playerid)
{
    cache_get_value_name_int(0, "id", PlayerData[playerid][pID]);
    cache_get_value_name(0, "password", PlayerData[playerid][pPassword], BCRYPT_HASH_LENGTH);
    cache_get_value_name_int(0, "money", PlayerData[playerid][pMoney]);
    cache_get_value_name_int(0, "skin", PlayerData[playerid][pSkin]);
    cache_get_value_name_int(0, "level", PlayerData[playerid][pLevel]);
    cache_get_value_name_int(0, "exp", PlayerData[playerid][pExp]);
    cache_get_value_name_float(0, "spawn_x", PlayerData[playerid][pSpawnX]);
    cache_get_value_name_float(0, "spawn_y", PlayerData[playerid][pSpawnY]);
    cache_get_value_name_float(0, "spawn_z", PlayerData[playerid][pSpawnZ]);
    cache_get_value_name_float(0, "spawn_a", PlayerData[playerid][pSpawnA]);
    cache_get_value_name_int(0, "job", PlayerData[playerid][pJob]);
    return 1;
}

stock PlayerData_Save(playerid)
{
    if(PlayerData[playerid][pID] <= 0) return 1;

    new query[512];
    mysql_format(g_SQL, query, sizeof(query),
        "UPDATE `users` SET `money`=%d, `skin`=%d, `level`=%d, `exp`=%d, `spawn_x`=%f, `spawn_y`=%f, `spawn_z`=%f, `spawn_a`=%f, `job`=%d WHERE `id`=%d LIMIT 1",
        PlayerData[playerid][pMoney],
        PlayerData[playerid][pSkin],
        PlayerData[playerid][pLevel],
        PlayerData[playerid][pExp],
        PlayerData[playerid][pSpawnX],
        PlayerData[playerid][pSpawnY],
        PlayerData[playerid][pSpawnZ],
        PlayerData[playerid][pSpawnA],
        PlayerData[playerid][pJob],
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
