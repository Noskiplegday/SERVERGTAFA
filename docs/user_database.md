# users

Lưu dữ liệu tài khoản và nhân vật người chơi.

## Columns

| Column | Description |
|---|---|
| id | ID người dùng |
| username | Tên tài khoản |
| password_hash | Mật khẩu đã hash |
| email | Email tài khoản |
| money | Tiền mặt |
| bank_money | Tiền ngân hàng |
| skin | Skin nhân vật |
| level | Level người chơi |
| exp | Kinh nghiệm |
| job_id | Nghề nghiệp |
| admin_level | Cấp admin |
| faction | ID faction |
| faction_rank | Rank faction |
| warnings | Số cảnh cáo |
| banned | Trạng thái ban |
| jailed | Trạng thái jail |
| jail_time | Thời gian jail |
| hunger | Độ đói |
| thirst | Độ khát |
| kills | Số kills |
| deaths | Số deaths |
| playtime | Tổng thời gian chơi |
| phone | Số điện thoại |
| house | ID nhà sở hữu |
| business | ID business sở hữu |
| pos_x | Tọa độ X |
| pos_y | Tọa độ Y |
| pos_z | Tọa độ Z |
| angle | Góc xoay nhân vật |
| last_login_at | Đăng nhập cuối |
| created_at | Ngày tạo tài khoản |
| updated_at | Ngày cập nhật cuối |

## Notes

- `username` unique ở database; `email` được account flow kiểm tra trùng trước khi đăng ký
- `password_hash` không lưu mật khẩu thô
- `house = -1` nghĩa là không có nhà
- `business = -1` nghĩa là không có business
- `banned = 1` là bị ban
- `jailed = 1` là đang bị jail
