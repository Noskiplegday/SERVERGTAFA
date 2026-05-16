# Database

Result: `1`

Current tables in `public` schema:

| Table | Purpose |
|---|---|
| users | Account and player state |
| factions | Faction definitions |
| families | Family relationship records |
| jobs | Job definitions |
| missions | Mission ownership and status |
| family_relations | CCCD-based family links |

## users

| Column | Type | Nullable | Default | Notes |
|---|---|---:|---|---|
| id | bigint | no |  | Primary key |
| username | varchar | no |  | Account name |
| password_hash | text | no |  | bcrypt hash |
| email | varchar | no |  | Account email |
| cccd | varchar | no |  | Citizen ID / roleplay identity number |
| role | varchar | no | `'member'` | Account role |
| mission | varchar | no | `'none'` | Current mission label/status shortcut |
| money | integer | no | `500` | Cash |
| bank_money | integer | no | `0` | Bank balance |
| skin | integer | no | `26` | Player skin |
| level | integer | no | `1` | Player level |
| exp | integer | no | `0` | Experience |
| job_id | bigint | yes |  | FK-style reference to `jobs.id` |
| faction_id | bigint | yes |  | FK-style reference to `factions.id` |
| faction_rank | integer | no | `0` | Rank inside faction |
| admin_level | integer | no | `0` | Admin permission level |
| warnings | integer | no | `0` | Warning count |
| banned | boolean | no | `false` | Ban status |
| jailed | boolean | no | `false` | Jail status |
| jail_time | integer | no | `0` | Jail time left |
| hunger | integer | no | `100` | Hunger status |
| thirst | integer | no | `100` | Thirst status |
| kills | integer | no | `0` | Kill count |
| deaths | integer | no | `0` | Death count |
| playtime | integer | no | `0` | Total playtime |
| phone | varchar | yes |  | Phone number |
| house_id | bigint | yes |  | Owned house reference |
| business_id | bigint | yes |  | Owned business reference |
| pos_x | double precision | no | `0` | Position X |
| pos_y | double precision | no | `0` | Position Y |
| pos_z | double precision | no | `0` | Position Z |
| angle | double precision | no | `0` | Facing angle |
| last_login_at | timestamp | yes |  | Last login timestamp |
| created_at | timestamp | no | `now()` | Created timestamp |
| updated_at | timestamp | no | `now()` | Updated timestamp |

## factions

| Column | Type | Nullable | Default | Notes |
|---|---|---:|---|---|
| id | bigint | no |  | Primary key |
| name | varchar | no |  | Internal faction name |
| label | varchar | no |  | Display label |
| type | varchar | no | `'civil'` | Faction type |
| created_at | timestamp | no | `now()` | Created timestamp |

## families

| Column | Type | Nullable | Default | Notes |
|---|---|---:|---|---|
| id | bigint | no |  | Primary key |
| family_code | varchar | no |  | Family code |
| dad_id | bigint | yes |  | User id |
| mom_id | bigint | yes |  | User id |
| child_1_id | bigint | yes |  | User id |
| child_2_id | bigint | yes |  | User id |
| child_3_id | bigint | yes |  | User id |
| created_at | timestamp | no | `now()` | Created timestamp |

## jobs

| Column | Type | Nullable | Default | Notes |
|---|---|---:|---|---|
| id | bigint | no |  | Primary key |
| name | varchar | no |  | Internal job name |
| label | varchar | no |  | Display label |
| base_salary | integer | no | `0` | Base salary |
| created_at | timestamp | no | `now()` | Created timestamp |

## missions

| Column | Type | Nullable | Default | Notes |
|---|---|---:|---|---|
| id | bigint | no |  | Primary key |
| owner_user_id | bigint | yes |  | Owner user id |
| owner_cccd | varchar(16) | yes |  | Owner CCCD |
| title | varchar | no |  | Mission title |
| status | varchar | no | `'pending'` | `pending`, `active`, `done`, etc. |
| created_at | timestamp | no | `now()` | Created timestamp |
| updated_at | timestamp | no | `now()` | Updated timestamp |

## family_relations

| Column | Type | Nullable | Default | Notes |
|---|---|---:|---|---|
| id | bigint | no |  | Primary key |
| user_id | bigint | yes |  | User id |
| user_cccd | varchar(16) | no |  | User CCCD |
| relative_user_id | bigint | yes |  | Related user id |
| relative_cccd | varchar(16) | no |  | Related user CCCD |
| relation | varchar | no |  | Cha, Me, Anh trai, Em gai, Co, Di, Chu, Bac... |
| created_at | timestamp | no | `now()` | Created timestamp |

## Gamemode Mapping Notes

The old gamemode fields need these PostgreSQL column mappings:

| Gamemode field/query | Current database column |
|---|---|
| `faction` | `faction_id` |
| `house` | `house_id` |
| `business` | `business_id` |
| integer `banned` | boolean `banned` |
| integer `jailed` | boolean `jailed` |
| integer `phone` | varchar `phone` |
| HUD `mission` | `users.mission`, detailed rows in `missions` |

## Runtime Notes

- Supabase admin account created: username `admin`, password `admin123`, role `admin`, `admin_level = 10`, CCCD `000000000001`.
- CCCD format is now 12 digits. The database constraint is `^[0-9]{12}$`.
- The gamemode currently seeds the admin account into runtime memory so login can work while the PostgreSQL bridge is still pending.
- In-game registration currently creates runtime accounts and CCCD but does not insert Supabase rows until a PostgreSQL bridge/plugin is added.
- Login from Supabase is not available inside Pawn yet for the same reason; direct DB access has been tested with `psql`.

## Gameplay Defaults

| Feature | Value |
|---|---|
| Default spawn | Pershing Square park area in front of City Hall |
| Spawn coordinates | `1481.1199, -1690.2500, 14.0469` |
| Facing angle | `180.0` |
| Login choices | Default spawn or continue from last saved position |
| Commands | `/logout`, `/me` |

## Planned Tables

These systems still use default/in-memory data in the gamemode and should be migrated next:

| Table | Purpose | Status |
|---|---|---|
| player_vehicles | Owned vehicles, fuel, lock state, spawn position | Planned |
| houses | Dynamic houses and ownership | Planned |
| businesses | Shops, ownership, income | Planned |
| faction_members | Player faction membership history/ranks | Planned |
| items | Item definitions | Planned |
| player_inventory | Player inventory slots | Planned |
