USE QuanLyVanTai;
GO

USE QuanLyVanTai;
GO

UPDATE Xe
SET SoChoNgoi = 48
WHERE BienSoXe = '29B-12345';
GO

UPDATE TaiXe
SET SoDienThoai = '0919876543'
WHERE MaTaiXe = 1001;
GO

UPDATE PhanCong
SET Gio = '09:00:00', SoGio = 7
WHERE BienSoXe = '43B-98765' AND Ngay = '2025-03-17';
GO