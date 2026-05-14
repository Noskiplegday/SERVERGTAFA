// Module/Faction/Faction_Locker.pwn
// Tu do faction (lay vu khi, ao giap).

stock FactionLocker_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/flocker", true, 8) || !strcmp(cmdtext, "/locker", true, 7))
    {
        if(PlayerData[playerid][pFaction] == FACTION_NONE)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong thuoc to chuc nao!");
            return 1;
        }
        if(!PlayerData[playerid][pOnDuty])
        {
            SendClientMessage(playerid, COLOR_RED, "Ban phai on duty!");
            return 1;
        }

        new fidx = Faction_FindByID(PlayerData[playerid][pFaction]);
        if(fidx == -1) return 1;

        if(GetPlayerDistanceFromPoint(playerid, FactionData[fidx][fHQX], FactionData[fidx][fHQY], FactionData[fidx][fHQZ]) > 20.0)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban phai dung tai HQ cua to chuc!");
            return 1;
        }

        ShowPlayerDialog(playerid, DIALOG_FACTION_LOCKER, DIALOG_STYLE_LIST,
            "TU DO TO CHUC",
            "Ao giap ($0)\nSung luc ($0)\nShotgun ($0)\nMP5 ($0)\nM4 ($0)\nDui cui ($0)",
            "Lay",
            "Dong");
        return 1;
    }
    return 0;
}

stock FactionLocker_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid == DIALOG_FACTION_LOCKER)
    {
        if(!response) return 1;
        if(!PlayerData[playerid][pOnDuty]) { SendClientMessage(playerid, COLOR_RED, "Ban phai on duty!"); return 1; }

        switch(listitem)
        {
            case 0: { SetPlayerArmour(playerid, 100.0); SendClientMessage(playerid, COLOR_GREEN, "Da lay ao giap."); }
            case 1: { GivePlayerWeapon(playerid, 24, 100); SendClientMessage(playerid, COLOR_GREEN, "Da lay sung luc."); }
            case 2: { GivePlayerWeapon(playerid, 25, 50); SendClientMessage(playerid, COLOR_GREEN, "Da lay shotgun."); }
            case 3: { GivePlayerWeapon(playerid, 29, 200); SendClientMessage(playerid, COLOR_GREEN, "Da lay MP5."); }
            case 4:
            {
                if(PlayerData[playerid][pFactionRank] < 3) { SendClientMessage(playerid, COLOR_RED, "Can rank 3+!"); return 1; }
                GivePlayerWeapon(playerid, 31, 300);
                SendClientMessage(playerid, COLOR_GREEN, "Da lay M4.");
            }
            case 5: { GivePlayerWeapon(playerid, 3, 1); SendClientMessage(playerid, COLOR_GREEN, "Da lay dui cui."); }
        }
        return 1;
    }
    return 0;
}
