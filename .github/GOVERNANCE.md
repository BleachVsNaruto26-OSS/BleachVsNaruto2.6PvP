# QUY CHẾ QUẢN TRỊ DỰ ÁN (PROJECT GOVERNANCE)

Dự án **BleachVsNaruto2.6PvP** vận hành theo mô hình **Đồng thuận mở (Consensus-Seeking)** kết hợp với chế độ **Công trạng kỹ thuật (Meritocracy)** nhằm đảm bảo tính minh bạch, công bằng và phát triển bền vững cho cộng đồng mã nguồn mở.

Quy chế này tuân thủ ba nguyên tắc cốt lõi của Bậc thang đóng góp theo chuẩn CNCF và Apache:
1. **Trách nhiệm đi liền với Quyền hạn:** Quyền hạn kỹ thuật trên kho lưu trữ phải là kết quả của quá trình cống hiến bền bỉ, không phải đặc ân ban phát.
2. **Lộ trình công khai:** Mọi lập trình viên mới đều có thể nhìn thấy rõ lộ trình thăng tiến từ Pull Request đầu tiên cho đến Hội đồng điều hành.
3. **Tiêu chuẩn từ nhiệm (Emeritus Status):** Thu hồi quyền hạn đối với các thành viên không còn hoạt động để giảm thiểu nguy cơ chiếm đoạt tài khoản (Account Takeover) và mất an toàn chuỗi cung ứng.

---

## 1. Bậc thang thăng tiến (Contributor Ladder)

### Cấp 1: Community Contributor (Người đóng góp cộng đồng)
- **Điều kiện:** Đã có ít nhất **01 Pull Request** được duyệt và gộp vào dự án (mã nguồn, tài liệu, hoặc kiểm thử).
- **Quyền hạn:** Được vinh danh trong danh sách thành viên đóng góp, có quyền tham gia góp ý kiến thảo luận các bản đề xuất kiến trúc (RFC) và mở Issue báo lỗi/đề xuất tính năng.

### Cấp 2: Reviewer / Triager (Người sàng lọc & Đánh giá)
- **Điều kiện:** Có tối thiểu **05 PRs** đóng góp chất lượng cao; tích cực hỗ trợ giải đáp thắc mắc và tái hiện lỗi trên Issue Tracker trong **30 ngày**.
- **Quyền hạn kỹ thuật:** Được cấp quyền **`Triage`** trên GitHub Organization (quản lý nhãn Labels theo chuẩn 3 trục, chỉ định người giải quyết, đóng/mở Issue và sàng lọc báo cáo trùng lặp).

### Cấp 3: Core Maintainer (Người bảo trì nòng cốt)
- **Điều kiện:** Đóng góp bền bỉ trong ít nhất **3 tháng**; nắm vững toàn diện kiến trúc dự án; được đề cử bởi **01 Maintainer hiện tại** và đạt **100% đồng thuận** từ nhóm Maintainers.
- **Quyền hạn kỹ thuật:** Được cấp quyền **`Write`** trên GitHub (kiểm duyệt mã nguồn, duyệt và gộp PR vào nhánh `main`/`develop`/`feature`, tạo thẻ Tag phiên bản, điều phối sprint và giám sát tiến trình `ROADMAP.md`).

### Cấp 4: Steering Committee (Hội đồng điều hành tối cao)
- **Cơ cấu:** Gồm **03 thành viên thường trực**, nhiệm kỳ **01 năm**, bầu cử dân chủ theo quy chế bỏ phiếu kín của cộng đồng Core Maintainers.
- **Quyền hạn kỹ thuật:** Được cấp quyền **`Admin`** (quản lý bí mật Secrets, phân quyền Organization/Repository, quản trị tài sản số, xử lý báo cáo an ninh [SECURITY.md](SECURITY.md), phê duyệt cuối cùng đối với các đề xuất RFC và chủ trì quyết định tranh chấp theo [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)).

---

## 2. Cơ chế ra quyết định (RFC & Lazy Consensus)

Mọi thay đổi kiến trúc cốt lõi hoặc thay đổi phá vỡ tương thích ngược (Breaking Changes) đều bắt buộc đi qua quy trình **RFC (Request for Comments)** tại thư mục `docs/rfc/`:
- Tác giả mở Pull Request đề xuất RFC với đầy đủ các mục: Tóm tắt (Summary), Động lực (Motivation), Tác động phá vỡ (Breaking Changes), và Giải pháp thay thế (Alternatives).
- Dự án áp dụng cơ chế **Đồng thuận tĩnh (Lazy Consensus — chuẩn Apache)**: Sau khi Project Lead / Steering Committee công bố mở giai đoạn thảo luận (mặc định **72 giờ**), nếu không có bất kỳ phiếu phản đối kỹ thuật có lý do hợp lệ (**`-1 Veto`**) nào từ Core Maintainers, đề xuất được xem là mặc định thông qua.
- Khi có phiếu **`-1 Veto`**, đề xuất không được gộp cho đến khi tác giả điều chỉnh kỹ thuật và người phủ quyết xác nhận thỏa mãn bằng phiếu **`+1`**.

---

## 3. Tiêu chuẩn thành viên danh dự (Emeritus Status)

- Maintainer hoặc thành viên Steering Committee không hoạt động liên tục trong **06 tháng** sẽ được chuyển sang trạng thái thành viên danh dự (**Emeritus Member**).
- Quyền ghi (**`Write`** / **`Admin`**) sẽ được thu hồi tạm thời để bảo vệ an toàn chuỗi cung ứng của dự án, nhưng thành viên vẫn giữ nguyên vinh danh trong hồ sơ lịch sử tại [MAINTAINERS.md](../MAINTAINERS.md).
- Thành viên danh dự có thể yêu cầu khôi phục quyền hạn bất cứ lúc nào khi quay lại đóng góp tích cực, thông qua biểu quyết đồng thuận của Steering Committee.

---

## 4. Tài liệu quản trị liên quan

- [MAINTAINERS.md](../MAINTAINERS.md) — Danh sách người bảo trì đương nhiệm & chính sách chuyển giao khẩn cấp (90 ngày).
- [ROADMAP.md](../ROADMAP.md) — Bản đồ lộ trình phát triển 3 thì (Now - Next - Later).
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) — Bộ quy tắc ứng xử cộng đồng và quy trình 4 cấp độ chế tài.
- [SECURITY.md](SECURITY.md) — Chính sách tiếp nhận và xử lý báo cáo lỗ hổng bảo mật.
