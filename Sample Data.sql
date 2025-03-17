USE QuanLyVanTai;
GO

INSERT INTO ThanhPho (MaThanhPho, TenThanhPho)
VALUES 
    (1, 'Hà Nội'),
    (2, 'TP. Hồ Chí Minh'),
    (3, 'Đà Nẵng');
GO

INSERT INTO ChiNhanh (MaChiNhanh, TenChiNhanh, MaThanhPho)
VALUES 
    (101, 'Chi nhánh Hà Nội 1', 1),
    (102, 'Chi nhánh Hà Nội 2', 1),
    (201, 'Chi nhánh Sài Gòn', 2),
    (301, 'Chi nhánh Đà Nẵng', 3);
GO

INSERT INTO Xe (BienSoXe, HangSanXuat, LoaiXe, SoChoNgoi, TrongTaiToiDa, MaChiNhanh)
VALUES 
    ('29B-12345', 'Hyundai', 'Chở khách', 45, NULL, 101),
    ('29B-12346', 'Thaco', 'Chở khách', 50, NULL, 101),
    ('51B-54321', 'Daewoo', 'Chở khách', 40, NULL, 201),
    ('51B-54322', 'Hyundai', 'Chở khách', 45, NULL, 201),
    ('43B-98765', 'Thaco', 'Chở khách', 50, NULL, 301),
    ('29B-12347', 'Daewoo', 'Chở khách', 40, NULL, 102);
GO

INSERT INTO TaiXe (MaTaiXe, TenTaiXe, SoDienThoai, MaChiNhanh)
VALUES 
    (1001, 'Nguyễn Văn A', '0912345678', 101),
    (1002, 'Trần Thị B', '0987654321', 101),
    (2001, 'Lê Văn C', '0901234567', 201),
    (2002, 'Phạm Thị D', '0934567890', 201),
    (3001, 'Hoàng Văn E', '0971234567', 301),
    (1003, 'Đỗ Thị F', '0945678901', 102);
GO

INSERT INTO PhanCong (BienSoXe, MaTaiXe, Ngay, Gio, SoNgay, SoGio)
VALUES 
    ('29B-12345', 1001, '2025-03-15', '07:00:00', 1, 8),
    ('29B-12346', 1002, '2025-03-15', '08:00:00', 1, 6),
    ('51B-54321', 2001, '2025-03-16', '06:30:00', 1, 7),
    ('51B-54322', 2002, '2025-03-16', '07:30:00', 1, 8),
    ('43B-98765', 3001, '2025-03-17', '08:00:00', 1, 6),
    ('29B-12345', 1001, '2025-03-17', '07:00:00', 1, 8),
    ('29B-12347', 1003, '2025-03-17', '06:00:00', 1, 7);
GO

