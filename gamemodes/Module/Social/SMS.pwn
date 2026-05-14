// Module/Social/SMS.pwn
// Nhan tin SMS.

stock SMS_OnCommand(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/sms", true, 4))
    {
        if(!Inventory_HasItem(playerid, ITEM_PHONE))
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong co dien thoai!");
            return 1;
        }

        new params[128];
        strmid(params, cmdtext, 5, strlen(cmdtext), sizeof(params));

        new p1[8], pi = 0, ci = 0;
        while(params[pi] && params[pi] != ' ') { if(ci < 7) p1[ci] = params[pi]; ci++; pi++; }
        p1[ci] = EOS;
        if(params[pi] == ' ') pi++;

        new number = strval(p1);
        new tid = Phone_FindByNumber(number);
        if(tid == INVALID_PLAYER_ID || !IsPlayerConnected(tid))
        {
            SendClientMessage(playerid, COLOR_RED, "So dien thoai khong ton tai!");
            return 1;
        }

        new text[128];
        strmid(text, params, pi, strlen(params), sizeof(text));
        if(strlen(text) < 1)
        {
            SendClientMessage(playerid, COLOR_RED, "Dung: /sms [so] [noi dung]");
            return 1;
        }

        new msg[256];
        format(msg, sizeof(msg), "[SMS tu %d] %s", PlayerData[playerid][pPhoneNumber], text);
        SendClientMessage(tid, COLOR_YELLOW, msg);

        format(msg, sizeof(msg), "[SMS gui den %d] %s", number, text);
        SendClientMessage(playerid, COLOR_YELLOW, msg);
        return 1;
    }
    return 0;
}
