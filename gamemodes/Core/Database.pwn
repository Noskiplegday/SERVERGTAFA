// Core/Database.pwn
// Ket noi MySQL va cac helper database dung chung.

#define DB_HOST     "127.0.0.1"
#define DB_USER     "root"
#define DB_PASS     ""
#define DB_NAME     "vancanhcity_db"

new MySQL:g_SQL;

stock Database_Connect()
{
    print("[MySQL] Dang ket noi database...");

    g_SQL = mysql_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);

    if(mysql_errno(g_SQL) != 0)
    {
        print("[MySQL] Ket noi THAT BAI!");
        return 0;
    }

    print("[MySQL] Ket noi THANH CONG!");
    return 1;
}

stock Database_Close()
{
    mysql_close(g_SQL);
    print("[MySQL] Da dong ket noi database.");
    return 1;
}
