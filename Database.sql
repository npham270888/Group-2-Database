-- Tạo cơ sở dữ liệu
CREATE DATABASE QuanLyVanTai;
GO

-- Sử dụng cơ sở dữ liệu vừa tạo
USE QuanLyVanTai;
GO

-- Tạo bảng ThanhPho
CREATE TABLE ThanhPho (
    MaThanhPho INT PRIMARY KEY,
    TenThanhPho VARCHAR(100) NOT NULL
);
GO

-- Tạo bảng ChiNhanh
CREATE TABLE ChiNhanh (
    MaChiNhanh INT PRIMARY KEY,
    TenChiNhanh VARCHAR(100) NOT NULL,
    MaThanhPho INT NOT NULL,
    FOREIGN KEY (MaThanhPho) REFERENCES ThanhPho(MaThanhPho)
);
GO

-- Tạo bảng Xe
CREATE TABLE Xe (
    BienSoXe VARCHAR(20) PRIMARY KEY,
    HangSanXuat VARCHAR(50) NOT NULL,
    LoaiXe VARCHAR(20) NOT NULL,
    SoChoNgoi INT,
    TrongTaiToiDa FLOAT,
    MaChiNhanh INT NOT NULL,
    FOREIGN KEY (MaChiNhanh) REFERENCES ChiNhanh(MaChiNhanh)
);
GO

-- Tạo bảng TaiXe
CREATE TABLE TaiXe (
    MaTaiXe INT PRIMARY KEY,
    TenTaiXe VARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15) NOT NULL,
    MaChiNhanh INT NOT NULL,
    FOREIGN KEY (MaChiNhanh) REFERENCES ChiNhanh(MaChiNhanh)
);
GO

-- Tạo bảng PhanCong
CREATE TABLE PhanCong (
    MaPhanCong INT PRIMARY KEY IDENTITY(1,1),
    BienSoXe VARCHAR(20) NOT NULL,
    MaTaiXe INT NOT NULL,
    Ngay DATE NOT NULL,
    Gio TIME NOT NULL,
    SoNgay INT,
    SoGio INT,
    FOREIGN KEY (BienSoXe) REFERENCES Xe(BienSoXe),
    FOREIGN KEY (MaTaiXe) REFERENCES TaiXe(MaTaiXe)
);
GO

ALTER TABLE Xe
ADD CONSTRAINT KiemTraLoaiXe
CHECK (
    (LoaiXe = 'Chở khách' AND SoChoNgoi IS NOT NULL AND TrongTaiToiDa IS NULL) OR
    (LoaiXe = 'Vận tải' AND TrongTaiToiDa IS NOT NULL AND SoChoNgoi IS NULL) OR
    (LoaiXe NOT IN ('Chở khách', 'Vận tải') AND SoChoNgoi IS NULL AND TrongTaiToiDa IS NULL)
);
GO
-- View 1: Hiển thị thông tin xe và chi nhánh quản lý
CREATE VIEW vw_Xe_ChiNhanh AS
SELECT x.BienSoXe, x.HangSanXuat, x.LoaiXe, x.SoChoNgoi, x.TrongTaiToiDa, c.TenChiNhanh
FROM Xe x
INNER JOIN ChiNhanh c ON x.MaChiNhanh = c.MaChiNhanh;
GO

-- View 2: Hiển thị thông tin tài xế và chi nhánh
CREATE VIEW vw_TaiXe_ChiNhanh AS
SELECT t.MaTaiXe, t.TenTaiXe, t.SoDienThoai, c.TenChiNhanh
FROM TaiXe t
INNER JOIN ChiNhanh c ON t.MaChiNhanh = c.MaChiNhanh;
GO

-- View 3: Hiển thị thông tin phân công xe
CREATE VIEW vw_PhanCong AS
SELECT p.MaPhanCong, p.BienSoXe, t.TenTaiXe, p.Ngay, p.Gio, p.SoNgay, p.SoGio
FROM PhanCong p
INNER JOIN TaiXe t ON p.MaTaiXe = t.MaTaiXe;
GO

-- View 4: Hiển thị số lượng xe theo loại
CREATE VIEW vw_SoLuongXeTheoLoai AS
SELECT LoaiXe, COUNT(*) AS SoLuong
FROM Xe
GROUP BY LoaiXe;
GO

-- View 5: Hiển thị tài xế có số ngày lái xe nhiều nhất
CREATE VIEW vw_TaiXe_NhieuNgayNhat AS
SELECT TOP 1 t.TenTaiXe, SUM(p.SoNgay) AS TongSoNgay
FROM PhanCong p
INNER JOIN TaiXe t ON p.MaTaiXe = t.MaTaiXe
GROUP BY t.TenTaiXe
ORDER BY TongSoNgay DESC;
GO

-- View 6: Hiển thị xe chưa được phân công
CREATE VIEW vw_Xe_ChuaPhanCong AS
SELECT x.BienSoXe, x.HangSanXuat, x.LoaiXe
FROM Xe x
LEFT JOIN PhanCong p ON x.BienSoXe = p.BienSoXe
WHERE p.MaPhanCong IS NULL;
GO

-- View 7: Hiển thị chi nhánh có nhiều xe nhất
CREATE VIEW vw_ChiNhanh_NhieuXeNhat AS
SELECT TOP 1 c.TenChiNhanh, COUNT(x.BienSoXe) AS SoLuongXe
FROM ChiNhanh c
INNER JOIN Xe x ON c.MaChiNhanh = x.MaChiNhanh
GROUP BY c.TenChiNhanh
ORDER BY SoLuongXe DESC;
GO

-- View 8: Hiển thị tài xế lái nhiều loại xe khác nhau
CREATE VIEW vw_TaiXe_LaiNhieuLoaiXe AS
SELECT t.TenTaiXe, COUNT(DISTINCT x.LoaiXe) AS SoLoaiXe
FROM PhanCong p
INNER JOIN TaiXe t ON p.MaTaiXe = t.MaTaiXe
INNER JOIN Xe x ON p.BienSoXe = x.BienSoXe
GROUP BY t.TenTaiXe
HAVING COUNT(DISTINCT x.LoaiXe) > 1;
GO

-- View 9: Hiển thị xe có trọng tải lớn hơn trung bình
CREATE VIEW vw_Xe_TrongTaiLonHonTrungBinh AS
SELECT BienSoXe, TrongTaiToiDa
FROM Xe
WHERE LoaiXe = 'Vận tải' AND TrongTaiToiDa > (SELECT AVG(TrongTaiToiDa) FROM Xe WHERE LoaiXe = 'Vận tải');
GO

-- View 10: Hiển thị phân công trong tuần hiện tại
CREATE VIEW vw_PhanCong_TuanHienTai AS
SELECT p.MaPhanCong, p.BienSoXe, t.TenTaiXe, p.Ngay, p.Gio
FROM PhanCong p
INNER JOIN TaiXe t ON p.MaTaiXe = t.MaTaiXe
WHERE p.Ngay >= DATEADD(day, -7, GETDATE()) AND p.Ngay <= GETDATE();
GO
-- Index 1: Trên cột MaChiNhanh của bảng Xe
CREATE INDEX idx_Xe_MaChiNhanh ON Xe(MaChiNhanh);
GO

-- Index 2: Trên cột MaTaiXe của bảng PhanCong
CREATE INDEX idx_PhanCong_MaTaiXe ON PhanCong(MaTaiXe);
GO

-- Index 3: Trên cột BienSoXe của bảng PhanCong
CREATE INDEX idx_PhanCong_BienSoXe ON PhanCong(BienSoXe);
GO

-- Index 4: Trên cột Ngay của bảng PhanCong
CREATE INDEX idx_PhanCong_Ngay ON PhanCong(Ngay);
GO

-- Index 5: Trên cột LoaiXe của bảng Xe
CREATE INDEX idx_Xe_LoaiXe ON Xe(LoaiXe);
GO

-- Index 6: Trên cột MaThanhPho của bảng ChiNhanh
CREATE INDEX idx_ChiNhanh_MaThanhPho ON ChiNhanh(MaThanhPho);
GO

-- Index 7: Trên cột SoDienThoai của bảng TaiXe
CREATE INDEX idx_TaiXe_SoDienThoai ON TaiXe(SoDienThoai);
GO

-- Index 8: Trên cột TenTaiXe của bảng TaiXe
CREATE INDEX idx_TaiXe_TenTaiXe ON TaiXe(TenTaiXe);
GO

-- Index 9: Trên cột HangSanXuat của bảng Xe
CREATE INDEX idx_Xe_HangSanXuat ON Xe(HangSanXuat);
GO

-- Index 10: Trên cột Gio của bảng PhanCong
CREATE INDEX idx_PhanCong_Gio ON PhanCong(Gio);
GO
-- Procedure 1: Thêm xe mới
CREATE PROCEDURE sp_ThemXe
    @BienSoXe VARCHAR(20),
    @HangSanXuat VARCHAR(50),
    @LoaiXe VARCHAR(20),
    @SoChoNgoi INT,
    @TrongTaiToiDa FLOAT,
    @MaChiNhanh INT
AS
BEGIN
    INSERT INTO Xe (BienSoXe, HangSanXuat, LoaiXe, SoChoNgoi, TrongTaiToiDa, MaChiNhanh)
    VALUES (@BienSoXe, @HangSanXuat, @LoaiXe, @SoChoNgoi, @TrongTaiToiDa, @MaChiNhanh);
END
GO

-- Procedure 2: Cập nhật thông tin tài xế
CREATE PROCEDURE sp_CapNhatTaiXe
    @MaTaiXe INT,
    @TenTaiXe VARCHAR(100),
    @SoDienThoai VARCHAR(15),
    @MaChiNhanh INT
AS
BEGIN
    UPDATE TaiXe
    SET TenTaiXe = @TenTaiXe, SoDienThoai = @SoDienThoai, MaChiNhanh = @MaChiNhanh
    WHERE MaTaiXe = @MaTaiXe;
END
GO

-- Procedure 3: Xóa phân công
CREATE PROCEDURE sp_XoaPhanCong
    @MaPhanCong INT
AS
BEGIN
    DELETE FROM PhanCong WHERE MaPhanCong = @MaPhanCong;
END
GO

-- Procedure 4: Lấy danh sách xe theo chi nhánh
CREATE PROCEDURE sp_DanhSachXeTheoChiNhanh
    @MaChiNhanh INT
AS
BEGIN
    SELECT * FROM Xe WHERE MaChiNhanh = @MaChiNhanh;
END
GO

-- Procedure 5: Tính tổng số ngày lái xe của tài xế
CREATE PROCEDURE sp_TongSoNgayLaiXe
    @MaTaiXe INT,
    @TongSoNgay INT OUTPUT
AS
BEGIN
    SELECT @TongSoNgay = SUM(SoNgay)
    FROM PhanCong
    WHERE MaTaiXe = @MaTaiXe;
END
GO

-- Procedure 6: Thêm chi nhánh mới
CREATE PROCEDURE sp_ThemChiNhanh
    @MaChiNhanh INT,
    @TenChiNhanh VARCHAR(100),
    @MaThanhPho INT
AS
BEGIN
    INSERT INTO ChiNhanh (MaChiNhanh, TenChiNhanh, MaThanhPho)
    VALUES (@MaChiNhanh, @TenChiNhanh, @MaThanhPho);
END
GO

-- Procedure 7: Lấy thông tin xe và tài xế phân công
CREATE PROCEDURE sp_ThongTinXeTaiXe
    @BienSoXe VARCHAR(20)
AS
BEGIN
    SELECT x.BienSoXe, x.HangSanXuat, x.LoaiXe, t.TenTaiXe, p.Ngay, p.Gio
    FROM PhanCong p
    INNER JOIN Xe x ON p.BienSoXe = x.BienSoXe
    INNER JOIN TaiXe t ON p.MaTaiXe = t.MaTaiXe
    WHERE x.BienSoXe = @BienSoXe;
END
GO

-- Procedure 8: Cập nhật số chỗ ngồi của xe
CREATE PROCEDURE sp_CapNhatSoChoNgoi
    @BienSoXe VARCHAR(20),
    @SoChoNgoi INT
AS
BEGIN
    UPDATE Xe
    SET SoChoNgoi = @SoChoNgoi
    WHERE BienSoXe = @BienSoXe AND LoaiXe = 'Chở khách';
END
GO

-- Procedure 9: Lấy danh sách tài xế chưa được phân công
CREATE PROCEDURE sp_TaiXeChuaPhanCong
AS
BEGIN
    SELECT t.MaTaiXe, t.TenTaiXe
    FROM TaiXe t
    LEFT JOIN PhanCong p ON t.MaTaiXe = p.MaTaiXe
    WHERE p.MaPhanCong IS NULL;
END
GO

-- Procedure 10: Tính số lượng xe theo hãng sản xuất
CREATE PROCEDURE sp_SoLuongXeTheoHang
    @HangSanXuat VARCHAR(50),
    @SoLuong INT OUTPUT
AS
BEGIN
    SELECT @SoLuong = COUNT(*)
    FROM Xe
    WHERE HangSanXuat = @HangSanXuat;
END
GO
-- Function 1: Tính tổng số xe của một chi nhánh
CREATE FUNCTION fn_TongSoXeChiNhanh (@MaChiNhanh INT)
RETURNS INT
AS
BEGIN
    DECLARE @TongSoXe INT;
    SELECT @TongSoXe = COUNT(*) FROM Xe WHERE MaChiNhanh = @MaChiNhanh;
    RETURN @TongSoXe;
END
GO

-- Function 2: Lấy tên thành phố từ mã thành phố
CREATE FUNCTION fn_TenThanhPho (@MaThanhPho INT)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @TenThanhPho VARCHAR(100);
    SELECT @TenThanhPho = TenThanhPho FROM ThanhPho WHERE MaThanhPho = @MaThanhPho;
    RETURN @TenThanhPho;
END
GO

-- Function 3: Kiểm tra xe có phải là xe chở khách hay không
CREATE FUNCTION fn_LaXeChoKhach (@BienSoXe VARCHAR(20))
RETURNS BIT
AS
BEGIN
    DECLARE @LaXeChoKhach BIT;
    SELECT @LaXeChoKhach = CASE WHEN LoaiXe = 'Chở khách' THEN 1 ELSE 0 END FROM Xe WHERE BienSoXe = @BienSoXe;
    RETURN @LaXeChoKhach;
END
GO

-- Function 4: Lấy danh sách xe theo loại
CREATE FUNCTION fn_DanhSachXeTheoLoai (@LoaiXe VARCHAR(20))
RETURNS TABLE
AS
RETURN
(
    SELECT BienSoXe, HangSanXuat, SoChoNgoi, TrongTaiToiDa
    FROM Xe
    WHERE LoaiXe = @LoaiXe
);
GO

-- Function 5: Tính tổng số giờ lái xe của tài xế
CREATE FUNCTION fn_TongSoGioLaiXe (@MaTaiXe INT)
RETURNS INT
AS
BEGIN
    DECLARE @TongSoGio INT;
    SELECT @TongSoGio = SUM(SoGio) FROM PhanCong WHERE MaTaiXe = @MaTaiXe;
    RETURN ISNULL(@TongSoGio, 0);
END
GO

-- Function 6: Lấy thông tin chi nhánh từ mã chi nhánh
CREATE FUNCTION fn_ThongTinChiNhanh (@MaChiNhanh INT)
RETURNS TABLE
AS
RETURN
(
    SELECT c.TenChiNhanh, t.TenThanhPho
    FROM ChiNhanh c
    INNER JOIN ThanhPho t ON c.MaThanhPho = t.MaThanhPho
    WHERE c.MaChiNhanh = @MaChiNhanh
);
GO

-- Function 7: Kiểm tra tài xế có được phân công trong ngày cụ thể không
CREATE FUNCTION fn_TaiXeDuocPhanCong (@MaTaiXe INT, @Ngay DATE)
RETURNS BIT
AS
BEGIN
    DECLARE @DuocPhanCong BIT;
    SELECT @DuocPhanCong = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
    FROM PhanCong
    WHERE MaTaiXe = @MaTaiXe AND Ngay = @Ngay;
    RETURN @DuocPhanCong;
END
GO

-- Function 8: Lấy danh sách phân công theo xe
CREATE FUNCTION fn_DanhSachPhanCongTheoXe (@BienSoXe VARCHAR(20))
RETURNS TABLE
AS
RETURN
(
    SELECT p.MaPhanCong, t.TenTaiXe, p.Ngay, p.Gio, p.SoNgay, p.SoGio
    FROM PhanCong p
    INNER JOIN TaiXe t ON p.MaTaiXe = t.MaTaiXe
    WHERE p.BienSoXe = @BienSoXe
);
GO

-- Function 9: Tính số lượng tài xế theo chi nhánh
CREATE FUNCTION fn_SoLuongTaiXeTheoChiNhanh (@MaChiNhanh INT)
RETURNS INT
AS
BEGIN
    DECLARE @SoLuong INT;
    SELECT @SoLuong = COUNT(*) FROM TaiXe WHERE MaChiNhanh = @MaChiNhanh;
    RETURN @SoLuong;
END
GO

-- Function 10: Lấy danh sách xe chưa được phân công
CREATE FUNCTION fn_XeChuaPhanCong ()
RETURNS @XeChuaPhanCong TABLE (BienSoXe VARCHAR(20), HangSanXuat VARCHAR(50), LoaiXe VARCHAR(20))
AS
BEGIN
    INSERT INTO @XeChuaPhanCong
    SELECT x.BienSoXe, x.HangSanXuat, x.LoaiXe
    FROM Xe x
    LEFT JOIN PhanCong p ON x.BienSoXe = p.BienSoXe
    WHERE p.MaPhanCong IS NULL;
    RETURN;
END
GO
-- Trigger 1: Kiểm tra trước khi thêm xe mới
CREATE TRIGGER tr_KiemTraThemXe ON Xe
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM INSERTED i WHERE i.LoaiXe = 'Chở khách' AND i.SoChoNgoi IS NULL)
    BEGIN
        RAISERROR ('Xe chở khách phải có số chỗ ngồi', 16, 1);
    END
    ELSE IF EXISTS (SELECT 1 FROM INSERTED i WHERE i.LoaiXe = 'Vận tải' AND i.TrongTaiToiDa IS NULL)
    BEGIN
        RAISERROR ('Xe vận tải phải có trọng tải tối đa', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO Xe (BienSoXe, HangSanXuat, LoaiXe, SoChoNgoi, TrongTaiToiDa, MaChiNhanh)
        SELECT BienSoXe, HangSanXuat, LoaiXe, SoChoNgoi, TrongTaiToiDa, MaChiNhanh FROM INSERTED;
    END
END
GO

-- Trigger 2: Ghi log khi cập nhật thông tin tài xế
CREATE TABLE LogTaiXe (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    MaTaiXe INT,
    TenTaiXeCu VARCHAR(100),
    TenTaiXeMoi VARCHAR(100),
    ThoiGianCapNhat DATETIME
);
GO

CREATE TRIGGER tr_LogCapNhatTaiXe ON TaiXe
AFTER UPDATE
AS
BEGIN
    INSERT INTO LogTaiXe (MaTaiXe, TenTaiXeCu, TenTaiXeMoi, ThoiGianCapNhat)
    SELECT d.MaTaiXe, d.TenTaiXe, i.TenTaiXe, GETDATE()
    FROM DELETED d
    INNER JOIN INSERTED i ON d.MaTaiXe = i.MaTaiXe;
END
GO

-- Trigger 3: Kiểm tra trước khi xóa phân công
CREATE TRIGGER tr_KiemTraXoaPhanCong ON PhanCong
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM DELETED d WHERE d.Ngay < GETDATE())
    BEGIN
        RAISERROR ('Không thể xóa phân công trong quá khứ', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM PhanCong WHERE MaPhanCong IN (SELECT MaPhanCong FROM DELETED);
    END
END
GO

-- Trigger 4: Cập nhật số lượng xe khi thêm xe mới
ALTER TABLE ChiNhanh
ADD SoLuongXe INT DEFAULT 0;
GO

CREATE TRIGGER tr_CapNhatSoLuongXe ON Xe
AFTER INSERT
AS
BEGIN
    UPDATE c
    SET c.SoLuongXe = c.SoLuongXe + 1
    FROM ChiNhanh c
    INNER JOIN INSERTED i ON c.MaChiNhanh = i.MaChiNhanh;
END
GO

-- Trigger 5: Kiểm tra số điện thoại khi thêm tài xế
CREATE TRIGGER tr_KiemTraSoDienThoai ON TaiXe
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM INSERTED i WHERE i.SoDienThoai NOT LIKE '0%')
    BEGIN
        RAISERROR ('Số điện thoại phải bắt đầu bằng 0', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO TaiXe (MaTaiXe, TenTaiXe, SoDienThoai, MaChiNhanh)
        SELECT MaTaiXe, TenTaiXe, SoDienThoai, MaChiNhanh FROM INSERTED;
    END
END
GO

-- TẠO DATABASE VÀ CÁC ĐỐI TƯỢNG CƠ BẢN
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'QuanLyVanTai')
BEGIN
    CREATE DATABASE QuanLyVanTai;
END
GO

USE QuanLyVanTai;
GO

-- TẠO CÁC BẢNG CẦN THIẾT
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ChiNhanh')
BEGIN
    CREATE TABLE dbo.ChiNhanh (
        MaChiNhanh INT PRIMARY KEY,
        TenChiNhanh NVARCHAR(100)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Xe')
BEGIN
    CREATE TABLE dbo.Xe (
        MaXe INT PRIMARY KEY,
        BienSo NVARCHAR(20),
        ChiNhanhID INT
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TaiXe')
BEGIN
    CREATE TABLE dbo.TaiXe (
        MaTaiXe INT PRIMARY KEY,
        TenTaiXe NVARCHAR(100)
    );
END

IF NOT EXISTS (SELECT * FROM sys.views WHERE name = 'vw_PhanCong')
BEGIN
    EXEC('CREATE VIEW dbo.vw_PhanCong AS SELECT 1 AS Dummy');
END
GO

-- QUẢN LÝ LOGIN/USER
DECLARE @SQL NVARCHAR(MAX);

-- Tạo login admin
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'admin')
BEGIN
    SET @SQL = 'CREATE LOGIN admin WITH PASSWORD = ''Admin@123456'', CHECK_POLICY = ON;';
    EXEC sp_executesql @SQL;
END

-- Tạo login branch_manager
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'branch_manager')
BEGIN
    SET @SQL = 'CREATE LOGIN branch_manager WITH PASSWORD = ''Manager@Secure987'', CHECK_POLICY = ON;';
    EXEC sp_executesql @SQL;
END

-- Tạo login driver
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'driver')
BEGIN
    SET @SQL = 'CREATE LOGIN driver WITH PASSWORD = ''Driver@Pass123!'', CHECK_POLICY = ON;';
    EXEC sp_executesql @SQL;
END

-- Tạo user và gán quyền
USE QuanLyVanTai;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'admin')
BEGIN
    CREATE USER admin FOR LOGIN admin;
    ALTER ROLE db_owner ADD MEMBER admin;
END

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'branch_manager')
BEGIN
    CREATE USER branch_manager FOR LOGIN branch_manager;
    GRANT SELECT, INSERT, UPDATE ON dbo.ChiNhanh TO branch_manager;
    GRANT SELECT, INSERT, UPDATE ON dbo.Xe TO branch_manager;
    GRANT SELECT ON dbo.TaiXe TO branch_manager;
END

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'driver')
BEGIN
    CREATE USER driver FOR LOGIN driver;
    GRANT SELECT ON dbo.vw_PhanCong TO driver;
END
GO

-- SAO LƯU DATABASE
USE master;
GO

DECLARE @BackupPath NVARCHAR(500) = 'D:\Backup\';
DECLARE @FolderExist INT;

EXEC master.dbo.xp_fileexist @BackupPath, @FolderExist OUTPUT;

IF @FolderExist = 0
BEGIN
    EXEC xp_create_subdir @BackupPath;
END

BACKUP DATABASE QuanLyVanTai 
TO DISK = @BackupPath + 'QuanLyVanTai_Full.bak'
WITH 
    FORMAT,
    NAME = 'Full Backup of QuanLyVanTai',
    COMPRESSION,
    CHECKSUM;
GO

-- PHỤC HỒI DATABASE
USE master;
GO

-- Đóng tất cả kết nối hiện tại
ALTER DATABASE QuanLyVanTai SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

RESTORE DATABASE QuanLyVanTai 
FROM DISK = 'D:\Backup\QuanLyVanTai_Full.bak'
WITH 
    REPLACE,
    RECOVERY,
    STATS = 5,
    CHECKSUM;

-- Trả lại chế độ multi-user
ALTER DATABASE QuanLyVanTai SET MULTI_USER;
GO