// Module/Gameplay/Hospital.pwn
// Benh vien: respawn, hoi mau, mua thuoc.

new Float:HospitalPos[] = {1172.0, -1323.0, 15.4};

stock Hospital_Init()
{
    CreatePickup(1240, 1, HospitalPos[0], HospitalPos[1], HospitalPos[2], -1);
    Create3DTextLabel("Benh Vien\n/heal", COLOR_GREEN, HospitalPos[0], HospitalPos[1], HospitalPos[2] + 0.5, 20.0, 0, 0);
    print("[Hospital] Benh vien da san sang.");
    return 1;
}

stock Hospital_OnPickup(playerid, pickupid)
{
    #pragma unused pickupid
    if(GetPlayerDistanceFromPoint(playerid, HospitalPos[0], HospitalPos[1], HospitalPos[2]) < 5.0)
    {
        SendClientMessage(playerid, COLOR_GREEN, "Ban dang tai benh vien. /heal de chua tri ($500).");
        return 1;
    }
    return 0;
}

stock Hospital_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/heal", true, 5))
    {
        if(GetPlayerDistanceFromPoint(playerid, HospitalPos[0], HospitalPos[1], HospitalPos[2]) > 10.0)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban phai dung tai benh vien!");
            return 1;
        }
        if(!Economy_HasMoney(playerid, 500))
        {
            SendClientMessage(playerid, COLOR_RED, "Khong du tien ($500)!");
            return 1;
        }

        Economy_TakeMoney(playerid, 500);
        SetPlayerHealth(playerid, 100.0);
        PlayerData[playerid][pHunger] = 100;
        PlayerData[playerid][pThirst] = 100;
        SendClientMessage(playerid, COLOR_GREEN, "Da chua tri! HP, Hunger, Thirst da hoi phuc.");
        return 1;
    }
    return 0;
}
