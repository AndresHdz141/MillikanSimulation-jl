module data_READ
include("../src/Millikan.jl")

export get_data
export getInfo
export plotter
using JLD2
using .Millikan
using Plots

function get_data(filepath::String, retrieve::String)
    data = jldopen(filepath, "r") do file
    return file[retrieve]
    end
    return data
end

function ReadData()

end

    
function plotter(trayectory::Array, timesteps::Array)
    t = 1:size(timesteps[2])
    y = trayectory
    plot(t, y)



end

end