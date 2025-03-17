USE QuanLyVanTai;
GO

SELECT BienSoXe, HangSanXuat, SoChoNgoi
FROM Xe
WHERE MaChiNhanh = 101;
GO

SELECT MaTaiXe, TenTaiXe, SoDienThoai
FROM TaiXe
WHERE MaChiNhanh = 201;
GO

SELECT BienSoXe, MaTaiXe, Gio, SoGio
FROM PhanCong
WHERE Ngay = '2025-03-17';
GO

SELECT TenThanhPho
FROM ThanhPho
WHERE MaThanhPho = (SELECT MaThanhPho FROM ChiNhanh WHERE MaChiNhanh = 301);
GO