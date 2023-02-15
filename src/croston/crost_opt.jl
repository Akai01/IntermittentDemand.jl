import Optim: optimize, NelderMead, Brent, Options

function crost_opt(data::Vector, method::String = "croston", 
    cost::String = "mar", w = missing, nop::Int = 2, init = "mean", 
    init_opt::Bool = true)

    method = croston_methods(method)
    init = initial_values(init)
    cost = cost_functions(cost)

    nzd = findall(x -> x != 0, data)
    k = length(nzd)
    x = [nzd[1], nzd[2:k] .- nzd[1:(k-1)]...]
    
    if ismissing(w) & !(init_opt)
        p0 = fill(0.05, nop)
        lbound = fill(0, nop)
        ubound = fill(1, nop)
        if nop != 1
            wopt = optimize((x -> crost_cost(x, data, cost, method, w,
             nop, ismissing(w), init, init_opt, lbound, ubound)), p0, 
             NelderMead(), Options(iterations = 2000))
            wopt = wopt.minimizer
        else
            # Use Brent
            wopt = optimize((x -> crost_cost(x, data, cost, method, w, nop, 
            ismissing(w), init, init_opt, lbound, ubound)), 
            lbound[1], ubound[1], Brent())

            wopt = wopt.minimizer
        end
        
        wopt = [wopt..., init...]
    elseif ismissing(w) & init_opt
        # Optimise w and init
        p0 = [fill(0.05, nop)..., init[1], init[2]]
        lbound = [fill(0, nop)..., 0, 1]
        ubound = [fill(1, nop)..., maximum(data), minimum(x)]
        
        wopt = optimize((x -> crost_cost(x, data, cost, method, w, 
        nop, ismissing(w), init, init_opt, lbound, ubound)), p0, 
        NelderMead(), Options(iterations = 2000))

        wopt = wopt.minimizer
    elseif !ismissing(w) & init_opt
        # Optimise only init
        nop = length(w)
        p0 = [init[1], init[2]]
        lbound = [0,1]
        ubound = [maximum(data), maximum(x)]
        wopt = optimize((x -> crost_cost(x, data, cost, method, w, nop, 
        ismissing(w), init, init_opt, lbound, ubound)), p0, NelderMead(),
        Options(iterations = 2000))

        wopt = wopt.minimizer
        wopt = [wopt..., init...]
    end
    
    out = Dict("w" => wopt[1:nop], "init" => wopt[(nop+1):(nop+2)])
    return(out)
end