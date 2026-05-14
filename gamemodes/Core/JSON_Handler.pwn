// Core/JSON_Handler.pwn
// Tien ich doc/ghi file JSON don gian (flat key-value).

stock JSON_ParseLine(const line[], key[], keymax, value[], valmax)
{
    new i = 0;
    key[0] = EOS;
    value[0] = EOS;

    while(line[i] && line[i] != '"') i++;
    if(!line[i]) return 0;
    i++;

    new ks = i;
    while(line[i] && line[i] != '"') i++;
    if(!line[i]) return 0;
    strmid(key, line, ks, i, keymax);
    i++;

    while(line[i] && line[i] != ':') i++;
    if(!line[i]) return 0;
    i++;

    while(line[i] == ' ') i++;

    if(line[i] == '"')
    {
        i++;
        new vs = i;
        while(line[i] && line[i] != '"') i++;
        strmid(value, line, vs, i, valmax);
    }
    else
    {
        new vs = i;
        while(line[i] && line[i] != ',' && line[i] != '\n' && line[i] != '\r' && line[i] != '}') i++;
        strmid(value, line, vs, i, valmax);

        new len = strlen(value);
        while(len > 0 && (value[len-1] == ' ' || value[len-1] == '\r' || value[len-1] == '\n'))
        {
            value[len-1] = EOS;
            len--;
        }
    }

    return 1;
}

stock JSON_WriteHeader(File:f)
{
    fwrite(f, "{\n");
}

stock JSON_WriteFooter(File:f)
{
    fwrite(f, "}\n");
}

stock JSON_WriteString(File:f, const key[], const value[], bool:last = false)
{
    new line[512];
    if(last)
        format(line, sizeof(line), "  \"%s\": \"%s\"\n", key, value);
    else
        format(line, sizeof(line), "  \"%s\": \"%s\",\n", key, value);
    fwrite(f, line);
}

stock JSON_WriteInt(File:f, const key[], value, bool:last = false)
{
    new line[256];
    if(last)
        format(line, sizeof(line), "  \"%s\": %d\n", key, value);
    else
        format(line, sizeof(line), "  \"%s\": %d,\n", key, value);
    fwrite(f, line);
}

stock JSON_WriteFloat(File:f, const key[], Float:value, bool:last = false)
{
    new line[256];
    if(last)
        format(line, sizeof(line), "  \"%s\": %f\n", key, value);
    else
        format(line, sizeof(line), "  \"%s\": %f,\n", key, value);
    fwrite(f, line);
}

stock bool:JSON_FileExists(const path[])
{
    return fexist(path) ? true : false;
}
