# Roadmap Server Roleplay

Roadmap nay dung de theo doi tien do gamemode `rp`. Trang thai chi chuyen `Done` khi code compile, server boot duoc, log sach loi runtime quan trong, va da test trong game neu task can gameplay/client.

## Tong Quan Trang Thai

| Giai doan | He thong | Trang thai | Ghi chu |
|---|---|---:|---|
| 1 | Core account/session/data | Doing | Da quay lai MySQL, compile duoc, server boot duoc; can test in-game register/login/save/load |
| 2 | Economy | Doing | Helper tien, bank, ATM, paycheck da co; dang luu theo player data MySQL |
| 3 | Jobs | Doing | Da co job base va 5 job mau; can test in-game va them cooldown/luu job sau khi login |
| 4 | Vehicles | Doing | Gameplay mua/xe con ton tai, JSON persistence da go; can migrate sang bang `player_vehicles` |
| 5 | Housing | Doing | Default houses con chay tam, JSON persistence da go; can migrate sang bang `houses` |
| 6 | Faction | Doing | Default factions con chay tam, JSON persistence da go; can migrate sang bang `factions`/`faction_members` |
| 7 | Social | Doing | Chat/phone/SMS/radio co khung lenh; can test RP flow |
| 8 | Inventory | Doing | Item/inventory co khung; can migrate persistence rieng |
| 9 | Admin | Doing | Rank/command admin co khung; ban/unban da chuyen sang cot `users.banned` |
| 10 | Gameplay | Doing | Spawn/death/hospital/jail co khung; can test in-game |
| 11 | Security | Todo | Can validate input, escape/rate limit, log SQL/security day du |
| 12 | Dynamic World | Todo | Chua migrate MySQL |
| 13 | Business | Doing | Default businesses con chay tam, JSON persistence da go; can migrate sang bang `businesses` |

## Phase 1: Core Bat Buoc

Muc tieu: nguoi choi co the dang ky, dang nhap, load/save du lieu on dinh bang MySQL.

- [x] Tao cau truc thu muc va file module theo `cautruc.md`.
- [x] Bo sung mo ta vai tro tung file trong `cautruc.md`.
- [x] Refactor `rp.pwn` va `gamemodes/Core/*.pwn` theo flow module.
- [x] Load plugin MySQL.
- [x] Load plugin bcrypt.
- [x] Ket noi database `vancanhcity_db`.
- [x] Tao bang database chuan ban dau cho `users`.
- [x] Chuan hoa account/player data ve MySQL, bo huong JSON file.
- [x] Luu `id`, `username`, `password`.
- [x] Luu va load tien.
- [x] Luu va load skin.
- [x] Luu va load level/exp.
- [x] Luu va load vi tri spawn.
- [x] Luu va load job hien tai.
- [x] Chan command/text/spawn khi chua dang nhap.
- [x] Auto save khi disconnect va timer session.
- [x] Tach database/connect khoi `rp.pwn` sang `gamemodes/Core/Database.pwn`.
- [x] Tach account logic sang `gamemodes/Core/Account.pwn`.
- [x] Tach player data sang `gamemodes/Core/Player_Data.pwn`.
- [x] Tao session logic trong `gamemodes/Core/Session.pwn`.
- [x] Compile duoc `gamemodes/rp.amx`.
- [x] Server boot duoc bang AMX moi, khong thay `Function not registered` trong log.
- [ ] Test in-game dang ky tai khoan moi.
- [ ] Test in-game dang nhap tai khoan cu.
- [ ] Test in-game save/load money, skin, level/exp, spawn, job sau reconnect.

Ghi chu da lam ngay 2026-05-14:
- Data source da chot ve MySQL. `users` hien gom account va player data nen Core co the chay truoc; co the tach them `player_data` sau khi Phase 1 on dinh.
- `Vehicle/Housing/Faction/Business` da go JSON file persistence. Hien dang dung default/in-memory tam thoi va can migrate sang table rieng trong phase tuong ung.
- Runtime log moi khong co `Function not registered`; co warning `mysql_connect: no password specified` vi `DB_PASS` dang rong.

## Phase 2: Economy

- [x] Tao helper cong tien.
- [x] Tao helper tru tien.
- [x] Tao helper kiem tra du tien.
- [x] Luu tien vao MySQL qua `PlayerData_Save`.
- [x] Load tien khi dang nhap qua `PlayerData_LoadFromCache`.
- [x] Them paycheck theo thoi gian.
- [x] Tao bank balance.
- [x] Gui tien vao bank.
- [x] Rut tien khoi bank.
- [x] Tao ATM checkpoint/menu co ban.
- [ ] Test in-game toan bo flow Economy.

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
- [ ] Test in-game tung job.

## Phase 4: Vehicles

- [ ] Tao bang `player_vehicles`.
- [x] Mua xe flow co ban.
- [x] Spawn xe ca nhan flow co ban.
- [ ] Despawn xe ca nhan.
- [x] Khoa/mo khoa xe flow co ban.
- [x] Fuel co ban.
- [x] Garage co ban.
- [ ] Luu vi tri xe vao MySQL.
- [ ] Luu trang thai fuel vao MySQL.

## Phase 5: Housing

- [ ] Tao bang `houses`.
- [x] Mua nha flow co ban.
- [x] Ban nha flow co ban.
- [x] Vao/ra interior.
- [x] Khoa/mo khoa nha.
- [x] Storage trong nha co khung.
- [ ] Luu/load house tu MySQL.
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
- [x] Escape query MySQL trong account/core bang `mysql_format` `%e`.
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
- [ ] Save/load dynamic world tu MySQL.

## Phase 13: Business

- [ ] Tao bang `businesses`.
- [x] Player mua shop flow co ban.
- [x] Player ban shop flow co ban.
- [x] Shop ban item co ban.
- [x] Thu tien theo gio co khung.
- [ ] Quan ly kho hang.
- [ ] Business tax optional.
- [ ] Luu/load business tu MySQL.

## Thu Tu Uu Tien Gan Nhat

1. Test in-game register/login/save/load Core voi MySQL.
2. Xu ly warning DB password: dat password MySQL that hoac chap nhan local dev rong.
3. Tach `users` va `player_data` neu muon schema sach hon.
4. Migrate Vehicles sang `player_vehicles`.
5. Migrate Housing sang `houses`.
6. Migrate Inventory sang `items` va `player_inventory`.
7. Test va sua warning compile theo tung module.

## Definition Of Done

Mot task chi chuyen sang `Done` khi:

- Code compile ra `gamemodes/rp.amx`.
- Server chay khong bao `Function not registered`.
- Log khong co loi MySQL nghiem trong.
- Test duoc trong game it nhat mot lan neu task co gameplay/client flow.
- Roadmap duoc cap nhat trang thai.
