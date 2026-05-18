function update_cfi_header!(
    tree::CFITree,
    item::String,
    node::CFINode
)

    if !haskey(tree.header_table, item)
        tree.header_table[item] = node
        return
    end

    current = tree.header_table[item]

    while current.node_link !== nothing
        current = current.node_link
    end

    current.node_link = node
end

function insert_cfi!(
    tree::CFITree,
    itemset::Vector{String},
    support::Int
)

    current = tree.root

    level = 1

    for item in itemset

        if haskey(current.children, item)

            child = current.children[item]
            child.count = max(child.count, support)

        else

            child = CFINode(item, support, level, current)

            current.children[item] = child

            update_cfi_header!(tree, item, child)
        end

        current = child
        level += 1
    end
end