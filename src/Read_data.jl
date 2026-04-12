module data_READ
include("../src/Millikan.jl")

export get_data
export getInfo
using JLD2
using .Millikan

function get_data(filepath::String, retrieve::String)
    data = jldopen(filepath, "r") do file
    return file[retrieve]
    end
    return data
end

function ReadData()

end

    
function plotter(trayectory::Array, timesteps::Array)
    
end

end