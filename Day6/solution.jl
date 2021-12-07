function timestep(fishes)
    no_of_fish_to_add = 0
    for (i, fish) in enumerate(fishes)
        if fish == 0
            no_of_fish_to_add += 1
            fishes[i] = 6
        else
            fishes[i] = fish - 1
        end
    end
    for i in 1:no_of_fish_to_add
        fishes = push!(fishes, 8)
    end
    #println(fishes)
    return fishes
end

function timestep2(fishes)
    toadd = zeros(Int, 9)
    for i in 1:9
        if i == 1
            toadd[9] = fishes[i]
            toadd[7] = fishes[i]
        else
            toadd[i-1] += fishes[i]
        end
    end
    return toadd  
end

function solve(filename, timesteps = 80)
    #load txt file
    values = readlines(filename*".txt")
    values = split(values[1], ',')
    fishes = parse.(Int, values)
    #println(fishes)
    for i in 1:timesteps
        #print("Day "*string(i))
        fishes = timestep(fishes)
    end
    println("Number of list elements after "*string(timesteps)*" days: "*string(length(fishes)))
end

function solve2(filename, timesteps = 80)
    #load txt file
    values = readlines(filename*".txt")
    values = split(values[1], ',')
    values = parse.(Int, values)
    fishes = zeros(Int, 9)
    for v in values
        fishes[v+1] += 1
    end
    for i in 1:timesteps
        fishes = timestep2(fishes)
    end
    res = 0
    for v in fishes
        res += v
    end
    println("Number of list elements after "*string(timesteps)*" days: "*string(res))
end

solve("smalltest")
solve("input")
solve2("smalltest", 256)
solve2("input", 256)