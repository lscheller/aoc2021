using Statistics

function fuelcost(steps)
    cost = 0
    stepcost = 1
    for i in 1:steps
        cost += stepcost
        stepcost += 1
    end
    return cost
end

function solve(filename, timesteps = 80)
    #load txt file
    values = readlines(filename*".txt")
    values = split(values[1], ',')
    positions = parse.(Int, values)
    goalpos = median(positions)
    avgpos = round(mean(positions))
    cost = 0
    costavg = 0
    costavgsmall = 0
    costavgbig = 0
    for p in positions
        cost += abs(p - goalpos)
        costavg += fuelcost(abs(p - avgpos))
        costavgsmall += fuelcost(abs(p-(avgpos-1)))
        costavgbig += fuelcost(abs(p-(avgpos+1)))
    end
    costavg = min(costavg, costavgsmall, costavgbig)
    println("Median: "*string(goalpos))
    println("Accumulated fuel cost: "*string(cost))
    println("Average: "*string(avgpos))
    println("Avg fuel cost accumulated: "*string(costavg))
end

solve("smalltest")
solve("input")