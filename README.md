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

## Chạy thuật toán

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

## Chạy notebook thực nghiệm

Notebook [`notebooks/experiment.ipynb`](notebooks/experiment.ipynb) là Julia notebook (kernel IJulia) dùng để thực hiện toàn bộ Chương 4 — Thực nghiệm và Đánh giá, bao gồm:

- **Kiểm tra tính đúng đắn:** So sánh kết quả FPClose của nhóm với output chuẩn của SPMF trên 5 tập dữ liệu benchmark (Chess, Mushrooms, Retail, Accidents, T10I4D100K), tính Precision/Recall/Match Rate.
- **Đo thời gian chạy và bộ nhớ:** Vẽ biểu đồ so sánh runtime và peak memory giữa cài đặt nhóm và SPMF ở nhiều ngưỡng `minsup` khác nhau.
- **Phân tích số lượng itemset:** Biểu đồ số lượng closed frequent itemset sinh ra theo `minsup` trên từng dataset.
- **Khả năng mở rộng (Scalability):** Đo thời gian chạy khi tăng dần kích thước tập dữ liệu Retail từ 10% đến 100%.
- **Ảnh hưởng của độ dài giao dịch:** Thực nghiệm trên dữ liệu sinh ngẫu nhiên với độ dài giao dịch từ 5 đến 60 item để đánh giá tác động lên runtime.

<!-- ## Chạy kiểm thử

```bash
julia --project tests/runtests.jl
``` -->

## Tải dữ liệu benchmark

Tải các tập dữ liệu từ [SPMF Datasets](https://www.philippe-fournier-viger.com/spmf/index.php?link=datasets.php) và đặt vào thư mục `data/benchmark/`:

| File | Nguồn |
|------|-------|
| `chess.txt` | [SPMF](https://www.philippe-fournier-viger.com/spmf/publicdatasets/chess.txt) |
| `mushrooms.txt` | [SPMF](https://www.philippe-fournier-viger.com/spmf/publicdatasets/mushrooms.txt) |
| `retail.txt` | [SPMF](https://www.philippe-fournier-viger.com/spmf/publicdatasets/retail.txt) |
| `accidents.txt` | [SPMF](https://www.philippe-fournier-viger.com/spmf/publicdatasets/accidents.txt) |
| `T10I4D100K.txt` | [SPMF](https://www.philippe-fournier-viger.com/spmf/publicdatasets/T10I4D100K.txt) |

```
└── data/
    └── benchmark/ 
        ├── chess.txt 
        ├── mushrooms.txt 
        ├── retail.txt
        ├── accidents.txt
        └── T10I4D100K.txt
```
<!-- ## Kết quả kiểm thử

*(Điền output của `julia --project tests/runtests.jl` sau lần chạy cuối trước khi nộp)*

```
Test Summary: | Pass  Fail  Error  Total
FPClose Correctness | ... -->

