// Core/Player_Data.pwn
// Load/save du lieu player bang database.

stock PlayerData_SetDefaults(playerid)
{
    PlayerData[playerid][pMoney] = 5000;
    PlayerData[playerid][pBankMoney] = 0;
    PlayerData[playerid][pSkin] = 26;
    PlayerData[playerid][pLevel] = 1;
    PlayerData[playerid][pExp] = 0;
    PlayerData[playerid][pSpawnX] = DEFAULT_SPAWN_X;
    PlayerData[playerid][pSpawnY] = DEFAULT_SPAWN_Y;
    PlayerData[playerid][pSpawnZ] = DEFAULT_SPAWN_Z;
    PlayerData[playerid][pSpawnA] = DEFAULT_SPAWN_A;
    PlayerData[playerid][pJob] = JOB_NONE;
    if(PlayerData[playerid][pRole][0] == EOS)
        strcat((PlayerData[playerid][pRole][0] = EOS, PlayerData[playerid][pRole]), "member", 16);
    if(PlayerData[playerid][pMission][0] == EOS)
        strcat((PlayerData[playerid][pMission][0] = EOS, PlayerData[playerid][pMission]), "none", 32);
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
    #pragma unused playerid
    return 1;
}

stock PlayerData_Save(playerid)
{
    if(!Session_IsLoggedIn(playerid) || PlayerData[playerid][pID] <= 0) return 0;
    GetPlayerPos(playerid, PlayerData[playerid][pSpawnX], PlayerData[playerid][pSpawnY], PlayerData[playerid][pSpawnZ]);
    GetPlayerFacingAngle(playerid, PlayerData[playerid][pSpawnA]);
    // PostgreSQL bridge chua duoc tich hop, nen save runtime tam thoi khong ghi remote.
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
