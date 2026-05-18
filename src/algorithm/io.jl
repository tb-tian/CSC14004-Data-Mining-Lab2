function load_transactions(path::String)
    transactions = Vector{Vector{String}}()

    open(path, "r") do io
        for line in eachline(io)
            items = split(strip(line))

            if !isempty(items)
                push!(transactions, items)
            end
        end
    end

    transactions
end