# Roadmap Server Roleplay

Roadmap nay dung de theo doi tien do gamemode `rp`. Trang thai chi chuyen `Done` khi code compile, server boot duoc, log sach loi runtime quan trong, va da test trong game neu task can gameplay/client.

## Tong Quan Trang Thai

| Giai doan | He thong | Trang thai | Ghi chu |
|---|---|---:|---|
| 1 | Core account/session/data | Doing | Dang chuyen sang Supabase PostgreSQL; connection da test OK bang psql, runtime Pawn can bridge/plugin |
| 2 | Economy | Doing | Helper tien, bank, ATM, paycheck da co; dang luu theo player data database |
| 3 | Jobs | Doing | Da co job base va 5 job mau; can test in-game va them cooldown/luu job sau khi login |
| 4 | Vehicles | Doing | Gameplay mua/xe con ton tai, JSON persistence da go; can migrate sang bang `player_vehicles` |
| 5 | Housing | Doing | Default houses con chay tam, JSON persistence da go; can migrate sang bang `houses` |
| 6 | Faction | Doing | Default factions con chay tam, JSON persistence da go; can migrate sang bang `factions`/`faction_members` |
| 7 | Social | Doing | Chat/phone/SMS/radio co khung lenh; can test RP flow |
| 8 | Inventory | Doing | Item/inventory co khung; can migrate persistence rieng |
| 9 | Admin | Doing | Rank/command admin co khung; ban/unban da chuyen sang cot `users.banned` |
| 10 | Gameplay | Doing | Spawn/death/hospital/jail co khung; can test in-game |
| 11 | Security | Todo | Can validate input, escape/rate limit, log SQL/security day du |
| 12 | Dynamic World | Todo | Chua migrate database |
| 13 | Business | Doing | Default businesses con chay tam, JSON persistence da go; can migrate sang bang `businesses` |

## Phase 1: Core
    Cơ bản OK xóa đỡ phiền

## Phase 2: Economy

- [x] Tao helper cong tien.
- [x] Tao helper tru tien.
- [x] Tao helper kiem tra du tien.
- [ ] Luu tien vao SQL qua `PlayerData_Save`.
- [x] Load tien khi dang nhap qua `PlayerData_LoadFromCache`.
- [x] Them paycheck theo thoi gian.
- [x] Tao bank balance.
- [x] Gui tien vao bank.
- [x] Rut tien khoi bank.
- [x] Tao ATM checkpoint/menu co ban.

## Phase 3: Jobs

- [x] Tao he nhan job.
- [x] Tao he bo job.
- [ ] Tao cooldown nhiem vu.
- [x] Job Taxi: nhan/trien khai checkpoint co ban.
- [x] Job Bus: chay tuyen checkpoint co ban.
- [x] Job Delivery: lay/giao hang co ban.
- [x] Job Garbage: thu gom rac co ban.
- [x] Job Mining: dao khoang co ban.
- [x] Luu job hien tai vao database qua `users.job`.

## Phase 4: Vehicles

- [ ] Tao bang `player_vehicles`.
- [x] Mua xe flow co ban.
- [x] Spawn xe ca nhan flow co ban.
- [ ] Despawn xe ca nhan.
- [x] Khoa/mo khoa xe flow co ban.
- [x] Fuel co ban.
- [x] Garage co ban.
- [ ] Luu vi tri xe vao database.
- [ ] Luu trang thai fuel vao database.

## Phase 5: Housing

- [ ] Tao bang `houses`.
- [x] Mua nha flow co ban.
- [x] Ban nha flow co ban.
- [x] Vao/ra interior.
- [x] Khoa/mo khoa nha.
- [x] Storage trong nha co khung.
- [ ] Luu/load house tu database.
- [ ] Upgrade nha.

## Phase 6: Faction

- [ ] Tao bang `factions`.
- [ ] Tao bang `faction_members`.
- [x] Police faction default.
- [x] EMS faction default.
- [x] Government faction default.
- [x] Gang/Mafia faction default.
- [x] Rank system co khung.
- [x] Duty on/off.
- [x] Faction vehicles default.
- [x] Faction locker co khung.
- [x] Radio faction co khung.

## Phase 7: Social

- [x] Chat IC.
- [x] Chat OOC.
- [x] Phone system co khung.
- [x] Goi dien co khung.
- [x] SMS co khung.
- [x] Radio co khung.
- [ ] Danh ba co ban.
- [ ] Test in-game social flow.

## Phase 8: Inventory

- [ ] Tao bang `items`.
- [ ] Tao bang `player_inventory`.
- [x] Them item food.
- [x] Them item tool/basic items.
- [x] Them item weapon co khung.
- [x] Dung item co khung.
- [ ] Drop item.
- [x] Storage trong nha co khung.
- [ ] Storage trong xe.
- [x] Storage trong faction locker co khung.

## Phase 9: Admin

- [x] Admin rank.
- [x] Lenh kick.
- [x] Lenh ban.
- [x] Lenh warn.
- [x] Spectate player.
- [x] Teleport toi player.
- [x] Teleport player toi minh.
- [x] Spawn vehicle.
- [x] Freeze/unfreeze player.
- [x] Ghi log admin action co ban.
- [ ] Test in-game permission/rank.

## Phase 10: Gameplay

- [x] Spawn system co ban.
- [x] Death system co ban.
- [x] Hospital respawn co ban.
- [x] Jail system co ban.
- [x] Hunger/thirst co ban.
- [ ] Newbie spawn flow.
- [ ] Tutorial ngan cho nguoi moi.
- [ ] Test in-game gameplay loop.

## Phase 11: Security

- [ ] Validate input dialog.
- [ ] Escape/parameterize query PostgreSQL trong account/core qua bridge/plugin.
- [ ] Rate limit lenh nhay cam.
- [ ] Anti money cheat.
- [ ] Anti weapon cheat co ban.
- [ ] Anti teleport bat thuong.
- [ ] Log loi SQL.
- [ ] Log login/register.
- [ ] Backup database dinh ky.

## Phase 12: Dynamic World

- [ ] Dynamic objects.
- [ ] Dynamic houses.
- [ ] Dynamic factions.
- [ ] Dynamic businesses.
- [ ] Admin command tao object/house/business.
- [ ] Save/load dynamic world tu database.

## Phase 13: Business

- [ ] Tao bang `businesses`.
- [x] Player mua shop flow co ban.
- [x] Player ban shop flow co ban.
- [x] Shop ban item co ban.
- [x] Thu tien theo gio co khung.
- [ ] Quan ly kho hang.
- [ ] Business tax optional.
- [ ] Luu/load business tu database.

## Thu Tu Uu Tien Gan Nhat

1. Tich hop PostgreSQL bridge/plugin de gamemode query Supabase.
2. Test in-game register/login/save/load Core voi Supabase PostgreSQL.
3. Tach `users` va `player_data` neu muon schema sach hon.
4. Migrate Vehicles sang `player_vehicles`.
5. Migrate Housing sang `houses`.
6. Migrate Inventory sang `items` va `player_inventory`.
7. Test va sua warning compile theo tung module.

## Definition Of Done

Mot task chi chuyen sang `Done` khi:

- Code compile ra `gamemodes/rp.amx`.
- Server chay khong bao `Function not registered`.
- Log khong co loi database nghiem trong.
- Test duoc trong game it nhat mot lan neu task co gameplay/client flow.
- Roadmap duoc cap nhat trang thai.
