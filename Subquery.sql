USE QuanLyVanTai;
GO

SELECT x.BienSoXe, x.HangSanXuat, x.SoChoNgoi
FROM Xe x
WHERE x.SoChoNgoi > (SELECT AVG(SoChoNgoi) FROM Xe);

SELECT t.MaTaiXe, t.TenTaiXe
FROM TaiXe t
WHERE t.MaChiNhanh = 101
AND t.MaTaiXe NOT IN (SELECT p.MaTaiXe FROM PhanCong p);

SELECT c.TenChiNhanh, COUNT(x.BienSoXe) AS SoLuongXe
FROM ChiNhanh c
INNER JOIN Xe x ON c.MaChiNhanh = x.MaChiNhanh
GROUP BY c.TenChiNhanh
HAVING COUNT(x.BienSoXe) > (SELECT COUNT(BienSoXe) / COUNT(DISTINCT MaChiNhanh) FROM Xe);