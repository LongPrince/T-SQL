/*a. Viết thủ tục/hàm dùng để lấy ra danh sách các quyển sách có trong thư viện.*/
create proc pr_LayDanhSachSach
AS
	SELECT *
	FROM Sachmuon

pr_LayDanhSachSach()
create function fc_LayDanhSachSach()
RETURNS TABLE 
AS
	RETURN (
		SELECT *
		FROM Sachmuon
	)
SELECT * FROM fc_LayDanhSachSach()
	
	
/*b. Viết thủ tục/hàm với tham số truyền vào là ngày. Thủ tục/hàm dùng để lấy ra danh sách
các quyển sách được mượn cùng các độc giả mượn sách trong ngày truyền vào.*/
create proc pr_LayDanhSachMuon(@ngay datetime)
AS
	SELECT Sachmuon.masach ,tensach
	FROM Sachmuon JOIN Muon on Sachmuon.masach = Muon.masach
	WHERE @ngay = ngaymuon

pr_LayDanhSachMuon '2004-11-1'

create function fc_LayDanhSachMuon(@ngay datetime)
RETURNS TABLE 
AS
	RETURN (
		SELECT Sachmuon.masach ,tensach
		FROM Sachmuon JOIN Muon on Sachmuon.masach = Muon.masach
		WHERE @ngay = ngaymuon
	)
SELECT * FROM fc_LayDanhSachMuon ('2004-11-1')
	

/*c. Viết thủ tục/hàm với tham số truyền vào là tên độc giả. Thủ tục/hàm dùng để lấy ra các
độc giả có tên tương tự với tên truyền vào.*/
create proc pr_LayDanhSachTacGia(@ten nvarchar(50))
AS
	SELECT *
	FROM Tacgia
	WHERE tentg like '%'+ @ten  + '%'

pr_LayDanhSachTacGia N'Lê'

create function fc_LayDanhSachMuon(@ngay datetime)
RETURNS TABLE 
AS
	RETURN (
		SELECT *
		FROM Tacgia
		WHERE tentg like '%'+ @ten  + '%'
	)
SELECT * FROM fc_LayDanhSachTacGia (N'Lê')



/*d. Viết thủ tục/ hàm với tham số truyền vào là mã tác giả, thủ tục/hàm dùng để lấy ra danh
sách các quyển sách mà tác giả này sáng tác.*/
create proc pr_LayDanhSachCuaTacGia(@matg nvarchar(10))
AS
	SELECT masach , tensach , tentg
	FROM Tacgia JOIN Sachmuon on Tacgia.matg = Sachmuon.matg
	WHERE @matg = Tacgia.matg

pr_LayDanhSachCuaTacGia '001'

create function fc_LayDanhSachCuaTacGia(@matg nvarchar(10))
RETURNS TABLE 
AS
	RETURN (
			SELECT masach , tensach , tentg
			FROM Tacgia JOIN Sachmuon on Tacgia.matg = Sachmuon.matg
			WHERE @matg = Tacgia.matg
	)

SELECT * FROM fc_LayDanhSachCuaTacGia ('001')


/*e. Viết thủ tục/hàm dùng để lấy ra danh sách các độc giả chưa trả sách.*/

create proc pr_LayDanhSachCuaDocGiaChuaTraSach
AS
	SELECT Muon.madg , tendg
	FROM Docgia JOIN Muon ON Docgia.madg = Muon.madg
	WHERE ngaymuon is null

pr_LayDanhSachCuaDocGiaChuaTraSach

create function fc_LayDanhSachCuaDocGiaChuaTraSach()
RETURNS TABLE 
AS
	RETURN (
		SELECT Muon.madg , tendg
		FROM Docgia JOIN Muon ON Docgia.madg = Muon.madg
		WHERE ngaymuon is null
	)

SELECT * FROM fc_LayDanhSachCuaDocGiaChuaTraSach()

/*f. Viết hàm dùng để lấy ra số các quyển sách có trong thư viện.*/

create function fc_LaySoSachTrongThuVien()
RETURNS INT
AS
	BEGIN 
		RETURN (
			SELECT COUNT(masach)
			FROM Sachmuon
		)
	END

SELECT dbo.fc_LaySoSachTrongThuVien()

/*g. Viết hàm với tham số truyền vào là ngày(dd/mm/yyyy), hàm dùng để lấy xem có bao
nhiêu độc giả tới mượn sách trong ngày này.*/

create function fc_LaySoSachMuonTrongTuNgay(@ngay datetime)
RETURNS INT
AS
	BEGIN 
		RETURN (
			SELECT COUNT(masach)
			FROM Muon
			WHERE @ngay = ngaymuon
		)
	END

SELECT dbo.fc_LaySoSachMuonTrongTuNgay('2024-1-1')

/*h. Viết thủ tục dùng để thêm mới một độc giả. Với các thông tin độc giả là tham số truyền
vào và tham số @Ketqua sẽ trả về chuỗi rỗng nếu thêm mới độc giả thành công, ngược
lại tham số này trả về chuỗi cho biết lý do không thêm mới được.*/

create proc pr_ThemMoiDocGia
	@madg nvarchar(10),
	@tendg nvarchar(50),
	@doituong nvarchar(50),
	@Ketqua nvarchar(50) output
AS
	if (exists(SELECT 1 FROM Docgia WHERE @madg = madg) )
		SET @Ketqua = N'Trùng mã độc giả'
	else 
		INSERT INTO Docgia
		VALUES (@madg , @tendg , @doituong)

DECLARE @Bien nvarchar(50)
EXECUTE pr_ThemMoiDocGia '001', 'A' , N'trẻ em', @Bien output
SELECT @Bien


/*i. Viết thủ tục với tham số truyền vào là mã sách. Thủ tục dùng để xóa quyển sách này
trong thư viện.*/

create proc pr_XoaSach(@masach nvarchar(10))
AS
	DELETE Muon
	WHERE masach = @masach

	DELETE Sachmuon
	WHERE masach = @masach

/*j. Viết thủ tục dùng để cập nhật lại thông tin của tác giả. Với các thông tin muốn cập nhật
là tham số truyền vào và tham số @Ketqua sẽ trả về chuỗi rỗng nếu cập nhật độc giả
thành công, ngược lại tham số này trả về chuỗi cho biết lý do không cập nhật được.*/

create proc pr_CapNhatThongTinTacGia
	(@matg nvarchar(10),
	@tentg nvarchar(50),
	@chuyenmon nvarchar(50),
	@Ketqua nvarchar(50) output)
AS 
	if (not exists(SELECT 1 FROM Tacgia WHERE @matg = matg) )
		SET @Ketqua = N'Mã tác giả không tồn tại'
	ELSE
		UPDATE Tacgia
		SET tentg = @tentg , 
			 chuyenmon = @chuyenmon
		WHERE matg = matg
DECLARE @Bien nvarchar(50)
EXECUTE pr_CapNhatThongTinTacGia '001', 'A' , N'trẻ em', @Bien output
SELECT @Bien


/*k. Viết thủ tục/hàm với tham số truyền vào là tháng, năm. Thủ tục/hàm dùng để thống kê
mỗi ngày có bao nhiêu người tới mượn sách trong tháng, năm truyền vào*/

create proc pr_ThongKeSoNguoi (@Thang int, @Nam int)
AS
	SELECT COUNT(madg)
	FROM Muon
	WHERE MONTH(ngaymuon) = @Thang AND YEAR(ngaymuon) = @Nam

pr_ThongKeSoNguoi

create function fc_ThongKeSoNguoi (@Thang int,@Nam int)
RETURNS INT
AS
	BEGIN 
		RETURN (
			SELECT COUNT(madg)
			FROM Muon
			WHERE MONTH(ngaymuon) = @Thang AND YEAR(ngaymuon) = @Nam
		)
	END

SELECT * FROM	
/*l. Viết thủ tục/hàm dùng để thống kê mỗi độc giả đã tới thư viện mượn bao nhiêu lần.*/
create proc pr_ThongKeSoLanDenCuaDocGia
AS
	SELECT tendg ,COUNT (Muon.madg) AS SoLanDen
	FROM Muon JOIN DocGia ON Muon.madg = Docgia.madg
	GROUP BY tendg , Muon.madg

pr_ThongKeSoLanDenCuaDocGia

create function fc_ThongKeSoLanDenCuaDocGia()
RETURNS TABLE
AS
	RETURN (
			SELECT tendg ,COUNT (Muon.madg) AS SoLanDen
			FROM Muon JOIN DocGia ON Muon.madg = Docgia.madg
			GROUP BY tendg , Muon.madg
		)
SELECT * FROM fc_ThongKeSoLanDenCuaDocGia()

/*m. Viết thủ tục/hàm với tham số truyền vào là số lần mượn sách. Thủ tục/hàm dùng để lấy
ra danh sách các độc giả đã tới mượn sách có số lần lớn hơn tham số truyền vào.*/
create proc pr_ThongKeDocGiaMuonSachHon (@lan int)
AS
	SELECT tendg
	FROM fc_ThongKeSoLanDenCuaDocGia()
	WHERE SoLanDen > @lan

create function pc_ThongKeDocGiaMuonSachHon (@lan int)
RETURNS TABLE
AS
	RETURN (
		SELECT tendg
		FROM fc_ThongKeSoLanDenCuaDocGia()
		WHERE SoLanDen > @lan
	)

/*n. Viết hàm dùng để ra số quyển sách có trong thư viện.*/
create proc pr_ThongKeSoSachTrongThuVien 
AS
	SELECT COUNT (masach)
	FROM Sachmuon

pr_ThongKeSoSachTrongThuVien 

CREATE function fc_ThongKeSoSachTrongThuVien ()
RETURNS int
AS
	BEGIN
		RETURN (
			SELECT COUNT (masach)
			FROM Sachmuon
		)
	END

SELECT dbo.fc_ThongKeSoSachTrongThuVien()

/*o. Viết thủ tục/hàm dùng để thống kê mỗi quyển sách trong thư viện được mượn bao
nhiêu lần. Nếu quyển sách nào chưa được mượn lần nào thì ghi số lần là 0.*/
create proc pr_ThongKeSoSachTrongThuVienDaDuocMuonBaoNhieu
AS
	SELECT Sachmuon.masach , tensach , ISNULL (COUNT (Sachmuon.masach) , 0) AS SoLanMuon
	FROM Sachmuon LEFT JOIN Muon ON Sachmuon.masach = Muon.masach
	GROUP BY Sachmuon.masach, tensach 

pr_ThongKeSoSachTrongThuVienDaDuocMuonBaoNhieu

CREATE function fc_ThongKeSoSachTrongThuVienDaDuocMuonBaoNhieu ()
RETURNS TABLE
AS
	RETURN (
			SELECT Sachmuon.masach , tensach , ISNULL (COUNT (Sachmuon.masach) , 0) AS SoLanMuon
			FROM Sachmuon LEFT JOIN Muon ON Sachmuon.masach = Muon.masach
			GROUP BY Sachmuon.masach, tensach 
		)

SELECT * FROM fc_ThongKeSoSachTrongThuVienDaDuocMuonBaoNhieu ()

/*p. Viết thủ tục/hàm với tham số truyền vào là @ngayA, @ngayB. Thủ tục/hàm dùng để
thống kê mỗi ngày từ @ngayA đến @ngayB có bao nhiêu người tới mượn sách. Nếu
ngày nào không có người nào mượn sách thì ghi là 0.*/
ALTER proc pr_ThongKeSoNguoiDenTrong (@NgayA datetime, @NgayB datetime)
AS
	BEGIN 
		DECLARE @ThongKe TABLE(Ngay datetime,SoNguoi int)
		DECLARE @Tmp datetime = @NgayA
		WHIlE (@Tmp <= @NgayB)
			BEGIN
				INSERT INTO @ThongKe 
				SELECT 
					@Tmp AS Ngay, 
					COUNT(masach) AS SoNguoi 
				FROM 
					fc_LayDanhSachMuon(@Tmp);
				SET @Tmp = DATEADD(DAY, 1, @Tmp)
			END
		SELECT * FROM @ThongKe
	END

pr_ThongKeSoNguoiDenTrong '2000-2-1' , '2025-2-1' 

create function fc_ThongKeSoNguoiDenTrong  (@NgayA datetime, @NgayB datetime)
RETURNS @ThongKe TABLE(Ngay datetime,SoNguoi int)
AS
	BEGIN 
		DECLARE @Tmp datetime = @NgayA
		WHIlE (@Tmp <= @NgayB)
			BEGIN
				INSERT INTO @ThongKe 
				SELECT 
					@Tmp AS Ngay, 
					COUNT(masach) AS SoNguoi 
				FROM 
					fc_LayDanhSachMuon(@Tmp);
				SET @Tmp = DATEADD(DAY, 1, @Tmp)
			END
		RETURN
	END

SELECT * FROM fc_ThongKeSoNguoiDenTrong ('2000-2-1' , '2025-2-1') 

/*q. Viết thủ tục/hàm với tham số truyền vào là năm. Thủ tục/hàm dùng để lấy ra các tác giả
không sáng tác một quyển sách nào trong năm truyền vào.*/


create proc pr_ThongKeSoTacGiaKhongVietTacPhamNaoTrong (@nam int)
AS
	SELECT *
	FROM Tacgia
	WHERE matg not in
				(
					SELECT matg
					FROM Sachmuon
					WHERE namxb = @nam
				)

pr_ThongKeSoTacGiaKhongVietTacPhamNaoTrong 2025

CREATE function fc_ThongKeSoTacGiaKhongVietTacPhamNaoTrong (@nam int)
RETURNS TABLE
AS
	RETURN (
				SELECT *
				FROM Tacgia
				WHERE matg not in
				(
					SELECT matg
					FROM Sachmuon
					WHERE namxb = @nam
				)
		)

SELECT * FROM fc_ThongKeSoTacGiaKhongVietTacPhamNaoTrong (2025)