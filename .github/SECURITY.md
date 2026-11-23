# CHÍNH SÁCH BẢO MẬT (SECURITY POLICY)

## 1. Phiên bản được hỗ trợ

| Phiên bản | Trạng thái hỗ trợ bảo mật |
|---|---|
| `main` (BVN 2.6 Netplay hiện hành) | ✅ Đang hỗ trợ |
| Các bản cũ chưa vá | ❌ Không hỗ trợ |

---

## 2. Quy trình báo cáo lỗ hổng bảo mật

**KHÔNG** báo cáo lỗ hổng bảo mật nghiêm trọng (`priority: P0 (Critical)`) trực tiếp qua GitHub Issues công khai để tránh bị khai thác trước khi có bản vá.

Vui lòng gửi báo cáo riêng tư tới **Steering Committee (Admin)**:
- **Email bảo mật:** `khoaphamit2004@gmail.com`
- **Tiêu đề gợi ý:** `[SECURITY] Mô tả ngắn gọn lỗ hổng`
- **Nội dung cần cung cấp:**
  1. Mô tả chi tiết lỗ hổng và thành phần bị ảnh hưởng (Server Node.js, Client AS2, hoặc quy trình patch).
  2. Các bước tái hiện (Proof of Concept) và log liên quan.
  3. Đánh giá mức độ ảnh hưởng và đề xuất khắc phục (nếu có).

---

## 3. Cam kết phản hồi (SLA)

- **Xác nhận tiếp nhận:** Trong vòng **24–48 giờ** làm việc.
- **Đánh giá & Phân loại:** Trong vòng **72 giờ** (gán mức ưu tiên `P0` cho lỗ hổng nghiêm trọng).
- **Công bố có trách nhiệm (Coordinated Disclosure):** Steering Committee phối hợp cùng người báo cáo phát hành bản vá trước khi công bố chi tiết kỹ thuật ra cộng đồng.
