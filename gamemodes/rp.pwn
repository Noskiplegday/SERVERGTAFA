// =============================================
//   GAMEMODE ROLEPLAY - open.mp
//   Entry point: chi include va dieu phoi module.
// =============================================

#include <open.mp>
#include <a_mysql>
#include <bcrypt>

#define DIALOG_REGISTER     1
#define DIALOG_LOGIN        2

#define COLOR_GREEN         0x00FF00FF
#define COLOR_RED           0xFF0000FF
#define COLOR_WHITE         0xFFFFFFFF

enum E_PLAYER_DATA
{
    pID,
    pName[MAX_PLAYER_NAME],
    pPassword[BCRYPT_HASH_LENGTH],
    pMoney,
    pSkin,
    pLevel,
    pExp,
    Float:pSpawnX,
    Float:pSpawnY,
    Float:pSpawnZ,
    Float:pSpawnA,
    pJob,
    bool:pLoggedIn
}

new PlayerData[MAX_PLAYERS][E_PLAYER_DATA];

#include "Core/Database.pwn"
#include "Core/Session.pwn"
#include "Core/Player_Data.pwn"
#include "Core/Account.pwn"
#include "Core/Admin_System.pwn"

main()
{
    print(" ");
    print("====================================");
    print("     VAN CANH CITY ROLEPLAY");
    print("====================================");
    print(" ");
}

public OnGameModeInit()
{
    Database_Connect();
    Admin_Init();
    return 1;
}

public OnGameModeExit()
{
    Database_Close();
    return 1;
}

public OnPlayerConnect(playerid)
{
    Account_OnPlayerConnect(playerid);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    return Account_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
}

public OnPlayerSpawn(playerid)
{
    if(!Session_IsLoggedIn(playerid))
    {
        Kick(playerid);
        return 1;
    }

    PlayerData_ApplySpawn(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(Session_IsLoggedIn(playerid))
    {
        PlayerData_Save(playerid);
    }

    Session_Reset(playerid);
    return 1;
}
