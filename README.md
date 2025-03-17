# QuanLyVanTai Database

## Giới thiệu
Cơ sở dữ liệu `QuanLyVanTai` được thiết kế để quản lý vận tải, tập trung vào xe bus (loại "Chở khách"). Hệ thống sử dụng SQL Server và bao gồm các bảng, view, stored procedure, function, trigger và index để quản lý thông tin về thành phố, chi nhánh, xe bus, tài xế và lịch phân công.

**Ngày hiện tại trong tài liệu:** 17/03/2025.

---

## Cấu trúc cơ sở dữ liệu

### Bảng (Tables)
1. **ThanhPho** (Thành phố)
   - `MaThanhPho` (INT, PK): Mã thành phố.
   - `TenThanhPho` (VARCHAR(100)): Tên thành phố.

2. **ChiNhanh** (Chi nhánh)
   - `MaChiNhanh` (INT, PK): Mã chi nhánh.
   - `TenChiNhanh` (VARCHAR(100)): Tên chi nhánh.
   - `MaThanhPho` (INT, FK): Liên kết tới `ThanhPho`.
   - `SoLuongXe` (INT): Số lượng xe (tự động cập nhật qua trigger).

3. **Xe** (Xe bus)
   - `BienSoXe` (VARCHAR(20), PK): Biển số xe.
   - `HangSanXuat` (VARCHAR(50)): Hãng sản xuất.
   - `LoaiXe` (VARCHAR(20)): Loại xe (chỉ "Chở khách").
   - `SoChoNgoi` (INT): Số chỗ ngồi.
   - `TrongTaiToiDa` (FLOAT): Trọng tải tối đa (NULL cho xe bus).
   - `MaChiNhanh` (INT, FK): Liên kết tới `ChiNhanh`.
   - **Ràng buộc**: Xe bus phải có `SoChoNgoi`, không có `TrongTaiToiDa`.

4. **TaiXe** (Tài xế)
   - `MaTaiXe` (INT, PK): Mã tài xế.
   - `TenTaiXe` (VARCHAR(100)): Tên tài xế.
   - `SoDienThoai` (VARCHAR(15)): Số điện thoại (bắt đầu bằng "0").
   - `MaChiNhanh` (INT, FK): Liên kết tới `ChiNhanh`.

5. **PhanCong** (Phân công)
   - `MaPhanCong` (INT, PK, IDENTITY): Mã phân công.
   - `BienSoXe` (VARCHAR(20), FK): Liên kết tới `Xe`.
   - `MaTaiXe` (INT, FK): Liên kết tới `TaiXe`.
   - `Ngay` (DATE): Ngày phân công.
   - `Gio` (TIME): Giờ bắt đầu.
   - `SoNgay` (INT): Số ngày làm việc.
   - `SoGio` (INT): Số giờ làm việc.

6. **LogTaiXe** (Log cập nhật tài xế)
   - `LogID` (INT, PK, IDENTITY): Mã log.
   - `MaTaiXe` (INT): Mã tài xế.
   - `TenTaiXeCu` (VARCHAR(100)): Tên cũ.
   - `TenTaiXeMoi` (VARCHAR(100)): Tên mới.
   - `ThoiGianCapNhat` (DATETIME): Thời gian cập nhật.

---

### Thành phần bổ sung
- **View**: 10 view cung cấp các góc nhìn dữ liệu (xe chưa phân công, tài xế lái nhiều nhất, v.v.).
- **Stored Procedure**: 10 procedure hỗ trợ thêm, sửa, xóa và truy vấn dữ liệu.
- **Function**: 10 hàm trả về giá trị hoặc bảng (tổng số xe, danh sách phân công, v.v.).
- **Trigger**: 5 trigger đảm bảo tính toàn vẹn (kiểm tra số điện thoại, log cập nhật tài xế, v.v.).
- **Index**: 10 index tối ưu hóa truy vấn trên các cột thường dùng.

Chi tiết các thành phần nằm trong file `QuanLyVanTai.sql`.

---

## Dữ liệu mẫu
Dữ liệu mẫu đã được nhập với các đặc điểm:
- **ThanhPho**: 3 thành phố (Hà Nội, TP. Hồ Chí Minh, Đà Nẵng).
- **ChiNhanh**: 4 chi nhánh.
- **Xe**: 6 xe bus từ 3 hãng (Hyundai, Thaco, Daewoo).
- **TaiXe**: 6 tài xế.
- **PhanCong**: 7 lịch phân công từ 15/03/2025 đến 17/03/2025.

Xem file `QuanLyVanTai.sql` để biết chi tiết dữ liệu mẫu.

---

## Hướng dẫn sử dụng

### Yêu cầu
- SQL Server (phiên bản bất kỳ hỗ trợ các tính năng trên).
- Quyền truy cập cơ sở dữ liệu với vai trò `db_owner` để tạo và chỉnh sửa.

### Cài đặt
1. Tạo cơ sở dữ liệu:
   ```sql
   CREATE DATABASE QuanLyVanTai;
   USE QuanLyVanTai;
