function generate_single_path_closed(
    tree::FPTree,
    cfi_tree::CFITree,
    results
)

    path = collect_single_path(tree)

    items = [x[1] for x in path]
    counts = [x[2] for x in path]

    n = length(items)

    for i in 1:n

        support = minimum(counts[1:i])

        closed = true

        if i < n && counts[i] == counts[i+1]
            closed = false
        end

        if !closed
            continue
        end

        itemset = sort(unique(vcat(
            tree.base,
            items[1:i]
        )))

        if !closed_checking(
            itemset,
            support,
            cfi_tree
        )

            insert_cfi!(
                cfi_tree,
                itemset,
                support
            )

            push!(
                results,
                (itemset, support)
            )
        end
    end
end

function recursive_fpclose!(
    tree::FPTree,
    minsup::Int,
    cfi_tree::CFITree,
    results
)

    isempty(tree.header_table) && return

    if is_single_path(tree)

        generate_single_path_closed(
            tree,
            cfi_tree,
            results
        )

        return
    end

    ordered_items = sort(
        collect(keys(tree.header_table)),
        by = x -> tree.header_table[x][1]
    )

    for item in ordered_items

        support, _ = tree.header_table[item]

        candidate = sort(unique(vcat(
            tree.base,
            [item]
        )))

        if closed_checking(
            candidate,
            support,
            cfi_tree
        )
            continue
        end

        insert_cfi!(
            cfi_tree,
            candidate,
            support
        )

        push!(
            results,
            (candidate, support)
        )

        conditional_tree = build_conditional_tree(
            tree,
            item,
            minsup
        )

        recursive_fpclose!(
            conditional_tree,
            minsup,
            cfi_tree,
            results
        )
    end
end

function mine_closed_itemsets(transactions, minsup)

    tree = build_fp_tree(
        transactions,
        minsup
    )

    cfi_tree = CFITree()

    results = Vector{Tuple{Vector{String},Int}}()

    recursive_fpclose!(
        tree,
        minsup,
        cfi_tree,
        results
    )

    unique(results)
end