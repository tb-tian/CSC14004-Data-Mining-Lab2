include("../structures.jl")
include("../utils.jl")
include("cfi_tree.jl")
include("closed_checking.jl")
include("fp_tree.jl")
include("fp_array.jl")
include("conditional_tree.jl")

# Recursive FPclose — Grahne & Zhu (2005), §4, Fig. 8.
# tree:     current conditional FP-tree (tree.base holds the itemset prefix)
# minsup:   minimum support threshold
# cfi_tree: shared CFI-tree used for closed_checking across all recursion levels
# results:  accumulated (itemset, support) pairs
function fpclose(
    tree::FPTree,
    minsup::Int,
    cfi_tree::CFITree,
    results
)
    isempty(tree.header_table) && return

    if is_single_path(tree)
        path = collect_single_path(tree)
        n = length(path)
        for i in 1:n
            count_i = path[i][2]
            # A prefix is closed only where the count strictly decreases.
            if i < n && count_i == path[i+1][2]
                continue
            end
            itemset = sort(unique(vcat(
                tree.base,
                [path[k][1] for k in 1:i]
            )))
            if !closed_checking(itemset, count_i, cfi_tree)
                insert_cfi!(cfi_tree, itemset, count_i)
                push!(results, (itemset, count_i))
            end
        end
        return
    end

    # Process items in ascending support order (bottom-up).
    ordered_items = sort(
        collect(keys(tree.header_table)),
        by = x -> tree.header_table[x][1]
    )

    for item in ordered_items
        support, _ = tree.header_table[item]
        candidate = sort(unique(vcat(tree.base, [item])))

        if closed_checking(candidate, support, cfi_tree)
            continue
        end

        cond_tree = build_conditional_tree(tree, item, minsup)

        # candidate is closed only if no item j in its conditional tree has
        # support equal to `support` (which would mean candidate ∪ {j} has
        # the same support, making candidate non-closed).
        y_is_closed = !any(
            v[1] == support
            for v in values(cond_tree.header_table)
        )

        if y_is_closed
            insert_cfi!(cfi_tree, candidate, support)
            push!(results, (candidate, support))
        end

        fpclose(cond_tree, minsup, cfi_tree, results)
    end
end

function run_fpclose(transactions, minsup)
    tree = build_fp_tree(transactions, minsup)
    cfi_tree = CFITree()
    results = Vector{Tuple{Vector{String},Int}}()
    fpclose(tree, minsup, cfi_tree, results)
    return sort(unique(results), by = x -> (length(x[1]), x[1]))
end

if abspath(PROGRAM_FILE) == @__FILE__
    if length(ARGS) < 2
        println("Usage: julia --project src/algorithm/fpclose.jl <minsup> <filepath> [output_path]")
        exit(1)
    end
    
    include("io.jl")
    minsup = parse(Int, ARGS[1])
    filepath = ARGS[2]
    output_path = length(ARGS) >= 3 ? ARGS[3] : nothing
    
    transactions = load_transactions(filepath)
    results = run_fpclose(transactions, minsup)
    
    if output_path === nothing
        for (itemset, count) in results
            println(join(itemset, " "), " #SUP: ", count)
        end
    else
        open(output_path, "w") do f
            for (itemset, count) in results
                println(f, join(itemset, " "), " #SUP: ", count)
            end
        end
        println("Kết quả đã được ghi vào file: $output_path")
    end
end

