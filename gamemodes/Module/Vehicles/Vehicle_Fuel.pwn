// Module/Vehicles/Vehicle_Fuel.pwn
// He thong xang: tieu hao xang, do xang tai tram.

new Float:GasStations[][3] = {
    {1941.0, -1773.0, 13.4},
    {-90.0, -1167.0, 2.4},
    {1380.0, 458.0, 19.9},
    {614.0, 1689.0, 6.8},
    {2202.0, 2474.0, 10.5},
    {2115.0, 920.0, 10.8}
};

stock Fuel_OnEnterVehicle(playerid, vehicleid)
{
    new idx = Vehicle_FindBySpawnedID(vehicleid);
    if(idx != -1)
    {
        new msg[64];
        format(msg, sizeof(msg), "Xang: %.0f%% | Dung /fuel de do xang tai tram.", VehicleData[idx][vFuel]);
        SendClientMessage(playerid, COLOR_YELLOW, msg);
    }
    return 1;
}

stock Fuel_OnStartDriving(playerid)
{
    PlayerData[playerid][pJobTimerID] = SetTimerEx("Fuel_Consume", 30000, true, "i", playerid);
    return 1;
}

stock Fuel_OnStopDriving(playerid)
{
    #pragma unused playerid
    return 1;
}

stock Fuel_OnVehicleDeath(vehicleid)
{
    new idx = Vehicle_FindBySpawnedID(vehicleid);
    if(idx != -1)
    {
        VehicleData[idx][vFuel] = 0.0;
    }
    return 1;
}

forward Fuel_Consume(playerid);
public Fuel_Consume(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

    new vid = GetPlayerVehicleID(playerid);
    if(!vid) return 1;

    new idx = Vehicle_FindBySpawnedID(vid);
    if(idx == -1) return 1;

    VehicleData[idx][vFuel] -= 1.0;
    if(VehicleData[idx][vFuel] <= 0.0)
    {
        VehicleData[idx][vFuel] = 0.0;
        new e, l, a, d, bo, bt, o;
        GetVehicleParamsEx(vid, e, l, a, d, bo, bt, o);
        SetVehicleParamsEx(vid, 0, l, a, d, bo, bt, o);
        SendClientMessage(playerid, COLOR_RED, "Xe het xang! Hay do xang tai tram xang (/fuel).");
    }
    else if(VehicleData[idx][vFuel] <= 15.0)
    {
        new msg[64];
        format(msg, sizeof(msg), "Canh bao: Xang con %.0f%%!", VehicleData[idx][vFuel]);
        SendClientMessage(playerid, COLOR_ORANGE, msg);
    }
    return 1;
}

stock Fuel_IsNearGasStation(playerid)
{
    for(new i = 0; i < sizeof(GasStations); i++)
    {
        if(GetPlayerDistanceFromPoint(playerid, GasStations[i][0], GasStations[i][1], GasStations[i][2]) < 15.0)
            return 1;
    }
    return 0;
}
