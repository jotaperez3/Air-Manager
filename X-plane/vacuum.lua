--Variables
local duty_minima = 0.05
local duty_maxima = 0.11
local travel = duty_maxima - duty_minima
local duty_escale = travel / 4


--Confirmar conexion puerto 10
if hw_connected("RPI_PICO_A_GP0") then
    print("Pin GP0 on Raspi Pico on channel A is connected")
end

-- Add the servo motor to the script
pwm_vac = hw_output_pwm_add("Vacuum", 50, duty_minima)


function vac_xpl(vac)

    if vac <= 3 then
        hw_output_pwm_duty_cycle(pwm_vac, duty_minima)
    else 
        hw_output_pwm_duty_cycle(pwm_vac, duty_escale * (vac - 3) + duty_minima)
    end

end

xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/suction_1_ratio","FLOAT", vac_xpl)