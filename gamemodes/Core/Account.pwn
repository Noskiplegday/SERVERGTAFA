#include <open.mp>
#include <a_mysql>
#include <samp_bcrypt>     // Quan trọng: phải là samp_bcrypt

#define MAX_PLAYER_NAME 24

new MySQL: db_handle;

enum E_PLAYER_DATA
{
    pID,
    pName[MAX_PLAYER_NAME],
    pPassword[60 + 1],
    bool: pLoggedIn
}

new PlayerData[MAX_PLAYERS][E_PLAYER_DATA];

#define DIALOG_REGISTER 1
#define DIALOG_LOGIN    2

// ====================== KHỞI ĐỘNG ======================
public OnGameModeInit()
{
    db_handle = mysql_connect("localhost", "root", "", "server_gta");
    
    if(mysql_errno(db_handle) != 0)
        print("[MySQL] Ket noi THAT BAI!");
    else
        print("[MySQL] Ket noi THANH CONG!");
    
    return 1;
}

// ====================== NGƯỜI CHƠI VÀO ======================
public OnPlayerConnect(playerid)
{
    GetPlayerName(playerid, PlayerData[playerid][pName], MAX_PLAYER_NAME);
    PlayerData[playerid][pLoggedIn] = false;

    new query[128];
    mysql_format(db_handle, query, sizeof(query), "SELECT id FROM users WHERE username = '%e' LIMIT 1", PlayerData[playerid][pName]);
    mysql_tquery(db_handle, query, "CheckPlayerAccount", "i", playerid);
    return 1;
}

// ====================== KIỂM TRA TÀI KHOẢN ======================
forward CheckPlayerAccount(playerid);
public CheckPlayerAccount(playerid)
{
    if(cache_num_rows() > 0)
    {
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, 
            "ĐĂNG NHẬP", "Vui lòng nhập mật khẩu:", "Đăng nhập", "Thoát");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, 
            "ĐĂNG KÝ", "Tài khoản chưa tồn tại.\nNhập mật khẩu để đăng ký:", "Đăng ký", "Thoát");
    }
    return 1;
}

// ====================== DIALOG ======================
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
                    "ĐĂNG KÝ", "Mật khẩu phải ít nhất 4 ký tự!", "Đăng ký", "Thoát");
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

// ====================== ĐĂNG KÝ ======================
forward OnPasswordHashed(playerid);
public OnPasswordHashed(playerid)
{
    new hash[BCRYPT_HASH_LENGTH];
    bcrypt_get_hash(hash);

    new query[300];
    mysql_format(db_handle, query, sizeof(query), 
        "INSERT INTO users (username, password) VALUES ('%e', '%e')", 
        PlayerData[playerid][pName], hash);
    
    mysql_tquery(db_handle, query, "OnAccountRegistered", "i", playerid);
}

forward OnAccountRegistered(playerid);
public OnAccountRegistered(playerid)
{
    SendClientMessage(playerid, 0x00FF00FF, "Đăng ký thành công! Hãy đăng nhập lại.");
    Kick(playerid);
}

// ====================== ĐĂNG NHẬP ======================
forward OnPasswordVerify(playerid, bool:success);
public OnPasswordVerify(playerid, bool:success)
{
    if(success)
    {
        PlayerData[playerid][pLoggedIn] = true;
        SendClientMessage(playerid, 0x00FF00FF, "Đăng nhập thành công!");
        SpawnPlayer(playerid);
    }
    else
    {
        SendClientMessage(playerid, 0xFF0000FF, "Mật khẩu sai!");
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, 
            "ĐĂNG NHẬP", "Mật khẩu không đúng!\nVui lòng nhập lại:", "Đăng nhập", "Thoát");
    }
}