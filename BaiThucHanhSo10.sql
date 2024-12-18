USE [master]
GO
/****** Object:  Database [BaiThucHanhSo10]    Script Date: 11/25/2024 9:26:24 PM ******/
CREATE DATABASE [BaiThucHanhSo10]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BaiThucHanhSo10', FILENAME = N'E:\SQL_Setup\MSSQL12.DATSQL\MSSQL\DATA\BaiThucHanhSo10.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'BaiThucHanhSo10_log', FILENAME = N'E:\SQL_Setup\MSSQL12.DATSQL\MSSQL\DATA\BaiThucHanhSo10_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [BaiThucHanhSo10] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BaiThucHanhSo10].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BaiThucHanhSo10] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET ARITHABORT OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BaiThucHanhSo10] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BaiThucHanhSo10] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BaiThucHanhSo10] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BaiThucHanhSo10] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BaiThucHanhSo10] SET  MULTI_USER 
GO
ALTER DATABASE [BaiThucHanhSo10] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BaiThucHanhSo10] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BaiThucHanhSo10] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BaiThucHanhSo10] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [BaiThucHanhSo10] SET DELAYED_DURABILITY = DISABLED 
GO
USE [BaiThucHanhSo10]
GO
/****** Object:  UserDefinedFunction [dbo].[fc_LaySoSachMuonTrongTuNgay]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fc_LaySoSachMuonTrongTuNgay](@ngay datetime)
RETURNS INT
AS
	BEGIN 
		RETURN (
			SELECT COUNT(masach)
			FROM Muon
			WHERE @ngay = ngaymuon
		)
	END

GO
/****** Object:  UserDefinedFunction [dbo].[fc_LaySoSachTrongThuVien]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fc_LaySoSachTrongThuVien]()
RETURNS INT
AS
	BEGIN 
		RETURN (
			SELECT COUNT(masach)
			FROM Sachmuon
		)
	END
GO
/****** Object:  UserDefinedFunction [dbo].[fc_ThongKeSoNguoiDenTrong]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fc_ThongKeSoNguoiDenTrong]  (@NgayA datetime, @NgayB datetime)
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
GO
/****** Object:  UserDefinedFunction [dbo].[fc_ThongKeSoSachTrongThuVien]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fc_ThongKeSoSachTrongThuVien] ()
RETURNS int
AS
	BEGIN
		RETURN (
			SELECT COUNT (masach)
			FROM Sachmuon
		)
	END

GO
/****** Object:  Table [dbo].[Docgia]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Docgia](
	[madg] [nvarchar](10) NOT NULL,
	[tendg] [nvarchar](50) NOT NULL,
	[doituong] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Docgia] PRIMARY KEY CLUSTERED 
(
	[madg] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Muon]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Muon](
	[madg] [nvarchar](10) NOT NULL,
	[masach] [nvarchar](10) NOT NULL,
	[ngaymuon] [datetime] NULL,
	[ngaytra] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Nhaxb]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Nhaxb](
	[maxb] [nvarchar](10) NOT NULL,
	[tenxb] [nvarchar](50) NOT NULL,
	[thanhpho] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Nhaxb] PRIMARY KEY CLUSTERED 
(
	[maxb] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Sachmuon]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sachmuon](
	[masach] [nvarchar](10) NOT NULL,
	[tensach] [nvarchar](50) NOT NULL,
	[namxb] [numeric](18, 0) NULL,
	[maxb] [nvarchar](10) NOT NULL,
	[matg] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_Sachmuon] PRIMARY KEY CLUSTERED 
(
	[masach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tacgia]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tacgia](
	[matg] [nvarchar](10) NOT NULL,
	[tentg] [nvarchar](50) NOT NULL,
	[chuyenmon] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Tacgia] PRIMARY KEY CLUSTERED 
(
	[matg] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  UserDefinedFunction [dbo].[fc_LayDanhSachChuaTraSach]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fc_LayDanhSachChuaTraSach]()
RETURNS TABLE 
AS
	RETURN (
			SELECT Muon.madg , tendg
		FROM Docgia JOIN Muon ON Docgia.madg = Muon.madg
		WHERE ngaymuon is null
	)

GO
/****** Object:  UserDefinedFunction [dbo].[fc_LayDanhSachCuaDocGiaChuaTraSach]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fc_LayDanhSachCuaDocGiaChuaTraSach]()
RETURNS TABLE 
AS
	RETURN (
		SELECT Muon.madg , tendg
		FROM Docgia JOIN Muon ON Docgia.madg = Muon.madg
		WHERE ngaymuon is null
	)
GO
/****** Object:  UserDefinedFunction [dbo].[fc_LayDanhSachCuaTacGia]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fc_LayDanhSachCuaTacGia](@matg nvarchar(10))
RETURNS TABLE 
AS
	RETURN (
			SELECT masach , tensach , tentg
			FROM Tacgia JOIN Sachmuon on Tacgia.matg = Sachmuon.matg
			WHERE @matg = Tacgia.matg
	)
GO
/****** Object:  UserDefinedFunction [dbo].[fc_LayDanhSachMuon]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fc_LayDanhSachMuon](@ngay datetime)
RETURNS TABLE 
AS
	RETURN (
		SELECT Sachmuon.masach ,tensach
		FROM Sachmuon JOIN Muon on Sachmuon.masach = Muon.masach
		WHERE @ngay = ngaymuon
	)
GO
/****** Object:  UserDefinedFunction [dbo].[fc_LayDanhSachSach]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fc_LayDanhSachSach]()
RETURNS TABLE 
AS
	RETURN (
		SELECT *
		FROM Sachmuon
	)
GO
/****** Object:  UserDefinedFunction [dbo].[fc_ThongKeSoLanDenCuaDocGia]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fc_ThongKeSoLanDenCuaDocGia]()
RETURNS TABLE
AS
	RETURN (
			SELECT tendg ,COUNT (Muon.madg) AS SoLanDen
			FROM Muon JOIN DocGia ON Muon.madg = Docgia.madg
			GROUP BY tendg , Muon.madg
		)
GO
/****** Object:  UserDefinedFunction [dbo].[fc_ThongKeSoNguoi]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fc_ThongKeSoNguoi] ()
RETURNS TABLE
AS
	RETURN (
			SELECT tendg ,COUNT (Muon.madg) AS SoLanDen
			FROM Muon JOIN DocGia ON Muon.madg = Docgia.madg
			GROUP BY tendg , Muon.madg
		)
GO
/****** Object:  UserDefinedFunction [dbo].[fc_ThongKeSoSachTrongThuVienDaDuocMuonBaoNhieu]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fc_ThongKeSoSachTrongThuVienDaDuocMuonBaoNhieu] ()
RETURNS TABLE
AS
	RETURN (
			SELECT Sachmuon.masach , tensach , ISNULL (COUNT (Sachmuon.masach) , 0) AS SoLanMuon
			FROM Sachmuon LEFT JOIN Muon ON Sachmuon.masach = Muon.masach
			GROUP BY Sachmuon.masach, tensach 
		)
GO
/****** Object:  UserDefinedFunction [dbo].[fc_ThongKeSoTacGiaKhongVietTacPhamNaoTrong]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fc_ThongKeSoTacGiaKhongVietTacPhamNaoTrong] (@nam int)
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
GO
ALTER TABLE [dbo].[Muon]  WITH CHECK ADD  CONSTRAINT [FK_Muon_Docgia] FOREIGN KEY([madg])
REFERENCES [dbo].[Docgia] ([madg])
GO
ALTER TABLE [dbo].[Muon] CHECK CONSTRAINT [FK_Muon_Docgia]
GO
ALTER TABLE [dbo].[Muon]  WITH CHECK ADD  CONSTRAINT [FK_Muon_Sachmuon] FOREIGN KEY([masach])
REFERENCES [dbo].[Sachmuon] ([masach])
GO
ALTER TABLE [dbo].[Muon] CHECK CONSTRAINT [FK_Muon_Sachmuon]
GO
ALTER TABLE [dbo].[Sachmuon]  WITH CHECK ADD  CONSTRAINT [FK_Sachmuon_Nhaxb] FOREIGN KEY([maxb])
REFERENCES [dbo].[Nhaxb] ([maxb])
GO
ALTER TABLE [dbo].[Sachmuon] CHECK CONSTRAINT [FK_Sachmuon_Nhaxb]
GO
ALTER TABLE [dbo].[Sachmuon]  WITH CHECK ADD  CONSTRAINT [FK_Sachmuon_Tacgia] FOREIGN KEY([matg])
REFERENCES [dbo].[Tacgia] ([matg])
GO
ALTER TABLE [dbo].[Sachmuon] CHECK CONSTRAINT [FK_Sachmuon_Tacgia]
GO
/****** Object:  StoredProcedure [dbo].[pr_CapNhatThongTinTacGia]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[pr_CapNhatThongTinTacGia]
	@matg nvarchar(10),
	@tentg nvarchar(50),
	@chuyenmon nvarchar(50),
	@Ketqua nvarchar(50) output
AS 
	if (not exists(SELECT 1 FROM Tacgia WHERE @matg = matg) )
		SET @Ketqua = N'Mã tác giả không tồn tại'
	ELSE
		UPDATE Tacgia
		SET tentg = @tentg , 
			 chuyenmon = @chuyenmon
		WHERE matg = matg
GO
/****** Object:  StoredProcedure [dbo].[pr_LayDanhSachCuaDocGiaChuaTraSach]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[pr_LayDanhSachCuaDocGiaChuaTraSach]
AS
	SELECT Muon.madg , tendg
	FROM Docgia JOIN Muon ON Docgia.madg = Muon.madg
	WHERE ngaymuon is null

GO
/****** Object:  StoredProcedure [dbo].[pr_LayDanhSachCuaTacGia]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[pr_LayDanhSachCuaTacGia](@matg nvarchar(10))
AS
	SELECT masach , tensach , tentg
	FROM Tacgia JOIN Sachmuon on Tacgia.matg = Sachmuon.matg
	WHERE @matg = Tacgia.matg

GO
/****** Object:  StoredProcedure [dbo].[pr_LayDanhSachMuon]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[pr_LayDanhSachMuon](@ngay datetime)
AS
	SELECT Sachmuon.masach ,tensach
	FROM Sachmuon JOIN Muon on Sachmuon.masach = Muon.masach
	WHERE @ngay = ngaymuon
GO
/****** Object:  StoredProcedure [dbo].[pr_LayDanhSachSach]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[pr_LayDanhSachSach]
AS
	SELECT *
	FROM Sachmuon
GO
/****** Object:  StoredProcedure [dbo].[pr_LayDanhSachTacGia]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[pr_LayDanhSachTacGia](@ten nvarchar(50))
AS
	SELECT *
	FROM Tacgia
	WHERE tentg like '%'+ @ten  + '%'

GO
/****** Object:  StoredProcedure [dbo].[pr_ThemMoiDocGia]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[pr_ThemMoiDocGia]
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
GO
/****** Object:  StoredProcedure [dbo].[pr_ThongKeDocGiaMuonSachHon]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[pr_ThongKeDocGiaMuonSachHon] (@lan int)
AS
	SELECT tendg
	FROM fc_ThongKeSoLanDenCuaDocGia()
	WHERE SoLanDen > @lan
GO
/****** Object:  StoredProcedure [dbo].[pr_ThongKeSoLanDenCuaDocGia]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[pr_ThongKeSoLanDenCuaDocGia]
AS
	SELECT tendg ,COUNT (Muon.madg) AS SoLanDen
	FROM Muon JOIN DocGia ON Muon.madg = Docgia.madg
	GROUP BY tendg , Muon.madg
GO
/****** Object:  StoredProcedure [dbo].[pr_ThongKeSoNguoi]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[pr_ThongKeSoNguoi]
	@Thang int,
	@Nam int
AS
	SELECT COUNT(madg)
	FROM Muon
	WHERE MONTH(ngaymuon) = @Thang AND YEAR(ngaymuon) = @Nam
GO
/****** Object:  StoredProcedure [dbo].[pr_ThongKeSoNguoiDenTrong]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[pr_ThongKeSoNguoiDenTrong] (@NgayA datetime, @NgayB datetime)
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
GO
/****** Object:  StoredProcedure [dbo].[pr_ThongKeSoSachTrongThuVien]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[pr_ThongKeSoSachTrongThuVien] 
AS
	SELECT COUNT (masach)
	FROM Sachmuon
GO
/****** Object:  StoredProcedure [dbo].[pr_ThongKeSoSachTrongThuVienDaDuocMuonBaoNhieu]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[pr_ThongKeSoSachTrongThuVienDaDuocMuonBaoNhieu]
AS
	SELECT Sachmuon.masach , tensach , ISNULL (COUNT (Sachmuon.masach) , 0) AS SoLanMuon
	FROM Sachmuon LEFT JOIN Muon ON Sachmuon.masach = Muon.masach
	GROUP BY Sachmuon.masach, tensach 

GO
/****** Object:  StoredProcedure [dbo].[pr_ThongKeSoTacGiaKhongVietTacPhamNaoTrong]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[pr_ThongKeSoTacGiaKhongVietTacPhamNaoTrong] (@nam int)
AS
	SELECT *
	FROM Tacgia
	WHERE matg not in
				(
					SELECT matg
					FROM Sachmuon
					WHERE namxb = @nam
				)
GO
/****** Object:  StoredProcedure [dbo].[pr_XoaSach]    Script Date: 11/25/2024 9:26:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[pr_XoaSach](@masach nvarchar(10))
AS
	DELETE Muon
	WHERE masach = @masach

	DELETE Sachmuon
	WHERE masach = @masach
GO
USE [master]
GO
ALTER DATABASE [BaiThucHanhSo10] SET  READ_WRITE 
GO
