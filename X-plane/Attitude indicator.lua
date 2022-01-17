-- Variables Bank
local bank_minimo_left = 0.04
local bank_maximo_right = 0.112
local bank_steps_duty = 0.0006
local bank_center = 0.076
local bank_travel = 0.036


--Confirmar conexion puerto 
if hw_connected("RPI_PICO_A_GP0") then
    print("Pin GP0 on Raspi Pico on channel A is connected")
end

-- PWM frequency is set to 1 kHz, with a duty cycle of 50%.
pwm_bank = hw_output_pwm_add("Bank Angle", 50, bank_center)

function bank_xpl (bank)

    if bank <= 0 then

        hw_output_pwm_duty_cycle(pwm_bank, bank_center + (-bank * bank_steps_duty))
        print("Steps < 0: "..(bank * bank_steps_duty))
        print("Final Position < 0: "..bank_center + (bank * bank_steps_duty))
    
    else

        hw_output_pwm_duty_cycle(pwm_bank, bank_maximo_right - bank_travel - (bank * bank_steps_duty))
        print("Steps > 0: "..(bank * bank_steps_duty))
        print("Final Position > 0: "..bank_maximo_right - bank_travel - (bank * bank_steps_duty))

    end




end



xpl_dataref_subscribe("sim/cockpit/gyros/phi_vac_ind_deg", "FLOAT", bank_xpl)