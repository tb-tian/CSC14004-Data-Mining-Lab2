function build_frequency_table(transactions, minsup)

    counts = Dict{String,Int}()

    for transaction in transactions
        for item in transaction
            counts[item] = get(counts, item, 0) + 1
        end
    end

    filter!(x -> x[2] >= minsup, counts)

    counts
end

function update_header!(tree::FPTree, item::String, node::FPNode)

    if !haskey(tree.header_table, item)
        tree.header_table[item] = (0, node)
        return
    end

    count, head = tree.header_table[item]

    if head === nothing
        tree.header_table[item] = (count, node)
        return
    end

    current = head

    while current.node_link !== nothing
        current = current.node_link
    end

    current.node_link = node
end

function insert_transaction!(
    tree::FPTree,
    transaction::Vector{String},
    count::Int=1
)

    current = tree.root

    for item in transaction

        if haskey(current.children, item)

            child = current.children[item]
            child.count += count

        else

            child = FPNode(item, count, current)
            current.children[item] = child

            update_header!(tree, item, child)
        end

        current = child
    end
end

function build_fp_tree(transactions, minsup)

    freq_table = build_frequency_table(transactions, minsup)

    tree = FPTree()

    for (item, count) in freq_table
        tree.header_table[item] = (count, nothing)
    end

    for transaction in transactions

        filtered = [x for x in transaction if haskey(freq_table, x)]

        if isempty(filtered)
            continue
        end

        ordered = sort_transaction(filtered, freq_table)

        insert_transaction!(tree, ordered)

        build_fp_array!(tree, ordered)
    end

    tree
end