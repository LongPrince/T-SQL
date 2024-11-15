--h.	Viết hàm với tham số truyền vào là năm, hàm dùng để lấy ra số trọng tài đã tham gia điều khiển các trận đấu trong năm truyền vào.
create function func_trongtai_thamgia(@year int)
returns int
as
begin
	return(select count(distinct TrongTai)
			from TranDau
			where year(Ngay)=@year)
end
-- loigoi
select dbo.func_trongtai_thamgia(2022) as sotrongtai
--i.Viết thủ tục vào tham số truyền vào là mã cầu thủ, thủ tục 
--dùng để xóa cầu thủ này. 
create proc sp_xoacauthu
@macauthu nvarchar(20)
as
begin
   if(exists(select * from ThamGia where MaCT = @macauthu))
       delete ThamGia where MaCT = @macauthu
    delete CauThu where MaCT=@macauthu
end
--loigoi 
EXEC sp_xoacauthu @macauthu = 'CT01';


--j.Viết hàm với tham số truyền vào là macauthu, hàm dùng để lấy
--ra tổng bàn thắng của cầu thủ này.
alter function func_tongbanthangcuamoicauthu
	(@macauthu nvarchar(20))
returns int
as
begin
	return(select isnull(sum(sotrai),0)
		from ThamGia
		where MaCT=@macauthu)
end
--loi goi
select dbo.func_tongbanthangcuamoicauthu('3')
--fix
create FUNCTION func_tongbanthangcuamoicauthu
    (@macauthu NVARCHAR(20))
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT ISNULL(SUM(SoBanThang), 0)
        FROM ThamGia
        WHERE MaCT = @macauthu
    );
END;

--loi goi:
SELECT dbo.func_tongbanthangcuamoicauthu('CT01') AS TongBanThang;


--k.Viết một hàm trả về tổng bàn thắng mà mỗi cầu thủ ghi được
--trong tất cả các trận.
alter function fuc_TongBanThangCauThuGhi()
returns table
as
return(select ThamGia.MaCT , CauThu.TenCT , 
			isnull(sum(sotrai),0) as Tongbanthang
       from ThamGia inner join CauThu 
	   on ThamGia.MaCT = CauThu.MaCT
	   group by ThamGia.MaCT, CauThu.TenCT)
--loi goi
select * from dbo.fuc_TongBanThangCauThuGhi()

--fix
create function func_TongBanThangCauThuGhi ()
returns table
as
return (select ThamGia.MaCT,CauThu.TenCT,
				isnull (Sum (SoBanThang),0)as TongBanThang
		from ThamGia join CauThu on ThamGia.MaCT = CauThu.MaCT
		group by ThamGia.MaCT,CauThu.TenCT )

select * from dbo.func_TongBanThangCauThuGhi()

--l.Viết thủ tục/hàm lấy danh sách các cầu thủ ghi nhiều bàn 
--thắng nhất.
create proc dbo.DS_CauThu_GhiNhieuBanNhat
as
begin
	select MaCT, TenCT, Tongbanthang as BanThangMax
	from fuc_TongBanThangCauThuGhi()
	where Tongbanthang = (select max(Tongbanthang)
							from fuc_TongBanThangCauThuGhi())
end
--
exec dbo.DS_CauThu_GhiNhieuBanNhat
--ham
create function func_DS_Cauthu__GhiNhieuBanNhat()
returns table
as
return( select MaCT, TenCT, Tongbanthang as BanThangMax
	from fuc_TongBanThangCauThuGhi()
	where Tongbanthang = (select max(Tongbanthang)
							from fuc_TongBanThangCauThuGhi()))

--loi goi
select * from func_DS_Cauthu__GhiNhieuBanNhat()
--m.Viết thủ tục/hàm với tham số truyền vào số A, thủ tục/hàm
--dùng để lấy ra danh sách các cầu thủ ghi số bàn thắng lớn hơn
--số A này.
create function func_DS_Cauthu__GhiNhieuBanHonA(@A int)
returns table
as
return( select MaCT, TenCT, Tongbanthang as BanThangMax
	from fuc_TongBanThangCauThuGhi()
	where Tongbanthang > @A)
--loi goi
select * from dbo.func_DS_Cauthu__GhiNhieuBanHonA(1)
--thu tuc
create proc proc_ds_cauthu_ghinhieubanhonA1(@A int)
as
begin
	select MaCT, TenCT, Tongbanthang as BanThangMax
	from fuc_TongBanThangCauThuGhi()
	where Tongbanthang > @A
end
--loi goi
proc_ds_cauthu_ghinhieubanhonA1 @A ='1'


--n.Viết thủ tục/hàm với tham số truyền vào là @nam. Thủ tục/hàm
--dùng để thống kê mỗi tháng trong năm truyền vào có bao nhiêu
--trận đấu được diễn ra. Nếu tháng nào không có trận đấu nào tổ
--chức thì ghi là 0.
create function func_SoTranDau_DienRa_TheoThang(@nam int)
returns @tbl_Thongke table (thang int, sotrandau int)
as begin
	declare @tblThang table(thang int)
	declare @thang int = 1
	while @thang <= 12
	begin
		insert into @tblThang
		values(@thang)
		set @thang +=  1
	end

	insert into @tbl_Thongke
	select bang1.thang, isnull(bang2.sotrandau, 0) as sotrandau
	from @tblThang as bang1 left join 
			(select month(td.Ngay) as thang, 
					count(td.MaTD) as sotrandau
			from TranDau AS TD
			where year(td.Ngay) = @nam
			group by month(td.Ngay)) as bang2
		on bang1.thang = bang2.thang
	return
end
--loi goi
select * from dbo.func_SoTranDau_DienRa_TheoThang(2022)
--o.Viết một thủ tục dùng để tạo ra một bảng mới có tên 
--CauThu_BanThang, bảng này chứa tổng số bàn thắng mà mỗi cầu 
--thủ ghi được. Nếu cầu thủ nào chưa ghi bàn thắng nào thì ghi 
--số bàn thắng là 0.
alter proc sp_CreateTable_CauThu_BanThang
as
	if(exists (select * from INFORMATION_SCHEMA.TABLES 
			where TABLE_NAME = 'CauThu_BanThang'))
		drop table CauThu_BanThang

	select ThamGia.MaCT , CauThu.TenCT , 
			isnull(sum(sotrai),0) as Tongbanthang
	into CauThu_BanThang
	from ThamGia left join CauThu on ThamGia.MaCT = CauThu.MaCT
	group by ThamGia.MaCT, CauThu.TenCT 
--loi goi
sp_CreateTable_CauThu_BanThang
select * from CauThu_BanThang
--p.Viết một trigger, trigger này dùng để cập nhật tổng bàn thắng
--của cầu thủ ở bảng CauThu_BanThang mỗi khi có cập nhật hoặc
--thêm mới số bàn thắng của cầu thủ ở bảng ThamGia.
create trigger trigger_Update_SoBanThang_CauThu_BanThang
on ThamGia
for update
as begin
	if(exists (select * from INFORMATION_SCHEMA.TABLES 
			where TABLE_NAME = 'CauThu_BanThang'))
	begin
		if (exists (select ctbt.MaCT
					from CauThu_BanThang as ctbt inner join inserted
					on ctbt.MaCT = inserted.MaCT))
		begin
			update CauThu_BanThang
			set Tongbanthang = Tongbanthang - (select sum(deleted.SoTrai) from deleted) + (select sum(inserted.SoTrai) from inserted)
			from CauThu_BanThang as ctbt
			where ctbt.MaCT in (select MaCT from inserted)
		end
		else begin
			insert into CauThu_BanThang
			select inserted.MaCT, ct.TenCT, inserted.SoTrai
			from inserted join CauThu as ct on inserted.MaCT=ct.MaCT
						inner join CauThu_BanThang as ctbt on inserted.MaCT=ctbt.MaCT
		end
	end
	else begin
		select ThamGia.MaCT , CauThu.TenCT , 
			isnull(sum(sotrai),0) as Tongbanthang
		into CauThu_BanThang
		from ThamGia left join CauThu on ThamGia.MaCT = CauThu.MaCT
		group by ThamGia.MaCT, CauThu.TenCT
	end
end
