// =============================================
//   GAMEMODE ROLEPLAY - open.mp
//   C? h? th?ng ??ng k? / ??ng nh?p
// =============================================

#include <open.mp>
#include <a_mysql>
#include <samp_bcrypt>     // ? ??i th?nh c?i n?y (kh?ng ph?i <bcrypt>)

#define MAX_PLAYER_NAME     24

// ====================== BI?N ======================
new MySQL: db_handle;

enum E_PLAYER_DATA
{
    pID,
    pName[MAX_PLAYER_NAME],
    pPassword[60],
    bool: pLoggedIn
}

new PlayerData[MAX_PLAYERS][E_PLAYER_DATA];

// Dialog
#define DIALOG_REGISTER     1
#define DIALOG_LOGIN        2

// ====================== KH?I ??NG SERVER ======================
main()
{
    print(" ");
    print("===============================");
    print("     SERVER ROLEPLAY DANG CHAY");
    print("===============================");
    print(" ");
}

public OnGameModeInit()
{
    // K?t n?i MySQL
    db_handle = mysql_connect("localhost", "root", "", "gta_server"); 
    
    if(mysql_errno(db_handle) != 0)
        print("[MySQL] Ket noi THAT BAI!");
    else
        print("[MySQL] Ket noi THANH CONG!");
    
    return 1;
}

// ====================== NG??I CH?I V?O ======================
public OnPlayerConnect(playerid)
{
    GetPlayerName(playerid, PlayerData[playerid][pName], MAX_PLAYER_NAME);
    PlayerData[playerid][pLoggedIn] = false;

    new query[128];
    mysql_format(db_handle, query, sizeof(query), 
        "SELECT id FROM users WHERE username = '%e' LIMIT 1", 
        PlayerData[playerid][pName]);
        
    mysql_tquery(db_handle, query, "CheckPlayerAccount", "i", playerid);
    return 1;
}

// ====================== KI?M TRA T?I KHO?N ======================
forward CheckPlayerAccount(playerid);
public CheckPlayerAccount(playerid)
{
    if(cache_num_rows() > 0)
    {
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, 
            "??NG NH?P", "Vui l?ng nh?p m?t kh?u c?a b?n:", "??ng nh?p", "Tho?t");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, 
            "??NG K?", "T?i kho?n ch?a t?n t?i.\nNh?p m?t kh?u ?? t?o t?i kho?n:", "??ng k?", "Tho?t");
    }
    return 1;
}

// ====================== X? L? DIALOG ======================
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(!response) return Kick(playerid);

    switch(dialogid)
    {
        case DIALOG_REGISTER:
        {
            if(strlen(inputtext) < 4)
            {
                ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, 
                    "??NG K?", "M?t kh?u ph?i ?t nh?t 4 k? t?!\nVui l?ng nh?p l?i:", "??ng k?", "Tho?t");
                return 1;
            }
            bcrypt_hash(playerid, "OnPasswordHashed", inputtext, 10);
        }

        case DIALOG_LOGIN:
        {
            bcrypt_verify(playerid, "OnPasswordVerify", inputtext, PlayerData[playerid][pPassword]);
        }
    }
    return 1;
}

// ====================== ??NG K? ======================
forward OnPasswordHashed(playerid, hash[]);
public OnPasswordHashed(playerid, hash[])
{
    new query[256];
    mysql_format(db_handle, query, sizeof(query), 
        "INSERT INTO users (username, password) VALUES ('%e', '%e')", 
        PlayerData[playerid][pName], hash);
    
    mysql_tquery(db_handle, query, "OnAccountRegistered", "i", playerid);
}

forward OnAccountRegistered(playerid);
public OnAccountRegistered(playerid)
{
    SendClientMessage(playerid, 0x00FF00FF, "??ng k? th?nh c?ng! H?y ??ng nh?p l?i.");
    Kick(playerid);
}

// ====================== ??NG NH?P ======================
forward OnPasswordVerify(playerid, bool:success);
public OnPasswordVerify(playerid, bool:success)
{
    if(success)
    {
        PlayerData[playerid][pLoggedIn] = true;
        SendClientMessage(playerid, 0x00FF00FF, "??ng nh?p th?nh c?ng! Ch?o m?ng b?n.");
        SpawnPlayer(playerid);
    }
    else
    {
        SendClientMessage(playerid, 0xFF0000FF, "M?t kh?u sai!");
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, 
            "??NG NH?P", "M?t kh?u kh?ng ??ng!\nVui l?ng nh?p l?i:", "??ng nh?p", "Tho?t");
    }
}

// ====================== C?C H?M C? B?N KH?C ======================
public OnPlayerSpawn(playerid)
{
    if(!PlayerData[playerid][pLoggedIn])
    {
        Kick(playerid);
        return 1;
    }
    // Th?m v? tr? spawn sau n?y...
    SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
    SetPlayerFacingAngle(playerid, 269.1425);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    PlayerData[playerid][pLoggedIn] = false;
    return 1;
}