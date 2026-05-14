// Module/Inventory/Items.pwn
// Dinh nghia ten item theo ITEM_* defines.

new ItemNames[][32] = {
    "Khong co",       // ITEM_NONE   0
    "Dien thoai",     // ITEM_PHONE  1
    "Thuc an",        // ITEM_FOOD   2
    "Nuoc uong",      // ITEM_WATER  3
    "Thuoc",          // ITEM_MEDKIT 4
    "Ao giap",        // ITEM_ARMOR  5
    "GPS"             // ITEM_GPS    6
};

stock Item_GetName(itemid, dest[], maxlen)
{
    if(itemid < 0 || itemid >= sizeof(ItemNames))
    {
        format(dest, maxlen, "Item %d", itemid);
        return 1;
    }
    format(dest, maxlen, "%s", ItemNames[itemid]);
    return 1;
}
