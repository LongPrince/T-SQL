--a. Hàm trả về số học viên hiện có:
CREATE FUNCTION dbo.LaySoHocVien()
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*) FROM Students);
END;
--loi goi
SELECT dbo.LaySoHocVien();
--b. Hàm lấy ra số học viên đăng ký học môn học theo mã môn học:
CREATE FUNCTION dbo.LaySoHocVienTheoMon(@MaMonHoc INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*) FROM Marks WHERE SubjectID = @MaMonHoc);
END;
--loi goi
SELECT dbo.LaySoHocVienTheoMon(1);
--c. Hàm tính điểm trung bình của học viên:
CREATE FUNCTION dbo.TinhDiemTrungBinhHocVien(@MaHocVien INT)
RETURNS FLOAT
AS
BEGIN
    RETURN (SELECT AVG(Mark) FROM Marks WHERE StudentID = @MaHocVien);
END;
--loi goi
SELECT dbo.TinhDiemTrungBinhHocVien(1);
--d. Hàm lấy ra điểm trung bình lớn nhất của các học viên:
CREATE FUNCTION dbo.LayDiemTrungBinhLonNhat()
RETURNS FLOAT
AS
BEGIN
    RETURN (SELECT MAX(AVG(Mark)) FROM Marks GROUP BY StudentID);
END;
--loi goi
SELECT dbo.LayDiemTrungBinhLonNhat();
-- e. Hàm lấy danh sách tất cả các học viên:

CREATE FUNCTION dbo.LayDanhSachHocVien()
RETURNS TABLE
AS
RETURN (SELECT * FROM Students);
-- loi goi
SELECT * FROM dbo.LayDanhSachHocVien();
-- f f. Hàm lấy danh sách các học viên có họ giống với họ truyền vào:
CREATE FUNCTION dbo.LayHocVienTheoHo(@Ho NVARCHAR(50))
RETURNS TABLE
AS
RETURN (SELECT * FROM Students WHERE StudentName LIKE @Ho + '%');
--loi goi
SELECT * FROM dbo.LayHocVienTheoHo(N'Nguyen');
--- g. Hàm lấy danh sách và điểm của các học viên ứng với các môn học:
CREATE FUNCTION dbo.LayDanhSachVaDiemHocVien()
RETURNS TABLE
AS
RETURN (
    SELECT S.StudentID, S.StudentName, Sub.SubjectName, M.Mark
    FROM Students S
    JOIN Marks M ON S.StudentID = M.StudentID
    JOIN Subjects Sub ON M.SubjectID = Sub.SubjectID
);
--loi goi
SELECT * FROM dbo.LayDanhSachVaDiemHocVien();
-- h. Hàm lấy danh sách học viên và điểm trung bình (ghi 0 nếu chưa có điểm):
CREATE FUNCTION dbo.LayHocVienVaDiemTrungBinh()
RETURNS @DanhSach TABLE (
    StudentID INT,
    StudentName NVARCHAR(50),
    DiemTrungBinh FLOAT
)
AS
BEGIN
    INSERT INTO @DanhSach
    SELECT S.StudentID, S.StudentName, 
           COALESCE(AVG(M.Mark), 0) AS DiemTrungBinh
    FROM Students S
    LEFT JOIN Marks M ON S.StudentID = M.StudentID
    GROUP BY S.StudentID, S.StudentName;

    RETURN;
END;

-- loi goi
SELECT * FROM dbo.LayHocVienVaDiemTrungBinh();
-- i i. Hàm thống kê số lượng học viên đăng ký thi theo môn học:
CREATE FUNCTION dbo.ThongKeHocVienDangKyThiTheoMon()
RETURNS @ThongKe TABLE (
    SubjectID INT,
    SoLuongHocVien INT
)
AS
BEGIN
    INSERT INTO @ThongKe
    SELECT SubjectID, COUNT(DISTINCT StudentID) AS SoLuongHocVien
    FROM Marks
    GROUP BY SubjectID;

    RETURN;
END;
--loi goi
SELECT * FROM dbo.ThongKeHocVienDangKyThiTheoMon();
--j. Hàm lấy danh sách các học viên chưa thi môn nào:
CREATE FUNCTION dbo.LayHocVienChuaThiMonNao()
RETURNS @DanhSach TABLE (
    StudentID INT,
    StudentName NVARCHAR(50)
)
AS
BEGIN
    INSERT INTO @DanhSach
    SELECT S.StudentID, S.StudentName
    FROM Students S
    WHERE S.StudentID NOT IN (SELECT DISTINCT StudentID FROM Marks);

    RETURN;
END;
--loi goi
SELECT * FROM dbo.LayHocVienChuaThiMonNao();
--k k. Hàm lấy ra danh sách các học viên có điểm trung bình lớn hơn điểm truyền vào:
CREATE FUNCTION dbo.LayHocVienCoDiemTrungBinhLonHon(@DiemTrungBinh FLOAT)
RETURNS @DanhSach TABLE (
    StudentID INT,
    StudentName NVARCHAR(50),
    DiemTrungBinh FLOAT
)
AS
BEGIN
    INSERT INTO @DanhSach
    SELECT S.StudentID, S.StudentName, AVG(M.Mark) AS DiemTrungBinh
    FROM Students S
    JOIN Marks M ON S.StudentID = M.StudentID
    GROUP BY S.StudentID, S.StudentName
    HAVING AVG(M.Mark) > @DiemTrungBinh;

    RETURN;
END;

---loi goi
SELECT * FROM dbo.LayHocVienCoDiemTrungBinhLonHon(7);

--l. Hàm thống kê số lượng học viên đạt các mức điểm (0-10) cho một môn học:
CREATE FUNCTION dbo.ThongKeDiemTheoMon(@MaMonHoc INT)
RETURNS @ThongKe TABLE (
    Diem INT,
    SoLuongHocVien INT
)
AS
BEGIN
    INSERT INTO @ThongKe
    SELECT Mark AS Diem, COUNT(*) AS SoLuongHocVien
    FROM Marks
    WHERE SubjectID = @MaMonHoc
    GROUP BY Mark;

    RETURN;
END;
--loi goi
SELECT * FROM dbo.ThongKeDiemTheoMon(1);
--m. Hàm lấy ra danh sách các môn học có số học viên đăng ký thi ít hơn số sinh viên truyền vào:
CREATE FUNCTION dbo.LayMonHocCoSoHocVienItHon(@SoHocVien INT)
RETURNS @DanhSach TABLE (
    SubjectID INT,
    SubjectName NVARCHAR(50),
    SoHocVien INT
)
AS
BEGIN
    INSERT INTO @DanhSach
    SELECT Sub.SubjectID, Sub.SubjectName, COUNT(DISTINCT M.StudentID) AS SoHocVien
    FROM Subjects Sub
    LEFT JOIN Marks M ON Sub.SubjectID = M.SubjectID
    GROUP BY Sub.SubjectID, Sub.SubjectName
    HAVING COUNT(DISTINCT M.StudentID) < @SoHocVien;

    RETURN;
END;
--loi goi
SELECT * FROM dbo.LayMonHocCoSoHocVienItHon(3);

