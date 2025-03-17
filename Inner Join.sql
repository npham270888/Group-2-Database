USE QuanLyVanTai;
GO

SELECT x.BienSoXe, x.HangSanXuat, x.SoChoNgoi, t.TenTaiXe, p.Ngay, p.Gio
FROM Xe x
INNER JOIN PhanCong p ON x.BienSoXe = p.BienSoXe
INNER JOIN TaiXe t ON p.MaTaiXe = t.MaTaiXe
WHERE x.MaChiNhanh = 101;

SELECT c.TenChiNhanh, tp.TenThanhPho, x.BienSoXe
FROM ChiNhanh c
INNER JOIN ThanhPho tp ON c.MaThanhPho = tp.MaThanhPho
INNER JOIN Xe x ON c.MaChiNhanh = x.MaChiNhanh
INNER JOIN PhanCong p ON x.BienSoXe = p.BienSoXe;