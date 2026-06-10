function sort_transaction(
    transaction::Vector{String},
    freq_map::Dict{String,Int}
)
    sort(
        transaction,
        by=x -> (-freq_map[x], x)
    )
end

function is_single_path(tree)
    node = tree.root

    while true
        n = length(node.children)

        if n == 0
            return true
        elseif n > 1
            return false
        end

        node = first(values(node.children))
    end
end

function collect_single_path(tree)
    result = []
    node = tree.root

    while !isempty(node.children)
        child = first(values(node.children))
        push!(result, (child.item, child.count))
        node = child
    end

    result
end

function all_combinations(items)
    n = length(items)
    result = []

    for mask in 1:(2^n - 1)
        subset = []

        for i in 1:n
            if (mask & (1 << (i-1))) != 0
                push!(subset, items[i])
            end
        end

        push!(result, subset)
    end

    result
end

function count_items(transactions)
    return sum(
        length(transaction)
        for transaction in transactions
)
end

function measure_time_ms(f::Function)
    start_time = time_ns()
    f()
    return (time_ns() - start_time) / 1_000_000
end

function measure_memory_mb(f::Function)
    GC.gc()

    memory_before = Base.gc_live_bytes()
    f()
    memory_after = Base.gc_live_bytes()

    return (memory_after - memory_before) / 1024 / 1024
end

function minsup_to_absolute(transactions,minsup_pct)
    return ceil(Int,minsup_pct * length(transactions))
end