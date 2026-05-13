#include <open.mp>
#include <a_mysql>
#include <bcrypt>

#include "Core/Account.pwn" // N?p module v?o

// C?p nh?t enum ?? kh?p v?i DB
enum PlayerInfo {
    pID,
    bool:pLoggedIn,
    pPassword[64],
    pTempName[MAX_PLAYER_NAME],
    pMoney,
    pLevel
}
new Player[MAX_PLAYERS][PlayerInfo];

public OnGameModeInit() {
    ConnectToDatabase(); // G?i h?m k?t n?i t? module Account
    return 1;
}

public OnPlayerDisconnect(playerid, reason) {
    SaveAccount(playerid); // T? ??ng l?u khi tho?t
    return 1;
}

// Trong OnDialogResponse, ?o?n x? l? Login/Register s? nh? sau:
// (V? d? cho Register)
if(dialogid == DIALOG_REGISTER) {
    if(response) {
        bcrypt_hash(playerid, "OnPlayerRegister", inputtext, 12);
    }
}
// (V? d? cho Login)
if(dialogid == DIALOG_LOGIN) {
    if(response) {
        new hash[BCRYPT_HASH_LENGTH], query[128];
        // ? ??y b?n c?n l?y hash t? DB tr??c r?i d?ng:
        // bcrypt_verify(playerid, "OnLoginVerify", inputtext, hash);
    }
}
public OnPlayerConnect(playerid)
{
    // L?y t?n ng??i ch?i l?u v?o bi?n t?m
    GetPlayerName(playerid, Player[playerid][pTempName], 24);
    
    // G?i h?m ki?m tra trong Account.pwn
    CheckPlayerAccount(playerid);
    
    return 1;
}