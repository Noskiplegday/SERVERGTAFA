// Bước A: Lấy mã hash từ SQL.
forward OnLoginVerify(playerid, const password[]);
public OnLoginVerify(playerid, const password[]) {
    new rows;
    cache_get_row_count(rows);

    if(rows > 0) {
        new hash[BCRYPT_HASH_LENGTH];
        cache_get_value_name(0, "password", hash, sizeof(hash)); // Lấy cột 'password'.

        // Dùng bcrypt để so sánh mật khẩu nhập vào với mã hash trong SQL.
        bcrypt_verify(playerid, "OnPasswordChecked", password, hash);
    }
    return 1;
}

// Bước B: Xử lý kết quả sau khi so sánh.
forward OnPasswordChecked(playerid, bool:success);
public OnPasswordChecked(playerid, bool:success) {
    if(success) {
        // Nếu đúng mật khẩu thì tiếp tục load dữ liệu.
        new query[128];
        mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `players` WHERE `id` = %d", Player[playerid][pID]);
        mysql_tquery(g_SQL, query, "LoadAccountData", "i", playerid);
    } else {
        // Nếu sai mật khẩu.
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "ĐĂNG NHẬP", "{FF0000}Mật khẩu hoặc tài khoản sai! {FFFFFF}Vui lòng nhập lại:", "Tiếp tục", "Thoát");
    }
    return 1;
}
