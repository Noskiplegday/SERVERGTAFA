
// Core/Database.pwn
// Ket noi MySQL va tao/migrate schema nen cho account/player data.

#define DB_HOST     "127.0.0.1"
#define DB_USER     "root"
#define DB_PASS     ""
#define DB_NAME     "vancanhcity_db"

new MySQL:g_SQL;

stock Database_Connect()
{
    print("[MySQL] Dang ket noi database...");

    g_SQL = mysql_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    mysql_log(ERROR | WARNING);

    if(mysql_errno(g_SQL) != 0)
    {
        print("[MySQL] Ket noi THAT BAI!");
        return 0;
    }

    print("[MySQL] Ket noi THANH CONG!");
    return 1;
}

stock Database_CreateTables()
{
    mysql_tquery(g_SQL,
        "CREATE TABLE IF NOT EXISTS users (\
            id INT AUTO_INCREMENT PRIMARY KEY,\
            username VARCHAR(24) NOT NULL UNIQUE,\
            password_hash VARCHAR(65) NOT NULL,\
            email VARCHAR(80) NOT NULL DEFAULT '',\
            money INT NOT NULL DEFAULT 5000,\
            bank_money INT NOT NULL DEFAULT 0,\
            skin INT NOT NULL DEFAULT 0,\
            level INT NOT NULL DEFAULT 1,\
            exp INT NOT NULL DEFAULT 0,\
            job_id INT NOT NULL DEFAULT 0,\
            admin_level INT NOT NULL DEFAULT 0,\
            pos_x FLOAT NOT NULL DEFAULT 1958.3783,\
            pos_y FLOAT NOT NULL DEFAULT 1343.1572,\
            pos_z FLOAT NOT NULL DEFAULT 15.3746,\
            angle FLOAT NOT NULL DEFAULT 269.1425,\
            last_login_at TIMESTAMP NULL DEFAULT NULL,\
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,\
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\
            banned INT NOT NULL DEFAULT 0,\
            faction INT NOT NULL DEFAULT 0,\
            faction_rank INT NOT NULL DEFAULT 0,\
            warnings INT NOT NULL DEFAULT 0,\
            hunger INT NOT NULL DEFAULT 100,\
            thirst INT NOT NULL DEFAULT 100,\
            jailed INT NOT NULL DEFAULT 0,\
            jail_time INT NOT NULL DEFAULT 0,\
            deaths INT NOT NULL DEFAULT 0,\
            kills INT NOT NULL DEFAULT 0,\
            phone INT NOT NULL DEFAULT 0,\
            house INT NOT NULL DEFAULT -1,\
            business INT NOT NULL DEFAULT -1,\
            playtime INT NOT NULL DEFAULT 0\
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

    Database_MigrateUsersTable();
    Database_RunSmokeTest();
    print("[MySQL] Schema users da san sang.");
    return 1;
}

stock Database_MigrateUsersTable()
{
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS password_hash VARCHAR(65) NOT NULL DEFAULT ''");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS email VARCHAR(80) NOT NULL DEFAULT ''");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS bank_money INT NOT NULL DEFAULT 0");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS job_id INT NOT NULL DEFAULT 0");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS admin_level INT NOT NULL DEFAULT 0");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS pos_x FLOAT NOT NULL DEFAULT 1958.3783");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS pos_y FLOAT NOT NULL DEFAULT 1343.1572");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS pos_z FLOAT NOT NULL DEFAULT 15.3746");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS angle FLOAT NOT NULL DEFAULT 269.1425");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS last_login_at TIMESTAMP NULL DEFAULT NULL");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS banned INT NOT NULL DEFAULT 0");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS faction INT NOT NULL DEFAULT 0");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS faction_rank INT NOT NULL DEFAULT 0");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS warnings INT NOT NULL DEFAULT 0");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS hunger INT NOT NULL DEFAULT 100");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS thirst INT NOT NULL DEFAULT 100");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS jailed INT NOT NULL DEFAULT 0");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS jail_time INT NOT NULL DEFAULT 0");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS deaths INT NOT NULL DEFAULT 0");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS kills INT NOT NULL DEFAULT 0");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS phone INT NOT NULL DEFAULT 0");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS house INT NOT NULL DEFAULT -1");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS business INT NOT NULL DEFAULT -1");
    mysql_tquery(g_SQL, "ALTER TABLE users ADD COLUMN IF NOT EXISTS playtime INT NOT NULL DEFAULT 0");
    return 1;
}

stock Database_RunSmokeTest()
{
    new query[512];
    mysql_format(g_SQL, query, sizeof(query),
        "SELECT COUNT(*) AS column_count FROM information_schema.columns WHERE table_schema='%e' AND table_name='users' AND column_name IN ('id','username','password_hash','email','money','bank_money','skin','level','exp','job_id','admin_level','pos_x','pos_y','pos_z','angle','last_login_at','created_at','updated_at')",
        DB_NAME);
    mysql_tquery(g_SQL, query, "Database_OnSmokeTest");
    return 1;
}

forward Database_OnSmokeTest();
public Database_OnSmokeTest()
{
    new column_count;
    cache_get_value_name_int(0, "column_count", column_count);

    if(column_count >= 18)
        print("[MySQL][TEST] users schema query OK.");
    else
        print("[MySQL][TEST] users schema query FAILED: thieu cot bat buoc.");

    return 1;
}

stock Database_Close()
{
    mysql_close(g_SQL);
    print("[MySQL] Da dong ket noi database.");
    return 1;
}

