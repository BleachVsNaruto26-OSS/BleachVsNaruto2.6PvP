# Bleach vs. Naruto 2.6 Online 2P (PvP)

Hệ thống mở rộng chế độ **2 PC đấu trực tuyến qua Node.js Server (LAN / Virtual VPN)** cho **Bleach vs. Naruto 2.6**, áp dụng kiến trúc **Delay-Based Lockstep (30 FPS)**, Lobby vẽ trực tiếp bằng ActionScript 2 trong cửa sổ game, và quy trình quản trị dự án mã nguồn mở (OSS Governance) theo chuẩn CNCF / Apache.

---

## Tổng quan kiến trúc & thư mục

```text
BleachVsNaruto2.6PvP/
├── .github/
│   ├── GOVERNANCE.md                  # Quy chế quản trị & Bậc thang thăng tiến (Contributor Ladder)
│   ├── CODE_OF_CONDUCT.md             # Bộ quy tắc ứng xử cộng đồng (Contributor Covenant v2.1)
│   ├── SECURITY.md                    # Chính sách báo cáo lỗ hổng bảo mật
│   └── workflows/
│       └── issue-triage.yml           # GitHub Actions tự động chào mừng & gắn nhãn Issue mới
├── bvn-netplay/                       # Mã nguồn Server Node.js + Client AS2 Netplay & auto-patcher
│   ├── README.md                      # Hướng dẫn cài đặt, chạy Server & đấu 2P chi tiết
│   ├── server/                        # TCP Relay, RoomManager, LockstepBroker, AUTO Delay, stress test
│   └── client/                        # netplay_module.as, build-patch-scripts.js, patch_scripts/
├── bvn2.6sieuvip/                     # Bộ game Bleach vs. Naruto 2.6 (đã backup launch.original.swf & patch launch.swf)
├── scripts/                           # Mã nguồn AS2 trích xuất dùng cho build-patch-scripts.js
├── docs/
│   ├── CASE_STUDIES_REPORT.md         # Báo cáo phân tích 2 tình huống quản trị OSS (CoC & Hard Fork)
│   └── rfc/                           # Đề xuất kiến trúc (Request for Comments - RFC)
├── ROADMAP.md                         # Bản đồ lộ trình phát triển 3 thì (Now - Next - Later)
├── MAINTAINERS.md                     # Danh sách người bảo trì & chính sách chuyển giao khẩn cấp (90 ngày)
└── HUONGDAN.md                        # Hướng dẫn phân công & trình tự thực hành quản trị OSS cho nhóm
```

---

## Khởi chạy nhanh (Online 2P)

Xem hướng dẫn đầy đủ tại [bvn-netplay/README.md](bvn-netplay/README.md):

1. Khởi chạy server bằng cách bấm đúp `bvn-netplay/server/start-server.bat` (mặc định TCP port `9000`).
2. Mở 2 cửa sổ `bvn2.6sieuvip/bvn2.6sieuvip/Bleach vs. Naruto.exe`.
3. Tại Menu chính bấm nút **`ONLINE 2P [F2]`** (hoặc phím `F2`) để tạo phòng (P1) và nhập mã phòng 4 ký tự (P2).
4. Cả 2 người chơi đều điều khiển bằng cụm phím P1 (`WASD + J K L U I O`) trên máy riêng của mình.

---

## Quản trị dự án & Đóng góp cộng đồng (OSS Governance)

Dự án vận hành theo mô hình **Đồng thuận mở (Consensus-Seeking)** kết hợp **Công trạng kỹ thuật (Meritocracy)**:

- **Quy chế quản trị & Bậc thang đóng góp:** [.github/GOVERNANCE.md](.github/GOVERNANCE.md)
- **Danh sách Maintainers & Kế thừa khẩn cấp:** [MAINTAINERS.md](MAINTAINERS.md)
- **Lộ trình phát triển (Now - Next - Later):** [ROADMAP.md](ROADMAP.md)
- **Quy tắc ứng xử cộng đồng:** [.github/CODE_OF_CONDUCT.md](.github/CODE_OF_CONDUCT.md)
- **Báo cáo lỗ hổng bảo mật:** [.github/SECURITY.md](.github/SECURITY.md)
- **Hướng dẫn thực hành cho nhóm:** [HUONGDAN.md](HUONGDAN.md) ([bản PDF](HUONGDAN.pdf))
- **Phân tích Case Studies quản trị OSS:** [docs/CASE_STUDIES_REPORT.md](docs/CASE_STUDIES_REPORT.md)

### Đội ngũ bảo trì hiện tại
- **`@Khoa35734`** — Project Lead / Steering Council (`Admin`)
- **`@antialberteinstein`** — Core Maintainer (`Write`)
- **`@neyugn261`** — Triager / Reviewer (`Triage`)
