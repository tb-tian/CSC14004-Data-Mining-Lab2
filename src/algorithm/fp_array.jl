function build_fp_array!(
    tree::FPTree,
    ordered_transaction::Vector{String}
)
    n = length(ordered_transaction)

    for i in 1:n-1
        for j in i+1:n

            a = ordered_transaction[i]
            b = ordered_transaction[j]

            key = (a, b)

            tree.fp_array[key] = get(tree.fp_array, key, 0) + 1
        end
    end
end

function get_conditional_frequent_items(
    tree::FPTree,
    suffix::String,
    minsup::Int
)
    counts = Dict{String,Int}()

    for ((a,b), c) in tree.fp_array

        if b == suffix && c >= minsup
            counts[a] = c
        end
    end

    counts
end