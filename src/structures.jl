mutable struct FPNode
    item::Union{Nothing,String}
    count::Int
    parent::Union{Nothing,FPNode}
    children::Dict{String,FPNode}
    node_link::Union{Nothing,FPNode}

    function FPNode(item, count, parent)
        new(item, count, parent, Dict{String,FPNode}(), nothing)
    end
end

mutable struct FPTree
    root::FPNode
    header_table::Dict{String,Tuple{Int,Union{Nothing,FPNode}}}
    base::Vector{String}
    fp_array::Dict{Tuple{String,String},Int}

    function FPTree(base=String[])
        root = FPNode(nothing, 0, nothing)

        new(
            root,
            Dict{String,Tuple{Int,Union{Nothing,FPNode}}}(),
            base,
            Dict{Tuple{String,String},Int}()
        )
    end
end

mutable struct CFINode
    item::Union{Nothing,String}
    count::Int
    level::Int
    parent::Union{Nothing,CFINode}
    children::Dict{String,CFINode}
    node_link::Union{Nothing,CFINode}

    function CFINode(item, count, level, parent)
        new(item, count, level, parent, Dict{String,CFINode}(), nothing)
    end
end

mutable struct CFITree
    root::CFINode
    header_table::Dict{String,Union{Nothing,CFINode}}

    function CFITree()
        root = CFINode(nothing, 0, 0, nothing)
        new(root, Dict{String,Union{Nothing,CFINode}}())
    end
end