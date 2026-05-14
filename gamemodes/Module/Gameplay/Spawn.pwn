// Module/Gameplay/Spawn.pwn
// Xu ly spawn player sau khi dang nhap.

stock Spawn_OnPlayerSpawn(playerid)
{
    if(!Session_IsLoggedIn(playerid)) return 1;

    PlayerData_ApplySpawn(playerid);

    if(PlayerData[playerid][pJailed])
    {
        Jail_ApplyJail(playerid);
        return 1;
    }

    SetPlayerHealth(playerid, 100.0);
    SetCameraBehindPlayer(playerid);

    new msg[128];
    format(msg, sizeof(msg), "Chao mung %s! Level %d | Tien: $%d | Job: %d",
        PlayerData[playerid][pName], PlayerData[playerid][pLevel],
        PlayerData[playerid][pMoney], PlayerData[playerid][pJob]);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}
