/*k. Viết thủ tục/hàm với tham số truyền vào là tháng, năm. 
Thủ tục/hàm dùng để thống kê mỗi ngày có bao nhiêu người
 tới mượn sách trong tháng, năm truyền vào*/
--thuc tuc
alter proc pr_ThongKeThangNam
 ( @thang int, @nam int)
 as
 begin
	select distinct count (masach) as Muon
	from Muon
	where MONTH(ngaymuon) = @thang and YEAR(ngaymuon) = @nam
 end

exec pr_ThongKeThangNam 10,2024
-- ham
alter function fc_ThongKeThangNamSL
( @thang int, @nam int)
returns table
as
return ( select distinct count(madg) AS SoLuongMuon
		 from Muon
		 where MONTH(ngaymuon) = @thang and YEAR(ngaymuon) = @nam)
select * from dbo.fc_ThongKeThangNamSL( 10,2024)


/*l. Viết thủ tục/hàm dùng để thống kê mỗi độc
 giả đã tới thư viện mượn bao nhiêu lần.*/
 create proc pr_TK_DocgiaMuon
 as
 begin
	select madg,count(madg) as SoLanMuon
	from Muon
	 group by madg
 end
 pr_TK_DocgiaMuon
 --ham
alter function fc_TK_DocGiaMuon ()
 returns table
 as
 return ( select Muon.madg,tendg,count(Muon.madg) as SoLanMuon
		  from Muon join Docgia on Muon.madg = Docgia.madg
		  group by Muon.madg,tendg )
select * from dbo. fc_TK_DocGiaMuon ()
/*m. Viết thủ tục/hàm với tham số truyền vào là số lần mượn sách. 
Thủ tục/hàm dùng để lấy ra danh sách các độc giả đã tới mượn sách
 có số lần lớn hơn tham số truyền vào.*/
 --Khong dùng lại hàm
 create proc pr_TK_SoLanMuon (@solan int)
 as
 begin
		select madg,count(madg) as Muon
		from Muon
		group by madg
		having count(madg) > @solan
 end
 pr_TK_SoLanMuon 0

--Dung lai ham
alter proc pr_TKSoLanMuon (@solan int)
as
begin
	select madg,tendg
	from dbo.fc_TK_DocGiaMuon()
	where SoLanMuon > @solan
end

pr_TKSoLanMuon 0
-- ham
create function fc_TkSoLanMuonDg (@solan int)
returns table
as
return ( select madg,tendg
		 from dbo.fc_TK_DocGiaMuon()
		 where SoLanMuon > @solan )
select * from dbo.fc_TkSoLanMuonDg (1)
/*o. Viết thủ tục/hàm dùng để thống kê mỗi quyển sách trong thư viện
 được mượn bao nhiêu lần. Nếu quyển sách nào chưa được mượn
  lần nào thì ghi số lần là 0.*/
create proc pr_TKSachThuVien
as
begin
	select Sachmuon.masach,tensach, isnull(count(Sachmuon.masach),0) as SoLan
	from  Sachmuon  left join Muon on Muon.masach = Sachmuon.masach
	group by Sachmuon.masach,tensach
	ORDER BY 
        SoLan DESC;
SELECT *
FROM Muon
end
/*q. Viết thủ tục/hàm với tham số truyền vào là năm. 
Thủ tục/hàm dùng để lấy ra các tác giả
không sáng tác một quyển sách nào trong năm truyền vào.*/
alter function sp_DSTacGiaXB ( @nam int)
returns table
as
return ( select Sachmuon.matg,tentg
		 from Tacgia JOIN Sachmuon on Tacgia.matg = Sachmuon.matg
		 where Sachmuon.matg NOT IN ( select matg
									from Sachmuon 
									where namxb = @nam) )

select  * from dbo.sp_DSTacGiaXB (2004)

/*p. Viết thủ tục/hàm với tham số truyền vào là @ngayA, @ngayB. Thủ tục/hàm dùng để
thống kê mỗi ngày từ @ngayA đến @ngayB có bao nhiêu người tới mượn sách. Nếu
ngày nào không có người nào mượn sách thì ghi là 0.*/
CREATE PROCEDURE ThongKeNguoiMuon
    @ngayA DATE,
    @ngayB DATE
AS
BEGIN
    -- Biến để lưu ngày hiện tại trong vòng lặp
    DECLARE @currentDate DATE;
    
    -- Bắt đầu từ ngày @ngayA
    SET @currentDate = @ngayA;

    -- Vòng lặp qua từng ngày từ @ngayA đến @ngayB
    WHILE @currentDate <= @ngayB
    BEGIN
        -- Thống kê số người mượn sách trong ngày @currentDate
        SELECT 
            @currentDate AS NgayMuon, 
            COUNT(*) AS SoNguoiMuon
        FROM Muon
        WHERE ngaymuon = @currentDate
        GROUP BY ngaymuon;

        -- Nếu không có người mượn sách trong ngày đó, hiển thị 0
        IF (NOT EXISTS (SELECT 1 FROM Muon WHERE ngaymuon = @currentDate))
        BEGIN
            SELECT 
                @currentDate AS NgayMuon,
                0 AS SoNguoiMuon;
        END

        -- Tiến đến ngày tiếp theo
        SET @currentDate = DATEADD(DAY, 1, @currentDate);
    END
END;

EXEC ThongKeNguoiMuon @ngayA = '2024-01-01', @ngayB = '2024-01-10';
