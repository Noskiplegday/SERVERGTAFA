// Module/Social/Chat.pwn
// Chat IC/OOC, /me, /do, /s, /b, /w, /ooc.

stock Chat_OnText(playerid, text[])
{
    if(!Session_IsLoggedIn(playerid)) return 0;
    if(PlayerData[playerid][pMuted])
    {
        SendClientMessage(playerid, COLOR_RED, "Ban dang bi cam chat!");
        return 0;
    }

    new msg[256], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    format(msg, sizeof(msg), "%s noi: %s", name, text);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !Session_IsLoggedIn(i)) continue;
        if(GetPlayerDistanceFromPoint(i, px, py, pz) <= 20.0)
        {
            SendClientMessage(i, COLOR_WHITE, msg);
        }
    }
    return 0;
}

stock Chat_OnCommand(playerid, cmdtext[])
{
    new cmd[32], params[256], idx;
    idx = 0;
    while(cmdtext[idx] && cmdtext[idx] != ' ') { if(idx < 31) cmd[idx] = cmdtext[idx]; idx++; }
    cmd[idx] = EOS;
    if(cmdtext[idx] == ' ') idx++;
    strmid(params, cmdtext, idx, strlen(cmdtext), sizeof(params));

    // /me [action]
    if(!strcmp(cmd, "/me", true))
    {
        if(strlen(params) < 1) { SendClientMessage(playerid, COLOR_RED, "Dung: /me [hanh dong]"); return 1; }
        new msg[256];
        format(msg, sizeof(msg), "* %s %s", PlayerData[playerid][pName], params);
        Chat_SendProximity(playerid, msg, COLOR_ME, 20.0);
        return 1;
    }

    // /do [description]
    if(!strcmp(cmd, "/do", true))
    {
        if(strlen(params) < 1) { SendClientMessage(playerid, COLOR_RED, "Dung: /do [mo ta]"); return 1; }
        new msg[256];
        format(msg, sizeof(msg), "* %s (( %s ))", params, PlayerData[playerid][pName]);
        Chat_SendProximity(playerid, msg, COLOR_ME, 20.0);
        return 1;
    }

    // /s [shout]
    if(!strcmp(cmd, "/s", true))
    {
        if(strlen(params) < 1) { SendClientMessage(playerid, COLOR_RED, "Dung: /s [noi dung]"); return 1; }
        new msg[256];
        format(msg, sizeof(msg), "%s het: %s!!", PlayerData[playerid][pName], params);
        Chat_SendProximity(playerid, msg, COLOR_WHITE, 40.0);
        return 1;
    }

    // /w [whisper]
    if(!strcmp(cmd, "/w", true))
    {
        if(strlen(params) < 1) { SendClientMessage(playerid, COLOR_RED, "Dung: /w [noi dung]"); return 1; }
        new msg[256];
        format(msg, sizeof(msg), "%s thi tham: %s", PlayerData[playerid][pName], params);
        Chat_SendProximity(playerid, msg, COLOR_GREY, 5.0);
        return 1;
    }

    // /b [local ooc]
    if(!strcmp(cmd, "/b", true))
    {
        if(strlen(params) < 1) { SendClientMessage(playerid, COLOR_RED, "Dung: /b [noi dung]"); return 1; }
        new msg[256];
        format(msg, sizeof(msg), "(( %s: %s ))", PlayerData[playerid][pName], params);
        Chat_SendProximity(playerid, msg, COLOR_OOC, 20.0);
        return 1;
    }

    // /ooc [global ooc]
    if(!strcmp(cmd, "/ooc", true) || !strcmp(cmd, "/o", true))
    {
        if(strlen(params) < 1) { SendClientMessage(playerid, COLOR_RED, "Dung: /ooc [noi dung]"); return 1; }
        new msg[256];
        format(msg, sizeof(msg), "[OOC] %s: %s", PlayerData[playerid][pName], params);
        SendClientMessageToAll(COLOR_OOC, msg);
        return 1;
    }

    return 0;
}

stock Chat_SendProximity(playerid, msg[], color, Float:range)
{
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !Session_IsLoggedIn(i)) continue;
        if(GetPlayerDistanceFromPoint(i, px, py, pz) <= range)
        {
            SendClientMessage(i, color, msg);
        }
    }
}
