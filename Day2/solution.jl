function main(filename)
    println("using file: "*filename*".txt")
    #load txt file
    values = readlines(filename*".txt")
    #split values into command array and value array
    values = split.(values," ")
    commands = []
    steps = []
    for (i, arr) in enumerate(values)
        push!(commands, String(arr[1]))
        push!(steps, String(arr[2]))
    end
    #apply directions
    depth = 0
    horizontal = 0
    for (i, _) in enumerate(commands)
        val = parse(Int, steps[i])
        if commands[i] == "up"
            depth -= val
        elseif commands[i] == "down"
            depth += val
        elseif commands[i] == "forward"
            horizontal += val
        end
    end
    println("Depth: "*string(depth))
    println("Horizontal position: "*string(horizontal))
    println("Product: "*string(depth*horizontal))
end

function part2(filename)
    println("part 2")
    println("using file: "*filename*".txt")
    #load txt file
    values = readlines(filename*".txt")
    #split values into command array and value array
    values = split.(values," ")
    commands = []
    steps = []
    for (i, arr) in enumerate(values)
        push!(commands, String(arr[1]))
        push!(steps, String(arr[2]))
    end
    #apply directions
    depth = 0
    horizontal = 0
    aim = 0
    for (i, _) in enumerate(commands)
        val = parse(Int, steps[i])
        if commands[i] == "up"
            aim -= val
        elseif commands[i] == "down"
            aim += val
        elseif commands[i] == "forward"
            horizontal += val
            depth += aim * val
        end
    end
    println("Depth: "*string(depth))
    println("Horizontal position: "*string(horizontal))
    println("Product: "*string(depth*horizontal))
end

main("smalltest")
main("input")

part2("smalltest")
part2("input")