USE QuanLyVanTai;
GO

SELECT x.HangSanXuat, COUNT(x.BienSoXe) AS SoLuongXe
FROM Xe x
GROUP BY x.HangSanXuat
HAVING COUNT(x.BienSoXe) >= 2;

SELECT t.TenTaiXe, SUM(p.SoGio) AS TongSoGio
FROM TaiXe t
INNER JOIN PhanCong p ON t.MaTaiXe = p.MaTaiXe
GROUP BY t.TenTaiXe
HAVING SUM(p.SoGio) > 10;