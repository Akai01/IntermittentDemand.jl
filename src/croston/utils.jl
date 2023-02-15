using Statistics
import Statistics; mean

function evaluation_metrics(actual, pred)
    error = actual .- pred
    mse = mean(error.^2)
    mae = mean(abs.(error))
    n = length(actual)
    temp = cumsum(actual) ./ (1:n)
    n = ceil(Int, 0.3*n)
    temp[1:n] .= temp[n]
    error2 = pred .- temp
    mar = sum(abs.(error2))
    msr = sum(error2.^2)
    out = Dict("mse" => mse, "mae" => mae, "mar" => mar, "msr" => msr)
    return(out)
end

function croston_methods(x::Vector{String})
    if all(elem in ["croston","sba","sbj"] for elem in x)
        return(x[1])
    else
        throw(ArgumentError("Invalid Method type"))
    end 
end

function croston_methods(x::String)
    if x in ["croston","sba","sbj"]
        return(x)
    else
        throw(ArgumentError("Invalid Method type"))
    end 
end

function initial_values(x::String)
    if x in ["naive","mean"]
        return(x)
    else
        throw(ArgumentError("Invalid initial Value"))
    end 
end

function initial_values(x::Vector{String})
    if all(elem in ["naive","mean"] for elem in x)
        return(x[1])
    else
        throw(ArgumentError("Invalid initial Value"))
    end 
end

function initial_values(x::Union{Vector{Int}, Vector{Float16}, Vector{Float32}, Vector{Float64}})
    if length(x)>=2
        out = return(x[1:2])
    else
        out = "mean"
    end
    return(out)
end

function initial_values(x::Int)
    out = "mean"
    return(out)
end

function cost_functions(x::String)
    if x in ["mar","msr","mae","mse"]
        return(x)
    else
        throw(ArgumentError("Invalid Cost function"))
    end 
end
