function ancestor_items(node)

    result = String[]

    current = node

    while current !== nothing && current.item !== nothing
        push!(result, current.item)
        current = current.parent
    end

    reverse!(result)

    return result
end

function closed_checking(
    itemset::Vector{String},
    support::Int,
    cfi_tree::CFITree
)

    isempty(itemset) && return false

    last_item = itemset[end]

    if !haskey(cfi_tree.header_table, last_item)
        return false
    end

    node = cfi_tree.header_table[last_item]

    target = Set(itemset)

    while node !== nothing

        if node.count == support

            ancestors = ancestor_items(node)

            ancestor_set = Set(ancestors)

            if target ⊆ ancestor_set
                return true
            end
        end

        node = node.node_link
    end

    return false
end