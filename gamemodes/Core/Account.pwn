#include <a_mysql>
#include <bcrypt>

// Bi?n l?u tr? k?t n?i MySQL
new MySQL:g_SQL;

// Callback khi k?t n?i Database (g?i ? OnGameModeInit file ch?nh)
forward ConnectToDatabase();
public ConnectToDatabase() {
    g_SQL = mysql_connect("127.0.0.1", "root", "", "gta_server"); // Thay "gta_server" b?ng t?n DB c?a b?n
    if(mysql_errno(g_SQL) != 0) print("L?I: Kh?ng th? k?t n?i Database!");
    else print("TH?NH C?NG: ?? k?t n?i Database.");
}

// H?m l?u d? li?u ng??i ch?i
forward SaveAccount(playerid);
public SaveAccount(playerid) {
    if(!Player[playerid][pLoggedIn]) return 1;

    new query[256];
    mysql_format(g_SQL, query, sizeof(query), 
        "UPDATE `players` SET `money` = %d, `level` = %d WHERE `id` = %d",
        Player[playerid][pMoney], Player[playerid][pLevel], Player[playerid][pID]);
    mysql_tquery(g_SQL, query);
    return 1;
}

// --- X? L? ??NG K? (BCRYPT HASH) ---
forward OnPlayerRegister(playerid, password[]);
public OnPlayerRegister(playerid, password[]) {
    new hash[BCRYPT_HASH_LENGTH], query[256];
    bcrypt_get_hash(hash); // L?y m? hash v?a t?o
    
    mysql_format(g_SQL, query, sizeof(query), 
        "INSERT INTO `players` (`username`, `password`) VALUES ('%e', '%s')", 
        Player[playerid][pTempName], hash);
    mysql_tquery(g_SQL, query, "OnAccountCreated", "i", playerid);
    return 1;
}

forward OnAccountCreated(playerid);
public OnAccountCreated(playerid) {
    Player[playerid][pID] = cache_insert_id();
    SendClientMessage(playerid, 0x00FF00FF, "??ng k? th?nh c?ng! Ch?o m?ng b?n.");
    Player[playerid][pLoggedIn] = true;
    SpawnPlayer(playerid);
    return 1;
}

// --- X? L? ??NG NH?P (BCRYPT VERIFY) ---
forward OnLoginVerify(playerid, bool:success);
public OnLoginVerify(playerid, bool:success) {
    if(success) {
        new query[128];
        mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `players` WHERE `username` = '%e' LIMIT 1", Player[playerid][pTempName]);
        mysql_tquery(g_SQL, query, "LoadAccountData", "i", playerid);
    } else {
        SendClientMessage(playerid, 0xFF0000FF, "Sai m?t kh?u! Vui l?ng nh?p l?i.");
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "??NG NH?P", "Vui l?ng nh?p l?i m?t kh?u:", "Ti?p", "Tho?t");
    }
    return 1;
}

forward LoadAccountData(playerid);
public LoadAccountData(playerid) {
    cache_get_value_name_int(0, "id", Player[playerid][pID]);
    cache_get_value_name_int(0, "money", Player[playerid][pMoney]);
    cache_get_value_name_int(0, "level", Player[playerid][pLevel]);
    
    Player[playerid][pLoggedIn] = true;
    GivePlayerMoney(playerid, Player[playerid][pMoney]);
    SetPlayerScore(playerid, Player[playerid][pLevel]);
    
    TogglePlayerSpectating(playerid, false); 
    SendClientMessage(playerid, 0x00FF00FF, "??ng nh?p th?nh c?ng. D? li?u ?? ???c t?i!");
    SpawnPlayer(playerid);
    return 1;
}
// Khi ng??i ch?i b?m "??ng k?" trong Dialog
forward OnPlayerRegister(playerid, password[]);
public OnPlayerRegister(playerid, password[]) {
    new hash[BCRYPT_HASH_LENGTH], query[512];
    bcrypt_get_hash(hash); // L?y m?t kh?u ?? m? h?a t? l?nh bcrypt_hash ph?a tr?n

    // G?i l?nh SQL INSERT ?? t?o d?ng m?i trong b?ng players
    mysql_format(g_SQL, query, sizeof(query), 
        "INSERT INTO `players` (`username`, `password`, `money`, `level`) VALUES ('%e', '%s', 5000, 1)", 
        Player[playerid][pTempName], hash);
    
    mysql_tquery(g_SQL, query, "OnAccountRegistered", "i", playerid);
    return 1;
}

forward OnAccountRegistered(playerid);
public OnAccountRegistered(playerid) {
    Player[playerid][pID] = cache_insert_id(); // L?y ID t? ??ng t? SQL
    Player[playerid][pLoggedIn] = true;
    Player[playerid][pMoney] = 5000;
    Player[playerid][pLevel] = 1;

    SendClientMessage(playerid, 0x00FF00FF, "T?i kho?n c?a b?n ?? ???c t?o v? l?u v?o SQL!");
    SpawnPlayer(playerid);
    return 1;
}