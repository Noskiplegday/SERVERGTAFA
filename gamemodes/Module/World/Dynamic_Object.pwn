// Module/World/Dynamic_Object.pwn
// He thong object dong.

stock DynObject_Init()
{
    CreateObject(1318, 1958.0, 1343.0, 14.5, 0.0, 0.0, 0.0); // Spawn area objects
    CreateObject(1317, 1960.0, 1345.0, 14.5, 0.0, 0.0, 0.0);
    CreateObject(1318, 1956.0, 1341.0, 14.5, 0.0, 0.0, 0.0);

    CreateObject(2942, 1460.0, -1010.0, 26.0, 0.0, 0.0, 0.0); // Bank area
    CreateObject(2943, 1462.0, -1010.0, 26.0, 0.0, 0.0, 0.0);

    print("[World] Dynamic objects da san sang.");
    return 1;
}
