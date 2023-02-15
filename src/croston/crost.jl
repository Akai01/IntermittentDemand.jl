using Statistics
using DataFrames

struct CrostonForecast
    data
    model
    frc_in
    frc_out
    weights
    initial
    components
end

function crost_optimized(;data::Vector, h::Int = 10, init = "mean", 
    nop::Int = 2, method::String = "croston", cost::String = "mar", 
    init_opt::Bool = true, na_rm::Bool = false)

    method = croston_methods(method)
    init = initial_values(init)
    cost = cost_functions(cost)
    
    if !(nop in [1, 2])
        @warn "nop can be either 1 or 2. Overriden to 2."
        nop = 2
    end

    if na_rm
        data = filter(!ismissing, data)
    end
    
    @assert sum(data .!= 0) >= 2 "I need at least two non-zero values to model your time series."
    nzd = findall(x -> x != 0, data)
    z = data[nzd]
    k = length(nzd)
    x = [nzd[1], nzd[2:k] .- nzd[1:(k-1)]...]

    if !(isa(init, Array))
        if init=="mean"
            init = [z[1], Statistics.mean(x)]
        elseif init == "naive"
            init = [z[1], x[1]]
        end
    end
    
    wopt = crost_opt(data, method, cost, missing, nop, init, init_opt)
    w = wopt["w"]
    init = wopt["init"]
    
    if na_rm 
        na_rm = false
    end

    out = crost_not_optimized(data = data, h = h, w = w, 
    init = init, method = method, na_rm = na_rm)
    return(out)
end

function crost_not_optimized(;data::Vector, h::Int = 10,
    w::Vector, init = "mean", method::String = "croston", na_rm::Bool = false)

    method = croston_methods(method)
    init = initial_values(init)

    if na_rm
        data = filter(!ismissing, data)
    end
    n = length(data)
    
    @assert sum(data .!= 0) >= 2 "I need at least two non-zero values to model your time series."
    nzd = findall(x -> x != 0, data)
    k = length(nzd)
    z = data[nzd]
    x = [nzd[1], nzd[2:k] .- nzd[1:(k-1)]...]

    if !(isa(init, Array))
        if init=="mean"
            init = [z[1], Statistics.mean(x)]
        elseif init == "naive"
            init = [z[1], x[1]]
        end
    end

    w = convert(Array{Float64,1}, w)
    init = convert(Array{Float64,1}, init)

    zfit = zeros(k)
    xfit = zeros(k)
    
    zfit[1] = init[1]
    xfit[1] = init[2]

    if length(w) == 1
        a_demand = w
        a_interval = w
    else
        a_demand = w[1]
        a_interval = w[2]
    end

    if method == "sba"
        coeff = 1-(a_interval/2)
        elseif method == "sbj"
            coeff = (1-a_interval/(2-a_interval)) 
        else
            coeff = 1
    end

    for i in 2:k
        zfit[i] = [zfit[i-1] .+ a_demand * (z[i] - zfit[i-1])...][1]
        xfit[i] = [xfit[i-1] .+ a_interval * (x[i] - xfit[i-1])...][1]
    end
    
    cc = coeff .* zfit ./ xfit
    frc_in = zeros(n)
    x_in = zeros(n)
    z_in = zeros(n)
    tv = [nzd .+ 1..., n]

    for i in 1:k
        if tv[i] <= n
            frc_in[tv[i]:Statistics.min(tv[i+1],n)] .= cc[i]
            x_in[tv[i]:Statistics.min(tv[i+1],n)] .= xfit[i]
            z_in[tv[i]:Statistics.min(tv[i+1],n)] .= zfit[i]
        end
    end

    if h > 0
        frc_out = fill(cc[k],h)
        x_out = fill(xfit[k],h)
        z_out = fill(zfit[k],h)
    else
        frc_out = missing
        x_out = missing
        z_out = missing
    end

    if length(w) == 1
        w = [w, w]
    end
    c_in = DataFrame(hcat(z_in, x_in), ["Demand", "Interval"])

    if h > 0
        c_out = DataFrame(hcat(z_out, x_out), ["Demand", "Interval"])
    else
        c_out = NaN
    end 
    
    comp = Dict("c_in" => c_in, "c_out" => c_out, "coeff" => coeff)
    initial = [zfit[1], xfit[1]]

    out = Dict("data"=>data, "method" => method, 
    "frc_in" => frc_in, "frc_out" => frc_out, 
    "weights" => w, "initial" => initial, 
    "components" => comp)

    return(out)
end


function crost(;data::Vector, h::Int = 10, 
    w::Union{Missing, Number, Vector{}} = missing, 
    init = "mean", nop::Int = 2, method::String = "croston", 
    cost::String = "mar", init_opt::Bool = true, na_rm::Bool = false)

    method = croston_methods(method)
    init = initial_values(init)
    cost = cost_functions(cost)
    if ismissing(w) | init_opt
        out = crost_optimized(
            data = data,
            h = h,
            init = init,
            nop = nop,
            method = method,
            cost = cost,
            na_rm = na_rm,
            init_opt = init_opt
          )
    else
        out = crost_not_optimized(
      data = data,
      h = h,
      w = w,
      init = init,
      method = method,
      na_rm = na_rm
    )
    end
    out = CrostonForecast(out["data"], out["method"], out["frc_in"], 
    out["frc_out"], out["weights"], out["initial"], out["components"])

    return(out)
end