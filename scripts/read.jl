include("../src/Read_data.jl")
using .data_READ

include("../src/Millikan.jl")
using .Millikan



function run_sim()
DIRECTORY = joinpath(@__DIR__, "..", "data")
number = 11
filepath = joinpath(DIRECTORY,"millikan_test_$number.jld2")
tray = get_data(filepath, "tray_data")
particle = get_data(filepath, "particle_data")
env1 = get_data(filepath, "environment_data")
dt_steps = get_data(filepath, "time_steps")
total_steps = size(tray,2)

println("Success! Extracted Y-positions for ", total_steps, " steps.")
Millikan.getInfo(particle)
for (i, step_data) in enumerate(eachcol(tray))
        println(dt_steps[i], " sec | Pos: ", step_data)
    end
end

run_sim()