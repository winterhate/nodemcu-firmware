#!/opt/homebrew/bin/lua

local pi = 3.1415926536
local half_pi = pi / 2
local two_pi = 2 * pi
local pi_sq = pi*pi
local five_pi_sq = 5 * pi_sq

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

-- function arcsin(z)
--     local z_sq = z * z
--     local term = z
--     local fact_fract = 1 / 2

--     local res = term
--     local n = 3
--     while n < 200 do
--         term = term * z_sq
--         res = res + term / n
--         fact_fract = fact_fract * (n / n + 1)
--         n = n + 2
--     end
--     return res
-- end

function sqrt(a)
    local x = 1
    x = x - (x * x - a) / ( 2 * x)
    x = x - (x * x - a) / ( 2 * x)
    x = x - (x * x - a) / ( 2 * x)
    x = x - (x * x - a) / ( 2 * x)
    x = x - (x * x - a) / ( 2 * x)
    x = x - (x * x - a) / ( 2 * x)
    x = x - (x * x - a) / ( 2 * x)
    return x
end

function rad(deg)
    return deg * pi / 360
end

function deg(deg, min, sec)
    return deg + min / 60 + sec / 3600
end

function radians(angle)
    return angle * ( pi / 180 )
end

function degrees(angle)
    return angle / ( pi / 180 )
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
        return half_pi - sqrt(1 - x) * horner(a,x)
    end

    if x < 0 then
        return -positive_arcsin(-x)
    else
        return positive_arcsin(x)
    end
end

-- https://m.tzb-info.cz/tabulky-a-vypocty/54-vypocet-osluneni-zastineni-okenni-plochy

local eps = radians(deg(23, 26, 0))
function declination0(n)
    return arcsin(eps * cos((n+10)*360/365))
end

function dateAngle(d, m)
    return 0.98 * d + 29.7 * m
end

function declination(t)
    return 23.45 * sin(radians(t - 109))
end

function solarHeight(d, w, t)
    local sinSolarHeight = sin(d) * sin(w) + cos(d) * cos(w) * cos(t)
    return degrees(arcsin(sinSolarHeight))
end

function solarIntensity(solarHeight)
    if (solarHeight < 0) then
        return 0
    else
        return sin(radians(solarHeight))
    end
end

-- print('--------')

-- local a = 0
-- while a <= 25 do
--     local sqrt = sqrt(a)
--     print(a, sqrt, sqrt * sqrt)
--     a = a + 1
-- end

-- print('--------')

-- local a = -1
-- while a <= 1 do
--     local asin = arcsin(a)
--     local full = sin(asin)
--     print(a, asin, full, 1 - a / full)
--     a = a + 0.1
-- end

print('--------')

-- for x = -1, 1, 0.1 do
--     print(x .. "," .. arcsin(x))
-- end

function dailyIntensity(d, m, h)
    local declination = radians(declination(dateAngle(d, m)))
    local solarHeight = solarHeight(declination, radians(50), radians(h * 15))
    local solarIntensity = solarIntensity(solarHeight)
    return solarIntensity
end

for x = 0.1, 10, 0.1 do
    print(sqrt2(x, 1/10000))
end

-- for m = 6,6 do
--     for d = 21, 21 do
--         local declination = radians(declination(dateAngle(d, m)))
--         for h = -12, 12, 1/6 do
--             local solarHeight = solarHeight(declination, radians(50), radians(h * 15))
--             local solarIntensity = solarIntensity(solarHeight)
--             print(h * 60 .. "," .. solarIntensity)
--         end
--     end
-- end

-- for h = -12, 12, 1/6 do
--     print(h * 60 .. "," .. dailyIntensity(21, 6, h) .. "," .. dailyIntensity(21, 12, h))
-- end

-- function show(a)
--     print(a, cos(a), sin(a))
-- end

-- show(two_pi)
-- show(pi)
-- show(half_pi)
-- show(0)
-- show(-half_pi)
-- show(-pi)
-- show(-two_pi)

-- local phi = rad(50)
