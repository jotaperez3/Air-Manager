--Variables
local duty_maxim = 0.03
local duty_minimal = 0.08
local duty_escale = 0.05
local duty_half = 0.025
local duty_per_amps = 0.000416667

--Confirmar conexion puerto 10
if hw_connected("ARDUINO_NANO_A_D10") then
    print("Pin D10 on Arduino Nano on channel A is connected")
end

-- Add the servo motor to the script
pwm_amps = hw_output_pwm_add("amps", 50, duty_minimal)


function amps_xpl(amps)

    if amps[1] >= 0 then
        hw_output_pwm_duty_cycle(pwm_amps, (duty_half + duty_maxim) - (amps[1] * duty_per_amps))
        print("Amperes: "..amps[1])
        print("Amps + Duty Per Amps: "..(amps[1] * duty_per_amps))
        print("Half + Minimal: "..(duty_half + duty_maxim))
        print("Final Position: "..(duty_half + duty_maxim) - (amps[1] * duty_per_amps))
    else 
        hw_output_pwm_duty_cycle(pwm_amps, (-amps[1] * duty_per_amps) + (duty_maxim + duty_half))
        print("Amperes: "..amps[1])
        print("Amps + Duty Per Amps: "..(-amps[1] * duty_per_amps))
        print("Half + Minimal: "..(duty_maxim + duty_half))
        print("Final Position: "..(-amps[1] * duty_per_amps) + (duty_maxim + duty_half))
    end        
end

xpl_dataref_subscribe("sim/cockpit2/electrical/battery_amps","FLOAT[8]", amps_xpl)