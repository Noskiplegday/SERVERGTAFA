// Core/Account.pwn
// Dang ky, dang nhap runtime trong luc cho PostgreSQL bridge.

#define MIN_PASSWORD_LENGTH 6
#define MAX_RUNTIME_ACCOUNTS 500

new RuntimeAccountCount = 0;
new RuntimeAccountName[MAX_RUNTIME_ACCOUNTS][MAX_PLAYER_NAME];
new RuntimeAccountPassword[MAX_RUNTIME_ACCOUNTS][65];
new RuntimeAccountEmail[MAX_RUNTIME_ACCOUNTS][80];
new RuntimeAccountCCCD[MAX_RUNTIME_ACCOUNTS][16];
new RuntimeAccountRole[MAX_RUNTIME_ACCOUNTS][16];
new RuntimeAccountMission[MAX_RUNTIME_ACCOUNTS][32];
new RuntimeAccountFamilyCCCD[MAX_RUNTIME_ACCOUNTS][16];
new RuntimeAccountFamilyRelation[MAX_RUNTIME_ACCOUNTS][32];
new RuntimeAccountAdminLevel[MAX_RUNTIME_ACCOUNTS];
new Float:RuntimeAccountSpawnX[MAX_RUNTIME_ACCOUNTS];
new Float:RuntimeAccountSpawnY[MAX_RUNTIME_ACCOUNTS];
new Float:RuntimeAccountSpawnZ[MAX_RUNTIME_ACCOUNTS];
new Float:RuntimeAccountSpawnA[MAX_RUNTIME_ACCOUNTS];

forward bool:Account_IsValidUsername(const username[]);
forward bool:Account_IsValidEmail(const email[]);
forward bool:Account_IsValidCCCD(const cccd[]);

stock Account_Init()
{
    Account_AddRuntimeAccount(
        "admin",
        "$2a$06$3COrRVXxiyW/kXBxNvUABOHNXZ2cYYqPJYdunG/PowW0H7qyuee0m",
        "admin@vancanhcity.local",
        "000000000001",
        "admin",
        "admin",
        "",
        "",
        10);
    return 1;
}

stock Account_OnPlayerConnect(playerid)
{
    Session_Reset(playerid);
    PlayerData_SetDefaults(playerid);
    Account_ShowLoginScreen(playerid);
    SetTimerEx("Account_DelayWelcome", 500, false, "i", playerid);
    return 1;
}

stock Account_ShowLoginScreen(playerid)
{
    TogglePlayerSpectating(playerid, true);
    SetPlayerCameraPos(playerid, LOGIN_CAMERA_X, LOGIN_CAMERA_Y, LOGIN_CAMERA_Z);
    SetPlayerCameraLookAt(playerid, LOGIN_LOOK_X, LOGIN_LOOK_Y, LOGIN_LOOK_Z);
    return 1;
}

stock Account_ShowWelcome(playerid)
{
    Account_ShowLoginScreen(playerid);
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
        "{00BFFF}DANG KY - USERNAME", body, "Tiep", "Lui");
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
        "{00BFFF}DANG KY - MAT KHAU", body, "Tiep", "Lui");
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
        "{00BFFF}DANG KY - XAC NHAN", body, "Tiep", "Lui");
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
        "{00BFFF}DANG KY - EMAIL", body, "Tiep", "Lui");
    return 1;
}

stock Account_ShowRegisterFamilyCCCD(playerid, const error[] = "")
{
    new body[320];
    if(error[0])
        format(body, sizeof(body), "{FF0000}%s\n\n{FFFFFF}Nhap CCCD nguoi than da co trong database.\n{AFAFAF}De trong hoac bam Bo qua neu chua co gia dinh.", error);
    else
        format(body, sizeof(body), "{FFFFFF}Nhap CCCD nguoi than da co trong database.\n{AFAFAF}De trong hoac bam Bo qua neu chua co gia dinh.");

    ShowPlayerDialog(playerid, DIALOG_REGISTER_FAMILY_CCCD, DIALOG_STYLE_INPUT,
        "{00BFFF}DANG KY - GIA DINH", body, "Tiep", "Bo qua");
    return 1;
}

stock Account_ShowRegisterFamilyRelation(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_REGISTER_FAMILY_RELATION, DIALOG_STYLE_LIST,
        "{00BFFF}DANG KY - QUAN HE",
        "Cha\nMe\nAnh trai\nEm trai\nChi gai\nEm gai\nCo\nDi\nChu\nBac",
        "Chon",
        "Bo qua");
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
        "{00BFFF}DANG NHAP - USERNAME", body, "Tiep", "Lui");
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
        "{00BFFF}DANG NHAP - MAT KHAU", body, "Dang nhap", "Lui");
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
        if(Account_FindRuntimeByUsername(username) != -1)
        {
            Account_ShowRegisterUsername(playerid, "Username nay da ton tai.");
            return 1;
        }

        strcat((PlayerData[playerid][pRegUsername][0] = EOS, PlayerData[playerid][pRegUsername]), username, MAX_PLAYER_NAME);
        Account_ShowRegisterPassword(playerid);
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
        if(Account_FindRuntimeByEmail(email) != -1)
        {
            Account_ShowRegisterEmail(playerid, "Email nay da duoc su dung.");
            return 1;
        }

        strcat((PlayerData[playerid][pRegEmail][0] = EOS, PlayerData[playerid][pRegEmail]), email, 80);
        Account_ShowRegisterFamilyCCCD(playerid);
        return 1;
    }

    if(dialogid == DIALOG_REGISTER_FAMILY_CCCD)
    {
        if(!response || !inputtext[0])
        {
            PlayerData[playerid][pRegFamilyCCCD][0] = EOS;
            PlayerData[playerid][pRegFamilyRelation][0] = EOS;
            Account_StartPasswordHash(playerid);
            return 1;
        }

        new cccd[16];
        Account_CopyCleanInput(cccd, sizeof(cccd), inputtext);
        if(!Account_IsValidCCCD(cccd))
        {
            Account_ShowRegisterFamilyCCCD(playerid, "CCCD phai gom dung 12 chu so.");
            return 1;
        }

        strcat((PlayerData[playerid][pRegFamilyCCCD][0] = EOS, PlayerData[playerid][pRegFamilyCCCD]), cccd, 16);
        Account_ShowRegisterFamilyRelation(playerid);
        return 1;
    }

    if(dialogid == DIALOG_REGISTER_FAMILY_RELATION)
    {
        if(!response)
        {
            PlayerData[playerid][pRegFamilyCCCD][0] = EOS;
            PlayerData[playerid][pRegFamilyRelation][0] = EOS;
        }
        else
        {
            Account_GetRelationName(listitem, PlayerData[playerid][pRegFamilyRelation], 32);
        }
        Account_StartPasswordHash(playerid);
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

        new account_idx = Account_FindRuntimeByUsername(username);
        if(account_idx == -1)
        {
            Account_ShowLoginUsername(playerid, "Tai khoan chua co trong runtime. Can PostgreSQL bridge de query Supabase.");
            return 1;
        }

        Account_LoadRuntimeToPlayer(playerid, account_idx);
        Account_ShowLoginPassword(playerid);
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

    if(dialogid == DIALOG_LOGIN_SPAWN)
    {
        if(!Session_IsLoggedIn(playerid)) return 1;

        if(response && listitem == 0)
        {
            PlayerData[playerid][pSpawnX] = DEFAULT_SPAWN_X;
            PlayerData[playerid][pSpawnY] = DEFAULT_SPAWN_Y;
            PlayerData[playerid][pSpawnZ] = DEFAULT_SPAWN_Z;
            PlayerData[playerid][pSpawnA] = DEFAULT_SPAWN_A;
        }

        TogglePlayerSpectating(playerid, false);
        PlayerData_ApplyAfterLogin(playerid);
        SpawnPlayer(playerid);
        return 1;
    }

    return 0;
}

stock Account_StartPasswordHash(playerid)
{
    new callback[] = "Account_OnPasswordHashed";
    new bcrypt_fmt[] = "i";
    bcrypt_hash(PlayerData[playerid][pRegPassword], 12, callback, bcrypt_fmt, playerid);
    return 1;
}

forward Account_OnPasswordHashed(playerid);
public Account_OnPasswordHashed(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new hash[BCRYPT_HASH_LENGTH];
    bcrypt_get_hash(hash);
    strcat((PlayerData[playerid][pPassword][0] = EOS, PlayerData[playerid][pPassword]), hash, 65);

    if(RuntimeAccountCount >= MAX_RUNTIME_ACCOUNTS)
    {
        PlayerData[playerid][pPassword][0] = EOS;
        SendClientMessage(playerid, COLOR_RED, "Dang ky that bai do database. Hay thu lai.");
        Account_ShowWelcome(playerid);
        return 1;
    }

    Account_GenerateCCCD(PlayerData[playerid][pCCCD], 16);
    new account_idx = RuntimeAccountCount++;
    Account_CopyRuntimeData(account_idx, PlayerData[playerid][pRegUsername], PlayerData[playerid][pPassword],
        PlayerData[playerid][pRegEmail], PlayerData[playerid][pCCCD], "member", "none",
        PlayerData[playerid][pRegFamilyCCCD], PlayerData[playerid][pRegFamilyRelation], 0);

    Account_LoadRuntimeToPlayer(playerid, account_idx);
    Account_MarkLogin(playerid);
    Session_Login(playerid);

    new msg[128];
    format(msg, sizeof(msg), "Dang ky thanh cong. CCCD cua ban: %s", PlayerData[playerid][pCCCD]);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    Account_ShowSpawnSelect(playerid);
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
        Account_ShowSpawnSelect(playerid);
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

stock Account_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/logout", true))
    {
        Account_SaveRuntime(playerid);
        PlayerData_Save(playerid);
        Session_Cleanup(playerid);
        PlayerData_SetDefaults(playerid);
        Account_ShowLoginScreen(playerid);
        SetTimerEx("Account_DelayWelcome", 300, false, "i", playerid);
        return 1;
    }

    if(!strcmp(cmdtext, "/me", true))
    {
        Account_ShowCharacterInfo(playerid);
        return 1;
    }
    return 0;
}

stock Account_MarkLogin(playerid)
{
    if(PlayerData[playerid][pID] <= 0) return 0;
    return 1;
}

stock Account_LoadRuntimeToPlayer(playerid, account_idx)
{
    PlayerData_SetDefaults(playerid);
    PlayerData[playerid][pID] = account_idx + 1;
    strcat((PlayerData[playerid][pName][0] = EOS, PlayerData[playerid][pName]), RuntimeAccountName[account_idx], MAX_PLAYER_NAME);
    strcat((PlayerData[playerid][pPassword][0] = EOS, PlayerData[playerid][pPassword]), RuntimeAccountPassword[account_idx], 65);
    strcat((PlayerData[playerid][pEmail][0] = EOS, PlayerData[playerid][pEmail]), RuntimeAccountEmail[account_idx], 80);
    strcat((PlayerData[playerid][pCCCD][0] = EOS, PlayerData[playerid][pCCCD]), RuntimeAccountCCCD[account_idx], 16);
    strcat((PlayerData[playerid][pRole][0] = EOS, PlayerData[playerid][pRole]), RuntimeAccountRole[account_idx], 16);
    strcat((PlayerData[playerid][pMission][0] = EOS, PlayerData[playerid][pMission]), RuntimeAccountMission[account_idx], 32);
    strcat((PlayerData[playerid][pFamilyCCCD][0] = EOS, PlayerData[playerid][pFamilyCCCD]), RuntimeAccountFamilyCCCD[account_idx], 16);
    strcat((PlayerData[playerid][pFamilyRelation][0] = EOS, PlayerData[playerid][pFamilyRelation]), RuntimeAccountFamilyRelation[account_idx], 32);
    PlayerData[playerid][pAdminLevel] = RuntimeAccountAdminLevel[account_idx];
    if(PlayerData[playerid][pAdminLevel] > 0)
        PlayerData[playerid][pMoney] = 5000000;

    if(RuntimeAccountSpawnZ[account_idx] != 0.0)
    {
        PlayerData[playerid][pSpawnX] = RuntimeAccountSpawnX[account_idx];
        PlayerData[playerid][pSpawnY] = RuntimeAccountSpawnY[account_idx];
        PlayerData[playerid][pSpawnZ] = RuntimeAccountSpawnZ[account_idx];
        PlayerData[playerid][pSpawnA] = RuntimeAccountSpawnA[account_idx];
    }
    return 1;
}

stock Account_AddRuntimeAccount(const username[], const password_hash[], const email[], const cccd[], const role[], const mission[], const family_cccd[], const family_relation[], admin_level)
{
    if(Account_FindRuntimeByUsername(username) != -1 || RuntimeAccountCount >= MAX_RUNTIME_ACCOUNTS) return 0;

    new account_idx = RuntimeAccountCount++;
    Account_CopyRuntimeData(account_idx, username, password_hash, email, cccd, role, mission, family_cccd, family_relation, admin_level);
    return 1;
}

stock Account_CopyRuntimeData(account_idx, const username[], const password_hash[], const email[], const cccd[], const role[], const mission[], const family_cccd[], const family_relation[], admin_level)
{
    strcat((RuntimeAccountName[account_idx][0] = EOS, RuntimeAccountName[account_idx]), username, MAX_PLAYER_NAME);
    strcat((RuntimeAccountPassword[account_idx][0] = EOS, RuntimeAccountPassword[account_idx]), password_hash, 65);
    strcat((RuntimeAccountEmail[account_idx][0] = EOS, RuntimeAccountEmail[account_idx]), email, 80);
    strcat((RuntimeAccountCCCD[account_idx][0] = EOS, RuntimeAccountCCCD[account_idx]), cccd, 16);
    strcat((RuntimeAccountRole[account_idx][0] = EOS, RuntimeAccountRole[account_idx]), role, 16);
    strcat((RuntimeAccountMission[account_idx][0] = EOS, RuntimeAccountMission[account_idx]), mission, 32);
    strcat((RuntimeAccountFamilyCCCD[account_idx][0] = EOS, RuntimeAccountFamilyCCCD[account_idx]), family_cccd, 16);
    strcat((RuntimeAccountFamilyRelation[account_idx][0] = EOS, RuntimeAccountFamilyRelation[account_idx]), family_relation, 32);
    RuntimeAccountAdminLevel[account_idx] = admin_level;
    RuntimeAccountSpawnX[account_idx] = DEFAULT_SPAWN_X;
    RuntimeAccountSpawnY[account_idx] = DEFAULT_SPAWN_Y;
    RuntimeAccountSpawnZ[account_idx] = DEFAULT_SPAWN_Z;
    RuntimeAccountSpawnA[account_idx] = DEFAULT_SPAWN_A;
    return 1;
}

stock Account_SaveRuntime(playerid)
{
    if(!Session_IsLoggedIn(playerid) || PlayerData[playerid][pID] <= 0) return 0;

    new account_idx = PlayerData[playerid][pID] - 1;
    if(account_idx < 0 || account_idx >= RuntimeAccountCount) return 0;

    GetPlayerPos(playerid, RuntimeAccountSpawnX[account_idx], RuntimeAccountSpawnY[account_idx], RuntimeAccountSpawnZ[account_idx]);
    GetPlayerFacingAngle(playerid, RuntimeAccountSpawnA[account_idx]);
    return 1;
}

stock Account_FindRuntimeByUsername(const username[])
{
    for(new i = 0; i < RuntimeAccountCount; i++)
    {
        if(!strcmp(RuntimeAccountName[i], username, true)) return i;
    }
    return -1;
}

stock Account_FindRuntimeByEmail(const email[])
{
    for(new i = 0; i < RuntimeAccountCount; i++)
    {
        if(!strcmp(RuntimeAccountEmail[i], email, true)) return i;
    }
    return -1;
}

stock Account_GenerateCCCD(dest[], maxlen)
{
    new value = 100000 + RuntimeAccountCount + random(899999);
    format(dest, maxlen, "079%09d", value);
    return 1;
}

stock bool:Account_IsValidCCCD(const cccd[])
{
    if(strlen(cccd) != 12) return false;
    for(new i = 0; i < 12; i++)
    {
        if(cccd[i] < '0' || cccd[i] > '9') return false;
    }
    return true;
}

stock Account_GetRelationName(listitem, dest[], maxlen)
{
    switch(listitem)
    {
        case 0: format(dest, maxlen, "Cha");
        case 1: format(dest, maxlen, "Me");
        case 2: format(dest, maxlen, "Anh trai");
        case 3: format(dest, maxlen, "Em trai");
        case 4: format(dest, maxlen, "Chi gai");
        case 5: format(dest, maxlen, "Em gai");
        case 6: format(dest, maxlen, "Co");
        case 7: format(dest, maxlen, "Di");
        case 8: format(dest, maxlen, "Chu");
        case 9: format(dest, maxlen, "Bac");
        default: format(dest, maxlen, "Khac");
    }
    return 1;
}

stock Account_ShowSpawnSelect(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_LOGIN_SPAWN, DIALOG_STYLE_LIST,
        "{00BFFF}CHON NOI XUAT HIEN",
        "Mac dinh: Cong vien City Hall\nTiep tuc: Vi tri lan truoc",
        "Spawn",
        "");
    return 1;
}

stock Account_ShowCharacterInfo(playerid)
{
    new job_name[32], body[768], family_cccd[16], family_relation[32];
    HUD_GetJobName(PlayerData[playerid][pJob], job_name, sizeof(job_name));

    if(PlayerData[playerid][pFamilyCCCD][0])
        format(family_cccd, sizeof(family_cccd), "%s", PlayerData[playerid][pFamilyCCCD]);
    else
        format(family_cccd, sizeof(family_cccd), "Chua co");

    if(PlayerData[playerid][pFamilyRelation][0])
        format(family_relation, sizeof(family_relation), "%s", PlayerData[playerid][pFamilyRelation]);
    else
        format(family_relation, sizeof(family_relation), "Chua co");

    format(body, sizeof(body),
        "Ten: %s\nCCCD: %s\nEmail: %s\nRole: %s\nAdmin: %d\nLevel: %d\nEXP: %d\nTien mat: $%d\nNgan hang: $%d\nMission: %s\nJob: %s\nFaction: %d | Rank: %d\nGia dinh CCCD: %s\nQuan he: %s\nKills/Deaths: %d/%d\nPlaytime: %d",
        PlayerData[playerid][pName],
        PlayerData[playerid][pCCCD],
        PlayerData[playerid][pEmail],
        PlayerData[playerid][pRole],
        PlayerData[playerid][pAdminLevel],
        PlayerData[playerid][pLevel],
        PlayerData[playerid][pExp],
        PlayerData[playerid][pMoney],
        PlayerData[playerid][pBankMoney],
        PlayerData[playerid][pMission],
        job_name,
        PlayerData[playerid][pFaction],
        PlayerData[playerid][pFactionRank],
        family_cccd,
        family_relation,
        PlayerData[playerid][pKills],
        PlayerData[playerid][pDeaths],
        PlayerData[playerid][pPlaytime]);
    ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "{00BFFF}THONG TIN CA NHAN", body, "Dong", "");
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

stock Account_AddBan(const name[])
{
    #pragma unused name
    return 1;
}

stock Account_RemoveBan(const name[])
{
    #pragma unused name
    return 1;
}

forward Account_DelayKick(playerid);
public Account_DelayKick(playerid)
{
    if(IsPlayerConnected(playerid)) Kick(playerid);
    return 1;
}

forward Account_DelayWelcome(playerid);
public Account_DelayWelcome(playerid)
{
    if(!IsPlayerConnected(playerid) || Session_IsLoggedIn(playerid)) return 1;
    Account_ShowWelcome(playerid);
    return 1;
}
