# CSC14004 - Data Mining - Lab 2
# KHAI THÁC TẬP PHỔ BIẾN — FPClose

## Thành viên nhóm 10

| Họ tên | MSSV |
|---|---|
| Trương Bảo Thiên Ân | 23120019 |
| Nguyễn Duy Khánh | 23120051 |
| Nguyễn Văn Phúc | 21120531 |
| Nguyễn Lê Phúc Thắng | 22120332 |
| Nguyễn Thanh Sang | 21120546 |

## Thuật toán

**FPClose** — Khai thác tập phổ biến đóng (Closed Frequent Itemset Mining) dựa trên cấu trúc FP-tree.

> Grahne, G., & Zhu, J. (2005). Fast algorithms for frequent itemset mining using FP-trees. *IEEE Transactions on Knowledge and Data Engineering*, 17(10), 1347-1362.

## Cấu trúc thư mục

```
.
├── Project.toml              # Julia project & dependencies
├── src/
│   ├── algorithm/
│   │   └── fpclose.jl        # Cài đặt FPClose
│   ├── structures.jl         # FP-tree, FPNode
│   └── utils.jl              # Đọc/ghi SPMF, CLI args
├── tests/
│   ├── runtests.jl           # Entry point
│   ├── test_correctness.jl   # Unit tests so sánh với SPMF
│   └── test_benchmark.jl     # Đo thời gian & bộ nhớ
├── data/
│   ├── toy/                  # CSDL nhỏ cho ví dụ tay
│   └── benchmark/            # Chess, Mushroom, Retail, Accidents, T10I4D100K
├── notebooks/
│   └── demo.ipynb
└── docs/
    └── Report.pdf
```

## Cài đặt môi trường

Yêu cầu: **Julia >= 1.9**

```bash
# Cài đặt các gói phụ thuộc
julia --project -e 'using Pkg; Pkg.instantiate()'
```

<!-- ## Chạy thuật toán

```bash
# julia --project src/algorithm/fpclose.jl <minsup> <filepath>
julia --project src/algorithm/fpclose.jl 2 data/toy/example1.txt
```

Định dạng đầu vào (SPMF `.txt`): mỗi dòng là một giao dịch, các item là số nguyên cách nhau bằng dấu cách.

Định dạng đầu ra:
```
1 2 3 #SUP: 4
2 3   #SUP: 6
```

## Chạy kiểm thử

```bash
julia --project tests/runtests.jl
```

## Tải dữ liệu benchmark

Tải các tập dữ liệu từ [SPMF Datasets](https://www.philippe-fournier-viger.com/spmf/index.php?link=datasets.php) hoặc [FIMI Repository](http://fimi.uantwerpen.be/data/) và đặt vào thư mục `data/benchmark/`:

| Tập dữ liệu | File | #Trans | #Items | Đặc điểm |
|---|---|---|---|---|
| Chess | chess.dat | 3.196 | 75 | Dày đặc |
| Mushroom | mushroom.dat | 8.124 | 119 | Dày đặc |
| Retail | retail.dat | 88.162 | 16.47 | Thưa |
| Accidents | accidents.dat | 340.183 | 468 | Rất lớn |
| T10I4D100K | T10I4D100K.dat | 100.000 | 870 | Tổng hợp |

> Nếu file benchmark > 25MB, tải từ Google Drive: *(link sẽ được thêm sau)*

## Kết quả kiểm thử

*(Điền output của `julia --project tests/runtests.jl` sau lần chạy cuối trước khi nộp)*

```
Test Summary: | Pass  Fail  Error  Total
FPClose Correctness | ...
``` -->
