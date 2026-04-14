module Data_Process

export data_process
export plotter
using JLD2
using Plots

include("../src/Millikan.jl")
using .Millikan

    DIRECTORY = joinpath(@__DIR__, "..", "data")

function data_process(ite::Integer)

(tray,particle,env1,dt_steps) = Read_data(ite)

end

function plotter(charges)
    y = 1:size(charges,1)
    name = "millikan_sim_result.png"
    
    plt = scatter(charges, y, 
                title = "Cargas de particulas", 
                marker_z = charges, 
                color = :viridis, 
                ylabel = "Carga Experimental", 
                xlabel = "Carga Asignada (n)",
                colorbar = true)

    filepath = joinpath(DIRECTORY,"images", name)
    savefig(plt, filepath)
end


function get_data(filepath::String, retrieve::String)
    data = jldopen(filepath, "r") do file
    return file[retrieve]
    end
    return data
end

function ReadData(num::Int)
    number = num
    filepath = joinpath(DIRECTORY,"millikan_test_$number.jld2")
    tray = get_data(filepath, "tray_data")
    particle = get_data(filepath, "particle_data")
    env1 = get_data(filepath, "environment_data")
    dt_steps = get_data(filepath, "time_steps")
    total_steps = size(tray,2)
    println("Success! Extracted Y-positions for ", total_steps, " steps.")
    Millikan.getInfo(particle)
    #=for (i, step_data) in enumerate(eachcol(tray))
            println(dt_steps[i], " sec | Pos: ", step_data)
    end=#
    return tray, particle, env1, dt_steps

end


end