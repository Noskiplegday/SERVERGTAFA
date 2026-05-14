// Module/Vehicles/Vehicles.pwn
// He thong xe: du lieu xe, load/save, spawn.

stock Vehicle_Init()
{
    Vehicle_LoadAll();

    DealershipPos[0] = 556.0;
    DealershipPos[1] = -1267.0;
    DealershipPos[2] = 17.2;

    DealerCars[0][dModel] = 411; strcat((DealerCars[0][dName][0] = EOS, DealerCars[0][dName]), "Infernus", 32); DealerCars[0][dPrice] = 100000;
    DealerCars[1][dModel] = 560; strcat((DealerCars[1][dName][0] = EOS, DealerCars[1][dName]), "Sultan", 32); DealerCars[1][dPrice] = 35000;
    DealerCars[2][dModel] = 562; strcat((DealerCars[2][dName][0] = EOS, DealerCars[2][dName]), "Elegy", 32); DealerCars[2][dPrice] = 40000;
    DealerCars[3][dModel] = 451; strcat((DealerCars[3][dName][0] = EOS, DealerCars[3][dName]), "Turismo", 32); DealerCars[3][dPrice] = 120000;
    DealerCars[4][dModel] = 541; strcat((DealerCars[4][dName][0] = EOS, DealerCars[4][dName]), "Bullet", 32); DealerCars[4][dPrice] = 150000;
    DealerCars[5][dModel] = 415; strcat((DealerCars[5][dName][0] = EOS, DealerCars[5][dName]), "Cheetah", 32); DealerCars[5][dPrice] = 90000;
    DealerCars[6][dModel] = 429; strcat((DealerCars[6][dName][0] = EOS, DealerCars[6][dName]), "Banshee", 32); DealerCars[6][dPrice] = 70000;
    DealerCars[7][dModel] = 405; strcat((DealerCars[7][dName][0] = EOS, DealerCars[7][dName]), "Sentinel", 32); DealerCars[7][dPrice] = 25000;
    DealerCars[8][dModel] = 445; strcat((DealerCars[8][dName][0] = EOS, DealerCars[8][dName]), "Admiral", 32); DealerCars[8][dPrice] = 20000;
    DealerCars[9][dModel] = 400; strcat((DealerCars[9][dName][0] = EOS, DealerCars[9][dName]), "Landstalker", 32); DealerCars[9][dPrice] = 30000;
    TotalDealerCars = 10;

    CreatePickup(1239, 1, DealershipPos[0], DealershipPos[1], DealershipPos[2], -1);
    Create3DTextLabel("Dai ly xe\n/buycar", COLOR_BLUE, DealershipPos[0], DealershipPos[1], DealershipPos[2] + 0.5, 20.0, 0, 0);

    print("[Vehicles] He thong xe da san sang.");
    return 1;
}

stock Vehicle_LoadAll()
{
    new path[64], line[512], key[64], value[128];
    TotalVehicles = 0;

    for(new i = 0; i < MAX_OWNED_VEHICLES; i++)
    {
        format(path, sizeof(path), "Vehicles/%d.json", i);
        if(!fexist(path)) continue;

        new File:f = fopen(path, io_read);
        if(!f) continue;

        VehicleData[TotalVehicles][vID] = i;
        while(fread(f, line))
        {
            if(!JSON_ParseLine(line, key, sizeof(key), value, sizeof(value))) continue;

            if(!strcmp(key, "model")) VehicleData[TotalVehicles][vModel] = strval(value);
            else if(!strcmp(key, "owner")) strcat((VehicleData[TotalVehicles][vOwner][0] = EOS, VehicleData[TotalVehicles][vOwner]), value, MAX_PLAYER_NAME);
            else if(!strcmp(key, "x")) VehicleData[TotalVehicles][vPosX] = floatstr(value);
            else if(!strcmp(key, "y")) VehicleData[TotalVehicles][vPosY] = floatstr(value);
            else if(!strcmp(key, "z")) VehicleData[TotalVehicles][vPosZ] = floatstr(value);
            else if(!strcmp(key, "a")) VehicleData[TotalVehicles][vPosA] = floatstr(value);
            else if(!strcmp(key, "color1")) VehicleData[TotalVehicles][vColor1] = strval(value);
            else if(!strcmp(key, "color2")) VehicleData[TotalVehicles][vColor2] = strval(value);
            else if(!strcmp(key, "locked")) VehicleData[TotalVehicles][vLocked] = strval(value);
            else if(!strcmp(key, "fuel")) VehicleData[TotalVehicles][vFuel] = floatstr(value);
            else if(!strcmp(key, "price")) VehicleData[TotalVehicles][vPrice] = strval(value);
        }
        fclose(f);

        VehicleData[TotalVehicles][vSpawnedID] = CreateVehicle(
            VehicleData[TotalVehicles][vModel],
            VehicleData[TotalVehicles][vPosX],
            VehicleData[TotalVehicles][vPosY],
            VehicleData[TotalVehicles][vPosZ],
            VehicleData[TotalVehicles][vPosA],
            VehicleData[TotalVehicles][vColor1],
            VehicleData[TotalVehicles][vColor2],
            -1);
        VehicleData[TotalVehicles][vEngineOn] = false;

        if(VehicleData[TotalVehicles][vLocked])
        {
            SetVehicleParamsEx(VehicleData[TotalVehicles][vSpawnedID], 0, 0, 0, 1, 0, 0, 0);
        }

        TotalVehicles++;
    }

    new msg[64];
    format(msg, sizeof(msg), "[Vehicles] Da load %d xe.", TotalVehicles);
    print(msg);
    return 1;
}

stock Vehicle_SaveOne(idx)
{
    new path[64];
    format(path, sizeof(path), "Vehicles/%d.json", VehicleData[idx][vID]);

    new File:f = fopen(path, io_write);
    if(!f) return 0;

    JSON_WriteHeader(f);
    JSON_WriteInt(f, "model", VehicleData[idx][vModel]);
    JSON_WriteString(f, "owner", VehicleData[idx][vOwner]);
    JSON_WriteFloat(f, "x", VehicleData[idx][vPosX]);
    JSON_WriteFloat(f, "y", VehicleData[idx][vPosY]);
    JSON_WriteFloat(f, "z", VehicleData[idx][vPosZ]);
    JSON_WriteFloat(f, "a", VehicleData[idx][vPosA]);
    JSON_WriteInt(f, "color1", VehicleData[idx][vColor1]);
    JSON_WriteInt(f, "color2", VehicleData[idx][vColor2]);
    JSON_WriteInt(f, "locked", VehicleData[idx][vLocked]);
    JSON_WriteFloat(f, "fuel", VehicleData[idx][vFuel]);
    JSON_WriteInt(f, "price", VehicleData[idx][vPrice], true);
    JSON_WriteFooter(f);
    fclose(f);
    return 1;
}

stock Vehicle_SaveAll()
{
    for(new i = 0; i < TotalVehicles; i++)
        Vehicle_SaveOne(i);
    return 1;
}

stock Vehicle_GetOwnerIdx(playerid, results[], maxresults)
{
    new count = 0;
    for(new i = 0; i < TotalVehicles; i++)
    {
        if(!strcmp(VehicleData[i][vOwner], PlayerData[playerid][pName], true) && count < maxresults)
        {
            results[count] = i;
            count++;
        }
    }
    return count;
}

stock Vehicle_FindBySpawnedID(vehicleid)
{
    for(new i = 0; i < TotalVehicles; i++)
    {
        if(VehicleData[i][vSpawnedID] == vehicleid)
            return i;
    }
    return -1;
}

stock Vehicle_OnCommand(playerid, cmdtext[])
{
    new cmd[32], params[128], idx;
    idx = 0;
    while(cmdtext[idx] && cmdtext[idx] != ' ') { if(idx < 31) cmd[idx] = cmdtext[idx]; idx++; }
    cmd[idx] = EOS;
    if(cmdtext[idx] == ' ') idx++;
    strmid(params, cmdtext, idx, strlen(cmdtext), sizeof(params));

    if(!strcmp(cmd, "/buycar", true))
    {
        if(GetPlayerDistanceFromPoint(playerid, DealershipPos[0], DealershipPos[1], DealershipPos[2]) > 10.0)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban phai dung tai dai ly xe!");
            return 1;
        }

        new dialog[1024], line[64];
        dialog[0] = EOS;
        for(new i = 0; i < TotalDealerCars; i++)
        {
            format(line, sizeof(line), "%s - $%d\n", DealerCars[i][dName], DealerCars[i][dPrice]);
            strcat(dialog, line, sizeof(dialog));
        }

        ShowPlayerDialog(playerid, DIALOG_VEHICLE_BUY, DIALOG_STYLE_LIST,
            "DAI LY XE - MUA XE",
            dialog,
            "Mua",
            "Dong");
        return 1;
    }

    if(!strcmp(cmd, "/mycars", true))
    {
        new results[10], count;
        count = Vehicle_GetOwnerIdx(playerid, results, sizeof(results));
        if(count == 0)
        {
            SendClientMessage(playerid, COLOR_RED, "Ban chua co xe nao!");
            return 1;
        }

        new dialog[512], line[64];
        dialog[0] = EOS;
        for(new i = 0; i < count; i++)
        {
            format(line, sizeof(line), "Xe #%d (Model %d) - Xang: %.0f%%\n",
                VehicleData[results[i]][vID], VehicleData[results[i]][vModel], VehicleData[results[i]][vFuel]);
            strcat(dialog, line, sizeof(dialog));
        }

        ShowPlayerDialog(playerid, DIALOG_VEHICLE_LIST, DIALOG_STYLE_LIST,
            "XE CUA BAN",
            dialog,
            "Spawn",
            "Dong");
        return 1;
    }

    if(!strcmp(cmd, "/lock", true))
    {
        new vid = GetPlayerVehicleID(playerid);
        new vidx = -1;
        if(vid > 0)
        {
            vidx = Vehicle_FindBySpawnedID(vid);
        }
        else
        {
            new results[10], count;
            count = Vehicle_GetOwnerIdx(playerid, results, sizeof(results));
            new Float:px, Float:py, Float:pz;
            GetPlayerPos(playerid, px, py, pz);
            for(new i = 0; i < count; i++)
            {
                new svid = VehicleData[results[i]][vSpawnedID];
                if(svid > 0)
                {
                    new Float:vx, Float:vy, Float:vz;
                    GetVehiclePos(svid, vx, vy, vz);
                    if(GetPlayerDistanceFromPoint(playerid, vx, vy, vz) < 15.0)
                    {
                        vidx = results[i];
                        break;
                    }
                }
            }
        }

        if(vidx == -1)
        {
            SendClientMessage(playerid, COLOR_RED, "Khong tim thay xe cua ban gan day!");
            return 1;
        }
        if(strcmp(VehicleData[vidx][vOwner], PlayerData[playerid][pName], true))
        {
            SendClientMessage(playerid, COLOR_RED, "Day khong phai xe cua ban!");
            return 1;
        }

        VehicleData[vidx][vLocked] = !VehicleData[vidx][vLocked];
        new svid = VehicleData[vidx][vSpawnedID];
        if(svid > 0)
        {
            new e, l, a, d, bo, bt, o;
            GetVehicleParamsEx(svid, e, l, a, d, bo, bt, o);
            SetVehicleParamsEx(svid, e, l, a, VehicleData[vidx][vLocked], bo, bt, o);
        }

        if(VehicleData[vidx][vLocked])
            SendClientMessage(playerid, COLOR_YELLOW, "Xe da khoa.");
        else
            SendClientMessage(playerid, COLOR_GREEN, "Xe da mo khoa.");
        Vehicle_SaveOne(vidx);
        return 1;
    }

    if(!strcmp(cmd, "/engine", true))
    {
        new vid = GetPlayerVehicleID(playerid);
        if(!vid) { SendClientMessage(playerid, COLOR_RED, "Ban phai ngoi trong xe!"); return 1; }

        new vidx = Vehicle_FindBySpawnedID(vid);
        if(vidx != -1 && strcmp(VehicleData[vidx][vOwner], PlayerData[playerid][pName], true))
        {
            SendClientMessage(playerid, COLOR_RED, "Day khong phai xe cua ban!");
            return 1;
        }

        new e, l, a, d, bo, bt, o;
        GetVehicleParamsEx(vid, e, l, a, d, bo, bt, o);
        if(e)
        {
            SetVehicleParamsEx(vid, 0, l, a, d, bo, bt, o);
            SendClientMessage(playerid, COLOR_YELLOW, "Da tat may xe.");
            if(vidx != -1) VehicleData[vidx][vEngineOn] = false;
        }
        else
        {
            if(vidx != -1 && VehicleData[vidx][vFuel] <= 0.0)
            {
                SendClientMessage(playerid, COLOR_RED, "Xe het xang! Hay do xang tai tram xang.");
                return 1;
            }
            SetVehicleParamsEx(vid, 1, l, a, d, bo, bt, o);
            SendClientMessage(playerid, COLOR_GREEN, "Da no may xe.");
            if(vidx != -1) VehicleData[vidx][vEngineOn] = true;
        }
        return 1;
    }

    if(!strcmp(cmd, "/park", true))
    {
        new vid = GetPlayerVehicleID(playerid);
        if(!vid) { SendClientMessage(playerid, COLOR_RED, "Ban phai ngoi trong xe!"); return 1; }

        new vidx = Vehicle_FindBySpawnedID(vid);
        if(vidx == -1) { SendClientMessage(playerid, COLOR_RED, "Day khong phai xe so huu!"); return 1; }
        if(strcmp(VehicleData[vidx][vOwner], PlayerData[playerid][pName], true))
        {
            SendClientMessage(playerid, COLOR_RED, "Day khong phai xe cua ban!");
            return 1;
        }

        new Float:x, Float:y, Float:z, Float:a2;
        GetVehiclePos(vid, x, y, z);
        GetVehicleZAngle(vid, a2);
        VehicleData[vidx][vPosX] = x;
        VehicleData[vidx][vPosY] = y;
        VehicleData[vidx][vPosZ] = z;
        VehicleData[vidx][vPosA] = a2;
        Vehicle_SaveOne(vidx);
        SendClientMessage(playerid, COLOR_GREEN, "Da luu vi tri dau xe.");
        return 1;
    }

    return 0;
}

stock Vehicle_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid == DIALOG_VEHICLE_BUY)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= TotalDealerCars) return 1;

        new price = DealerCars[listitem][dPrice];
        if(!Economy_HasMoney(playerid, price))
        {
            SendClientMessage(playerid, COLOR_RED, "Ban khong du tien!");
            return 1;
        }

        if(TotalVehicles >= MAX_OWNED_VEHICLES)
        {
            SendClientMessage(playerid, COLOR_RED, "He thong da dat gioi han xe!");
            return 1;
        }

        Economy_TakeMoney(playerid, price);

        new idx = TotalVehicles;
        VehicleData[idx][vID] = TotalVehicles;
        VehicleData[idx][vModel] = DealerCars[listitem][dModel];
        strcat((VehicleData[idx][vOwner][0] = EOS, VehicleData[idx][vOwner]), PlayerData[playerid][pName], MAX_PLAYER_NAME);
        VehicleData[idx][vPosX] = DealershipPos[0] + 5.0;
        VehicleData[idx][vPosY] = DealershipPos[1];
        VehicleData[idx][vPosZ] = DealershipPos[2];
        VehicleData[idx][vPosA] = 0.0;
        VehicleData[idx][vColor1] = random(126);
        VehicleData[idx][vColor2] = random(126);
        VehicleData[idx][vLocked] = 0;
        VehicleData[idx][vFuel] = 100.0;
        VehicleData[idx][vEngineOn] = false;
        VehicleData[idx][vPrice] = price;

        VehicleData[idx][vSpawnedID] = CreateVehicle(
            VehicleData[idx][vModel],
            VehicleData[idx][vPosX],
            VehicleData[idx][vPosY],
            VehicleData[idx][vPosZ],
            VehicleData[idx][vPosA],
            VehicleData[idx][vColor1],
            VehicleData[idx][vColor2],
            -1);

        PutPlayerInVehicle(playerid, VehicleData[idx][vSpawnedID], 0);
        TotalVehicles++;
        Vehicle_SaveOne(idx);

        new msg[128];
        format(msg, sizeof(msg), "Ban da mua %s voi gia $%d!", DealerCars[listitem][dName], price);
        SendClientMessage(playerid, COLOR_GREEN, msg);
        return 1;
    }

    if(dialogid == DIALOG_VEHICLE_LIST)
    {
        if(!response) return 1;

        new results[10], count;
        count = Vehicle_GetOwnerIdx(playerid, results, sizeof(results));
        if(listitem >= count) return 1;

        new idx = results[listitem];
        new svid = VehicleData[idx][vSpawnedID];
        if(svid > 0)
        {
            SetVehiclePos(svid, VehicleData[idx][vPosX], VehicleData[idx][vPosY], VehicleData[idx][vPosZ]);
            SetVehicleZAngle(svid, VehicleData[idx][vPosA]);
            PutPlayerInVehicle(playerid, svid, 0);
            SendClientMessage(playerid, COLOR_GREEN, "Xe da duoc spawn tai vi tri dau.");
        }
        return 1;
    }

    return 0;
}
