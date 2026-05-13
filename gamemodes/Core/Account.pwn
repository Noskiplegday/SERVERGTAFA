// Core/Account.pwn
// Dang ky, dang nhap, bcrypt va dialog account.

stock Account_OnPlayerConnect(playerid)
{
    Session_Reset(playerid);
    PlayerData_SetDefaults(playerid);
    GetPlayerName(playerid, PlayerData[playerid][pName], MAX_PLAYER_NAME);

    new query[256];
    mysql_format(g_SQL, query, sizeof(query),
        "SELECT `id`, `password`, `money`, `skin`, `level`, `exp`, `spawn_x`, `spawn_y`, `spawn_z`, `spawn_a`, `job` FROM `users` WHERE `username`='%e' LIMIT 1",
        PlayerData[playerid][pName]);
    mysql_tquery(g_SQL, query, "Account_OnLookup", "i", playerid);
    return 1;
}

forward Account_OnLookup(playerid);
public Account_OnLookup(playerid)
{
    new rows;
    cache_get_row_count(rows);

    if(rows > 0)
    {
        PlayerData_LoadFromCache(playerid);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
            "DANG NHAP",
            "Vui long nhap mat khau cua ban:",
            "Dang nhap",
            "Thoat");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,
            "DANG KY",
            "Tai khoan chua ton tai.\nNhap mat khau de tao tai khoan:",
            "Dang ky",
            "Thoat");
    }
    return 1;
}

stock Account_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused listitem

    if(dialogid != DIALOG_REGISTER && dialogid != DIALOG_LOGIN) return 0;

    if(!response)
    {
        Kick(playerid);
        return 1;
    }

    switch(dialogid)
    {
        case DIALOG_REGISTER:
        {
            if(strlen(inputtext) < 4)
            {
                ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,
                    "DANG KY",
                    "Mat khau phai it nhat 4 ky tu.\nVui long nhap lai:",
                    "Dang ky",
                    "Thoat");
                return 1;
            }

            new callback[] = "Account_OnPasswordHashed";
            new callbackFormat[] = "i";
            bcrypt_hash(inputtext, 10, callback, callbackFormat, playerid);
        }

        case DIALOG_LOGIN:
        {
            new callback[] = "Account_OnPasswordChecked";
            new callbackFormat[] = "i";
            bcrypt_check(inputtext, PlayerData[playerid][pPassword], callback, callbackFormat, playerid);
        }
    }
    return 1;
}

forward Account_OnPasswordHashed(playerid);
public Account_OnPasswordHashed(playerid)
{
    new hash[BCRYPT_HASH_LENGTH];
    bcrypt_get_hash(hash);

    new query[512];
    mysql_format(g_SQL, query, sizeof(query),
        "INSERT INTO `users` (`username`, `password`, `money`, `skin`, `level`, `exp`, `spawn_x`, `spawn_y`, `spawn_z`, `spawn_a`, `job`) VALUES ('%e', '%e', %d, %d, %d, %d, %f, %f, %f, %f, %d)",
        PlayerData[playerid][pName],
        hash,
        PlayerData[playerid][pMoney],
        PlayerData[playerid][pSkin],
        PlayerData[playerid][pLevel],
        PlayerData[playerid][pExp],
        PlayerData[playerid][pSpawnX],
        PlayerData[playerid][pSpawnY],
        PlayerData[playerid][pSpawnZ],
        PlayerData[playerid][pSpawnA],
        PlayerData[playerid][pJob]);
    mysql_tquery(g_SQL, query, "Account_OnRegistered", "i", playerid);
    return 1;
}

forward Account_OnRegistered(playerid);
public Account_OnRegistered(playerid)
{
    PlayerData[playerid][pID] = cache_insert_id();
    Session_Login(playerid);
    PlayerData_ApplyAfterLogin(playerid);

    SendClientMessage(playerid, COLOR_GREEN, "Dang ky thanh cong. Chao mung ban den voi Van Canh City.");
    SpawnPlayer(playerid);
    return 1;
}

forward Account_OnPasswordChecked(playerid);
public Account_OnPasswordChecked(playerid)
{
    if(bcrypt_is_equal())
    {
        Session_Login(playerid);
        PlayerData_ApplyAfterLogin(playerid);

        SendClientMessage(playerid, COLOR_GREEN, "Dang nhap thanh cong.");
        SpawnPlayer(playerid);
    }
    else
    {
        SendClientMessage(playerid, COLOR_RED, "Mat khau sai.");
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
            "DANG NHAP",
            "Mat khau khong dung.\nVui long nhap lai:",
            "Dang nhap",
            "Thoat");
    }
    return 1;
}
