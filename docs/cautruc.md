# Cấu Trúc Dự Án

Tài liệu này là chuẩn tổ chức source cho gamemode roleplay. Khi thêm tính năng mới, tạo file đúng vị trí trong cây này rồi cập nhật `roadmap.md`.

## Mục Tiêu

- `gamemodes/rp.pwn` là entry chính của gamemode.
- `gamemodes/Core/` chứa hệ thống bắt buộc để server chạy ổn định.
- `gamemodes/Module/` chứa gameplay có thể phát triển từng phần.
- Mỗi file `.pwn` chỉ nên phụ trách một nhóm logic rõ ràng.
- File generated như `.amx`, `.xml`, log runtime và gamemode mẫu không được xem là source module chính.

## Cấu Trúc Source Chính

```text
gamemodes/
|-- rp.pwn
|-- rp.amx
|-- Core/
|   |-- Account.pwn
|   |-- Player_Data.pwn
|   |-- Session.pwn
|   |-- Database.pwn
|   `-- Admin_System.pwn
`-- Module/
    |-- Economy/
    |   |-- Economy.pwn
    |   |-- Bank.pwn
    |   `-- ATM.pwn
    |-- Jobs/
    |   |-- Jobs.pwn
    |   |-- Taxi.pwn
    |   |-- Bus.pwn
    |   |-- Delivery.pwn
    |   |-- Garbage.pwn
    |   `-- Mining.pwn
    |-- Vehicles/
    |   |-- Vehicles.pwn
    |   |-- Vehicle_Ownership.pwn
    |   |-- Vehicle_Fuel.pwn
    |   `-- Garage.pwn
    |-- Housing/
    |   |-- Housing.pwn
    |   |-- House_Interior.pwn
    |   `-- House_Storage.pwn
    |-- Faction/
    |   |-- Factions.pwn
    |   |-- Faction_Rank.pwn
    |   |-- Faction_Duty.pwn
    |   |-- Faction_Vehicles.pwn
    |   `-- Faction_Locker.pwn
    |-- Social/
    |   |-- Chat.pwn
    |   |-- Phone.pwn
    |   |-- SMS.pwn
    |   `-- Radio.pwn
    |-- Inventory/
    |   |-- Inventory.pwn
    |   |-- Items.pwn
    |   `-- Storage.pwn
    |-- Gameplay/
    |   |-- Spawn.pwn
    |   |-- Death.pwn
    |   |-- Hospital.pwn
    |   `-- Jail.pwn
    |-- Security/
    |   |-- AntiCheat.pwn
    |   |-- AntiCrash.pwn
    |   `-- Server_Log.pwn
    |-- World/
    |   |-- Dynamic_Object.pwn
    |   |-- Dynamic_House.pwn
    |   |-- Dynamic_Faction.pwn
    |   `-- Dynamic_Business.pwn
    `-- Business/
        |-- Business.pwn
        |-- Shop.pwn
        `-- Business_Income.pwn
```

## File Ngoài Source Chính

Các file này có thể còn tồn tại trong project nhưng không thuộc cấu trúc module roleplay:

| File | Vai trò |
|---|---|
| `gamemodes/derby.pwn`, `derby.amx` | Gamemode mẫu của open.mp, không thuộc RP chính. |
| `gamemodes/gungame.pwn`, `gungame.amx` | Gamemode mẫu của open.mp, không thuộc RP chính. |
| `gamemodes/simpletdm.pwn`, `simpletdm.amx` | Gamemode mẫu của open.mp, không thuộc RP chính. |
| `gamemodes/rp.xml` | File tài liệu/generated từ compiler hoặc tool, không sửa tay. |
| `gamemodes/Core/*.xml` | File generated/tài liệu, không phải source chính. |
| `gamemodes/Core/*.amx` | File compile nhầm vị trí hoặc generated, source chính vẫn là `.pwn`. |
| `log.txt`, `logs/` | Log runtime, dùng để debug, không chứa logic gameplay. |

Nếu muốn cây `gamemodes/` sạch tuyệt đối, chuyển các gamemode mẫu sang thư mục lưu trữ hoặc xóa sau khi đã chắc chắn không cần dùng.

## Mô Tả File Chính

### Gamemode Root

| File | Chứa gì | Không nên chứa |
|---|---|---|
| `gamemodes/rp.pwn` | Include, callback tổng, khởi động gamemode, gọi init module. | Logic dài của account, job, xe, nhà, faction. |
| `gamemodes/rp.amx` | File compile để server load. | Không sửa tay. |

### Core

| File | Chứa gì |
|---|---|
| `Core/Database.pwn` | Kết nối MySQL, handle database, helper query chung, log lỗi SQL. |
| `Core/Account.pwn` | Đăng ký, đăng nhập, hash/check mật khẩu, dialog account. |
| `Core/Player_Data.pwn` | Load/save dữ liệu player: tiền, skin, level, exp, job, vị trí. |
| `Core/Session.pwn` | Trạng thái đăng nhập, chặn chơi khi chưa login, auto load/auto save. |
| `Core/Admin_System.pwn` | Admin rank, kick, ban, warn, spectate, teleport, freeze, admin log. |

### Economy

| File | Chứa gì |
|---|---|
| `Economy/Economy.pwn` | Helper cộng/trừ tiền, kiểm tra đủ tiền, paycheck cơ bản. |
| `Economy/Bank.pwn` | Số dư ngân hàng, gửi tiền, rút tiền, chuyển tiền. |
| `Economy/ATM.pwn` | Vị trí ATM, menu ATM, luồng thao tác với bank. |

### Jobs

| File | Chứa gì |
|---|---|
| `Jobs/Jobs.pwn` | Job hiện tại, nhận/bỏ job, helper thưởng tiền, cooldown nhiệm vụ. |
| `Jobs/Taxi.pwn` | Job taxi: nhận khách, trả khách, tính tiền. |
| `Jobs/Bus.pwn` | Job bus: tuyến đường, checkpoint, lương theo tuyến. |
| `Jobs/Delivery.pwn` | Job giao hàng: nhận hàng, giao hàng, hoàn thành nhiệm vụ. |
| `Jobs/Garbage.pwn` | Job dọn rác: điểm thu gom, xe rác, thưởng. |
| `Jobs/Mining.pwn` | Job đào khoáng: đào, nhận vật phẩm, bán khoáng. |

### Vehicles

| File | Chứa gì |
|---|---|
| `Vehicles/Vehicles.pwn` | Helper xe chung, spawn/despawn, kiểm tra quyền dùng xe. |
| `Vehicles/Vehicle_Ownership.pwn` | Mua xe, bán xe, chủ sở hữu, lưu xe vào database. |
| `Vehicles/Vehicle_Fuel.pwn` | Xăng, hao xăng, đổ xăng, lưu fuel. |
| `Vehicles/Garage.pwn` | Garage, lấy xe, cất xe, vị trí spawn xe cá nhân. |

### Housing

| File | Chứa gì |
|---|---|
| `Housing/Housing.pwn` | Mua/bán nhà, chủ nhà, giá nhà, trạng thái khóa. |
| `Housing/House_Interior.pwn` | Vào/ra nhà, teleport interior, vị trí cửa. |
| `Housing/House_Storage.pwn` | Kho đồ trong nhà, quyền truy cập storage. |

### Faction

| File | Chứa gì |
|---|---|
| `Faction/Factions.pwn` | Danh sách faction, thành viên faction, helper faction chung. |
| `Faction/Faction_Rank.pwn` | Rank, quyền hạn, thăng/giáng chức. |
| `Faction/Faction_Duty.pwn` | On duty/off duty, trang bị khi duty. |
| `Faction/Faction_Vehicles.pwn` | Xe faction, quyền dùng xe faction. |
| `Faction/Faction_Locker.pwn` | Tủ đồ faction, lấy/cất item theo rank. |

### Social

| File | Chứa gì |
|---|---|
| `Social/Chat.pwn` | Chat IC, OOC, local chat, format tin nhắn. |
| `Social/Phone.pwn` | Số điện thoại, cuộc gọi, danh bạ, trạng thái điện thoại. |
| `Social/SMS.pwn` | Gửi/nhận SMS, lịch sử tin nhắn nếu cần. |
| `Social/Radio.pwn` | Radio faction/job, kênh chat nội bộ. |

### Inventory

| File | Chứa gì |
|---|---|
| `Inventory/Inventory.pwn` | Túi đồ player, add/remove item, load/save inventory. |
| `Inventory/Items.pwn` | Định nghĩa item: food, weapon, tool, material. |
| `Inventory/Storage.pwn` | Storage dùng chung cho nhà, xe, faction locker. |

### Gameplay

| File | Chứa gì |
|---|---|
| `Gameplay/Spawn.pwn` | Spawn system, newbie spawn, spawn đã lưu. |
| `Gameplay/Death.pwn` | Death state, mất đồ/tiền nếu có, điều kiện respawn. |
| `Gameplay/Hospital.pwn` | Hospital respawn, hồi máu, phí bệnh viện nếu có. |
| `Gameplay/Jail.pwn` | Jail state, thời gian tù, thả tù, liên kết faction/admin. |

### Security

| File | Chứa gì |
|---|---|
| `Security/AntiCheat.pwn` | Check tiền, weapon, teleport, spam command. |
| `Security/AntiCrash.pwn` | Validate ID player/vehicle/object, chặn state bất thường. |
| `Security/Server_Log.pwn` | Helper ghi log admin, login, SQL, security. |

### World

| File | Chứa gì |
|---|---|
| `World/Dynamic_Object.pwn` | Tạo/sửa/xóa object động, save/load object. |
| `World/Dynamic_House.pwn` | Tạo nhà động, sửa giá/vị trí/interior. |
| `World/Dynamic_Faction.pwn` | Tạo faction động, cấu hình faction. |
| `World/Dynamic_Business.pwn` | Tạo business động, vị trí, loại business. |

### Business

| File | Chứa gì |
|---|---|
| `Business/Business.pwn` | Chủ business, mua/bán business, trạng thái hoạt động. |
| `Business/Shop.pwn` | Shop bán item, giá bán, kho hàng. |
| `Business/Business_Income.pwn` | Thu nhập theo giờ, lợi nhuận, thuế nếu có. |

## Workflow Phát Triển

1. Chọn task trong `roadmap.md`.
2. Viết code trong đúng file module.
3. Nếu module cần dùng ở runtime, include vào `rp.pwn`.
4. Compile:

```powershell
.\qawno\pawncc.exe .\gamemodes\rp.pwn "-i.\qawno\include" "-i.\pawno\include" "-i.\plugins" "-o.\gamemodes\rp.amx"
```

5. Chạy `omp-server.exe`.
6. Kiểm tra `log.txt`, `logs/errors.log`, `logs/warnings.log`, `logs/plugins/mysql.log`.
7. Test trong game.
8. Cập nhật trạng thái trong `roadmap.md`.
9. Commit theo từng nhóm nhỏ.

## Quy Ước Trạng Thái

- `Todo`: chưa làm.
- `Doing`: đang làm.
- `Done`: đã làm và đã test cơ bản.
- `Blocked`: bị chặn do thiếu plugin, database, asset hoặc quyết định thiết kế.

## Quy Ước Database

Nên tách bảng theo từng hệ:

```text
users
player_data
player_vehicles
player_houses
player_inventory
jobs
factions
faction_members
businesses
server_logs
```

Core phải ổn định trước khi làm module lớn, vì Economy, Jobs, Vehicles, Housing và Faction đều phụ thuộc vào dữ liệu người chơi và session đăng nhập.
