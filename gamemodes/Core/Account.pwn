// Core/Account.pwn
// Dang ky, dang nhap voi bcrypt hash va JSON file.

stock Account_OnPlayerConnect(playerid)
{
    Session_Reset(playerid);
    PlayerData_SetDefaults(playerid);
    GetPlayerName(playerid, PlayerData[playerid][pName], MAX_PLAYER_NAME);

    if(Account_IsBanned(PlayerData[playerid][pName]))
    {
        SendClientMessage(playerid, COLOR_RED, "Tai khoan cua ban da bi cam. Lien he admin de giai quyet.");
        SetTimerEx("Account_DelayKick", 500, false, "i", playerid);
        return 1;
    }

    if(PlayerData_FileExists(playerid))
    {
        PlayerData_Load(playerid);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
            "{00BFFF}VAN CANH CITY - DANG NHAP",
            "{FFFFFF}Chao mung ban quay lai!\n\nVui long nhap mat khau cua ban:",
            "Dang nhap",
            "Thoat");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,
            "{00BFFF}VAN CANH CITY - DANG KY",
            "{FFFFFF}Tai khoan chua ton tai.\n\nNhap mat khau de tao tai khoan moi\n(it nhat 4 ky tu):",
            "Dang ky",
            "Thoat");
    }
    return 1;
}

stock Account_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused listitem

    if(dialogid == DIALOG_REGISTER)
    {
        if(!response)
        {
            SetTimerEx("Account_DelayKick", 500, false, "i", playerid);
            return 1;
        }

        if(strlen(inputtext) < 4)
        {
            ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,
                "{00BFFF}VAN CANH CITY - DANG KY",
                "{FF0000}Mat khau phai it nhat 4 ky tu!\n\n{FFFFFF}Nhap mat khau de tao tai khoan moi:",
                "Dang ky",
                "Thoat");
            return 1;
        }

        bcrypt_hash(playerid, "Account_OnPasswordHashed", inputtext, BCRYPT_COST);
        return 1;
    }

    if(dialogid == DIALOG_LOGIN)
    {
        if(!response)
        {
            SetTimerEx("Account_DelayKick", 500, false, "i", playerid);
            return 1;
        }

        bcrypt_verify(playerid, "Account_OnPasswordChecked", inputtext, PlayerData[playerid][pPassword]);
        return 1;
    }

    return 0;
}

forward Account_OnPasswordHashed(playerid, bool:success);
public Account_OnPasswordHashed(playerid, bool:success)
{
    if(!success || !IsPlayerConnected(playerid)) return 1;

    new hash[BCRYPT_HASH_LENGTH];
    bcrypt_get_hash(hash);

    strcat((PlayerData[playerid][pPassword][0] = EOS, PlayerData[playerid][pPassword]), hash, 65);
    PlayerData[playerid][pID] = 1;

    PlayerData_Save(playerid);
    Session_Login(playerid);
    PlayerData_ApplyAfterLogin(playerid);

    SendClientMessage(playerid, COLOR_GREEN, "Dang ky thanh cong! Chao mung ban den Van Canh City.");
    SendClientMessage(playerid, COLOR_YELLOW, "Ban nhan duoc $5,000 khoi dau. Dung /help de xem huong dan.");
    SpawnPlayer(playerid);

    new msg[128];
    format(msg, sizeof(msg), "[Server] %s da tham gia server lan dau tien!", PlayerData[playerid][pName]);
    SendClientMessageToAll(COLOR_ANNOUNCE, msg);
    return 1;
}

forward Account_OnPasswordChecked(playerid, bool:success);
public Account_OnPasswordChecked(playerid, bool:success)
{
    if(!IsPlayerConnected(playerid)) return 1;

    if(success)
    {
        PlayerData[playerid][pID] = 1;
        Session_Login(playerid);
        PlayerData_ApplyAfterLogin(playerid);

        SendClientMessage(playerid, COLOR_GREEN, "Dang nhap thanh cong!");
        SpawnPlayer(playerid);

        new msg[128];
        format(msg, sizeof(msg), "[Server] %s da ket noi vao server.", PlayerData[playerid][pName]);
        SendClientMessageToAll(COLOR_GREY, msg);
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

        new msg[128];
        format(msg, sizeof(msg), "{FF0000}Mat khau sai! Ban con %d lan thu.\n\n{FFFFFF}Vui long nhap lai:",
            3 - PlayerData[playerid][pLoginAttempts]);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
            "{00BFFF}VAN CANH CITY - DANG NHAP",
            msg,
            "Dang nhap",
            "Thoat");
    }
    return 1;
}

forward Account_DelayKick(playerid);
public Account_DelayKick(playerid)
{
    if(IsPlayerConnected(playerid)) Kick(playerid);
    return 1;
}

stock bool:Account_IsBanned(const name[])
{
    if(!fexist("bans.json")) return false;

    new File:f = fopen("bans.json", io_read);
    if(!f) return false;

    new line[128];
    while(fread(f, line))
    {
        new len = strlen(line);
        while(len > 0 && (line[len-1] == '\n' || line[len-1] == '\r'))
        {
            line[len-1] = EOS;
            len--;
        }
        if(!strcmp(line, name, true))
        {
            fclose(f);
            return true;
        }
    }
    fclose(f);
    return false;
}

stock Account_AddBan(const name[])
{
    new File:f = fopen("bans.json", io_append);
    if(!f) return 0;

    new line[64];
    format(line, sizeof(line), "%s\n", name);
    fwrite(f, line);
    fclose(f);
    return 1;
}

stock Account_RemoveBan(const name[])
{
    if(!fexist("bans.json")) return 0;

    new File:f = fopen("bans.json", io_read);
    if(!f) return 0;

    new File:tmp = fopen("bans_tmp.json", io_write);
    if(!tmp) { fclose(f); return 0; }

    new line[128], found = 0;
    while(fread(f, line))
    {
        new clean[128];
        strmid(clean, line, 0, strlen(line), sizeof(clean));
        new len = strlen(clean);
        while(len > 0 && (clean[len-1] == '\n' || clean[len-1] == '\r'))
        {
            clean[len-1] = EOS;
            len--;
        }
        if(!strcmp(clean, name, true))
        {
            found = 1;
            continue;
        }
        fwrite(tmp, line);
    }
    fclose(f);
    fclose(tmp);

    fremove("bans.json");

    if(fexist("bans_tmp.json"))
    {
        new File:src = fopen("bans_tmp.json", io_read);
        new File:dst = fopen("bans.json", io_write);
        if(src && dst)
        {
            new buf[256];
            while(fread(src, buf)) fwrite(dst, buf);
        }
        if(src) fclose(src);
        if(dst) fclose(dst);
        fremove("bans_tmp.json");
    }

    return found;
}
