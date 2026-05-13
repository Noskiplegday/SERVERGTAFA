# Roadmap Server Roleplay

Roadmap này dùng để theo dõi thứ tự làm việc dựa trên `NewbornSV.txt`. Cập nhật trạng thái sau mỗi lần hoàn thành hoặc test.

## Tổng Quan Trạng Thái

| Giai đoạn | Hệ thống | Trạng thái | Ghi chú |
|---|---|---:|---|
| 1 | Core account/session/data | Doing | Đã có login/register nền trong `rp.pwn`, cần tách module và hoàn thiện load/save |
| 2 | Economy | Todo | Cần trước Jobs, Vehicles, Housing |
| 3 | Jobs | Todo | Nguồn tiền chính cho người chơi |
| 4 | Vehicles | Todo | Mua xe, spawn xe, khóa xe, fuel, garage |
| 5 | Housing | Todo | Nhà, interior, storage |
| 6 | Faction | Todo | Police, EMS, Government, Gang/Mafia |
| 7 | Social | Todo | Phone, SMS, IC/OOC chat, radio |
| 8 | Inventory | Todo | Item, weapon, food, tools, storage |
| 9 | Admin | Todo | Rank, kick/ban/warn, spectate, teleport |
| 10 | Gameplay | Todo | Spawn, death, hospital, jail |
| 11 | Security | Todo | Anti cheat, anti crash, log, MySQL protection |
| 12 | Dynamic World | Todo | Dynamic objects, houses, factions, businesses |
| 13 | Business | Todo | Shop người chơi sở hữu, bán đồ, thu tiền |

## Phase 1: Core Bắt Buộc

Mục tiêu: người chơi có thể đăng ký, đăng nhập, load/save dữ liệu ổn định.

- [x] Tạo cấu trúc thư mục và file module theo `cautruc.md`.
- [x] Bổ sung mô tả vai trò từng file trong `cautruc.md`.
- [x] Refactor `rp.pwn` và `gamemodes/Core/*.pwn` theo flow trong `cautruc.md`.
- [x] Load plugin MySQL.
- [x] Load plugin bcrypt.
- [x] Kết nối database `vancanhcity_db`.
- [x] Compile được `gamemodes/rp.amx`.
- [x] Có register/login cơ bản.
- [ ] Tạo bảng database chuẩn cho `users` và dữ liệu người chơi.
- [ ] Lưu `id`, `username`, `password`.
- [ ] Lưu và load tiền.
- [ ] Lưu và load skin.
- [ ] Lưu và load level/exp.
- [ ] Lưu và load vị trí spawn.
- [ ] Lưu và load job hiện tại.
- [ ] Chặn chơi khi chưa đăng nhập.
- [ ] Auto save khi disconnect.
- [ ] Tách database/connect khỏi `rp.pwn` sang `gamemodes/Core/Database.pwn`.
- [ ] Tách account logic sang `gamemodes/Core/Account.pwn`.
- [ ] Tách player data sang `gamemodes/Core/Player_Data.pwn`.
- [ ] Tạo session logic trong `gamemodes/Core/Session.pwn`.

## Phase 2: Economy

Mục tiêu: có nền tiền tệ để các hệ khác dùng.

- [ ] Tạo helper cộng tiền.
- [ ] Tạo helper trừ tiền.
- [ ] Tạo helper kiểm tra đủ tiền.
- [ ] Lưu tiền vào MySQL.
- [ ] Load tiền khi đăng nhập.
- [ ] Thêm paycheck theo thời gian.
- [ ] Tạo bank balance.
- [ ] Gửi tiền vào bank.
- [ ] Rút tiền khỏi bank.
- [ ] Tạo ATM checkpoint/menu cơ bản.

## Phase 3: Jobs

Mục tiêu: người chơi có cách kiếm tiền hợp lệ.

- [ ] Tạo hệ nhận job.
- [ ] Tạo hệ bỏ job.
- [ ] Tạo cooldown nhiệm vụ.
- [ ] Job Taxi: nhận khách, trả khách, nhận tiền.
- [ ] Job Bus: chạy tuyến, nhận tiền theo checkpoint.
- [ ] Job Delivery: lấy hàng, giao hàng.
- [ ] Job Garbage: thu gom rác theo điểm.
- [ ] Job Mining: đào khoáng, bán khoáng.
- [ ] Lưu job hiện tại vào database.

## Phase 4: Vehicles

Mục tiêu: người chơi có phương tiện cá nhân.

- [ ] Tạo bảng `player_vehicles`.
- [ ] Mua xe.
- [ ] Spawn xe cá nhân.
- [ ] Despawn xe cá nhân.
- [ ] Khóa/mở khóa xe.
- [ ] Fuel cơ bản.
- [ ] Garage cơ bản.
- [ ] Lưu vị trí xe.
- [ ] Lưu trạng thái fuel.

## Phase 5: Housing

Mục tiêu: người chơi có nhà và chỗ lưu đồ.

- [ ] Tạo bảng `houses`.
- [ ] Mua nhà.
- [ ] Bán nhà.
- [ ] Vào/ra interior.
- [ ] Khóa/mở khóa nhà.
- [ ] Storage trong nhà.
- [ ] Upgrade nhà.

## Phase 6: Faction

Mục tiêu: tạo tổ chức RP chính.

- [ ] Tạo bảng `factions`.
- [ ] Tạo bảng `faction_members`.
- [ ] Police faction.
- [ ] EMS faction.
- [ ] Government faction.
- [ ] Gang/Mafia faction.
- [ ] Rank system.
- [ ] Duty on/off.
- [ ] Faction vehicles.
- [ ] Faction locker.
- [ ] Radio faction.

## Phase 7: Social

Mục tiêu: tăng tương tác RP giữa người chơi.

- [ ] Chat IC.
- [ ] Chat OOC.
- [ ] Phone system.
- [ ] Gọi điện.
- [ ] SMS.
- [ ] Radio.
- [ ] Danh bạ cơ bản.

## Phase 8: Inventory

Mục tiêu: quản lý item và storage.

- [ ] Tạo bảng `items`.
- [ ] Tạo bảng `player_inventory`.
- [ ] Thêm item food.
- [ ] Thêm item tool.
- [ ] Thêm item weapon nếu cần.
- [ ] Dùng item.
- [ ] Drop item.
- [ ] Storage trong nhà.
- [ ] Storage trong xe.
- [ ] Storage trong faction locker.

## Phase 9: Admin

Mục tiêu: có công cụ vận hành server.

- [ ] Admin rank.
- [ ] Lệnh kick.
- [ ] Lệnh ban.
- [ ] Lệnh warn.
- [ ] Spectate player.
- [ ] Teleport tới player.
- [ ] Teleport player tới mình.
- [ ] Spawn vehicle.
- [ ] Freeze/unfreeze player.
- [ ] Ghi log admin action.

## Phase 10: Gameplay

Mục tiêu: hoàn thiện vòng chơi cơ bản.

- [ ] Spawn system.
- [ ] Death system.
- [ ] Hospital respawn.
- [ ] Jail system.
- [ ] Hunger/thirst optional.
- [ ] Newbie spawn flow.
- [ ] Tutorial ngắn cho người mới.

## Phase 11: Security

Mục tiêu: giảm lỗi và chống phá.

- [ ] Validate input dialog.
- [ ] Escape toàn bộ query MySQL.
- [ ] Rate limit lệnh nhạy cảm.
- [ ] Anti money cheat.
- [ ] Anti weapon cheat cơ bản.
- [ ] Anti teleport bất thường.
- [ ] Log lỗi SQL.
- [ ] Log login/register.
- [ ] Backup database định kỳ.

## Phase 12: Dynamic World

Mục tiêu: dễ mở rộng nội dung server.

- [ ] Dynamic objects.
- [ ] Dynamic houses.
- [ ] Dynamic factions.
- [ ] Dynamic businesses.
- [ ] Admin command tạo object/house/business.
- [ ] Save/load dynamic world từ MySQL.

## Phase 13: Business

Mục tiêu: tạo hệ kinh tế nâng cao cho server lớn.

- [ ] Tạo bảng `businesses`.
- [ ] Player mua shop.
- [ ] Player bán shop.
- [ ] Shop bán item.
- [ ] Thu tiền theo giờ.
- [ ] Quản lý kho hàng.
- [ ] Business tax optional.

## Thứ Tự Ưu Tiên Gần Nhất

1. Sửa encoding tiếng Việt trong `rp.pwn` và các file Core.
2. Chuẩn hóa database: thống nhất dùng `users` hay `players`.
3. Hoàn thiện login/register và load password đúng cách.
4. Tách Core ra khỏi `rp.pwn`.
5. Làm Economy helper.
6. Làm Job Taxi hoặc Delivery làm job mẫu đầu tiên.
7. Dùng job mẫu làm template cho các job còn lại.

## Definition Of Done

Một task chỉ chuyển sang `Done` khi:

- Code compile ra `gamemodes/rp.amx`.
- Server chạy không báo `Function not registered`.
- Log không có lỗi MySQL.
- Test được trong game ít nhất một lần.
- Roadmap được cập nhật trạng thái.
