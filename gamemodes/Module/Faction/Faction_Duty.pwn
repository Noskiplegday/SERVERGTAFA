// Module/Faction/Faction_Duty.pwn
// On/off duty cho faction.

stock FactionDuty_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/duty", true, 5))
    {
        if(PlayerData[playerid][pFaction] == FACTION_NONE)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong thuoc to chuc nao!");
            return 1;
        }

        PlayerData[playerid][pOnDuty] = !PlayerData[playerid][pOnDuty];

        if(PlayerData[playerid][pOnDuty])
        {
            SendClientMessage(playerid, COLOR_GREEN, "Ban da vao ca truc (On Duty).");
            switch(PlayerData[playerid][pFaction])
            {
                case FACTION_LSPD: SetPlayerColor(playerid, 0x0000BBFF);
                case FACTION_EMS: SetPlayerColor(playerid, 0xFF0000FF);
                case FACTION_GOV: SetPlayerColor(playerid, 0x00FF00FF);
            }
        }
        else
        {
            SendClientMessage(playerid, COLOR_YELLOW, "Ban da het ca truc (Off Duty).");
            SetPlayerColor(playerid, COLOR_WHITE);
        }
        return 1;
    }
    return 0;
}
