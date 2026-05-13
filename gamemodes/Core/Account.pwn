#include <a_mysql>
#include <bcrypt>

// Biến lưu trữ kết nối MySQL
new MySQL:g_SQL;

// Callback kết nối Database, gọi từ OnGameModeInit ở file chính.
forward ConnectToDatabase();
public ConnectToDatabase() {
    g_SQL = mysql_connect("127.0.0.1", "root", "", "vancanhcity_db");
    if(mysql_errno(g_SQL) != 0) print("LỗI: Không thể kết nối Database!");
    else print("THÀNH CÔNG: Đã kết nối Database.");
}

// Lưu dữ liệu người chơi vào database.
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

// --- Xử lý đăng ký bằng bcrypt hash ---
forward OnPlayerRegister(playerid, password[]);
public OnPlayerRegister(playerid, password[]) {
    new hash[BCRYPT_HASH_LENGTH], query[256];
    bcrypt_get_hash(hash); // Lấy mã hash vừa tạo.
    
    mysql_format(g_SQL, query, sizeof(query), 
        "INSERT INTO `players` (`username`, `password`) VALUES ('%e', '%s')", 
        Player[playerid][pTempName], hash);
    mysql_tquery(g_SQL, query, "OnAccountCreated", "i", playerid);
    return 1;
}

forward OnAccountCreated(playerid);
public OnAccountCreated(playerid) {
    Player[playerid][pID] = cache_insert_id();
    SendClientMessage(playerid, 0x00FF00FF, "Đăng ký thành công! Chào mừng bạn đến với Vân Canh city.");
    Player[playerid][pLoggedIn] = true;
    SpawnPlayer(playerid);
    return 1;
}

// --- Xử lý đăng nhập bằng bcrypt verify ---
forward OnLoginVerify(playerid, bool:success);
public OnLoginVerify(playerid, bool:success) {
    if(success) {
        new query[128];
        mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `players` WHERE `username` = '%e' LIMIT 1", Player[playerid][pTempName]);
        mysql_tquery(g_SQL, query, "LoadAccountData", "i", playerid);
    } else {
        SendClientMessage(playerid, 0xFF0000FF, "Mật khẩu hoặc tài khoản sai! Vui lòng nhập lại.");
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "ĐĂNG NHẬP", "Vui lòng nhập lại tài khoản hoặc mật khẩu:", "Tiếp tục", "Thoát");
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
    SendClientMessage(playerid, 0x00FF00FF, "Đăng nhập thành công. Dữ liệu đã đượcc tải!");
    SpawnPlayer(playerid);
    return 1;
}
// Khi người chơi bấm "Đăng ký" trong dialog.
forward OnPlayerRegister(playerid, password[]);
public OnPlayerRegister(playerid, password[]) {
    new hash[BCRYPT_HASH_LENGTH], query[512];
    bcrypt_get_hash(hash); // Lấy mật khẩu đã mã hóa từ lệnh bcrypt_hash phía trước.

    // Gửi lệnh SQL INSERT để tạo dòng mới trong bảng players.
    mysql_format(g_SQL, query, sizeof(query), 
        "INSERT INTO `players` (`username`, `password`, `money`, `level`) VALUES ('%e', '%s', 5000, 1)", 
        Player[playerid][pTempName], hash);
    
    mysql_tquery(g_SQL, query, "OnAccountRegistered", "i", playerid);
    return 1;
}

forward OnAccountRegistered(playerid);
public OnAccountRegistered(playerid) {
    Player[playerid][pID] = cache_insert_id(); // Lấy ID tự động từ SQL.
    Player[playerid][pLoggedIn] = true;
    Player[playerid][pMoney] = 5000;
    Player[playerid][pLevel] = 1;

    SendClientMessage(playerid, 0x00FF00FF, "Tài khoản của đã được lưu vào SQL!");
    SpawnPlayer(playerid);
    return 1;
}
