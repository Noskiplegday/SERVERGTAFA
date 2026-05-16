
// Core/Account.pwn
// Dang ky, dang nhap voi bcrypt hash va MySQL.

#define MIN_PASSWORD_LENGTH 6

forward bool:Account_IsValidUsername(const username[]);
forward bool:Account_IsValidEmail(const email[]);

stock Account_OnPlayerConnect(playerid)
{
    Session_Reset(playerid);
    PlayerData_SetDefaults(playerid);
    TogglePlayerSpectating(playerid, true);
    Account_ShowWelcome(playerid);
    return 1;
}

stock Account_ShowWelcome(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_ACCOUNT_WELCOME, DIALOG_STYLE_LIST,
        "{00BFFF}VAN CANH CITY",
        "Dang nhap\nDang ky",
        "Chon",
        "Thoat");
    return 1;
}

stock Account_ShowRegisterUsername(playerid, const error[] = "")
{
    new body[256];
    if(error[0])
        format(body, sizeof(body), "{FF0000}%s\n\n{FFFFFF}Nhap username muon dang ky:", error);
    else
        format(body, sizeof(body), "{FFFFFF}Nhap username muon dang ky:\n{AFAFAF}3-24 ky tu, khong bo trong.");

    ShowPlayerDialog(playerid, DIALOG_REGISTER_USERNAME, DIALOG_STYLE_INPUT,
        "{00BFFF}DANG KY - USERNAME",
        body,
        "Tiep",
        "Lui");
    return 1;
}

stock Account_ShowRegisterPassword(playerid, const error[] = "")
{
    new body[256];
    if(error[0])
        format(body, sizeof(body), "{FF0000}%s\n\n{FFFFFF}Nhap mat khau:", error);
    else
        format(body, sizeof(body), "{FFFFFF}Nhap mat khau:\n{AFAFAF}Toi thieu %d ky tu.", MIN_PASSWORD_LENGTH);

    ShowPlayerDialog(playerid, DIALOG_REGISTER_PASSWORD, DIALOG_STYLE_PASSWORD,
        "{00BFFF}DANG KY - MAT KHAU",
        body,
        "Tiep",
        "Lui");
    return 1;
}

stock Account_ShowRegisterVerify(playerid, const error[] = "")
{
    new body[256];
    if(error[0])
        format(body, sizeof(body), "{FF0000}%s\n\n{FFFFFF}Nhap lai mat khau:", error);
    else
        format(body, sizeof(body), "{FFFFFF}Nhap lai mat khau de xac nhan:");

    ShowPlayerDialog(playerid, DIALOG_REGISTER_VERIFY, DIALOG_STYLE_PASSWORD,
        "{00BFFF}DANG KY - XAC NHAN",
        body,
        "Tiep",
        "Lui");
    return 1;
}

stock Account_ShowRegisterEmail(playerid, const error[] = "")
{
    new body[256];
    if(error[0])
        format(body, sizeof(body), "{FF0000}%s\n\n{FFFFFF}Nhap email:", error);
    else
        format(body, sizeof(body), "{FFFFFF}Nhap email de ho tro quen mat khau sau nay:");

    ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT,
        "{00BFFF}DANG KY - EMAIL",
        body,
        "Dang ky",
        "Lui");
    return 1;
}

stock Account_ShowLoginUsername(playerid, const error[] = "")
{
    new body[256];
    if(error[0])
        format(body, sizeof(body), "{FF0000}%s\n\n{FFFFFF}Nhap username:", error);
    else
        format(body, sizeof(body), "{FFFFFF}Nhap username da dang ky:");

    ShowPlayerDialog(playerid, DIALOG_LOGIN_USERNAME, DIALOG_STYLE_INPUT,
        "{00BFFF}DANG NHAP - USERNAME",
        body,
        "Tiep",
        "Lui");
    return 1;
}

stock Account_ShowLoginPassword(playerid, const error[] = "")
{
    new body[256];
    if(error[0])
        format(body, sizeof(body), "{FF0000}%s\n\n{FFFFFF}Nhap mat khau:", error);
    else
        format(body, sizeof(body), "{FFFFFF}Nhap mat khau cua tai khoan {FFFF00}%s{FFFFFF}:", PlayerData[playerid][pLoginUsername]);

    ShowPlayerDialog(playerid, DIALOG_LOGIN_PASSWORD, DIALOG_STYLE_PASSWORD,
        "{00BFFF}DANG NHAP - MAT KHAU",
        body,
        "Dang nhap",
        "Lui");
    return 1;
}

stock Account_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_ACCOUNT_WELCOME)
    {
        if(!response)
        {
            SetTimerEx("Account_DelayKick", 500, false, "i", playerid);
            return 1;
        }

        switch(listitem)
        {
            case 0: Account_ShowLoginUsername(playerid);
            case 1: Account_ShowRegisterUsername(playerid);
        }
        return 1;
    }

    if(dialogid == DIALOG_REGISTER_USERNAME)
    {
        if(!response) { Account_ShowWelcome(playerid); return 1; }

        new username[MAX_PLAYER_NAME];
        Account_CopyCleanInput(username, sizeof(username), inputtext);
        if(!Account_IsValidUsername(username))
        {
            Account_ShowRegisterUsername(playerid, "Username phai tu 3 den 24 ky tu va khong chua khoang trang.");
            return 1;
        }

        strcat((PlayerData[playerid][pRegUsername][0] = EOS, PlayerData[playerid][pRegUsername]), username, MAX_PLAYER_NAME);

        new query[192];
        mysql_format(g_SQL, query, sizeof(query),
            "SELECT id FROM users WHERE LOWER(username)=LOWER('%e') LIMIT 1",
            PlayerData[playerid][pRegUsername]);
        mysql_tquery(g_SQL, query, "Account_OnRegisterUsernameChecked", "i", playerid);
        return 1;
    }

    if(dialogid == DIALOG_REGISTER_PASSWORD)
    {
        if(!response) { Account_ShowRegisterUsername(playerid); return 1; }
        if(strlen(inputtext) < MIN_PASSWORD_LENGTH)
        {
            Account_ShowRegisterPassword(playerid, "Mat khau qua ngan.");
            return 1;
        }

        strcat((PlayerData[playerid][pRegPassword][0] = EOS, PlayerData[playerid][pRegPassword]), inputtext, 65);
        Account_ShowRegisterVerify(playerid);
        return 1;
    }

    if(dialogid == DIALOG_REGISTER_VERIFY)
    {
        if(!response) { Account_ShowRegisterPassword(playerid); return 1; }
        if(strcmp(inputtext, PlayerData[playerid][pRegPassword], false))
        {
            Account_ShowRegisterVerify(playerid, "Mat khau xac nhan khong khop.");
            return 1;
        }

        Account_ShowRegisterEmail(playerid);
        return 1;
    }

    if(dialogid == DIALOG_REGISTER_EMAIL)
    {
        if(!response) { Account_ShowRegisterVerify(playerid); return 1; }

        new email[80];
        Account_CopyCleanInput(email, sizeof(email), inputtext);
        if(!Account_IsValidEmail(email))
        {
            Account_ShowRegisterEmail(playerid, "Email khong hop le.");
            return 1;
        }

        strcat((PlayerData[playerid][pRegEmail][0] = EOS, PlayerData[playerid][pRegEmail]), email, 80);

        new query[192];
        mysql_format(g_SQL, query, sizeof(query),
            "SELECT id FROM users WHERE LOWER(email)=LOWER('%e') LIMIT 1",
            PlayerData[playerid][pRegEmail]);
        mysql_tquery(g_SQL, query, "Account_OnRegisterEmailChecked", "i", playerid);
        return 1;
    }

    if(dialogid == DIALOG_LOGIN_USERNAME)
    {
        if(!response) { Account_ShowWelcome(playerid); return 1; }

        new username[MAX_PLAYER_NAME];
        Account_CopyCleanInput(username, sizeof(username), inputtext);
        if(!Account_IsValidUsername(username))
        {
            Account_ShowLoginUsername(playerid, "Username khong hop le.");
            return 1;
        }

        PlayerData[playerid][pID] = 0;
        PlayerData[playerid][pPassword][0] = EOS;
        strcat((PlayerData[playerid][pLoginUsername][0] = EOS, PlayerData[playerid][pLoginUsername]), username, MAX_PLAYER_NAME);

        new query[192];
        mysql_format(g_SQL, query, sizeof(query),
            "SELECT * FROM users WHERE LOWER(username)=LOWER('%e') LIMIT 1",
            PlayerData[playerid][pLoginUsername]);
        mysql_tquery(g_SQL, query, "Account_OnLoginUserLoaded", "i", playerid);
        return 1;
    }

    if(dialogid == DIALOG_LOGIN_PASSWORD)
    {
        if(!response) { Account_ShowLoginUsername(playerid); return 1; }
        if(PlayerData[playerid][pID] <= 0 || PlayerData[playerid][pPassword][0] == EOS)
        {
            Account_ShowLoginUsername(playerid, "Tai khoan chua duoc load. Thu lai.");
            return 1;
        }

        new callback[] = "Account_OnPasswordChecked";
        new bcrypt_fmt[] = "i";
        bcrypt_check(inputtext, PlayerData[playerid][pPassword], callback, bcrypt_fmt, playerid);
        return 1;
    }

    return 0;
}

forward Account_OnRegisterEmailChecked(playerid);
public Account_OnRegisterEmailChecked(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new rows;
    cache_get_row_count(rows);
    if(rows > 0)
    {
        Account_ShowRegisterEmail(playerid, "Email nay da duoc su dung.");
        return 1;
    }

    new callback[] = "Account_OnPasswordHashed";
    new bcrypt_fmt[] = "i";
    bcrypt_hash(PlayerData[playerid][pRegPassword], 12, callback, bcrypt_fmt, playerid);
    return 1;
}

forward Account_OnRegisterUsernameChecked(playerid);
public Account_OnRegisterUsernameChecked(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new rows;
    cache_get_row_count(rows);
    if(rows > 0)
    {
        Account_ShowRegisterUsername(playerid, "Username nay da ton tai.");
        return 1;
    }

    Account_ShowRegisterPassword(playerid);
    return 1;
}

forward Account_OnLoginUserLoaded(playerid);
public Account_OnLoginUserLoaded(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new rows;
    cache_get_row_count(rows);
    if(rows == 0)
    {
        PlayerData[playerid][pID] = 0;
        PlayerData[playerid][pPassword][0] = EOS;
        Account_ShowLoginUsername(playerid, "Tai khoan khong ton tai.");
        return 1;
    }

    new banned;
    cache_get_value_name_int(0, "banned", banned);
    if(banned)
    {
        SendClientMessage(playerid, COLOR_RED, "Tai khoan cua ban da bi cam. Lien he admin de giai quyet.");
        SetTimerEx("Account_DelayKick", 500, false, "i", playerid);
        return 1;
    }

    PlayerData_LoadFromCache(playerid);
    Account_ShowLoginPassword(playerid);
    return 1;
}

forward Account_OnPasswordHashed(playerid);
public Account_OnPasswordHashed(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new hash[BCRYPT_HASH_LENGTH];
    bcrypt_get_hash(hash);
    strcat((PlayerData[playerid][pPassword][0] = EOS, PlayerData[playerid][pPassword]), hash, 65);

    new query[1024];
    mysql_format(g_SQL, query, sizeof(query),
        "INSERT INTO users (username, password_hash, email, money, bank_money, skin, level, exp, job_id, admin_level, pos_x, pos_y, pos_z, angle, faction, faction_rank, warnings, hunger, thirst, jailed, jail_time, deaths, kills, phone, house, business, playtime) VALUES ('%e', '%e', '%e', %d, %d, %d, %d, %d, %d, %d, %f, %f, %f, %f, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d)",
        PlayerData[playerid][pRegUsername],
        PlayerData[playerid][pPassword],
        PlayerData[playerid][pRegEmail],
        PlayerData[playerid][pMoney],
        PlayerData[playerid][pBankMoney],
        PlayerData[playerid][pSkin],
        PlayerData[playerid][pLevel],
        PlayerData[playerid][pExp],
        PlayerData[playerid][pJob],
        PlayerData[playerid][pAdminLevel],
        PlayerData[playerid][pSpawnX],
        PlayerData[playerid][pSpawnY],
        PlayerData[playerid][pSpawnZ],
        PlayerData[playerid][pSpawnA],
        PlayerData[playerid][pFaction],
        PlayerData[playerid][pFactionRank],
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
        PlayerData[playerid][pPlaytime]);
    mysql_tquery(g_SQL, query, "Account_OnRegisterSaved", "i", playerid);
    return 1;
}

forward Account_OnRegisterSaved(playerid);
public Account_OnRegisterSaved(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new affected = cache_affected_rows();
    new insert_id = cache_insert_id();
    if(affected <= 0 || insert_id <= 0)
    {
        PlayerData[playerid][pPassword][0] = EOS;
        SendClientMessage(playerid, COLOR_RED, "Dang ky that bai do database. Hay thu lai.");
        Account_ShowWelcome(playerid);
        return 1;
    }

    PlayerData[playerid][pID] = insert_id;
    strcat((PlayerData[playerid][pName][0] = EOS, PlayerData[playerid][pName]), PlayerData[playerid][pRegUsername], MAX_PLAYER_NAME);
    strcat((PlayerData[playerid][pEmail][0] = EOS, PlayerData[playerid][pEmail]), PlayerData[playerid][pRegEmail], 80);

    Account_MarkLogin(playerid);
    Session_Login(playerid);
    PlayerData_ApplyAfterLogin(playerid);
    TogglePlayerSpectating(playerid, false);

    SendClientMessage(playerid, COLOR_GREEN, "Dang ky thanh cong! Chao mung ban den Van Canh City.");
    SendClientMessage(playerid, COLOR_YELLOW, "Ban nhan duoc $5,000 khoi dau. Dung /help de xem huong dan.");
    SpawnPlayer(playerid);
    ServerLog_PlayerAction(playerid, "register/login");
    return 1;
}

forward Account_OnPasswordChecked(playerid);
public Account_OnPasswordChecked(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    if(bcrypt_is_equal())
    {
        Account_MarkLogin(playerid);
        Session_Login(playerid);
        PlayerData_ApplyAfterLogin(playerid);
        TogglePlayerSpectating(playerid, false);

        SendClientMessage(playerid, COLOR_GREEN, "Dang nhap thanh cong!");
        SpawnPlayer(playerid);
        ServerLog_PlayerAction(playerid, "login");
    }
    else
    {
        PlayerData[playerid][pLoginAttempts]++;
        if(PlayerData[playerid][pLoginAttempts] >= 3)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban da nhap sai mat khau 3 lan. Da bi kick.");
            SetTimerEx("Account_DelayKick", 500, false, "i", playerid);
            return 1;
        }

        new msg[80];
        format(msg, sizeof(msg), "Mat khau sai. Con %d lan thu.", 3 - PlayerData[playerid][pLoginAttempts]);
        Account_ShowLoginPassword(playerid, msg);
    }
    return 1;
}

stock Account_MarkLogin(playerid)
{
    if(PlayerData[playerid][pID] <= 0) return 0;

    new query[128];
    mysql_format(g_SQL, query, sizeof(query),
        "UPDATE users SET last_login_at=NOW() WHERE id=%d",
        PlayerData[playerid][pID]);
    mysql_tquery(g_SQL, query);
    return 1;
}

stock bool:Account_IsValidUsername(const username[])
{
    new len = strlen(username);
    if(len < 3 || len >= MAX_PLAYER_NAME) return false;

    for(new i = 0; i < len; i++)
    {
        if(username[i] <= ' ') return false;
    }
    return true;
}

stock Account_CopyCleanInput(dest[], maxlen, const input[])
{
    new start = 0;
    new end = strlen(input);

    while(start < end && input[start] <= ' ') start++;
    while(end > start && input[end - 1] <= ' ') end--;

    new len = end - start;
    if(len >= maxlen) len = maxlen - 1;

    strmid(dest, input, start, start + len, maxlen);
    dest[len] = EOS;
    return 1;
}

stock bool:Account_IsValidEmail(const email[])
{
    new len = strlen(email);
    if(len < 5 || len >= 80) return false;

    new bool:has_at = false, bool:has_dot = false;
    for(new i = 0; i < len; i++)
    {
        if(email[i] == '@') has_at = true;
        if(has_at && email[i] == '.') has_dot = true;
        if(email[i] <= ' ') return false;
    }
    return has_at && has_dot;
}

forward Account_DelayKick(playerid);
public Account_DelayKick(playerid)
{
    if(IsPlayerConnected(playerid)) Kick(playerid);
    return 1;
}

stock Account_AddBan(const name[])
{
    new query[160];
    mysql_format(g_SQL, query, sizeof(query),
        "UPDATE users SET banned=1 WHERE username='%e'",
        name);
    mysql_tquery(g_SQL, query);
    return 1;
}

stock Account_RemoveBan(const name[])
{
    new query[160];
    mysql_format(g_SQL, query, sizeof(query),
        "UPDATE users SET banned=0 WHERE username='%e'",
        name);
    mysql_tquery(g_SQL, query);
    return 1;
}

