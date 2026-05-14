// Module/Business/Business_Income.pwn
// Thu nhap tu business theo thoi gian (goi trong paycheck).

stock BusinessIncome_Process()
{
    for(new b = 0; b < TotalBusinesses; b++)
    {
        if(BusinessData[b][bOwnerID] == -1) continue;
        new income = 100 + random(200);
        BusinessData[b][bIncome] += income;
    }
    Business_SaveAll();
}

stock BusinessIncome_Collect(playerid)
{
    new total = 0;
    for(new b = 0; b < TotalBusinesses; b++)
    {
        if(BusinessData[b][bOwnerID] == playerid && BusinessData[b][bIncome] > 0)
        {
            total += BusinessData[b][bIncome];
            BusinessData[b][bIncome] = 0;
        }
    }
    if(total > 0)
    {
        Economy_GiveMoney(playerid, total);
        new msg[64];
        format(msg, sizeof(msg), "Da thu $%d tu business.", total);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        Business_SaveAll();
    }
    return total;
}
