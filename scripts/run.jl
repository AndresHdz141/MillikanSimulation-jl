
include("../src/Millikan.jl")

using .Millikan
using Random
using Revise
using Distributions

function run_test()
#initial position
ini_pos = [0.0,1e-5,0.0]

#charge generator
charge::Float64 = 1.6e-19 * rand(1:5)
#Radius distribution
rad_dis = Normal(1,0.3)
radius_rand = rand(rad_dis)*10^-6

Oil_drop = Oil_Particle(r = radius_rand, chargeQ = charge, pos = ini_pos)
Env = Environment()
(trayectory, time_st)= runSim(Oil_drop,Env, 1e-6, 100)

saveData(trayectory, Oil_drop, Env, time_st)

end

run_test()
