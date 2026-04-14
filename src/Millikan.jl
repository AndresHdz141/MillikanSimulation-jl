module Millikan
export Oil_Particle
export Environment
export runSim
export getInfo
export saveData

using JLD2

Base.@kwdef mutable struct Oil_Particle        #Caracteristicas de la particula
r::Float64                       #m^2
mass::Float64 = 0.0              #kg
pos::Vector{Float64}             #m
vel::Vector{Float64} = [0,0,0]   #m/s
acc::Vector{Float64} = [0,0,0]   #m/s^2
chargeQ::Float64                 #C
volume::Float64 = 0.0            #m^3
end

function getInfo(p::Oil_Particle)
println("----------------------------")
println("Mass:", p.mass, "kg")
println("Volume:", p.volume, "kg/m^3")
println("Charge:", p.chargeQ, "C")
println("Radius:", p.r, "kg \n")
end

# Valores de variables constantes o del entorno
Base.@kwdef struct Environment
g::Vector{Float64} = [0,-9.81,0]                   #m/s^2
eta::Float64 = 1.81e-5              #Pa*s
EField::Vector{Float64} = [0,1e5,0] #C/N
rho_oil::Float64 = 8.86e2           #kg/m^3
rho_air::Float64 = 1.29             #kg/m^3
charge_val::Float64 = 1.6e-19       #C
end

#metodo iterativo de euler
function Euler!(p::Oil_Particle,env::Environment, dt::Float64)
    println("-----------------------------")
    Forces = ForcesCalc(p,env, p.vel)
    p.acc .= Forces / p.mass
    println("Acceleration = ", p.acc)
    p.vel .+= p.acc .* dt
    p.pos .+= p.vel .* dt
end
#Metodo iterativo RK4
function RK4!(p::Oil_Particle,env::Environment, dt::Float64)
#Stage1
    vel1 = p.vel
    acc1 = ForcesCalc(p,env, vel1)/p.mass
#Stage 2
    vel2 = p.vel .+dt .* acc1/2
    acc2 = ForcesCalc(p,env,vel2)/p.mass
#Stage 3
    vel3 = p.vel .+dt .*acc2/2
    acc3 = ForcesCalc(p,env,vel3)/p.mass
#Stage 4
    vel4 = p.vel .+ dt .*acc3
    acc4 = ForcesCalc(p, env, vel4)/p.mass
#Final Values
    p.pos .+= (dt/6) .* (vel1 .+ 2 .* vel2 .+ 2 .* vel3 .+ vel4)
    p.vel .+= (dt / 6) .* (acc1 .+ 2 .* acc2 .+ 2 .* acc3 .+ acc4)
    p.acc .= ForcesCalc(p,env,p.vel) /p.mass

    println("Acceleration: ", p.acc)
    println("Velocity: ", p.vel)
end

#Calculo de fuerzas
#Fuerza de gravedad effectiva
function GForce(p::Oil_Particle, env::Environment)
    return env.g*(p.mass - p.volume * env.rho_air)
end

#Fuerza de arrastre
function DragForce(p::Oil_Particle, env::Environment, velocity::Vector)
    return -6*env.eta*pi*p.r*velocity
end
#Fuerza Electrica
function ElectricForce(p::Oil_Particle, env::Environment)
    return p.chargeQ*env.EField
end
function ForcesCalc(p::Oil_Particle, env::Environment, vel::Vector)
    Fg = GForce(p,env)
    Fd = DragForce(p,env, vel)
    Fe = ElectricForce(p,env)
    F_total = Fg .+ Fd .+ Fe
    return F_total

end
function saveData(traj::Array, p::Oil_Particle, env::Environment, time::Array)

DIRECTORY = joinpath(@__DIR__, "..", "data")
name = "millikan_test_"
i = 1
while isfile(joinpath(DIRECTORY,"$(name)$(i).jld2"))
    i+=1
end
full_name = "$name$i"
full_path = joinpath(DIRECTORY,"$full_name.jld2")
jldsave(full_path;
    tray_data = traj,
    particle_data = p,
    environment_data = env,
    time_steps = time)
println("Data succesfully saved to -> ", full_path)

end


function runSim(p::Oil_Particle,env::Environment, dt::Float64, steps::Int)
    p.volume = (4/3) * p.r^3
    p.mass = p.volume * env.rho_oil
    pos_history = zeros(Float64, 3, steps)
    getInfo(p)
    time_steps = zeros(Float64,steps)
    dt_accum = 0.0
    i = 1
    while i<=steps
        past_vel_y = p.vel[2]
        RK4!(p,env, dt)
        vel_error = (abs(past_vel_y - p.vel[2])/past_vel_y)
        println("Vel_Error> ", vel_error )
        pos_history[:,i] .= p.pos 
        time_steps[i] = dt_accum
        dt_accum += dt
        println(dt_accum, "|", p.pos)
        i +=1

    end

    return pos_history, time_steps

end

end