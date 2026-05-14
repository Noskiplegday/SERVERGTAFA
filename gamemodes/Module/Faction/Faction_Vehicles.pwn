// Module/Faction/Faction_Vehicles.pwn
// Xe cua to chuc.

stock FactionVehicle_Init()
{
    CreateVehicle(596, 1536.0, -1677.0, 13.5, 0.0, 0, 0, -1); // LSPD car
    CreateVehicle(596, 1540.0, -1677.0, 13.5, 0.0, 0, 0, -1);
    CreateVehicle(597, 1544.0, -1677.0, 13.5, 0.0, 0, 0, -1);

    CreateVehicle(416, 1177.0, -1325.0, 14.5, 0.0, 1, 3, -1); // Ambulance
    CreateVehicle(416, 1181.0, -1325.0, 14.5, 0.0, 1, 3, -1);

    CreateVehicle(427, 1485.0, -1774.0, 18.8, 0.0, 0, 0, -1); // Enforcer (Gov)
    return 1;
}
