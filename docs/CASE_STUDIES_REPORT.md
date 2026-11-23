# BÁO CÁO BÀI TẬP TÌNH HUỐNG THỰC CHIẾN (CASE STUDIES)

> **Dự án:** BleachVsNaruto2.6PvP  
> **Vai trò chủ trì:** Sinh viên A — Project Lead / Steering Committee (`@Khoa35734`, `khoaphamit2004@gmail.com`)

---

## TÌNH HUỐNG 1: TRANH CÃI ĐỘC HẠI & XỬ LÝ VI PHẠM CODE OF CONDUCT

### Tóm tắt ngữ cảnh
Một lập trình viên kỳ cựu gửi Pull Request tối ưu thuật toán giúp giảm 45% thời gian xử lý dữ liệu. Khi một sinh viên mới đặt câu hỏi về một dòng mã khó hiểu trên PR, tác giả đã công kích cá nhân nặng nề: *"Kiến thức cơ bản về con trỏ thế này cũng không nắm được thì đừng học CNTT, đừng vào bình luận làm loãng thời gian của người lớn."*

### 1. Phương án xử lý của Steering Committee theo 4 cấp độ chế tài (Contributor Covenant)

Hội đồng điều hành (Steering Committee) hành động theo nguyên tắc **khách quan — minh bạch — bảo vệ người bị hại — thực thi nhất quán bất kể thâm niên**:

1. **Hành động khẩn cấp ngay lập tức (Containment & De-escalation):**
   - Ẩn (Minimize/Hide với lý do `Abuse`) bình luận công kích cá nhân trên PR để chấm dứt tổn thương tâm lý và tránh leo thang tranh cãi trên luồng công khai.
   - Gửi tin nhắn riêng động viên bạn sinh viên mới, khẳng định câu hỏi của bạn hoàn toàn hợp lệ và dự án hoan nghênh người mới học hỏi.
   - Ghi nhận bằng chứng (screenshot, link bình luận, thời điểm) vào hồ sơ nội bộ của Steering Committee.

2. **Áp dụng khung 4 cấp độ chế tài của Contributor Covenant:**
   - **Đánh giá cấp độ ban đầu — Cấp độ 2 (`Warning` — Cảnh cáo chính thức) hoặc Cấp độ 1 nâng cao tùy tiền sử:**
     - Dù đây có thể là lần vi phạm đầu tiên, nội dung phát ngôn mang tính **công kích cá nhân nặng nề và hạ nhục người mới (gatekeeping/harassment)** — vượt quá mức "sơ suất ngôn từ nhẹ" của Cấp 1 (`Correction`).
     - **Nếu chưa từng có tiền sử vi phạm:** Áp dụng **Cấp độ 1 → 2 (`Correction` kèm `Formal Warning`)**:
       - Gửi thông báo chính thức bằng văn bản (riêng tư) trích dẫn điều khoản vi phạm trong `.github/CODE_OF_CONDUCT.md`.
       - Yêu cầu tác giả chỉnh sửa/rút lại thái độ, cam kết tuân thủ quy tắc ứng xử và tôn trọng người tham gia review.
       - Đăng phản hồi trung lập trên PR nhắc lại chuẩn mực trao đổi kỹ thuật mang tính xây dựng.
     - **Nếu tác giả tiếp tục tranh cãi, tỏ thái độ bất hợp tác hoặc tái phạm:** Nâng lên **Cấp độ 3 (`Temporary Ban` — Đình chỉ tạm thời)** trong 30–90 ngày (khóa quyền tương tác trên Issue/PR, tạm dừng quyền ghi nếu có).
     - **Nếu tiếp tục quấy rối sau đình chỉ hoặc lách luật bằng tài khoản khác:** Áp dụng **Cấp độ 4 (`Permanent Ban` — Cấm vĩnh viễn)** khỏi toàn bộ kho lưu trữ và cộng đồng dự án.

### 2. Có đồng ý Merge Pull Request ngay lập tức hay không?

**Quyết định: KHÔNG bấm Merge ngay lập tức.**

**Lý do kỹ thuật và triết lý quản trị OSS ("Chất lượng code" vs "Văn hóa cộng đồng"):**
- **Không đổi văn hóa lấy hiệu năng ngắn hạn:** Một bản tối ưu giúp nhanh hơn 45% chỉ mang lại lợi ích kỹ thuật tại một thời điểm, nhưng nếu dự án dung túng hành vi độc hại ("brilliant jerk"), dự án sẽ phát đi tín hiệu ngầm rằng *"chỉ cần giỏi code thì được phép xúc phạm người khác"*. Hệ quả là hàng chục Contributor mới và Maintainer lành mạnh sẽ rời bỏ dự án, khiến dự án suy tàn về dài hạn.
- **Triết lý "Code có thể viết lại, nhưng niềm tin cộng đồng rất khó khôi phục":** Trong mã nguồn mở, phần mềm là tài sản sống đòi hỏi nhiều thế hệ bảo trì. Một dòng code khó hiểu đến mức người mới phải hỏi bản thân nó cũng là dấu hiệu cần cải thiện khả năng đọc hiểu (readability) hoặc bổ sung comment/tài liệu giải thích — ngay cả khi thuật toán nhanh.
- **Lộ trình xử lý PR công bằng:**
  1. **Tạm đóng băng (Hold/Draft) PR** trong thời gian xử lý vi phạm CoC.
  2. Nếu tác giả **thiện chí tiếp thu cảnh cáo**, bổ sung giải thích kỹ thuật rõ ràng cho đoạn code phức tạp (comment/docs) và vượt qua review tiêu chuẩn → PR vẫn được xem xét Merge bình thường dựa trên giá trị kỹ thuật.
  3. Nếu tác giả **từ chối hợp tác và bị đình chỉ/cấm**, PR sẽ bị đóng (`Closed without merge`); dự án có thể mở Issue mới về bài toán tối ưu hiệu năng để cộng đồng tự triển khai giải pháp sạch sẽ, dễ bảo trì theo đúng văn hóa chung.

---

## TÌNH HUỐNG 2: XUNG ĐỘT THƯƠNG MẠI HÓA & NGUY CƠ RẼ NHÁNH (HARD FORK CRISIS)

### Tóm tắt ngữ cảnh
Dự án đang phát hành dưới giấy phép **MIT** và được hàng ngàn doanh nghiệp tích hợp. Một quỹ đầu tư mạo hiểm đề nghị tài trợ **300.000 USD** với điều kiện đổi giấy phép sang **BSL / SSPL** (cấm các nhà cung cấp Cloud dùng miễn phí). Phần lớn Maintainer muốn có tài chính để làm toàn thời gian, nhưng cộng đồng đe dọa sẽ **Hard Fork** dự án.

### 1. Phân tích bài học lịch sử: Redis → Valkey & Terraform → OpenTofu

| Dự án gốc | Sự kiện đổi giấy phép | Dự án rẽ nhánh (Hard Fork) | Hệ quả & Bài học rút ra |
|---|---|---|---|
| **Redis** (BSD-3-Clause → RSALv2 / SSPLv1, 03/2024) | Redis Inc. chấm dứt giấy phép OSI thuần túy để ngăn các hãng Cloud (AWS, GCP...) kinh doanh Redis-as-a-Service. | **Valkey** (bảo trợ bởi Linux Foundation, giữ nguyên BSD-3-Clause) | Các tập đoàn lớn (AWS, Google, Oracle, Ericsson...) và phần lớn cộng đồng cốt lõi lập tức chuyển sang ủng hộ Valkey. Các bản phân phối Linux loại bỏ Redis mới khỏi kho gói mặc định. *(Thậm chí về sau Redis phải bổ sung thêm lựa chọn AGPLv3 để xoa dịu cộng đồng).* |
| **Terraform** (MPL 2.0 → BSL 1.1, 08/2023) | HashiCorp chuyển Terraform sang giấy phép nguồn sẵn có (Source-Available BSL) để bảo vệ doanh thu Terraform Cloud. | **OpenTofu** (bảo trợ bởi Linux Foundation / CNCF) | Hàng trăm doanh nghiệp và hàng ngàn lập trình viên ký tuyên ngôn phản đối, lập tức xây dựng OpenTofu tương thích ngược. Hệ sinh thái bị phân mảnh, uy tín thương hiệu "open source" của công ty gốc bị tổn hại nghiêm trọng. |

**3 bài học cốt lõi từ lịch sử:**
1. **Giấy phép MIT/BSD trao quyền Fork hợp pháp vĩnh viễn:** Mã nguồn đã phát hành dưới MIT trước thời điểm đổi giấy phép không thể bị thu hồi. Nếu cộng đồng và doanh nghiệp cảm thấy bị phản bội ("rug pull"), họ có đầy đủ cơ sở pháp lý và động lực tài chính để tạo Hard Fork và kéo theo toàn bộ hệ sinh thái.
2. **Đổi sang BSL/SSPL mất danh xưng OSS (theo chuẩn OSI):** Nhiều doanh nghiệp lớn có quy định pháp chế cấm sử dụng phần mềm SSPL/BSL → mất người dùng, mất đóng góp cộng đồng, mất hiệu ứng mạng lưới.
3. **300.000 USD không đủ để bù đắp chi phí đánh mất cộng đồng:** Khi dự án bị Fork, đội ngũ gốc mất đi lực lượng tester, contributor miễn phí và phải tự cạnh tranh với chính nhánh Fork được hậu thuẫn bởi cộng đồng/doanh nghiệp.

### 2. Kế hoạch tổ chức cuộc họp & Giải pháp cân bằng Tài chính — Cộng đồng

Với vai trò **Steering Committee**, nhóm tổ chức xử lý theo quy trình dân chủ, minh bạch gồm 4 bước:

#### Bước 1: Tổ chức Town Hall / Public RFC minh bạch (Không quyết định sau cánh cửa đóng kín)
- Mở một **RFC công khai** (`RFC: Chiến lược bền vững tài chính & Giấy phép`) và tổ chức cuộc họp trực tuyến công khai (Community Town Hall) với đại diện Maintainers, người dùng doanh nghiệp và Contributor.
- Công bố thẳng thắn thực trạng chi phí duy trì và nhu cầu tài chính để Maintainers làm việc bền vững, thay vì đột ngột đổi giấy phép trong một commit.

#### Bước 2: Đàm phán lại với Nhà đầu tư & Đề xuất mô hình kinh doanh **giữ nguyên MIT cho phần lõi (Open Core)**
Đề xuất **4 phương án thay thế** để vừa có doanh thu vừa bảo toàn giấy phép MIT của nhân dự án:
1. **Mô hình Open Core (Lõi MIT + Tiện ích Enterprise thương mại):**
   - Giữ nguyên **100% mã nguồn lõi hiện tại dưới giấy phép MIT** (cam kết không bao giờ thu hồi).
   - Phát triển các module mở rộng dành riêng cho doanh nghiệp lớn (SSO/SAML, Audit Compliance nâng cao, Clustering/Dashboard quản trị, SLA 24/7) dưới giấy phép thương mại riêng.
2. **Dịch vụ Quản trị đám mây & Hỗ trợ doanh nghiệp (Managed Service / Commercial Support):**
   - Bán gói hỗ trợ kỹ thuật, tư vấn tích hợp, đào tạo và hạ tầng Managed Hosting cho hàng ngàn doanh nghiệp đang dùng dự án.
3. **Tài trợ cộng đồng minh bạch (Corporate Sponsorship / Open Collective / GitHub Sponsors):**
   - Với hàng ngàn doanh nghiệp đang tích hợp dự án, chỉ cần 100–200 doanh nghiệp tài trợ mức 1.500–3.000 USD/năm đã đạt con số 300.000 USD/năm mà **không bị ràng buộc đổi giấy phép hay mất quyền tự chủ**.
4. **Cân nhắc giấy phép Copyleft chuẩn OSI (ví dụ AGPLv3) chỉ cho thế hệ v2.0 mới nếu cộng đồng đồng thuận (tránh BSL/SSPL):**
   - Chỉ áp dụng nếu đạt đồng thuận rộng rãi qua biểu quyết RFC công khai và không vi phạm quyền đóng góp của các tác giả cũ (cần CLA/đồng thuận toàn bộ tác giả).

#### Bước 3: Biểu quyết công khai theo quy chế quản trị
- Nếu quỹ đầu tư **khăng khăng ép buộc đổi lõi sang BSL/SSPL**, Steering Committee khuyến nghị **từ chối khoản tài trợ 300.000 USD** kèm lý giải rõ: bảo vệ giá trị dài hạn của cộng đồng và tránh kịch bản phân mảnh như Redis/Terraform.
- Đưa ra biểu quyết minh bạch trong Core Maintainers & tham vấn cộng đồng, công bố biên bản cuộc họp và cam kết **License Pledge** (cam kết duy trì giấy phép OSI cho phần lõi) ngay trong `GOVERNANCE.md`.

#### Bước 4: Thiết lập quỹ duy trì Maintainer bền vững
- Thành lập kênh tài trợ chính thức (GitHub Sponsors / Open Collective), công bố báo cáo tài chính minh bạch hàng quý và xây dựng lộ trình tiến tới gia nhập Quỹ phi lợi nhuận trung lập (như Linux Foundation / CNCF — khớp với `ROADMAP.md` giai đoạn Later) để bảo vệ tính trung lập vĩnh viễn của dự án.
