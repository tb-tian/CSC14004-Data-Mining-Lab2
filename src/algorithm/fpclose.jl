include("../structures.jl")
include("../utils.jl")

function fpclose(
    tree::FPTree,
    alpha::Vector{String},
    minsup::Int,
    cfi_tree::CFITree,
    results
)

    if isempty(tree.header_order)
        return
    end

    # single path optimization
    if is_single_path(tree.root)

        path = collect_single_path(tree.root)

        current_pattern = copy(alpha)
        previous_support = -1

        for (item, support) in path

            push!(current_pattern, item)

            if support != previous_support

                pattern = sort(copy(current_pattern))

                if !cfi_subsumes(
                    cfi_tree,
                    pattern,
                    support
                )

                    insert_cfi!(
                        cfi_tree,
                        pattern,
                        support
                    )

                    push!(
                        results,
                        (pattern, support)
                    )
                end

                previous_support = support
            end
        end

        return
    end

    # bottom-up mining
    for item in reverse(tree.header_order)

        support = tree.item_support[item]

        beta = copy(alpha)
        push!(beta, item)

        closed_beta = sort(beta)

        if !cfi_subsumes(
            cfi_tree,
            closed_beta,
            support
        )

            insert_cfi!(
                cfi_tree,
                closed_beta,
                support
            )

            push!(
                results,
                (closed_beta, support)
            )
        end

        paths = find_prefix_paths(tree, item)

        if isempty(paths)
            continue
        end

        cond_tree = build_conditional_tree(
            paths,
            minsup
        )

        if !isempty(cond_tree.header_order)

            fpclose(
                cond_tree,
                closed_beta,
                minsup,
                cfi_tree,
                results
            )
        end
    end
end

function run_fpclose(
    transactions,
    minsup
)

    tree = build_fp_tree(
        transactions,
        minsup
    )

    cfi_tree = CFITree()

    results = Vector{
        Tuple{Vector{String}, Int}
    }()

    fpclose(
        tree,
        String[],
        minsup,
        cfi_tree,
        results
    )

    return sort(
        unique(results),
        by = x -> (
            length(x[1]),
            x[1]
        )
    )
end