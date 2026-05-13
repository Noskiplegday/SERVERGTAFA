# VUTRUTHIENHA Game Server

Mã nguồn server GTA SA-MP/open.mp, dùng Pawn để viết gamemode và các module gameplay.

Gamemode chính hiện tại là `rp`, được cấu hình trong `config.json`:

```json
"pawn": {
    "main_scripts": [
        "rp 1"
    ],
    "side_scripts": []
}
```

## Yêu cầu

- Windows để chạy trực tiếp bằng `omp-server.exe` có sẵn trong thư mục này.
- open.mp/SA-MP client tương thích để kết nối vào server.
- MySQL/MariaDB nếu dùng hệ thống tài khoản trong gamemode `rp`.
- Pawn compiler, có sẵn tại `qawno/pawncc.exe`.
- Các plugin đi kèm:
  - `mysql.dll`
  - `sscanf.dll`
  - `streamer.dll`
  - `bcrypt-samp.dll`
  - `crashdetect.dll`

## Tài liệu đi kèm

Repo này có một số file tài liệu và giấy phép từ các thành phần bên thứ ba:

| File | Nội dung |
| --- | --- |
| `README.md` | Tài liệu chính của server này. |
| `README.txt` | Ghi chú tiếng Việt về SA-MP Streamer Plugin. |
| `LICENSE` | Mozilla Public License 1.1, đi kèm một số thành phần/plugin mã nguồn mở. |
| `LICENSE.txt` | BSD 2-Clause License của CrashDetect. |
| `CHANGES.txt` | Lịch sử thay đổi của một thành phần/plugin đi kèm. |
| `pawn.json` | Metadata/package config của CrashDetect trong hệ sinh thái Pawn. |

README tiếng Anh cũ trong repo là tài liệu đầy đủ của riêng CrashDetect, không
phải tài liệu tổng quan của server. Vì vậy README hiện tại chỉ giữ phần cần
thiết cho việc chạy và phát triển server, còn thông tin license/plugin được
tách ra theo các file ở trên.

## Cấu trúc thư mục

```text
Server/
├── components/              # Component DLL của open.mp
├── filterscripts/           # Filterscript Pawn
├── gamemodes/               # Gamemode và source Pawn
│   ├── rp.pwn               # Gamemode roleplay chính
│   ├── Core/                # Module lõi: account, dữ liệu player, admin
│   └── Module/              # Module gameplay: economy, faction, inventory, jobs, vehicles
├── models/                  # Custom models/artwork
├── npcmodes/                # NPC mode và recording
├── plugins/                 # Plugin SA-MP/open.mp
├── qawno/                   # IDE/compiler Pawn và include
├── scriptfiles/             # Dữ liệu runtime của script
├── config.json              # Cấu hình open.mp server
└── omp-server.exe           # File chạy server
```

## Chạy server

1. Kiểm tra cấu hình trong `config.json`.
2. Đảm bảo gamemode `rp` đã được compile thành `gamemodes/rp.amx`.
3. Chạy file:

```powershell
.\omp-server.exe
```

Server mặc định chạy ở port `7777`.

Nếu chạy LAN, có thể giữ:

```json
"bind": "0.0.0.0",
"port": 7777
```

Nếu public server, kiểm tra lại các mục:

- `network.public_addr`
- `announce`
- `name`
- `password`
- firewall/NAT port `7777`

## Compile gamemode

Compile gamemode chính bằng Pawn compiler trong `qawno`:

```powershell
.\qawno\pawncc.exe .\gamemodes\rp.pwn -i.\qawno\include -o.\gamemodes\rp.amx
```

Sau khi compile thành công, chạy lại server để load bản mới.

## Cấu hình database

Gamemode `rp` đang kết nối MySQL trong `gamemodes/Core/Account.pwn`:

```pawn
mysql_connect("127.0.0.1", "root", "", "gta_server");
```

Trước khi chạy hệ thống tài khoản, cần tạo database `gta_server` hoặc đổi lại thông tin kết nối cho đúng môi trường của bạn.

Schema tối thiểu cho bảng `players`:

```sql
CREATE TABLE `players` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(24) NOT NULL UNIQUE,
    `password` VARCHAR(128) NOT NULL,
    `money` INT NOT NULL DEFAULT 5000,
    `level` INT NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`)
);
```

## Cấu hình quan trọng

Các mục thường chỉnh trong `config.json`:

| Mục | Ý nghĩa |
| --- | --- |
| `name` | Tên server hiển thị |
| `max_players` | Số người chơi tối đa |
| `network.port` | Port server |
| `network.public_addr` | IP public/LAN quảng bá |
| `password` | Mật khẩu vào server, để rỗng nếu không khóa |
| `rcon.enable` | Bật/tắt RCON |
| `rcon.password` | Mật khẩu RCON |
| `pawn.main_scripts` | Danh sách gamemode chính |
| `logging.file` | File log server |

Lưu ý: không nên dùng mật khẩu RCON mặc định khi public server.

## Gamemode và module hiện có

- `gamemodes/rp.pwn`: gamemode roleplay chính.
- `gamemodes/Core/Account.pwn`: kết nối database, đăng ký, đăng nhập, lưu dữ liệu.
- `gamemodes/Core/Player_Data.pwn`: xử lý kiểm tra mật khẩu và load dữ liệu player.
- `gamemodes/Core/Admin_System.pwn`: module admin, hiện chưa có nội dung.
- `gamemodes/Module/Economy/Economy.pwn`: module kinh tế.
- `gamemodes/Module/Faction/Factions.pwn`: module faction.
- `gamemodes/Module/Inventory/Inventory.pwn`: module inventory.
- `gamemodes/Module/Jobs/Jobs.pwn`: module job.
- `gamemodes/Module/Vehicles/Vehicles.pwn`: module vehicle.

Ngoài ra repo còn có các gamemode mẫu như `gungame`, `derby`, `simpletdm`.

## Log và debug

- Log chính được ghi vào `log.txt`.
- `crashdetect.dll` có thể hỗ trợ debug lỗi runtime.
- Khi gặp lỗi script, kiểm tra `log.txt` trước.
- Nếu server không load gamemode, kiểm tra:
  - `gamemodes/rp.amx` có tồn tại không.
  - Plugin cần thiết đã có trong `plugins/` hoặc thư mục gốc chưa.
  - Include và plugin MySQL/bcrypt có đúng phiên bản không.

## Plugin bên thứ ba

Server đang dùng hoặc có sẵn một số plugin/thành phần bên thứ ba:

| Thành phần | File liên quan | Công dụng |
| --- | --- | --- |
| CrashDetect | `crashdetect.dll`, `crashdetect.inc`, `LICENSE.txt`, `pawn.json` | Hỗ trợ debug lỗi runtime và crash trong Pawn. |
| Streamer Plugin | `plugins/streamer.dll`, `plugins/streamer.so`, `README.txt` | Stream object, pickup, checkpoint, 3D text label, actor... |
| MySQL Plugin | `plugins/mysql.dll`, `libmariadb.dll` | Kết nối gamemode với MySQL/MariaDB. |
| sscanf | `plugins/sscanf.dll`, `amxsscanf.dll`, `pawno/include/sscanf2.inc` | Parse chuỗi/tham số command trong Pawn. |
| bcrypt | `plugins/bcrypt-samp.dll`, `plugins/bcrypt.inc` | Hash và kiểm tra mật khẩu tài khoản. |

Khi cập nhật hoặc phân phối server, nên giữ lại file license và tài liệu đi kèm
của các plugin này.

## Giấy phép

Mã nguồn server và các file đi kèm có thể không dùng chung một giấy phép duy
nhất. Repo hiện có ít nhất các giấy phép sau:

Được cấp phép theo giấy phép BSD 2 điều khoản. Giấy phép tại [LICENSE.txt](LICENSE.txt)

Các file binary/plugin trong repo có thể thuộc license riêng của tác giả gốc.
Nếu public hoặc phát hành lại server, hãy giữ nguyên các file license, copyright
và ghi chú nguồn gốc của plugin.

## Ghi chú phát triển

- Source Pawn nên đặt trong `gamemodes/`.
- Module dùng cho gamemode `rp` nên đặt theo nhóm trong `gamemodes/Core/` hoặc `gamemodes/Module/`.
- Không commit file log runtime nếu không cần thiết.
- Sau khi sửa `.pwn`, cần compile lại `.amx` trước khi chạy server.
