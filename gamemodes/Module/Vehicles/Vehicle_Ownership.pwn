// Module/Vehicles/Vehicle_Ownership.pwn
// Mua/ban xe, so huu.
// Logic mua xe da duoc xu ly trong Vehicles.pwn (Vehicle_OnDialogResponse)
// File nay chua cac helper bo sung.

stock Vehicle_SellCar(playerid, idx)
{
    new refund = VehicleData[idx][vPrice] / 2;
    Economy_GiveMoney(playerid, refund);

    if(VehicleData[idx][vSpawnedID] > 0)
    {
        DestroyVehicle(VehicleData[idx][vSpawnedID]);
        VehicleData[idx][vSpawnedID] = 0;
    }

    new path[64];
    format(path, sizeof(path), "Vehicles/%d.json", VehicleData[idx][vID]);
    if(fexist(path)) fremove(path);

    VehicleData[idx][vOwner][0] = EOS;
    VehicleData[idx][vModel] = 0;

    new msg[128];
    format(msg, sizeof(msg), "Ban da ban xe voi gia $%d (50%% gia goc).", refund);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}
