/*b. Viết thủ tục/hàm với tham số truyền vào là ngày. 
Thủ tục/hàm dùng để lấy ra danh sách
các quyển sách được mượn cùng các độc giả mượn sách trong ngày truyền vào.*/
alter proc pr_dsmuonsach (@ngay datetime)
as
begin
	select Muon.masach,tensach,tendg,ngaymuon
	from Muon join Sachmuon on Muon.masach = Sachmuon.masach
			  JOIN Docgia   on Muon.madg = Docgia.madg
	where Day(ngaymuon) = @ngay
end
pr_dsmuonsach 25

--hàm
create function fc_dsmuonsach (@ngay datetime)
returns table
as

	return (select Muon.masach,tensach,ngaymuon
		    from Muon join Sachmuon on Muon.masach = Sachmuon.masach
			where Day(ngaymuon) = @ngay
	)

select * from dbo.fc_dsmuonsach (25)

/*c. Viết thủ tục/hàm với tham số truyền vào là tên độc giả. 
Thủ tục/hàm dùng để lấy ra các
độc giả có tên tương tự với tên truyền vào.*/
--Thủ tục
create proc pr_dsDocGia 
(@ten nvarchar (50))
as 
begin
  select Docgia.madg,tendg,Muon.masach,tensach
  from Muon join Docgia on Muon.madg = Docgia.madg
            join Sachmuon on Muon.masach = Sachmuon.masach
  where tendg like '%' + @ten + '%'
end
exec pr_dsDocGia N'Hùng'
--Hàm
create function fc_DsDocGia
(@tendg nvarchar(50))
returns table
as
	return ( select *
			  from Docgia
			  where tendg like '%' + @tendg + '%')
select * from dbo.fc_DsDocGia(N'Lân') 
/*d. Viết thủ tục/ hàm với tham số truyền vào là mã tác giả, 
thủ tục/hàm dùng để lấy ra danh
sách các quyển sách mà tác giả này sáng tác.*/
--thủ tục
alter proc pr_DsTacGia (@tg nvarchar(50))
as
begin
	select Tacgia.matg,tentg,chuyenmon,tensach,namxb
	from Tacgia join Sachmuon on Sachmuon.matg = Tacgia.matg
	where Tacgia.matg = @tg
end
exec pr_DsTacGia '004'
--hàm
create function fc_DsTagia(@matg int )
returns table
as
	return (select Tacgia.matg,tentg,masach,tensach
		    from Tacgia join Sachmuon on Tacgia.matg = Sachmuon.matg
			where Tacgia.matg = @matg
			)
	select * from dbo.fc_DsTagia (002)
/*e. Viết thủ tục/hàm dùng để lấy ra danh sách các độc giả chưa trả sách.*/
create proc pr_DsChuaTra
as
begin
 select Docgia.madg,tendg,ngaytra
 from Muon join Docgia on Muon.madg = Docgia.madg
 where ngaytra is null
end
exec pr_DsChuaTra
--hàm
create function fc_DsChuaTra ()
returns table
	as
		return( select Muon.madg,tendg
			    from Muon join Docgia on Muon.madg = Muon.madg
				where ngaymuon is null 
				)
select * from dbo.fc_DsChuaTra()

/*f. Viết hàm dùng để lấy ra số các quyển sách có trong thư viện.*/
create function fc_SoQuyenSach ()
returns int
as
begin
	return ( select COUNT(masach)
			 from Sachmuon )
end
select dbo.fc_SoQuyenSach()

create function fc_SoQuyenSachCoTrongTv ()
returns table
as
	return ( select count(masach) as SoQuyen
		     from Sachmuon
			)

select * from dbo.fc_SoQuyenSachCoTrongTv()
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
/*i. Viết thủ tục với tham số truyền vào là mã sách. 
Thủ tục dùng để xóa quyển sách này
trong thư viện.*/
create proc pr_XoaSach (@masach nvarchar (10))
as
begin
	delete Muon
	where masach = @masach
	delete Sachmuon
	where masach = @masach
end
/*k. Viết thủ tục/hàm với tham số truyền vào là tháng, năm. 
Thủ tục/hàm dùng để thống kê mỗi ngày có bao 
nhiêu người tới mượn sách trong tháng, năm truyền vào*/
create proc pr_SoNguoiMuon1 (@nam int, @thang int)
as
begin
	select COUNT(madg) as SoNguoiMuon
	from Muon
	where MONTH(ngaymuon) = @thang and YEAR(ngaymuon) =@nam
end
pr_SoNguoiMuon1 2024,10

alter function fc_ThongKeNguoiMuonTheoNamThang1(@thang int, @nam int)
returns table
as
return ( select COUNT(madg) as SoNguoiMuon
	from Muon
	where MONTH(ngaymuon) = @thang and YEAR(ngaymuon) =@nam
		)
select * from dbo.fc_ThongKeNguoiMuonTheoNamThang1(10,2024)

select * from Muon


/*q. Viết thủ tục/hàm với tham số truyền vào là năm. 
Thủ tục/hàm dùng để lấy ra các tác giả
không sáng tác một quyển sách nào trong năm truyền vào.*/
--thu tuc
alter proc pr_DsNamTacGiaKhongXB
( @nam numeric(18,0))
as
begin
	select Sachmuon.matg,tentg,tensach,namxb
	from Sachmuon join Tacgia on Sachmuon.matg = Tacgia.matg
	where Sachmuon.matg not in (select matg
								from Sachmuon 
								where namxb = @nam )
end
pr_DsNamTacGiaKhongXB 2004

--hàm
create function fc_DsTacGiaTheoNam
( @nam int)
returns table 
as
	return (
			select Sachmuon.matg,tentg
			from Tacgia join Sachmuon on Tacgia.matg = Sachmuon.matg
			where Sachmuon.namxb not in (select matg
										 from Sachmuon
										 where namxb = @nam)
			)
select * from fc_DsTacGiaTheoNam(2004)										   

/*l. Viết thủ tục/hàm dùng để thống kê mỗi độc giả đã 
tới thư viện mượn bao nhiêu lần.*/
--thu tuc
create proc pr_DocGiaMuonSach
as
begin
	select Muon.madg,Docgia.tendg, COUNT(Muon.madg) as SoLanMuon
	from Muon join Docgia on Muon.madg = Docgia.madg
	group by  Muon.madg,Docgia.tendg
end
exec pr_DocGiaMuonSach
--ham
create function fc_ThongKeDocGia ()
returns table
 as
   return ( select Muon.madg,tendg,count(Muon.madg) as SoLanMuon
			from Muon join Docgia on Muon.madg = Docgia.madg
			group by Muon.madg,tendg
			)
select * from dbo.fc_ThongKeDocGia ()

/*m. Viết thủ tục/hàm với tham số truyền vào là số lần mượn sách. 
Thủ tục/hàm dùng để lấy ra danh sách các độc giả 
đã tới mượn sách có số lần lớn hơn tham số truyền vào.*/
--KO dung ham
alter proc pr_SoLanMuon (@luot int)
as
begin
	select Muon.madg,tendg,COUNT(Muon.madg) as SoLanMuon
	from Muon join Docgia on Muon.madg = Docgia.madg
	group by Muon.madg,tendg
	Having COUNT(Muon.madg) > @luot --- 
	
end
pr_SoLanMuon 1
--ham
create function fc_DoGiaMuonSach(@solan int)
returns table
 as
 return ( select *
	      from dbo.fc_ThongKeDocGia() --dùng ham l
		  where SoLanMuon > @solan
		)
select * from fc_DoGiaMuonSach(1)
--thu tuc
create proc pr_DoGiaMuon (@solan int)
as
begin
	select *
	from  dbo.fc_ThongKeDocGia() 
	where SoLanMuon > @solan
end

/*o. Viết thủ tục/hàm dùng để thống kê mỗi quyển sách trong thư viện
 được mượn bao nhiêu lần. 
 Nếu quyển sách nào chưa được mượn lần nào thì ghi số lần là 0.*/
 --thu tuc
 select Muon.masach,tensach, ISNULL(Count (Muon.masach),0) as solan
 from Muon join Sachmuon on Muon.masach = Sachmuon.masach
 group by Muon.masach,tensach
 -- ham
 create function fc_ThongKe()
 returns table
 as
	return(
			select Muon.masach,tensach,ISNULL(count(Muon.masach),0) as SoLanMuon
			from Muon join Sachmuon on Muon.masach = Sachmuon.masach
			group by Muon.masach,tensach
	)
select * from fc_ThongKe()