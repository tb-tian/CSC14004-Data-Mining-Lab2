function prefix_path_with_count(node::FPNode)

    path = String[]

    current = node.parent

    while current !== nothing && current.item !== nothing
        push!(path, current.item)
        current = current.parent
    end

    reverse!(path)

    return path, node.count
end

function conditional_pattern_base(
    tree::FPTree,
    item::String
)

    base = Vector{Tuple{Vector{String},Int}}()

    _, node = tree.header_table[item]

    while node !== nothing

        path, count = prefix_path_with_count(node)

        if !isempty(path)
            push!(base, (path, count))
        end

        node = node.node_link
    end

    return base
end

function build_conditional_tree(
    tree::FPTree,
    item::String,
    minsup::Int
)

    pattern_base = conditional_pattern_base(
        tree,
        item
    )

    counts = Dict{String,Int}()

    for (path, support) in pattern_base
        for x in path
            counts[x] = get(counts, x, 0) + support
        end
    end

    filter!(kv -> kv[2] >= minsup, counts)

    cond_tree = FPTree()

    for (x, support) in counts
        cond_tree.header_table[x] = (support, nothing)
    end

    for (path, support) in pattern_base

        filtered = [x for x in path if haskey(counts, x)]

        if isempty(filtered)
            continue
        end

        ordered = sort(
            filtered,
            by = x -> (-counts[x], x)
        )

        insert_transaction!(
            cond_tree,
            ordered,
            support
        )

        build_fp_array!(
            cond_tree,
            ordered
        )
    end

    cond_tree.base = copy(tree.base)

    push!(
        cond_tree.base,
        item
    )

    return cond_tree
end