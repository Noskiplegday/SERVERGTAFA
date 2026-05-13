// Core/Session.pwn
// Quan ly trang thai dang nhap va reset session cua player.

stock Session_Reset(playerid)
{
    PlayerData[playerid][pLoggedIn] = false;
    PlayerData[playerid][pID] = 0;
    PlayerData[playerid][pPassword][0] = EOS;
    return 1;
}

stock Session_Login(playerid)
{
    PlayerData[playerid][pLoggedIn] = true;
    return 1;
}

stock bool:Session_IsLoggedIn(playerid)
{
    return PlayerData[playerid][pLoggedIn];
}
