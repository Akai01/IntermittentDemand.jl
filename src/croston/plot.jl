import Plots: none, plot, scatter!, plot!
function plot(object::CrostonForecast)
    n = length(object.data)
    h = length(object.frc_out)
    
    plot!(1:n, object.data, linetype=:path, xlim=(1, n+h), xlabel="Period", 
    ylabel="", ylim=(0, maximum(object.data)*1.1), label = :none, 
    title = "Forecast from "*object.model*" method")
    scatter!(findall(object.data .> 0), object.data[object.data .> 0], markershape=:circle, label = :none)
    plot!(1:n, object.frc_in, color=:red, label = :none)
    plot!((n+1):(n+h), object.frc_out, color=:red, linewidth=2, label = :none)
end