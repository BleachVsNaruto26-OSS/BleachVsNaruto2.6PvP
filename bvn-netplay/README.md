# BVN 2.6 Online 2P (LAN / Virtual VPN)

Hệ thống mở rộng chế độ **2 PC đấu nhau qua 1 Server Node.js** cho **Bleach vs. Naruto 2.6** (`bvn2.6sieuvip`), dùng kiến trúc **Delay-Based Lockstep (30 FPS)** và **Lobby vẽ trực tiếp trong cửa sổ game**.

---

## Trạng thái 5 Giai đoạn

| Giai đoạn | Hạng mục | Trạng thái |
|---|---|---|
| **Giai đoạn 0 (PoC)** | TCP Relay + Flash Policy + Monkey-patch `Key.isDown` + Backup & Patch `launch.swf` | ✅ Hoàn tất (sẵn sàng mở 2 cửa sổ test thực tế) |
| **Giai đoạn 1 (Server)** | RoomManager, LockstepBroker, AUTO Delay Telemetry, Field-level Desync Logger (`desync.log`), Stress test 10.000 frame (`0.054 ms/frame`, 0 leak) | ✅ Hoàn tất (`11/11` test PASS) |
| **Giai đoạn 2 (Lõi Lockstep)** | Input Bitmask 10-bit (WASD cho cả 2 PC), Seeded PRNG (Park-Miller LCG), Virtual Frame Timer (`setInterval`/`setTimeout`), Frame-Delta Freeze + khóa `on_enterframe` (kể cả `onDashing`), Checksum 11 trường | ✅ Hoàn tất (biên dịch 11/11 script qua FFDec 0 lỗi) |
| **Giai đoạn 3 (Lobby & Rematch)** | Lobby vẽ thuần AS2 trong cửa sổ game (`ONLINE 2P [F2]`), chọn IP/Port/AUTO Delay/HP/Time, đồng bộ Chọn tướng/Trợ thủ/Map, Loading Barrier, Rematch & Disconnect an toàn | ✅ Hoàn tất |
| **Giai đoạn 4 (Kiểm thử & Tinh chỉnh)** | Quét tương thích toàn bộ **36 fighter + 27 assist** (`audit-fighters.js`), tự động gợi ý `Delay` theo RTT (`AUTO`), ghi log phân tích lệch theo từng trường vào `server/desync.log` | ✅ Tự động hóa xong — chờ bạn đấu thực tế trên 2 cửa sổ / 2 PC |

---

## Cấu trúc thư mục

```text
bvn-netplay/
├── server/
│   ├── server.js          # Node.js TCP Relay + RoomManager + Lockstep + AUTO Delay + desync.log
│   ├── test-server.js     # Bộ test 11 kịch bản + Stress test 10.000 frame
│   └── start-server.bat   # Bấm đúp để bật Server (port 9000) & in IP LAN/VPN
└── client/
    ├── netplay_module.as       # Mã nguồn AS2 của lõi Lockstep + Lobby UI + HUD
    ├── build-patch-scripts.js  # Sinh 11 file AS2 vào patch_scripts/
    ├── audit-fighters.js       # Kiểm tra tương thích toàn bộ 36 fighter & 27 assist
    ├── patch-launch.bat        # Sao lưu launch.original.swf & patch launch.swf qua JPEXS
    ├── restore-launch.bat      # Khôi phục launch.swf gốc 1 click
    └── patch_scripts/          # 11 file .as đã sẵn sàng cho JPEXS -importScript
```

---

## Hướng dẫn chạy thử ngay (File `launch.swf` đã được backup & patch sẵn!)

> Bản gốc đã được lưu an toàn tại `bvn2.6sieuvip\bvn2.6sieuvip\launch.original.swf`. Muốn quay lại bản gốc bất cứ lúc nào chỉ cần chạy `client\restore-launch.bat`.

### 1. Test nhanh trên 1 PC (mở 2 cửa sổ game)
1. Bấm đúp **`server\start-server.bat`** để bật Server (port `9000`).
2. Mở **2 cửa sổ** `D:\BleackVsNaruto\bvn2.6sieuvip\bvn2.6sieuvip\Bleach vs. Naruto.exe`.
3. Ở cả 2 cửa sổ, tại Menu chính bấm nút **`ONLINE 2P [F2]`** góc trên phải (hoặc bấm phím **`F2`**, hoặc chọn mục **More Games / 更多游戏**).
4. **Cửa sổ 1 (P1):** giữ `Server IP` là `127.0.0.1`, để `Delay: AUTO` (hoặc chỉnh `2f`), bấm **`TAO PHONG (P1)`** → lấy mã phòng 4 ký tự (ví dụ `AB12`).
5. **Cửa sổ 2 (P2):** để `Server IP` là `127.0.0.1`, nhập mã 4 ký tự vào ô `Ma phong`, bấm **`VAO PHONG (P2)`**.
6. **Cửa sổ 1:** kiểm tra ping P1/P2 hiển thị trong khung phòng, bấm **`BAT DAU CHON TUONG`** → Chọn nhân vật, trợ thủ, map (P1 chọn map) rồi vào đấu!

### 2. Đấu giữa 2 PC qua LAN / Radmin VPN / ZeroTier
1. **Copy file `launch.swf` đã patch** sang đúng thư mục game trên PC 2 (đảm bảo cả 2 PC dùng cùng bộ `bvn2.6sieuvip`).
2. PC 1 chạy **`server\start-server.bat`**, mở Inbound TCP port `9000` trong Windows Firewall nếu Windows hỏi, xem địa chỉ **IPv4 LAN/VPN** in ra trên console.
3. PC 1 vào game với IP `127.0.0.1` tạo phòng; PC 2 vào game nhập **IP LAN/VPN của PC 1** + mã phòng 4 ký tự.
4. **Cả 2 PC đều điều khiển bằng phím P1 (`WASD + J K L U I O`)** trên máy riêng của mình.

---

## Kiểm tra đồng bộ & Xử lý lỗi
- Thanh HUD trên đỉnh màn hình: `P1 [AB12] 12ms D2 F1240 OK`
  - Xanh lá `OK`: 2 PC khớp 100% ở lần check gần nhất.
  - Vàng `CHO DOI THU...`: đang tạm đóng băng chờ gói tin đối thủ tới trễ (tăng `Delay` thêm 1f nếu hiện thường xuyên).
  - Đỏ `DESYNC@F...`: phát hiện lệch giữa 2 PC → mở file **`server\desync.log`** để xem chính xác nhân vật, frame và chỉ số (`p1.x, p1.hp, p1.fr...`) bị lệch.
