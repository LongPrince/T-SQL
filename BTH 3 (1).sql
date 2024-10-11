-- a. Viết thủ tục dùng để hiển thị các thông tin gồm oID, oDate, oTotalPrice 
-- của tất cả các hóa đơn trong bảng Order, danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn nằm trên.
CREATE PROCEDURE sp_Order_Select_HienThi
AS
BEGIN
    SELECT oID, cID, oDate, oTotalPrice
    FROM [Order]
    ORDER BY oDate DESC;
END
-- Lời gọi:
sp_Order_Select_HienThi


-- b. Viết thủ tục dùng để hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó.
CREATE PROCEDURE sp_KhachHang_Select_SanPhamMua
AS
BEGIN
    SELECT C.cName, P.pName
    FROM Customer C
    JOIN [Order] O ON C.cID = O.cID
    JOIN OrderDetail OD ON O.oID = OD.oID
    JOIN Product P ON OD.pID = P.pID;
END
-- Lời gọi:
sp_KhachHang_Select_SanPhamMua


-- c. Viết thủ tục dùng để hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào.
ALTER PROCEDURE sp_KhachHang_Select_KhongMua
AS
BEGIN
    SELECT cName 
    FROM Customer
    WHERE cID NOT IN (SELECT cID FROM [Order]);
END
-- Lời gọi:
sp_KhachHang_Select_KhongMua


-- d. Viết thủ tục dùng để hiển thị các mặt hàng chưa được mua lần nào.
CREATE PROCEDURE sp_MatHang_Select_ChuaMua
AS
BEGIN
    SELECT pID, pName
    FROM Product
    WHERE pID NOT IN (SELECT pID FROM OrderDetail);
END
-- Lời gọi:
sp_MatHang_Select_ChuaMua


-- e. Viết thủ tục với tham số truyền vào là tháng, năm. 
-- Thủ tục dùng để hiển thị các hóa đơn được lập và số tiền bán được trong tháng, năm truyền vào.
CREATE PROCEDURE sp_Order_Select_ThangNam
    @Thang INT,
    @Nam INT
AS
BEGIN
    SELECT oID, cID, oDate, oTotalPrice
    FROM [Order]
    WHERE MONTH(oDate) = @Thang AND YEAR(oDate) = @Nam;
END
-- Lời gọi:
sp_Order_Select_ThangNam 3, 2006


-- f. Viết thủ tục với tham số truyền vào là năm. 
-- Thủ tục dùng để hiển thị doanh thu của mỗi tháng trong năm truyền vào.
CREATE PROCEDURE sp_DoanhThu_Select_TheoNam
    @Nam INT
AS
BEGIN
    SELECT MONTH(oDate) AS Thang, SUM(oTotalPrice) AS TongDoanhThu
    FROM [Order]
    WHERE YEAR(oDate) = @Nam
    GROUP BY MONTH(oDate);
END
-- Lời gọi:
sp_DoanhThu_Select_TheoNam 2006


-- g. Viết thủ tục dùng để thêm mới một sản phẩm. 
-- Thủ tục có các tham số là các thông tin của sản phẩm và một tham số @ketqua 
-- sẽ trả về chuỗi rỗng nếu thêm mới sản phẩm thành công, ngược lại tham số này trả về chuỗi cho biết lý do không thêm mới được.
CREATE PROCEDURE sp_SanPham_Insert
    @pName VARCHAR(25),
    @pPrice INT,
    @ketqua NVARCHAR(100) OUTPUT
AS
BEGIN
    IF EXISTS (SELECT * FROM Product WHERE pName = @pName)
    BEGIN
        SET @ketqua = N'Sản phẩm đã tồn tại.'
    END
    ELSE
    BEGIN
        INSERT INTO Product (pName, pPrice)
        VALUES (@pName, @pPrice);
        SET @ketqua = '';
    END
END
-- Lời gọi:
DECLARE @ketqua NVARCHAR(100)
EXEC sp_SanPham_Insert 'TV', 100, @ketqua OUTPUT
SELECT @ketqua
-- h. Viết thủ tục dùng để cập nhật một sản phẩm. 
-- Thủ tục có các tham số là các thông tin của sản phẩm và một tham số @ketqua 
-- sẽ trả về chuỗi rỗng nếu cập nhật sản phẩm thành công, ngược lại tham số này trả về chuỗi cho biết lý do không cập nhật được.
CREATE PROCEDURE sp_SanPham_Update
    @pID INT,
    @pName VARCHAR(25),
    @pPrice INT,
    @ketqua NVARCHAR(100) OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Product WHERE pID = @pID)
    BEGIN
        SET @ketqua = N'Sản phẩm không tồn tại.'
    END
    ELSE
    BEGIN
        UPDATE Product
        SET pName = @pName, pPrice = @pPrice
        WHERE pID = @pID;
        SET @ketqua = '';
    END
END
-- Lời gọi:
DECLARE @ketqua NVARCHAR(100)
EXEC sp_SanPham_Update 1, 'Máy Giặt', 300, @ketqua OUTPUT
SELECT @ketqua


-- i. Viết thủ tục dùng để xóa một sản phẩm. 
-- Thủ tục có các tham số là mã của sản phẩm và một tham số @ketqua sẽ trả về chuỗi rỗng nếu xóa sản phẩm thành công,
-- ngược lại tham số này trả về chuỗi cho biết lý do không xóa được.
CREATE PROCEDURE sp_SanPham_Delete
    @pID INT,
    @ketqua NVARCHAR(100) OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Product WHERE pID = @pID)
    BEGIN
        SET @ketqua = N'Sản phẩm không tồn tại.'
    END
    ELSE
    BEGIN
        DELETE FROM Product WHERE pID = @pID;
        SET @ketqua = '';
    END
END
-- Lời gọi:
DECLARE @ketqua NVARCHAR(100)
EXEC sp_SanPham_Delete 1, @ketqua OUTPUT
SELECT @ketqua


-- j. Viết thủ tục dùng để hiển thị các khách hàng đã đến mua bao nhiêu lần.
CREATE PROCEDURE sp_KhachHang_Select_SoLanMua
AS
BEGIN
    SELECT C.cName, COUNT(O.oID) AS SoLanMua
    FROM Customer C
    LEFT JOIN [Order] O ON C.cID = O.cID
    GROUP BY C.cName;
END
-- Lời gọi:
sp_KhachHang_Select_SoLanMua


-- k. Viết thủ tục dùng để hiển thị chi tiết của từng hóa đơn.
CREATE PROCEDURE sp_HoaDon_Select_ChiTiet
AS
BEGIN
    SELECT O.oID, O.oDate, SUM(OD.odQTY * P.pPrice) AS TongGiaTriHoaDon
    FROM [Order] O
    JOIN OrderDetail OD ON O.oID = OD.oID
    JOIN Product P ON OD.pID = P.pID
    GROUP BY O.oID, O.oDate;
END
-- Lời gọi:
sp_HoaDon_Select_ChiTiet


-- l. Viết thủ tục dùng để hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn.
-- Giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn.
CREATE PROCEDURE sp_HoaDon_Select_GiaTien
AS
BEGIN
    SELECT O.oID, O.oDate, SUM(OD.odQTY * P.pPrice) AS TongGiaTriHoaDon
    FROM [Order] O
    JOIN OrderDetail OD ON O.oID = OD.oID
    JOIN Product P ON OD.pID = P.pID
    GROUP BY O.oID, O.oDate;
END
-- Lời gọi:
sp_HoaDon_Select_GiaTien


-- m. Viết thủ tục dùng để hiển thị tên và giá của các sản phẩm có giá cao nhất.
CREATE PROCEDURE sp_SanPham_Select_GiaCaoNhat
AS
BEGIN
    SELECT pName, pPrice
    FROM Product
    WHERE pPrice = (SELECT MAX(pPrice) FROM Product);
END
-- Lời gọi:
sp_SanPham_Select_GiaCaoNhat


-- n. Viết thủ tục với tham số truyền vào là số tiền. 
-- Thủ tục dùng để hiển thị những hóa đơn có tổng thành tiền trên số tiền truyền vào.
CREATE PROCEDURE sp_HoaDon_Select_TongTienTren
    @SoTien INT
AS
BEGIN
    SELECT O.oID, O.oDate, SUM(OD.odQTY * P.pPrice) AS TongGiaTriHoaDon
    FROM [Order] O
    JOIN OrderDetail OD ON O.oID = OD.oID
    JOIN Product P ON OD.pID = P.pID
    GROUP BY O.oID, O.oDate
    HAVING SUM(OD.odQTY * P.pPrice) > @SoTien;
END
-- Lời gọi:
sp_HoaDon_Select_TongTienTren 100


-- o. Viết thủ tục dùng để hiển thị những hóa đơn có tổng thành tiền cao nhất.
CREATE PROCEDURE sp_HoaDon_Select_CaoNhat
AS
BEGIN
    SELECT TOP 1 O.oID, O.oDate, SUM(OD.odQTY * P.pPrice) AS TongGiaTriHoaDon
    FROM [Order] O
    JOIN OrderDetail OD ON O.oID = OD.oID
    JOIN Product P ON OD.pID = P.pID
    GROUP BY O.oID, O.oDate
    ORDER BY TongGiaTriHoaDon DESC;
END
-- Lời gọi:
sp_HoaDon_Select_CaoNhat
