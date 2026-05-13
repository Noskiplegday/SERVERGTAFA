// B??c A: L?y m? Hash t? SQL
forward OnLoginVerify(playerid, const password[]);
public OnLoginVerify(playerid, const password[]) {
    new rows;
    cache_get_row_count(rows);

    if(rows > 0) {
        new hash[BCRYPT_HASH_LENGTH];
        cache_get_value_name(0, "password", hash, sizeof(hash)); // L?y c?t 'password' ra

        // D?ng bcrypt ?? so s?nh m?t kh?u nh?p v?o v?i m? hash trong SQL
        bcrypt_verify(playerid, "OnPasswordChecked", password, hash);
    }
    return 1;
}

// B??c B: K?t qu? sau khi so s?nh
forward OnPasswordChecked(playerid, bool:success);
public OnPasswordChecked(playerid, bool:success) {
    if(success) {
        // N?u ??ng m?t kh?u -> Load d? li?u ti?p
        new query[128];
        mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `players` WHERE `id` = %d", Player[playerid][pID]);
        mysql_tquery(g_SQL, query, "LoadAccountData", "i", playerid);
    } else {
        // N?u sai m?t kh?u
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "??NG NH?P", "{FF0000}M?t kh?u kh?ng ??ng! {FFFFFF}Vui l?ng nh?p l?i:", "Ti?p", "Tho?t");
    }
    return 1;
}