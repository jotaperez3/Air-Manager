--Variables
local duty_cycle = 0.095
local duty_minimal = 0.03
local duty_escale = 0.003823529

--Confirmar conexion puerto 10
if hw_connected("ARDUINO_NANO_A_D10") then
    print("Pin D10 on Arduino Nano on channel A is connected")
end

-- Add the servo motor to the script
pwm_egt = hw_output_pwm_add("EGT", 50, duty_minimal)


function egt_xpl(egt)
   
        hw_output_pwm_duty_cycle(pwm_egt, ((((egt[1] * 9/5)+32) / 17) * duty_escale) + duty_minimal)
        print ("EGT Centigrades: "..egt[1])
        print ("EGT Fahrenheit: "..((egt[1] * 9/5)+32))
        print ("Duty EGT: "..(((egt[1] * 9/5)+32) / 17))
        print ("Duty Final: "..((((egt[1] * 9/5)+32) / 17) * duty_escale) + duty_minimal)
end

xpl_dataref_subscribe("sim/cockpit2/engine/indicators/EGT_deg_C","FLOAT[8]", egt_xpl)