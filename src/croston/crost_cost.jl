function crost_cost(p0, data, cost, method, w, nop, w_opt, init, init_opt, lbound, ubound)
    
    if w_opt & init_opt
        frc_in = crost_not_optimized(data = data, w = [p0[1:nop]...], h = 0, init = p0[(nop+1):(nop+2)], method = method)
        
        frc_in = frc_in["frc_in"]

    elseif w_opt & !(init_opt)

        frc_in = crost_not_optimized(data = data, w = [p0...], h = 0, init = init, method = method)

        frc_in = frc_in["frc_in"]

    elseif w_opt == false & init_opt == true

        frc_in = crost_not_optimized(data = data, w = [w...], h = 0, init = p0, type = type)
        
        frc_in = frc_in["frc_in"]

    end
    err = evaluation_metrics(data, frc_in)
    
    err = err[cost]

    for i in 1:(nop.* w_opt .+ 2 .* init_opt)
        if ((p0[i] < lbound[i]) | (p0[i] > ubound[i]))
            err = 9*10^99
        end 
    end

    return(err)
end