# HƯỚNG DẪN THỰC HÀNH QUẢN TRỊ DỰ ÁN & VẬN HÀNH CỘNG ĐỒNG OSS

> **Dự án:** BleachVsNaruto2.6PvP — BVN 2.6 Online 2P (Delay-Based Lockstep)  
> **Repository chính thức (GitHub Organization):** `https://github.com/BleachVsNaruto26-OSS/BleachVsNaruto2.6PvP`  
> **Ngày cập nhật:** 23/11/2026

---

## 1. Phân công vai trò & Trạng thái hiện tại

| Thành viên | GitHub ID | Vai trò đảm nhiệm | Quyền hạn trên Org | Trách nhiệm chính |
|---|---|---|---|---|
| **Sinh viên A** | `@Khoa35734` | Project Lead / Steering Council | **`Admin`** | Quản trị Organization/Repo, ban hành `GOVERNANCE.md`, chủ trì CoC & Lazy Consensus, phê duyệt & Merge RFC |
| **Sinh viên B** | `@antialberteinstein` | Core Maintainer | **`Write`** | Code Review, quản lý nhánh `main`/`develop`, phản biện kỹ thuật (`-1 Veto` / `+1`), gộp PR, giám sát `ROADMAP.md` |
| **Sinh viên C** | `@neyugn261` | Triager / Reviewer | **`Triage`** | Thiết lập bộ nhãn 3 trục, sàng lọc Issue, tái hiện lỗi, kiểm chứng ranh giới quyền hạn (`Triage` không được Merge PR) |
| **Sinh viên D** | *(Tài khoản phụ của SV B hoặc SV C)* | Community Contributor | **`Read` (Fork)** | Mở Issue báo lỗi, Fork repo, tạo nhánh `feat/rfc-json-logging`, gửi PR đề xuất `RFC-0001` và cập nhật theo phản biện |

### Các hạng mục Sinh viên A đã hoàn thành trên nhánh `main`
- ✅ Tạo Organization **`BleachVsNaruto26-OSS`** và chuyển repo `BleachVsNaruto2.6PvP` sang Organization.
- ✅ Đẩy đủ bộ hồ sơ quản trị & tự động hóa (tác giả `PhamKhoa <khoaphamit2004@gmail.com>`):
  - `.github/GOVERNANCE.md` — Quy chế quản trị, Bậc thang thăng tiến 4 cấp (Contributor Ladder), RFC/Lazy Consensus, Emeritus Status.
  - `.github/CODE_OF_CONDUCT.md` — Bộ quy tắc ứng xử Contributor Covenant v2.1 (4 cấp độ chế tài).
  - `.github/SECURITY.md` — Quy trình báo cáo lỗ hổng bảo mật P0.
  - `.github/workflows/issue-triage.yml` — GitHub Actions tự động chào mừng và gắn nhãn `status: needs-triage` (pinned SHA).
  - `ROADMAP.md` — Bản đồ lộ trình 3 thì (`Now` – `Next` – `Later`).
  - `MAINTAINERS.md` — Danh sách người bảo trì (`@Khoa35734`, `@antialberteinstein`, `@neyugn261`) & chính sách chuyển giao khẩn cấp 90 ngày.
  - `docs/CASE_STUDIES_REPORT.md` — Bài phân tích chi tiết 2 tình huống thực chiến (Mục VI).

---

## 2. Sơ đồ trình tự thực hiện (5 Giai đoạn)

```text
[Giai đoạn 1: SV A phân quyền -> SV B & SV C chấp nhận lời mời]
                              │
        ┌─────────────────────┴─────────────────────┐
        ▼                                           ▼
[Giai đoạn 2A: SV C tạo 8 Labels]      [Giai đoạn 2B: SV B tạo nhánh develop]
        └─────────────────────┬─────────────────────┘
                              ▼
[Giai đoạn 3: SV D mở Issue -> Bot Actions chạy -> SV C gắn nhãn & đóng Issue]
                              ▼
[Giai đoạn 4: SV D gửi PR RFC-0001 -> SV C chụp nút Merge Disabled
              -> SV A mở Lazy Consensus -> SV B Veto (-1)
              -> SV D sửa commit -> SV B đổi (+1) -> SV A Merge PR]
                              ▼
[Giai đoạn 5: Cả nhóm rà soát Case Studies & ghép 6 bộ ảnh minh chứng nộp bài]
```

> **Nguyên tắc phối hợp:** Thực hiện **đúng thứ tự Giai đoạn 1 → 5** để không bị kẹt quyền hạn và đảm bảo GitHub Actions tự động chạy đúng lúc mở Issue.

---

## 3. Hướng dẫn chi tiết theo từng Giai đoạn

### Giai đoạn 1 — Thiết lập phân quyền thực tế trên GitHub Organization *(Bài 1 — Mục 2.3)*

#### Bước 1.1 — Sinh viên A (`@Khoa35734` — Admin)
1. Truy cập: `https://github.com/BleachVsNaruto26-OSS/BleachVsNaruto2.6PvP/settings/access`
2. Bấm **Add people** (hoặc **Add teams/people**) và phân quyền chính xác:
   - Nhập `antialberteinstein` → chọn quyền **`Write`** → gửi lời mời.
   - Nhập `neyugn261` → chọn quyền **`Triage`** → gửi lời mời.
3. Vào **Settings → Actions → General**, kiểm tra mục **Actions permissions** đang chọn *Allow all actions and reusable workflows*.

#### Bước 1.2 — Sinh viên B (`@antialberteinstein`) & Sinh viên C (`@neyugn261`)
1. Kiểm tra Email hoặc biểu tượng chuông thông báo trên GitHub.
2. Bấm **Accept invitation** để tham gia Organization `BleachVsNaruto26-OSS` với đúng vai trò được cấp.

#### Bước 1.3 — Minh chứng cần chụp *(SV A)*
- 📸 **Ảnh #1:** Màn hình **Settings → Collaborators and teams** hiển thị đầy đủ 3 thành viên và đúng 3 mức quyền: `@Khoa35734` (`Admin`), `@antialberteinstein` (`Write`), `@neyugn261` (`Triage`).

---

### Giai đoạn 2 — Thiết lập bộ nhãn 3 trục & Nhánh `develop` *(Làm song song sau Giai đoạn 1)*

#### Bước 2.1 — Sinh viên C (`@neyugn261` — Triage) tạo hệ thống nhãn *(Bài 3 — Mục 4.1)*
1. Truy cập: `https://github.com/BleachVsNaruto26-OSS/BleachVsNaruto2.6PvP/labels`
2. Bấm **New label** và tạo đầy đủ **8 nhãn** sau (gõ đúng tên và mã màu Hex):

| Trục phân loại | Tên nhãn (`Label name`) | Mã màu Hex | Mô tả (`Description`) |
|---|---|---|---|
| Phân loại việc (Type) | `type: bug` | `#d73a4a` | Lỗi chức năng không đúng với đặc tả hoặc tài liệu. |
| Phân loại việc (Type) | `type: feature` | `#a2eeef` | Yêu cầu bổ sung tính năng mới hoặc nâng cấp cải tiến. |
| Phân loại việc (Type) | `type: documentation` | `#0075ca` | Cải tiến tài liệu hướng dẫn, sửa lỗi chính tả README. |
| Mức ưu tiên (Priority) | `priority: P0 (Critical)` | `#b60205` | Sự cố bảo mật khẩn cấp hoặc sập hệ thống; cần xử lý ngay. |
| Mức ưu tiên (Priority) | `priority: P1 (High)` | `#e99695` | Lỗi nghiêm trọng ảnh hưởng nhiều người nhưng có cách tạm vượt qua. |
| Mức ưu tiên (Priority) | `priority: P2 (Medium)` | `#fef2c0` | Lỗi nhỏ, ảnh hưởng thứ yếu, xếp hàng giải quyết trong sprint sau. |
| Hỗ trợ người mới | `good first issue` | `#7057ff` | Công việc nhỏ, độc lập, dành riêng cho Contributor mới bắt đầu. |
| Trạng thái tự động *(Actions)* | `status: needs-triage` | `#fbca04` | Issue mới đang chờ đội ngũ Triager sàng lọc. |

- 📸 **Ảnh #2:** Chụp toàn cảnh trang **Issues → Labels** sau khi tạo xong đủ bộ nhãn 3 trục.

#### Bước 2.2 — Sinh viên B (`@antialberteinstein` — Write) thiết lập nhánh `develop`
1. Clone repository từ Organization về máy và tạo nhánh `develop` từ `main`:
   ```bash
   git clone https://github.com/BleachVsNaruto26-OSS/BleachVsNaruto2.6PvP.git
   cd BleachVsNaruto2.6PvP
   git checkout -b develop
   git push -u origin develop
   ```
2. Đọc rà soát `.github/GOVERNANCE.md` và `ROADMAP.md` để nắm mốc triển khai.

---

### Giai đoạn 3 — Kiểm chứng GitHub Actions & Quyền Triage trên Issue *(Bài 3 — 4.2 & Bài 1 — 2.3)*

#### Bước 3.1 — Sinh viên D *(tài khoản phụ ngoài Org — quyền Read)* mở Issue báo lỗi
1. Truy cập mục **Issues → New issue** của `BleachVsNaruto26-OSS/BleachVsNaruto2.6PvP`.
2. Tạo 01 Issue mẫu:
   - **Title:** `[Bug] Lệch khung hình (Desync) khi đấu 2P qua LAN có RTT > 120ms`
   - **Body:**
     ```markdown
     ### Mô tả lỗi
     Khi đấu 2P với độ trễ mạng RTT vượt quá 120ms ở chế độ Delay cố định 2f, HUD báo `DESYNC`.
     ### Môi trường
     - OS: Windows 11 64-bit
     - Phiên bản: BVN 2.6 Netplay (main)
     - Log đính kèm: `server/desync.log` ghi nhận lệch trường `p1.x` tại frame 1240.
     ```

#### Bước 3.2 — Kiểm chứng GitHub Actions `Automated Issue Triage` *(tự động sau 15–30 giây)*
1. Tải lại trang Issue vừa mở và xác nhận 2 kết quả tự động:
   - Bot `github-actions` bình luận chào mừng kèm `@username` của SV D.
   - Nhãn **`status: needs-triage`** tự động xuất hiện ở cột **Labels** bên phải.
2. Vào tab **Actions** kiểm tra workflow **`Automated Issue Triage`** hiện dấu tích xanh (Success).
3. 📸 **Ảnh #3:** Chụp bình luận của Bot + nhãn `status: needs-triage` trên Issue + tab **Actions** chạy xanh.

#### Bước 3.3 — Sinh viên C (`@neyugn261` — Triage) sàng lọc & đóng Issue *(Bài 1 — 2.3)*
1. Vào Issue do SV D vừa tạo:
   - Gỡ nhãn `status: needs-triage`.
   - Gán nhãn **`type: bug`** và **`priority: P1 (High)`**.
   - Gán **Assignees** cho `@antialberteinstein`.
   - Bình luận phản hồi thân thiện xác nhận đã tái hiện được lỗi và chuyển Core Maintainer xử lý.
2. Thử bấm nút **Close issue** (đóng Issue) → xác nhận **đóng thành công** *(có thể mở lại sau khi chụp nếu muốn giữ Issue mở)*.
3. 📸 **Ảnh #4A:** Chụp màn hình `@neyugn261` gắn nhãn 3 trục và đóng Issue thành công.

---

### Giai đoạn 4 — Quy trình RFC-0001, Lazy Consensus, Veto `-1` & Kiểm chứng nút Merge *(Bài 2 + Bài 1 — 2.3)*

#### Bước 4.1 — Sinh viên D *(tài khoản phụ — Read / Fork)* soạn `RFC-0001` & mở PR *(Bài 2 — 3.2)*
1. Bấm nút **Fork** trên `https://github.com/BleachVsNaruto26-OSS/BleachVsNaruto2.6PvP` về tài khoản phụ của SV D.
2. Clone bản Fork về máy (hoặc thao tác trực tiếp trên Web GitHub), tạo nhánh **`feat/rfc-json-logging`**:
   ```bash
   git checkout -b feat/rfc-json-logging
   ```
3. Tạo tệp **`docs/rfc/RFC-0001.md`** với nội dung chuẩn theo đề bài:
   ```markdown
   # RFC-0001: Chuẩn hóa hệ thống Log sang định dạng có cấu trúc JSON
   - Tác giả: @<username_tai_khoan_phu_SV_D>
   - Trạng thái: DRAFT (Đang lấy ý kiến đóng góp)
   - Ngày tạo: 2026-11-23

   ## 1. Tóm tắt đề xuất (Summary)
   Chuyển đổi toàn bộ cơ chế ghi nhật ký hoạt động (Logging) của ứng dụng từ văn bản thuần (Plain Text) sang định dạng JSON có cấu trúc (Structured JSON Logging) kèm chuẩn hóa các trường metadata (`timestamp`, `level`, `service`, `trace_id`).

   ## 2. Động lực thay đổi (Motivation)
   Hệ thống hiện tại in log dạng chuỗi gây khó khăn cho việc phân tích tự động trên các nền tảng tập trung (ELK Stack, Grafana Loki, Datadog). Việc dùng Regex để trích xuất thông tin tiêu tốn nhiều tài nguyên CPU và dễ bị lỗi khi format chuỗi thay đổi.

   ## 3. Phân tích tác động phá vỡ (Breaking Changes)
   - Tác động SemVer: Đòi hỏi tăng bản MAJOR (`v1.x.x -> v2.0.0`) vì các parser log bên ngoài phụ thuộc định dạng cũ sẽ bị lỗi.
   - Biện pháp giảm nhẹ: Cung cấp tùy chọn cấu hình biến môi trường `LOG_FORMAT=json|text` trong giai đoạn chuyển giao 6 tháng.

   ## 4. Các giải pháp thay thế đã xem xét (Alternatives)
   - Giữ nguyên text log và xây dựng parser Fluentd riêng: Bác bỏ vì chi phí duy trì cao và không giải quyết được tính mở rộng.
   ```
4. Commit, push nhánh `feat/rfc-json-logging` lên Fork và bấm **Contribute → Open pull request** hướng về nhánh `main` của `BleachVsNaruto26-OSS/BleachVsNaruto2.6PvP` với tiêu đề: `feat(rfc): RFC-0001 Chuẩn hóa hệ thống Log sang định dạng JSON`.

#### Bước 4.2 — Sinh viên C (`@neyugn261` — Triage) kiểm chứng ranh giới quyền hạn *(Bài 1 — 2.3)*
1. Đăng nhập bằng tài khoản `@neyugn261`, mở trang Pull Request `RFC-0001` vừa tạo.
2. Kéo xuống cuối PR để quan sát khu vực Merge.
3. 📸 **Ảnh #4B:** Chụp màn hình chứng minh **nút `Merge pull request` bị vô hiệu hóa (Disabled / không có quyền gộp)** khi đăng nhập dưới quyền `Triage` (`@neyugn261`).

#### Bước 4.3 — Sinh viên A (`@Khoa35734` — Admin) công bố giai đoạn Lazy Consensus *(Bài 2 — 3.3)*
- Bình luận trên PR `RFC-0001`:
  > `Đề xuất RFC-0001 chính thức bước vào giai đoạn Lazy Consensus. Nếu sau thời hạn thảo luận không có ý kiến phản đối (-1 Veto), RFC sẽ được phê duyệt.`

#### Bước 4.4 — Sinh viên B (`@antialberteinstein` — Write) phản biện kỹ thuật `-1 (Veto)` *(Bài 2 — 3.3)*
- Vào PR `RFC-0001` → tab **Files changed** → bấm **Review changes** → chọn **`Request changes`** và gửi nội dung:
  > `Phản đối -1: Việc bắt buộc tăng bản MAJOR ngay lập tức sẽ làm gián đoạn kế hoạch phát hành v1.4 vào cuối tháng. Tôi yêu cầu tác giả bổ sung cờ cấu hình fallback để người dùng cũ không bị ảnh hưởng.`

#### Bước 4.5 — Sinh viên D *(tài khoản phụ)* tiếp thu & đẩy commit cập nhật RFC
1. Mở file `docs/rfc/RFC-0001.md` trên nhánh `feat/rfc-json-logging`, cập nhật mục **3. Phân tích tác động phá vỡ**:
   - Quy định rõ cờ cấu hình fallback mặc định là **`LOG_FORMAT=text`** cho nhánh `v1.4.x` (giữ 100% tương thích ngược, không bắt buộc tăng bản MAJOR ngay lập tức).
   - Người dùng có thể chủ động bật `LOG_FORMAT=json` (opt-in) trong giai đoạn chuyển giao 6 tháng trước khi chuyển mặc định sang JSON ở `v2.0.0`.
   - Đổi trạng thái đầu file thành `REVIEWED (Đã bổ sung cơ chế fallback theo phản biện)`.
2. Commit (ví dụ: `docs(rfc): add default LOG_FORMAT=text fallback flag per Veto feedback`) và push vào nhánh `feat/rfc-json-logging` (PR sẽ tự động cập nhật thêm commit thứ 2).
3. Bình luận trên PR: `Đã bổ sung cơ chế cờ fallback mặc định LOG_FORMAT=text để không ảnh hưởng kế hoạch v1.4. Mời @antialberteinstein kiểm tra lại!`

#### Bước 4.6 — Sinh viên B (`@antialberteinstein` — Write) gỡ Veto và đổi phiếu `+1`
- Vào PR `RFC-0001` → tab **Files changed** → **Review changes** → chọn **`Approve`** và bình luận:
  > `+1: Đã xác nhận cờ fallback mặc định LOG_FORMAT=text đáp ứng yêu cầu tương thích ngược cho bản v1.4. Tôi gỡ phản đối (-1) và đồng ý thông qua RFC-0001.`

#### Bước 4.7 — Sinh viên A (`@Khoa35734` — Admin) phê duyệt & Merge PR
- Bình luận xác nhận kết thúc Lazy Consensus (đạt đồng thuận, không còn Veto) và bấm **`Merge pull request`** gộp `RFC-0001` vào `main`.
- 📸 **Ảnh #5:** Chụp toàn bộ chuỗi hội thoại PR `RFC-0001` gồm đầy đủ 5 mốc: `Lazy Consensus (SV A)` → `-1 Veto (SV B)` → `Commit sửa (SV D)` → `+1 Approve (SV B)` → `Merged (SV A)`.

#### Bước 4.8 — Sinh viên B (`@antialberteinstein` — Write) xác nhận quyền quản lý nhánh & `ROADMAP.md`
- Tạo 01 Pull Request nhỏ từ nhánh `develop` (hoặc nhánh `docs/roadmap-update`) cập nhật trạng thái trong `ROADMAP.md`, đồng bộ `main` vào `develop` và tự bấm **Merge** bằng quyền `Write` để hoàn thiện đầy đủ minh chứng của Core Maintainer.

---

### Giai đoạn 5 — Hoàn thiện Báo cáo nộp bài *(Mục VI — Cả 3 sinh viên)*
1. **Rà soát 2 Case Studies:** Toàn bộ lời giải chi tiết cho **Tình huống 1** (4 cấp độ chế tài Contributor Covenant + Triết lý Chất lượng code vs Văn hóa cộng đồng) và **Tình huống 2** (Hard Fork Crisis MIT → BSL/SSPL, bài học Redis → Valkey & Terraform → OpenTofu, kế hoạch tổ chức cuộc họp) đã được biên soạn sẵn trong tệp **`docs/CASE_STUDIES_REPORT.md`**.
2. **Kiểm tra đủ 6 bộ ảnh minh chứng trước khi xuất báo cáo nộp:**
   - [ ] **Ảnh #1:** Phân quyền `Admin` (`@Khoa35734`), `Write` (`@antialberteinstein`), `Triage` (`@neyugn261`) trên Organization.
   - [ ] **Ảnh #2:** Hệ thống 8 nhãn chuẩn 3 trục tại trang **Issues → Labels**.
   - [ ] **Ảnh #3:** GitHub Actions `Automated Issue Triage` chạy xanh + Bot tự chào mừng & gắn nhãn `status: needs-triage`.
   - [ ] **Ảnh #4A & #4B:** Kiểm chứng ranh giới quyền `Triage` của `@neyugn261` (đóng Issue thành công nhưng nút Merge PR bị Disabled).
   - [ ] **Ảnh #5:** Toàn bộ luồng PR `RFC-0001` (`Lazy Consensus` → `-1 Veto` → commit sửa → `+1` → `Merged`).
   - [ ] **Ảnh #6:** Cấu trúc cây file quản trị trên `main` (`.github/GOVERNANCE.md`, `ROADMAP.md`, `MAINTAINERS.md`, `docs/rfc/RFC-0001.md`) kèm nội dung 2 Case Studies.

---

## 4. Bảng tra cứu nhanh việc cần làm theo từng thành viên

| Thành viên | Danh sách việc cần thực hiện theo thứ tự |
|---|---|
| **SV A (`@Khoa35734`)** | 1. Mời `@antialberteinstein` (`Write`) & `@neyugn261` (`Triage`) trên Org, chụp **Ảnh #1**<br>2. Bình luận mở Lazy Consensus trên PR `RFC-0001`<br>3. Bấm **Merge** PR `RFC-0001` sau khi SV B đổi `+1`, chụp **Ảnh #5**<br>4. Tổng hợp báo cáo cuối cùng cùng nhóm |
| **SV B (`@antialberteinstein`)** | 1. Bấm **Accept invitation** (`Write`)<br>2. Clone repo Org & đẩy nhánh `develop`<br>3. Review PR `RFC-0001` → **Request changes (`-1 Veto`)**<br>4. Sau khi SV D sửa → **Approve (`+1`)**<br>5. Đồng bộ nhánh `develop` & cập nhật tiến độ `ROADMAP.md` |
| **SV C (`@neyugn261`)** | 1. Bấm **Accept invitation** (`Triage`)<br>2. Tạo đủ 8 Labels chuẩn 3 trục, chụp **Ảnh #2**<br>3. Sàng lọc Issue của SV D (gỡ `needs-triage`, gắn `type: bug` + `priority: P1`, gán Assignee, đóng Issue test), chụp **Ảnh #4A**<br>4. Mở PR `RFC-0001` chụp nút **Merge bị Disabled**, chụp **Ảnh #4B** |
| **SV D** *(tài khoản phụ của B hoặc C)* | 1. Mở 01 Issue báo lỗi mẫu kích hoạt Bot Actions, chụp **Ảnh #3**<br>2. Fork repo, tạo nhánh `feat/rfc-json-logging`, thêm `docs/rfc/RFC-0001.md`, mở PR vào `main`<br>3. Cập nhật commit bổ sung cờ fallback `LOG_FORMAT=text` sau khi SV B Veto |

---

## 5. Xử lý nhanh các sự cố thường gặp

- **Không thấy quyền `Triage` khi mời thành viên:** Kiểm tra đúng đường dẫn phải là repo thuộc Organization **`BleachVsNaruto26-OSS/BleachVsNaruto2.6PvP`** (không phải repo cá nhân cũ).
- **Đã gửi lời mời nhưng SV B / SV C chưa có quyền:** Thành viên phải bấm **Accept invitation** trong email hoặc tại `https://github.com/BleachVsNaruto26-OSS`.
- **Mở Issue nhưng Bot Actions không bình luận:** Vào tab **Actions** xem log lỗi; kiểm tra **Settings → Actions → General → Workflow permissions** đảm bảo workflow được phép ghi Issue.
- **Lệnh `git push` báo lỗi remote cũ:** Chạy lệnh cập nhật URL sang Organization mới:
  ```bash
  git remote set-url origin https://github.com/BleachVsNaruto26-OSS/BleachVsNaruto2.6PvP.git
  ```
