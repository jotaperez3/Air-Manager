--Variables
local turnrate_minimo = 0.025
local turnrate_maximo = 0.083
local turnrate_center = 0.054
local turnrate_steps = 0.0007

local slip_minimo = 0.028
local slip_maximo = 0.048
local slip_center = 0.037
local slip_steps_positive = 0.001000
local slip_steps_negative = 0.001222


--Confirmar conexion puerto 10
if hw_connected("RPI_PICO_A_GP0") then
    print("Pin GP0 on Raspi Pico on channel A is connected")
end

if hw_connected("RPI_PICO_A_GP5") then
    print("Pin GP5 on Raspi Pico on channel A is connected")
end

-- Create new PWM pin
-- PWM frequency is set to 1 kHz, with a duty cycle of 50%.
pwm_turn_rate = hw_output_pwm_add("Turn Rate", 50, turnrate_center)
pwm_ball_slip = hw_output_pwm_add("Ball Slip", 50, slip_center)


-- Servo Turn Rate
function turn_rate(turnrate)

    if turnrate <= 0 then

        hw_output_pwm_duty_cycle(pwm_turn_rate,  turnrate_center + (turnrate_steps * - turnrate))
        print("Turn escale < 0: "..turnrate_steps * - turnrate)
        print("Turn final < 0: "..turnrate_center + (turnrate_steps * - turnrate))
    
    else 

        hw_output_pwm_duty_cycle(pwm_turn_rate, turnrate_center - (turnrate * turnrate_steps))
        print("Turn escale > 0: "..turnrate * turnrate_steps)
        print("Turn final > 0: "..(turnrate * turnrate_steps) - turnrate_center)
     end
end

-- Servo Slip Ball
function ball_slip(slip)

    if slip >=0 then

        hw_output_pwm_duty_cycle(pwm_ball_slip, slip_center + (slip_steps_positive * -slip)) 
        print("Slip scale > 0: "..(slip_steps_positive * -slip))
        print("Slip Final > 0: "..slip_center + (slip_steps_positive * -slip))
    
    else
        hw_output_pwm_duty_cycle(pwm_ball_slip, slip_center - (slip * slip_steps_negative))
        print("Slip scale > 0: ".. (slip * slip_steps_negative))
        print("Slip final > 0: "..slip_center - (slip * slip_steps_negative))

    end
end

xpl_dataref_subscribe("sim/flightmodel/misc/turnrate_roll", "FLOAT", turn_rate)
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/slip_deg", "FLOAT", ball_slip)
