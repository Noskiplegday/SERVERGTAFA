// =============================================================================
//   VAN CANH CITY ROLEPLAY - MODULE INVENTORY GRAPHICAL UI (UEF TEXTDRAW)
// =============================================================================

#include <open.mp>

enum E_INV_UI_DATA {
    PlayerText:inv_Background,
    PlayerText:inv_Title,
    PlayerText:inv_Slots[MAX_INV_SLOTS],
    PlayerText:inv_ItemModels[MAX_INV_SLOTS],
    PlayerText:inv_ItemAmounts[MAX_INV_SLOTS],
    PlayerText:inv_CloseButton
}
new InventoryUI[MAX_PLAYERS][E_INV_UI_DATA];
new bool:IsShowingInventory[MAX_PLAYERS] = {false, ...};

// Hàm l?y ID Model 3D t??ng ?ng v?i Item ID trong file txt c?a b?n
stock GetItemModelID(itemid)
{
    switch(itemid)
    {
        case ITEM_PHONE:  return 330;  // ?i?n tho?i
        case ITEM_FOOD:   return 2768; // Bánh Hambuger / Th?c ?n
        case ITEM_WATER:  return 19561;// Chai n??c tinh khi?t
        case ITEM_MEDKIT: return 11738;// H?p s? c?u th??ng
        case ITEM_ARMOR:  return 1242; // Giáp b?o h?
        case ITEM_GPS:    return 18875;// Thi?t b? ??nh v? GPS
    }
    return 0;
}

// Hàm l?y tên v?t ph?m hi?n th?
stock GetItemNameText(itemid)
{
    switch(itemid)
    {
        case ITEM_PHONE:  return "Dien Thoai";
        case ITEM_FOOD:   return "Thuc An";
        case ITEM_WATER:  return "Nuoc Uong";
        case ITEM_MEDKIT: return "Hop Cuu Thuong";
        case ITEM_ARMOR:  return "Giap Bao Ho";
        case ITEM_GPS:    return "Thiet Bi GPS";
    }
    return "Trong";
}

forward ShowPlayerInventoryUI(playerid);
public ShowPlayerInventoryUI(playerid)
{
    if(IsShowingInventory[playerid]) HidePlayerInventoryUI(playerid);

    // 1. Khung n?n chính (Black Transparent Box)
    InventoryUI[playerid][inv_Background] = CreatePlayerTextDraw(playerid, 200.0, 140.0, "_");
    PlayerTextDrawLetterSize(playerid, InventoryUI[playerid][inv_Background], 0.0, 22.0);
    PlayerTextDrawUseBox(playerid, InventoryUI[playerid][inv_Background], 1);
    PlayerTextDrawBoxColor(playerid, InventoryUI[playerid][inv_Background], 0x000000BD); // ?en m? c?c sang
    PlayerTextDrawShow(playerid, InventoryUI[playerid][inv_Background]);

    // 2. Tiêu ?? Túi ??
    InventoryUI[playerid][inv_Title] = CreatePlayerTextDraw(playerid, 210.0, 145.0, "HANH LY CUA BAN");
    PlayerTextDrawFont(playerid, InventoryUI[playerid][inv_Title], TEXT_DRAW_FONT:1);
    PlayerTextDrawLetterSize(playerid, InventoryUI[playerid][inv_Title], 0.35, 1.4);
    PlayerTextDrawColor(playerid, InventoryUI[playerid][inv_Title], 0x00FF00FF);
    PlayerTextDrawShow(playerid, InventoryUI[playerid][inv_Title]);

    // 3. Vòng l?p t? ??ng t?o L??i 10 Ô ?? v?t (L??i 5x2) d?a theo MAX_INV_SLOTS trong txt
    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        new Float:x_pos = 210.0 + (i % 5) * 46.0;
        new Float:y_pos = 170.0 + (i / 5) * 48.0;

        // T?o ô l??i vuông r?ng
        InventoryUI[playerid][inv_Slots[i]] = CreatePlayerTextDraw(playerid, x_pos, y_pos, "_");
        PlayerTextDrawLetterSize(playerid, InventoryUI[playerid][inv_Slots[i]], 0.0, 4.5);
        PlayerTextDrawTextSize(playerid, InventoryUI[playerid][inv_Slots[i]], x_pos + 42.0, 0.0);
        PlayerTextDrawUseBox(playerid, InventoryUI[playerid][inv_Slots[i]], 1);
        PlayerTextDrawBoxColor(playerid, InventoryUI[playerid][inv_Slots[i]], 0x333333AA);
        PlayerTextDrawShow(playerid, InventoryUI[playerid][inv_Slots[i]]);

        // N?u ô ?ó có ch?a v?t ph?m -> Render Model 3D & S? l??ng
        new item = PlayerData[playerid][pInvItem][i];
        new amount = PlayerData[playerid][pInvAmount][i];

        if(item != ITEM_NONE && amount > 0)
        {
            // Hi?n th? Mô hình 3D th?c th? (UEF Preview Model)
            InventoryUI[playerid][inv_ItemModels[i]] = CreatePlayerTextDraw(playerid, x_pos, y_pos, "_");
            PlayerTextDrawFont(playerid, InventoryUI[playerid][inv_ItemModels[i]], TEXT_DRAW_FONT_MODEL_PREVIEW);
            PlayerTextDrawTextSize(playerid, InventoryUI[playerid][inv_ItemModels[i]], 42.0, 40.0);
            PlayerTextDrawSetPreviewModel(playerid, InventoryUI[playerid][inv_ItemModels[i]], GetItemModelID(item));
            PlayerTextDrawSetPreviewRot(playerid, InventoryUI[playerid][inv_ItemModels[i]], -16.0, 0.0, -45.0, 1.0); // Góc xoay 3D ??p m?t
            PlayerTextDrawSetSelectable(playerid, InventoryUI[playerid][inv_ItemModels[i]], 1); // Cho phép Click vào item
            PlayerTextDrawShow(playerid, InventoryUI[playerid][inv_ItemModels[i]]);

            // S? l??ng v?t ph?m góc ô vuông
            new amt_str[12];
            format(amt_str, sizeof(amt_str), "x%d", amount);
            InventoryUI[playerid][inv_ItemAmounts[i]] = CreatePlayerTextDraw(playerid, x_pos + 25.0, y_pos + 28.0, amt_str);
            PlayerTextDrawFont(playerid, InventoryUI[playerid][inv_ItemAmounts[i]], TEXT_DRAW_FONT:1);
            PlayerTextDrawLetterSize(playerid, InventoryUI[playerid][inv_ItemAmounts[i]], 0.18, 0.9);
            PlayerTextDrawColor(playerid, InventoryUI[playerid][inv_ItemAmounts[i]], 0xFFFF00FF);
            PlayerTextDrawShow(playerid, InventoryUI[playerid][inv_ItemAmounts[i]]);
        }
        else
        {
            InventoryUI[playerid][inv_ItemModels[i]] = INVALID_PLAYER_TEXT_DRAW;
            InventoryUI[playerid][inv_ItemAmounts[i]] = INVALID_PLAYER_TEXT_DRAW;
        }
    }

    // 4. Nút ?ÓNG giao di?n b?ng chu?t
    InventoryUI[playerid][inv_CloseButton] = CreatePlayerTextDraw(playerid, 410.0, 145.0, "X");
    PlayerTextDrawFont(playerid, InventoryUI[playerid][inv_CloseButton], TEXT_DRAW_FONT:2);
    PlayerTextDrawLetterSize(playerid, InventoryUI[playerid][inv_CloseButton], 0.3, 1.2);
    PlayerTextDrawTextSize(playerid, InventoryUI[playerid][inv_CloseButton], 420.0, 12.0);
    PlayerTextDrawColor(playerid, InventoryUI[playerid][inv_CloseButton], 0xFF0000FF);
    PlayerTextDrawSetSelectable(playerid, InventoryUI[playerid][inv_CloseButton], 1);
    PlayerTextDrawShow(playerid, InventoryUI[playerid][inv_CloseButton]);

    IsShowingInventory[playerid] = true;
    SelectTextDraw(playerid, 0x00FF00FF); // Hi?n tr? chu?t màu xanh lá t??ng tác UI
    return 1;
}

forward HidePlayerInventoryUI(playerid);
public HidePlayerInventoryUI(playerid)
{
    if(!IsShowingInventory[playerid]) return 0;

    PlayerTextDrawDestroy(playerid, InventoryUI[playerid][inv_Background]);
    PlayerTextDrawDestroy(playerid, InventoryUI[playerid][inv_Title]);
    PlayerTextDrawDestroy(playerid, InventoryUI[playerid][inv_CloseButton]);

    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        PlayerTextDrawDestroy(playerid, InventoryUI[playerid][inv_Slots[i]]);
        if(InventoryUI[playerid][inv_ItemModels[i]] != INVALID_PLAYER_TEXT_DRAW)
            PlayerTextDrawDestroy(playerid, InventoryUI[playerid][inv_ItemModels[i]]);
        if(InventoryUI[playerid][inv_ItemAmounts[i]] != INVALID_PLAYER_TEXT_DRAW)
            PlayerTextDrawDestroy(playerid, InventoryUI[playerid][inv_ItemAmounts[i]]);
    }

    CancelSelectTextDraw(playerid); // T?t con tr? chu?t gi?i phóng màn hình
    IsShowingInventory[playerid] = false;
    return 1;
}