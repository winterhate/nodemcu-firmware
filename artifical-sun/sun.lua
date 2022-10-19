#!/opt/homebrew/bin/lua

local pi = 3.1415926536
local half_pi = pi / 2
local two_pi = 2 * pi

local pi_sq = pi*pi
local five_pi_sq = 5 * pi_sq

local precision = 1e-8

function abs(x)
    if (x >= 0) then
        return x
    else
        return -x
    end
end

function round(x, p)
    local i1 = x / p
    local i2 = i1 % 1
    local i3 = i1 - i2
    local i4 = i3 * p
    return i4
end

function sqrt(a)
    function newton_step(x)
        return - (x * x - a) / ( 2 * x)
    end

    local est = a > 1 and a / 2 or a * 2
    repeat
        local diff = newton_step(est)
        est = est + diff
    until abs(diff) < precision
    return round(est, precision)
end

function sin(angle)

    -- https://datagenetics.com/blog/july12019/index.html
    function Bhaskara_I(x)
        local x_times_pi_minus_x = x * (pi - x)
        return (16 * x_times_pi_minus_x) / (five_pi_sq - 4 * x_times_pi_minus_x)
    end

    local angle_in_2_pi = ((angle / two_pi) % 1) * two_pi
    if (angle_in_2_pi <= pi) then
        return Bhaskara_I(angle_in_2_pi)
    else
        return -Bhaskara_I(two_pi - angle_in_2_pi)
    end

end

function cos(angle)
    return sin(half_pi - angle)
end

-- https://dsp.stackexchange.com/a/25771
function arcsin(x)
    local a = { 1.5707288, -0.2121144, 0.0742610, -0.0187293 }
    function horner(a, x)
        local res = a[#a]
        for i = #a - 1, 1, -1 do
            res = res * x + a[i]
        end
        return res
    end
    
    function positive_arcsin(x)
        return half_pi - sqrt(1 - x) * horner(a, x)
    end

    if x < 0 then
        return -positive_arcsin(-x)
    else
        return positive_arcsin(x)
    end
end

-- ---------------------------------------------------------------------

function deg(deg, min, sec)
    return deg + min / 60 + sec / 3600
end

local degToRad = pi / 180
local radToDeg = 180 / pi

function radians(angle)
    return angle * degToRad
end

function degrees(angle)
    return angle * radToDeg
end

-- ---------------------------------------------------------------------

function dateAngle(d, m)
    return radians((0.98 * d + 29.7 * m) % 360 - 109)
end

local eps = radians(deg(23, 26, 0))

function declination(t)
    return eps * sin(t)
end

function solarHeightSin(d, w, t)
    local sinSolarHeight = sin(d) * sin(w) + cos(d) * cos(w) * cos(t)
    return sinSolarHeight
end

function solarIntensity(solarHeightSin)
    if (solarHeightSin < 0) then
        return 0
    else
        return solarHeightSin
    end
end

function dailyIntensity(d, m, h)
    local declination = declination(dateAngle(d, m))
    local solarHeightSin = solarHeightSin(declination, radians(50), radians(h * 15))
    local solarIntensity = solarIntensity(solarHeightSin)
    return solarIntensity
end

function pwmScale(x)
    return round(x * 255, 1)
end

for h = -12, 12, 1/6 do
    print(round(h * 60, 1) .. "," .. pwmScale(dailyIntensity(21, 6, h)) .. "," .. pwmScale(dailyIntensity(21, 12, h)))
end

-- for m=1,12 do
--     for d = 1,30 do
--         local da = dateAngle(d, m)
--         local decl = declination(da)
--         print(m .. " " .. d .. " " .. da .. " " .. decl)
--     end
-- end

-- see also https://stavba.tzb-info.cz/denni-osvetleni-a-osluneni/22433-o-minimalni-vysce-slunce-v-nove-evropske-norme