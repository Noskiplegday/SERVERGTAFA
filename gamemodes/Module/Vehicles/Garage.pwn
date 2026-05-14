// Module/Vehicles/Garage.pwn
// He thong garage: cat xe, lay xe.
// Garage su dung /park va /mycars de spawn xe tu vi tri da luu.
// File nay chua them lenh /fuel va /sellcar.

stock Garage_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/fuel", true, 5))
    {
        new vid = GetPlayerVehicleID(playerid);
        if(!vid) { SendClientMessage(playerid, COLOR_RED, "Ban phai ngoi trong xe!"); return 1; }

        if(!Fuel_IsNearGasStation(playerid))
        {
            SendClientMessage(playerid, COLOR_RED, "Ban phai dung tai tram xang!");
            return 1;
        }

        new idx = Vehicle_FindBySpawnedID(vid);
        if(idx == -1) { SendClientMessage(playerid, COLOR_RED, "Xe nay khong can do xang!"); return 1; }

        new cost = floatround((100.0 - VehicleData[idx][vFuel]) * 5.0);
        if(cost <= 0) { SendClientMessage(playerid, COLOR_YELLOW, "Binh xang da day!"); return 1; }

        if(!Economy_HasMoney(playerid, cost))
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong du tien do xang!");
            return 1;
        }

        Economy_TakeMoney(playerid, cost);
        VehicleData[idx][vFuel] = 100.0;
        Vehicle_SaveOne(idx);

        new msg[128];
        format(msg, sizeof(msg), "Da do day xang. Chi phi: $%d", cost);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }

    if(!strcmp(cmdtext, "/sellcar", true, 8))
    {
        new vid = GetPlayerVehicleID(playerid);
        if(!vid) { SendClientMessage(playerid, COLOR_RED, "Ban phai ngoi trong xe muon ban!"); return 1; }

        new idx = Vehicle_FindBySpawnedID(vid);
        if(idx == -1) { SendClientMessage(playerid, COLOR_RED, "Day khong phai xe so huu!"); return 1; }
        if(strcmp(VehicleData[idx][vOwner], PlayerData[playerid][pName], true))
        {
            SendClientMessage(playerid, COLOR_RED, "Day khong phai xe cua ban!");
            return 1;
        }

        RemovePlayerFromVehicle(playerid);
        Vehicle_SellCar(playerid, idx);
        return 1;
    }

    return 0;
}
