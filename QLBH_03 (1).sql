USE [QLBH_BT3]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 10/4/2024 7:36:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[cID] [nchar](10) NOT NULL,
	[cName] [nvarchar](25) NULL,
	[cAge] [tinyint] NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[cID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Order]    Script Date: 10/4/2024 7:36:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[oID] [nchar](10) NOT NULL,
	[cID] [nchar](10) NULL,
	[oDate] [datetime] NULL,
	[oTotalPrice] [int] NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[oID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 10/4/2024 7:36:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[oID] [nchar](10) NOT NULL,
	[pID] [nchar](10) NOT NULL,
	[odQTY] [int] NULL,
 CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED 
(
	[oID] ASC,
	[pID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product]    Script Date: 10/4/2024 7:36:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[pID] [nchar](10) NOT NULL,
	[PName] [nvarchar](25) NULL,
	[pPrice] [int] NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[pID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[Customer] ([cID], [cName], [cAge]) VALUES (N'1         ', N'Minh Quan', 10)
INSERT [dbo].[Customer] ([cID], [cName], [cAge]) VALUES (N'2         ', N'Ngoc Oanh', 20)
INSERT [dbo].[Customer] ([cID], [cName], [cAge]) VALUES (N'3         ', N'Hong Ha', 50)
INSERT [dbo].[Customer] ([cID], [cName], [cAge]) VALUES (N'4         ', NULL, NULL)
INSERT [dbo].[Order] ([oID], [cID], [oDate], [oTotalPrice]) VALUES (N'1         ', N'1         ', CAST(N'2006-03-21 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[Order] ([oID], [cID], [oDate], [oTotalPrice]) VALUES (N'2         ', N'2         ', CAST(N'2006-03-23 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[Order] ([oID], [cID], [oDate], [oTotalPrice]) VALUES (N'3         ', N'1         ', CAST(N'2006-03-16 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[OrderDetail] ([oID], [pID], [odQTY]) VALUES (N'1         ', N'1         ', 3)
INSERT [dbo].[OrderDetail] ([oID], [pID], [odQTY]) VALUES (N'1         ', N'3         ', 7)
INSERT [dbo].[OrderDetail] ([oID], [pID], [odQTY]) VALUES (N'1         ', N'4         ', 2)
INSERT [dbo].[OrderDetail] ([oID], [pID], [odQTY]) VALUES (N'2         ', N'1         ', 1)
INSERT [dbo].[OrderDetail] ([oID], [pID], [odQTY]) VALUES (N'2         ', N'3         ', 3)
INSERT [dbo].[OrderDetail] ([oID], [pID], [odQTY]) VALUES (N'2         ', N'5         ', 4)
INSERT [dbo].[OrderDetail] ([oID], [pID], [odQTY]) VALUES (N'3         ', N'1         ', 8)
INSERT [dbo].[Product] ([pID], [PName], [pPrice]) VALUES (N'1         ', N'May Giat', 3)
INSERT [dbo].[Product] ([pID], [PName], [pPrice]) VALUES (N'2         ', N'Tu Lanh', 5)
INSERT [dbo].[Product] ([pID], [PName], [pPrice]) VALUES (N'3         ', N'Dieu Hoa', 7)
INSERT [dbo].[Product] ([pID], [PName], [pPrice]) VALUES (N'4         ', N'Quat', 1)
INSERT [dbo].[Product] ([pID], [PName], [pPrice]) VALUES (N'5         ', N'Bep Dien', 2)
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Customer] FOREIGN KEY([cID])
REFERENCES [dbo].[Customer] ([cID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Customer]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_Order] FOREIGN KEY([oID])
REFERENCES [dbo].[Order] ([oID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_Order]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_Product] FOREIGN KEY([pID])
REFERENCES [dbo].[Product] ([pID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_Product]
GO
/****** Object:  StoredProcedure [dbo].[HienThiKhachHangVaSanPham]    Script Date: 10/4/2024 7:36:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[HienThiKhachHangVaSanPham]
AS
BEGIN
    SELECT C.cName, P.pName
    FROM Customer C
    JOIN [Order] O ON C.cID = O.cID
    JOIN OrderDetail OD ON O.oID = OD.oID
    JOIN Product P ON OD.pID = P.pID
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DoanhThu_Select_TheoNam]    Script Date: 10/4/2024 7:36:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DoanhThu_Select_TheoNam]
    @Nam INT
AS
BEGIN
    SELECT MONTH(oDate) AS Thang, SUM(oTotalPrice) AS TongDoanhThu
    FROM [Order]
    WHERE YEAR(oDate) = @Nam
    GROUP BY MONTH(oDate);
END
GO
/****** Object:  StoredProcedure [dbo].[sp_HoaDon_Select_CaoNhat]    Script Date: 10/4/2024 7:36:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_HoaDon_Select_CaoNhat]
AS
BEGIN
    SELECT TOP 1 O.oID, O.oDate, SUM(OD.odQTY * P.pPrice) AS TongGiaTriHoaDon
    FROM [Order] O
    JOIN OrderDetail OD ON O.oID = OD.oID
    JOIN Product P ON OD.pID = P.pID
    GROUP BY O.oID, O.oDate
    ORDER BY TongGiaTriHoaDon DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_KhachHang_Selct_Khongmua]    Script Date: 10/4/2024 7:36:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_KhachHang_Selct_Khongmua]
as
begin
	select cName 
	from Customer
	where cID not in (select distinct cID from [Order])
end
GO
/****** Object:  StoredProcedure [dbo].[sp_KhachHang_Select_SanPhamMua]    Script Date: 10/4/2024 7:36:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_KhachHang_Select_SanPhamMua]
AS
BEGIN
    SELECT C.cName, P.pName
    FROM Customer C
    JOIN [Order] O ON C.cID = O.cID
    JOIN OrderDetail OD ON O.oID = OD.oID
    JOIN Product P ON OD.pID = P.pID;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_MatHang_Select_ChuaMua]    Script Date: 10/4/2024 7:36:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_MatHang_Select_ChuaMua]
as
	begin
		select pID,pName
		from Product
		where pID not in (select pID from OrderDetail)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_Oder_Select_Hienthi]    Script Date: 10/4/2024 7:36:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Oder_Select_Hienthi]
AS
BEGIN
    SELECT oID,cID, oDate, oTotalPrice
    FROM [Order]
    ORDER BY oDate DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Order_Select_ThangNam]    Script Date: 10/4/2024 7:36:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Order_Select_ThangNam]
    @Thang INT,
    @Nam INT
AS
BEGIN
    SELECT [Order].oID as MaHoaDon,[Order].cID as MaNguoiMua ,Product.pID as MaSanPhan, Product.pName as TenSanPham, [Order].oDate, [Order].oTotalPrice
    FROM [Order]
    JOIN OrderDetail ON OrderDetail.oID = [Order].oID
    JOIN Product ON Product.pID = OrderDetail.pID
    WHERE MONTH([Order].oDate) = @Thang AND YEAR([Order].oDate) = @Nam;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Order_Select_TheoThangNam]    Script Date: 10/4/2024 7:36:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Order_Select_TheoThangNam]
    @Thang INT,
    @Nam INT
AS
BEGIN
    SELECT oID, oDate, oTotalPrice
    FROM [Order]
    WHERE MONTH(oDate) = @Thang AND YEAR(oDate) = @Nam;
END
GO
