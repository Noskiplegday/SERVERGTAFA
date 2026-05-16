

// =============================================
//   VAN CANH CITY ROLEPLAY - open.mp
//   Full RP Server - MySQL Storage
// =============================================

#include <open.mp>
#include <a_mysql>
#include <bcrypt>
#include <izcmd>

// ---- DIALOG IDS ----
#define DIALOG_ACCOUNT_WELCOME  1
#define DIALOG_REGISTER_USERNAME 2
#define DIALOG_REGISTER_PASSWORD 3
#define DIALOG_REGISTER_VERIFY 4
#define DIALOG_REGISTER_EMAIL  5
#define DIALOG_LOGIN_USERNAME  6
#define DIALOG_LOGIN_PASSWORD  7
#define DIALOG_BANK_MENU        10
#define DIALOG_BANK_DEPOSIT     11
#define DIALOG_BANK_WITHDRAW    12
#define DIALOG_BANK_TRANSFER    13
#define DIALOG_BANK_TRANSFER_AMT 14
#define DIALOG_ATM_MENU         15
#define DIALOG_ATM_DEPOSIT      16
#define DIALOG_ATM_WITHDRAW     17
#define DIALOG_JOB_LIST         20
#define DIALOG_VEHICLE_BUY      30
#define DIALOG_VEHICLE_LIST     31
#define DIALOG_GARAGE_LIST      32
#define DIALOG_HOUSE_BUY        40
#define DIALOG_HOUSE_STORAGE    41
#define DIALOG_HOUSE_STORE_ITEM 42
#define DIALOG_FACTION_LOCKER   50
#define DIALOG_INVENTORY        70
#define DIALOG_SHOP             82
#define DIALOG_HELP             100

// ---- COLORS ----
#define COLOR_GREEN     0x00FF00FF
#define COLOR_RED       0xFF0000FF
#define COLOR_WHITE     0xFFFFFFFF
#define COLOR_YELLOW    0xFFFF00FF
#define COLOR_GREY      0xAFAFAFFF
#define COLOR_ORANGE    0xFF8800FF
#define COLOR_BLUE      0x0088FFFF
#define COLOR_PURPLE    0xCC00FFFF
#define COLOR_OOC       0xE0E0E0FF
#define COLOR_ME        0xC2A2DAFF
#define COLOR_RADIO     0x8D8DFFFF
#define COLOR_ADMIN     0xFF6347FF
#define COLOR_ANNOUNCE  0x00BFFFFF

// ---- LIMITS ----
#define MAX_HOUSES          200
#define MAX_OWNED_VEHICLES  500
#define MAX_FACTIONS        10
#define MAX_BUSINESSES      100
#define MAX_INV_SLOTS       10
#define MAX_HOUSE_STORAGE   10
#define MAX_ATM_LOCATIONS   20
#define MAX_DEALERSHIP_CARS 30

// ---- JOBS ----
#define JOB_NONE        0
#define JOB_TAXI        1
#define JOB_BUS         2
#define JOB_DELIVERY    3
#define JOB_GARBAGE     4
#define JOB_MINING      5

// ---- ITEM IDS ----
#define ITEM_NONE       0
#define ITEM_PHONE      1
#define ITEM_FOOD       2
#define ITEM_WATER      3
#define ITEM_MEDKIT     4
#define ITEM_ARMOR      5
#define ITEM_GPS        6

// ---- FACTION IDS ----
#define FACTION_NONE    0
#define FACTION_LSPD    1
#define FACTION_EMS     2
#define FACTION_GOV     3
#define FACTION_GANG    4

// ---- PLAYER DATA ENUM ----
enum E_PLAYER_DATA
{
    pID,
    pName[MAX_PLAYER_NAME],
    pPassword[65],
    pEmail[80],
    pRegUsername[MAX_PLAYER_NAME],
    pRegPassword[65],
    pRegEmail[80],
    pLoginUsername[MAX_PLAYER_NAME],
    bool:pLoggedIn,
    pAdminLevel,

    pMoney,
    pBankMoney,
    pSkin,
    pLevel,
    pExp,
    Float:pSpawnX,
    Float:pSpawnY,
    Float:pSpawnZ,
    Float:pSpawnA,

    pJob,
    bool:pOnJob,
    pJobCP,
    pJobVehicle,
    pJobStep,
    pJobEarned,
    pPlaytime,

    pFaction,
    pFactionRank,
    bool:pOnDuty,

    pWarnings,
    bool:pMuted,

    pHunger,
    pThirst,
    bool:pJailed,
    pJailTime,
    pDeaths,
    pKills,

    pPhoneNumber,
    pCallingTo,
    bool:pInCall,

    pHouseID,
    pBusinessID,

    pInvItem[MAX_INV_SLOTS],
    pInvAmount[MAX_INV_SLOTS],

    pSaveTimerID,
    pPaycheckTimerID,
    pJailTimerID,
    pHungerTimerID,
    pJobTimerID,

    pACWarnings,
    pLoginAttempts
}

new PlayerData[MAX_PLAYERS][E_PLAYER_DATA];

// ---- HOUSE DATA ----
enum E_HOUSE_DATA
{
    hID,
    hOwner[MAX_PLAYER_NAME],
    hPrice,
    hLocked,
    Float:hEnterX,
    Float:hEnterY,
    Float:hEnterZ,
    Float:hExitX,
    Float:hExitY,
    Float:hExitZ,
    hInterior,
    hPickupID,
    hLabelID,
    hStorage[MAX_HOUSE_STORAGE],
    hStorageAmt[MAX_HOUSE_STORAGE]
}

new HouseData[MAX_HOUSES][E_HOUSE_DATA];
new TotalHouses = 0;

// ---- VEHICLE DATA ----
enum E_VEHICLE_OWNED
{
    vID,
    vModel,
    vOwner[MAX_PLAYER_NAME],
    Float:vPosX,
    Float:vPosY,
    Float:vPosZ,
    Float:vPosA,
    vColor1,
    vColor2,
    vLocked,
    Float:vFuel,
    bool:vEngineOn,
    vSpawnedID,
    vPrice
}

new VehicleData[MAX_OWNED_VEHICLES][E_VEHICLE_OWNED];
new TotalVehicles = 0;

// ---- FACTION DATA ----
enum E_FACTION_DATA
{
    fID,
    fName[32],
    Float:fHQX,
    Float:fHQY,
    Float:fHQZ
}

new FactionData[MAX_FACTIONS][E_FACTION_DATA];
new TotalFactions = 0;

// ---- BUSINESS DATA ----
enum E_BUSINESS_DATA
{
    bName[32],
    bPrice,
    bOwnerID,
    Float:bEnterX,
    Float:bEnterY,
    Float:bEnterZ,
    Float:bInteriorX,
    Float:bInteriorY,
    Float:bInteriorZ,
    bInterior,
    bool:bLocked,
    bIncome
}

new BusinessData[MAX_BUSINESSES][E_BUSINESS_DATA];
new TotalBusinesses = 0;

// ---- ATM DATA ----
new Float:ATMLocations[MAX_ATM_LOCATIONS][3];
new ATMPickups[MAX_ATM_LOCATIONS];
new TotalATMs = 0;

// ---- DEALERSHIP ----
enum E_DEALER_CAR
{
    dModel,
    dName[32],
    dPrice
}

new DealerCars[MAX_DEALERSHIP_CARS][E_DEALER_CAR];
new TotalDealerCars = 0;
new Float:DealershipPos[3];

// ---- GLOBAL TIMERS / VARS ----
new gPaycheckInterval = 1800;
new gAutoSaveInterval = 300;

// ---- CORE INCLUDES ----
#include "Core/Database.pwn"
#include "Core/Session.pwn"
#include "Core/Player_Data.pwn"
#include "Core/Account.pwn"
#include "Core/Admin_System.pwn"

// ---- MODULE INCLUDES ----
// Security first (ServerLog used by other modules)
#include "Module/Security/Server_Log.pwn"
#include "Module/Security/AntiCheat.pwn"
#include "Module/Security/AntiCrash.pwn"

#include "Module/Economy/Economy.pwn"
#include "Module/Economy/Bank.pwn"
#include "Module/Economy/ATM.pwn"

// Inventory before Social (Inventory_HasItem used by Phone)
#include "Module/Inventory/Items.pwn"
#include "Module/Inventory/Inventory.pwn"
#include "Module/Inventory/Storage.pwn"

#include "Module/Jobs/Jobs.pwn"
#include "Module/Jobs/Taxi.pwn"
#include "Module/Jobs/Bus.pwn"
#include "Module/Jobs/Delivery.pwn"
#include "Module/Jobs/Garbage.pwn"
#include "Module/Jobs/Mining.pwn"

#include "Module/Vehicles/Vehicles.pwn"
#include "Module/Vehicles/Vehicle_Ownership.pwn"
#include "Module/Vehicles/Vehicle_Fuel.pwn"
#include "Module/Vehicles/Garage.pwn"

#include "Module/Housing/Housing.pwn"
#include "Module/Housing/House_Interior.pwn"
#include "Module/Housing/House_Storage.pwn"

#include "Module/Faction/Factions.pwn"
#include "Module/Faction/Faction_Rank.pwn"
#include "Module/Faction/Faction_Duty.pwn"
#include "Module/Faction/Faction_Vehicles.pwn"
#include "Module/Faction/Faction_Locker.pwn"

#include "Module/Social/Chat.pwn"
#include "Module/Social/Phone.pwn"
#include "Module/Social/SMS.pwn"
#include "Module/Social/Radio.pwn"

#include "Module/Gameplay/Spawn.pwn"
#include "Module/Gameplay/Death.pwn"
#include "Module/Gameplay/Hospital.pwn"
#include "Module/Gameplay/Jail.pwn"

#include "Module/Business/Business.pwn"
#include "Module/Business/Business_Income.pwn"
#include "Module/Business/Shop.pwn"

#include "Module/World/Dynamic_Object.pwn"
#include "Module/World/Dynamic_House.pwn"
#include "Module/World/Dynamic_Faction.pwn"
#include "Module/World/Dynamic_Business.pwn"

// =============================================
//   CALLBACKS
// =============================================

main()
{
    print(" ");
    print("====================================");
    print("     VAN CANH CITY ROLEPLAY");
    print("  Full RP - MySQL Storage");
    print("====================================");
    print(" ");
}

public OnGameModeInit()
{
    if(!Database_Connect())
    {
        print("[Server] Khong the ket noi MySQL. Tat gamemode.");
        SendRconCommand("exit");
        return 0;
    }
    Database_CreateTables();

    SetGameModeText("VC:RP v1.0");
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
    ShowNameTags(1);
    EnableStuntBonusForAll(0);
    DisableInteriorEnterExits();
    UsePlayerPedAnims();

    ServerLog_Init();
    Admin_Init();
    AntiCheat_Init();
    AntiCrash_Init();
    Economy_Init();
    Inventory_Init();
    ATM_Init();
    Job_Init();
    Vehicle_Init();
    House_Init();
    Faction_Init();
    FactionVehicle_Init();
    Business_Init();
    Hospital_Init();
    Jail_Init();
    DynObject_Init();
    DynHouse_Init();

    AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);

    print("[Server] Van Canh City RP da khoi dong thanh cong!");
    return 1;
}

public OnGameModeExit()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && Session_IsLoggedIn(i))
        {
            PlayerData_Save(i);
        }
    }
    Vehicle_SaveAll();
    House_SaveAll();
    Business_SaveAll();
    ServerLog_Write("[Server] Server da tat.");
    Database_Close();
    print("[Server] Server da tat. Da luu toan bo du lieu.");
    return 1;
}

public OnPlayerConnect(playerid)
{
    Session_Reset(playerid);
    Account_OnPlayerConnect(playerid);
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    #pragma unused classid
    if(!Session_IsLoggedIn(playerid))
    {
        TogglePlayerSpectating(playerid, true);
        Account_ShowWelcome(playerid);
        return 0;
    }
    return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    if(!Session_IsLoggedIn(playerid))
    {
        TogglePlayerSpectating(playerid, true);
        Account_ShowWelcome(playerid);
        return 0;
    }
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(Session_IsLoggedIn(playerid))
    {
        Job_StopWork(playerid);

        new tid = PlayerData[playerid][pCallingTo];
        if(tid != INVALID_PLAYER_ID && IsPlayerConnected(tid))
        {
            PlayerData[tid][pInCall] = false;
            PlayerData[tid][pCallingTo] = INVALID_PLAYER_ID;
            SendClientMessage(tid, COLOR_YELLOW, "Cuoc goi da ket thuc.");
        }

        PlayerData_Save(playerid);
    }
    Session_Cleanup(playerid);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(!Session_IsLoggedIn(playerid))
    {
        TogglePlayerSpectating(playerid, true);
        Account_ShowWelcome(playerid);
        return 1;
    }
    Spawn_OnPlayerSpawn(playerid);
    return 1;
}

public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
    Death_OnPlayerDeath(playerid, killerid, reason);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(Account_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(Economy_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(Vehicle_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(House_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(HouseStorage_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(FactionLocker_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(Inventory_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(Business_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(Shop_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
    return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!Session_IsLoggedIn(playerid))
    {
        SendClientMessage(playerid, COLOR_RED, "Ban phai dang nhap truoc!");
        return 1;
    }

    if(Admin_OnCommand(playerid, cmdtext)) return 1;
    if(FactionRank_OnCommand(playerid, cmdtext)) return 1;
    if(Economy_OnCommand(playerid, cmdtext)) return 1;
    if(Job_OnCommand(playerid, cmdtext)) return 1;
    if(Vehicle_OnCommand(playerid, cmdtext)) return 1;
    if(Garage_OnCommand(playerid, cmdtext)) return 1;
    if(House_OnCommand(playerid, cmdtext)) return 1;
    if(HouseInterior_OnCommand(playerid, cmdtext)) return 1;
    if(HouseStorage_OnCommand(playerid, cmdtext)) return 1;
    if(Faction_OnCommand(playerid, cmdtext)) return 1;
    if(FactionDuty_OnCommand(playerid, cmdtext)) return 1;
    if(FactionLocker_OnCommand(playerid, cmdtext)) return 1;
    if(Chat_OnCommand(playerid, cmdtext)) return 1;
    if(Phone_OnCommand(playerid, cmdtext)) return 1;
    if(SMS_OnCommand(playerid, cmdtext)) return 1;
    if(Radio_OnCommand(playerid, cmdtext)) return 1;
    if(Inventory_OnCommand(playerid, cmdtext)) return 1;
    if(InvStorage_OnCommand(playerid, cmdtext)) return 1;
    if(Hospital_OnCommand(playerid, cmdtext)) return 1;
    if(Jail_OnCommand(playerid, cmdtext)) return 1;
    if(Business_OnCommand(playerid, cmdtext)) return 1;
    if(Shop_OnCommand(playerid, cmdtext)) return 1;
    if(DynHouse_OnCommand(playerid, cmdtext)) return 1;
    if(DynFaction_OnCommand(playerid, cmdtext)) return 1;
    if(DynBusiness_OnCommand(playerid, cmdtext)) return 1;
    if(Video_OnCommand(playerid, cmdtext)) return 1;
    SendClientMessage(playerid, COLOR_RED, "Lenh khong ton tai. Dung /help de xem danh sach lenh.");
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    ATM_OnPickup(playerid, pickupid);
    House_OnPickup(playerid, pickupid);
    Hospital_OnPickup(playerid, pickupid);
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    Job_OnCheckpoint(playerid);
    return 1;
}

public OnPlayerUpdate(playerid)
{
    AntiCheat_OnUpdate(playerid);
    return 1;
}

public OnPlayerText(playerid, text[])
{
    if(!Session_IsLoggedIn(playerid)) return 0;
    if(PlayerData[playerid][pMuted])
    {
        SendClientMessage(playerid, COLOR_RED, "Ban dang bi cam chat.");
        return 0;
    }

    if(Phone_OnText(playerid, text)) return 0;

    Chat_OnText(playerid, text);
    return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    Fuel_OnEnterVehicle(playerid, vehicleid);
    return 1;
}

public OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
    {
        Fuel_OnStartDriving(playerid);
    }
    if(oldstate == PLAYER_STATE_DRIVER)
    {
        Fuel_OnStopDriving(playerid);
    }
    return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    Fuel_OnVehicleDeath(vehicleid);
    return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
    AntiCrash_OnRconLogin(INVALID_PLAYER_ID, ip, success);
    return 1;
}

forward Video_OnCommand(playerid, cmdtext[]);
public Video_OnCommand(playerid, cmdtext[])
{
    if(strcmp(cmdtext, "/veh", true) == 0)
    {
        new Float:X, Float:Y, Float:Z;
        GetPlayerPos(playerid, X, Y, Z);
        CreateVehicle(411, X, Y + 2.0, Z, 0.0, 3, 3, -1); 
        SendClientMessage(playerid, -1, "{00FF00}[VanCanhCity]{FFFFFF} Ban da tao thanh cong Infernus!");
        return 1;
    }
    return 0;
}

