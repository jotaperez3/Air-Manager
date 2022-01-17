--Variables
local sec_per_hour = 3600
local kg_per_gallon = 3.04
local duty_cycle = 0.089
local duty_cycle_5 = 0.084
local duty_minimal = 0.02
local cycle_per_0to5_gallon = 0.001
local cycle_per_5to19_gallon = 0.0045714
local less_five_gallon = 0.004222222222

--Confirmar conexion puerto 9
if hw_connected("ARDUINO_NANO_A_D9") then
    print("Pin D9 on Arduino Nano on channel A is connected")
end

-- Add the servo motor to the script
pwm_fuel_flow = hw_output_pwm_add("Fuel Flow", 50, duty_cycle)


function fuel_flow(fuelflow)

   if fuelflow[1] <= less_five_gallon then
   
        hw_output_pwm_duty_cycle(pwm_fuel_flow, duty_cycle - (fuelflow[1] * sec_per_hour / kg_per_gallon) * ((duty_cycle - duty_cycle_5) / 5))
        print ("Gl/h: "..(fuelflow[1] * sec_per_hour / kg_per_gallon))
        print ("Position x Gallon: "..(duty_cycle - duty_cycle_5) / 5)
        print ("Position x Gl/h: "..(fuelflow[1] * sec_per_hour / kg_per_gallon) * ((duty_cycle - duty_cycle_5) / 5))
        print ("Position Final: "..(duty_cycle - (fuelflow[1] * sec_per_hour / kg_per_gallon) * ((duty_cycle - duty_cycle_5) / 5)))     
   else
    hw_output_pwm_duty_cycle(pwm_fuel_flow, duty_cycle - (fuelflow[1] * sec_per_hour / kg_per_gallon) * ((duty_cycle - duty_minimal) / 14) + duty_minimal)
        print ("Gl/h: "..(fuelflow[1] * sec_per_hour / kg_per_gallon))
        print ("Position x Gallon: "..((duty_cycle - duty_minimal) / 14))
        print ("Position x Gl/h: "..(fuelflow[1] * sec_per_hour / kg_per_gallon) * ((duty_cycle - duty_minimal) / 14))
        print ("Position Final: "..(duty_cycle - (fuelflow[1] * sec_per_hour / kg_per_gallon) * ((duty_cycle - duty_minimal) / 14) + duty_minimal)) 
    end
end

xpl_dataref_subscribe("sim/flightmodel/engine/ENGN_FF_","FLOAT[8]", fuel_flow)