-- Bảng Đội Bóng
CREATE TABLE DoiBong (
    MaDoi CHAR(5) PRIMARY KEY,
    TenDoi NVARCHAR(50) NOT NULL,
    SanNha NVARCHAR(50)
);

-- Bảng Cầu Thủ
CREATE TABLE CauThu (
    MaCT CHAR(5) PRIMARY KEY,
    TenCT NVARCHAR(50) NOT NULL,
    ViTri NVARCHAR(20),
    MaDoi CHAR(5),
    FOREIGN KEY (MaDoi) REFERENCES DoiBong(MaDoi)
);

-- Bảng Trận Đấu
CREATE TABLE TranDau (
    MaTD CHAR(5) PRIMARY KEY,
    NgayThiDau DATE,
    SanDau NVARCHAR(50),
    MaDoiChuNha CHAR(5),
    MaDoiKhach CHAR(5),
    FOREIGN KEY (MaDoiChuNha) REFERENCES DoiBong(MaDoi),
    FOREIGN KEY (MaDoiKhach) REFERENCES DoiBong(MaDoi)
);

-- Bảng Tham Gia (liệt kê các cầu thủ tham gia mỗi trận đấu)
CREATE TABLE ThamGia (
    MaTD CHAR(5),
    MaCT CHAR(5),
    SoBanThang INT DEFAULT 0,
    PRIMARY KEY (MaTD, MaCT),
    FOREIGN KEY (MaTD) REFERENCES TranDau(MaTD),
    FOREIGN KEY (MaCT) REFERENCES CauThu(MaCT)
);
-- Thêm dữ liệu vào bảng Đội Bóng
INSERT INTO DoiBong (MaDoi, TenDoi, SanNha)
VALUES 
    ('D01', 'Hà Nội FC', 'Sân Mỹ Đình'),
    ('D02', 'Hồ Chí Minh City', 'Sân Thống Nhất'),
    ('D03', 'Đà Nẵng FC', 'Sân Hòa Xuân');

-- Thêm dữ liệu vào bảng Cầu Thủ
INSERT INTO CauThu (MaCT, TenCT, ViTri, MaDoi)
VALUES 
    ('CT01', 'Nguyễn Văn A', 'Tiền đạo', 'D01'),
    ('CT02', 'Lê Văn B', 'Hậu vệ', 'D01'),
    ('CT03', 'Trần Văn C', 'Tiền vệ', 'D02'),
    ('CT04', 'Phạm Văn D', 'Thủ môn', 'D03');

-- Thêm dữ liệu vào bảng Trận Đấu
INSERT INTO TranDau (MaTD, NgayThiDau, SanDau, MaDoiChuNha, MaDoiKhach)
VALUES 
    ('TD01', '2023-05-21', 'Sân Mỹ Đình', 'D01', 'D02'),
    ('TD02', '2023-06-15', 'Sân Thống Nhất', 'D02', 'D03');

-- Thêm dữ liệu vào bảng Tham Gia
INSERT INTO ThamGia (MaTD, MaCT, SoBanThang)
VALUES 
    ('TD01', 'CT01', 2),
    ('TD01', 'CT02', 0),
    ('TD02', 'CT03', 1),
    ('TD02', 'CT04', 0);
