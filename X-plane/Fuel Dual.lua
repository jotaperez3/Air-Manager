--Variables
local duty_minimal = 0.028
local duty_maxim = 0.072
local travel = duty_maxim - duty_minimal
local escale = 26
local duty_escale = travel / escale


--Confirmar conexion puerto 9 y 10
if hw_connected("ARDUINO_NANO_A_D9") then
    print("Pin D9 on Arduino Nano on channel A is connected")
end

if hw_connected("ARDUINO_NANO_A_D10") then
    print("Pin D10 on Arduino Nano on channel A is connected")
end

-- Add the servo motor to the script
pwm_fuel_left = hw_output_pwm_add("Fuel Left", 50, duty_minimal)
pwm_fuel_right = hw_output_pwm_add("Fuel Right", 50, duty_maxim)

-- Run the servos dial
function fuel_qty_xpl(fuel_qty)

    hw_output_pwm_duty_cycle(pwm_fuel_left, duty_minimal + (duty_escale * (fuel_qty[1] * 2.20462) / 6))
    print ("Gl Left Tank: "..duty_maxim - (duty_escale * (fuel_qty[1] * 2.20462) / 6))
    hw_output_pwm_duty_cycle(pwm_fuel_right, duty_maxim - (duty_escale * (fuel_qty[2] * 2.20462) / 6))
    print ("Gl Right Tank: "..duty_minimal + (duty_escale * (fuel_qty[2] * 2.20462) / 6))
          
end

xpl_dataref_subscribe( "sim/cockpit2/fuel/fuel_quantity","FLOAT[9]", fuel_qty_xpl)