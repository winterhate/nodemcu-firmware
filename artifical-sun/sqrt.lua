#!/opt/homebrew/bin/lua

local itercnt = 0

function abs(x)
    if (x >= 0) then
        return x
    else
        return -x
    end
end

function sqrt(a)
    function newton_step(x)
        return - (x * x - a) / ( 2 * x)
    end

    local est = a > 1 and a / 2 or a * 2
    repeat
        local diff = newton_step(est)
        est = est + diff
        itercnt = itercnt + 1
    until abs(diff) < 0.00000001
    return est
end

for i = 1, 1000 do
    sqrt(0.01)
    sqrt(0.1)
    sqrt(0.5)
    sqrt(1)
    sqrt(2)
    sqrt(4)
    sqrt(10)
    sqrt(100)
    sqrt(1000)
    sqrt(100000000000)
end

print("Total iterations: " .. itercnt)