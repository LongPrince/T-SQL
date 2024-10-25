--a.	Viết hàm dùng để lấy ra danh sách các học viên.
create function func_DanhSachHocVien()
Returns table
as
return (select StudentID,StudentName, Age,Email
        from dbo.Students)
-- lời gọi
select*from func_DanhSachHocVien()
--b.Viết hàm với tham số truyền vào là Họ, hàm dùng để lấy danh
--sách các học viên có họ giống với họ truyền vào.
create function func_HocVien_HoGiongNhau(@Ho nvarchar(20))
returns table
        return(
		     select *
			 from students
			 where  studentName like  N''+ @Ho + '%'
	)
--loi goi
select * from func_HocVien_HoGiongNhau(N'Nguyen')
--c.Viết hàm với tham số truyền vào là mã môn học, hàm dùng để 
--lấy ra số học viên đăng ký học môn học này
create function danhsachhocviendangky(@mamh int)
returns int 
as
begin
return(
	select count(*) 
	from[dbo].[Marks]
	where [SubjectID]=@mamh
	)
end
--loi goi
select dbo.danhsachhocviendangky(1)
--d.Viết hàm hiển thị danh sách và điểm của các học viên ứng với
--các môn học.
create function func_HocVien_DanhSach_Diem()
returns table
as
 return (select StudentName,SubjectName,Mark
		from Students,Subjects,Marks
		where Students.StudentID=Marks.StudentID
		and Marks.SubjectID=Subjects.SubjectID)
--loi goi
select * from func_HocVien_DanhSach_Diem()
--e.	Viết hàm lấy ra số học viên hiện có.
create function func_ds_hocvien()
returns int
as
begin
	return(
		select COUNT( StudentID)
		from Students
	)
end
--loi goi 
select dbo.func_ds_hocvien()
--f.Viết hàm với tham số truyền vào là tuổi 1 đến tuổi 2, hàm 
--dùng để lấy ra danh sách các học viên có độ tuổi từ tuổi 1 đến
--tuổi 2.
create function func_DSHV_tuoi
(	
	@age1 int, 
	@age2 int 
)
returns table 
as
return ( select*
		from Students s
		where s.age>= @age1 and s.age <= @age2 )
-- loi goi
select * from func_DSHV_tuoi(15,20)
--g.	Viết hàm tính điểm trung bình của các học viên
alter function func_DiemTB()
returns table
as
return(select Students.StudentID, StudentName, 
				avg(cast(Mark as float)) as DiemTB
			FROM Students inner join Marks
			on Students.StudentID = Marks.StudentID
			group by Students.StudentID, StudentName)
--loi goi
select*from func_DiemTB()
--h.Viết hàm lấy ra điểm trung bình lớn nhất của các học viên
alter function func_DTBMax()
returns float
as
begin
return(
		select max(DiemTB)
		from func_DiemTB()
	)
end
-- loi goi
select  dbo.func_DTBMax()
--i.Viết hàm hiển thị danh sách các học viên chưa thi môn nào.
create function func_Select_HocVien_ChuaThi()
returns table
as
return (select *
		from Students
		where StudentID not in (select distinct StudentID
								from Marks))
-- loi goi
select *
from dbo.func_Select_HocVien_ChuaThi()
--j.Viết hàm với tham số truyền vào là điểm trung bình, hàm dùng
--để lấy ra danh sách các học viên có điểm trung bình lớn hơn 
--điểm trung bình truyền vào.
create function func_HocVien_DTBCaoHon(@dtb float)
returns table
as
return(
		select *
		from func_DiemTB()
		where DiemTB >= @dtb
		)

--loi goi
select * 
from dbo.func_HocVien_DTBCaoHon(7.5)
--k.Giả sử điểm (mark) của sinh viên từ 0, 1, 2, …, 9, 10. Hãy 
--viết hàm với tham số truyền vào là mã môn học, hàm dùng để 
--thống kê mỗi mức điểm này có bao nhiêu sinh viên đạt trong môn 
--học này. (Ví dụ: điểm 0 có 2 người, điểm 1 có 0 người, …, điểm 
--10 có 2 người).
create function func_Select_ThongKeDiemTheoMonHoc
(
	@SubjectID int
)
returns @ThongKeDiem table(Diem int, SoHocVien int)
as
begin
	declare @diem int
	set @diem = 0
	declare @tblDiem table(mark int)
	while(@diem <= 10)
		begin
			insert into @tblDiem
			values(@diem)
			set @diem = @diem + 1
		end
	insert into @ThongKeDiem
	select d1.mark, isnull(d2.SoHocVien,0) as SoHocVien
	from @tblDiem d1 left join 
					(select Mark, count(StudentID) as 'SoHocVien' 
					from Marks
					where SubjectID = @SubjectID
					group by Mark) d2
	on d1.mark = d2.Mark
	return
end
--l.Viết hàm lấy ra những sinh viên có điểm trung bình cao nhất.
create function func_DanhSach_SinhVien_DTBMax
()
returns table
as
	return ( select *
			 from func_DiemTB()
			 where DiemTB = dbo.func_DTBMax() )
-- Lời gọi:
select * from func_DanhSach_SinhVien_DTBMax()
--m.Viết hàm dùng để thống kê mỗi môn học có bao nhiêu học viên
--đăng kí thi.
create function func_ThongKe_HocVienDk()
returns table
as
return(
	select Subjects.SubjectID, Subjects.SubjectName, 
		count(Marks.Mark) as SoHV
	from Subjects left join Marks
	on Subjects.SubjectID = Marks.SubjectID
	group by Subjects.SubjectID, Subjects.SubjectName)
--loi goi
select * from func_ThongKe_HocVienDk()
--n.Viết hàm với tham số truyền vào là SoSV, hãy lấy ra danh sách
--các môn học có số học viên đăng ký thi là nhỏ hơn SoSV truyền 
--vào.
create function func_DS_HocVienDK
(
@SoSV INT
)
returns table
as
return (
	select *
	from dbo.func_ThongKe_HocVienDk()
	where SoHV < @SoSV
)
--lời gọi
select * from  func_DS_HocVienDK(4)
--o.Viết hàm để lấy ra danh sách học viên cùng với điểm trung 
--bình của các học viên. Nếu học viên nào chưa có điểm thì ghi 0.
create function func_DS_DTB()
returns table
as
	return(select Students.StudentID,StudentName, 
				isnull(avg(cast(Mark as float)),0) as DTB
			from Students left join Marks 
			on Students.StudentID = Marks.StudentID
			group by Students.StudentID,StudentName)
--loi goi
select * from func_DS_DTB()