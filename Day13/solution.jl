function createMap(filename)
    values = readlines(filename*".txt")
    coords = Tuple[]
    instructions = String[]
    maxX = maxY = 1
    for line in values
        if !isempty(line) && line[1] == 'f'
            inst = split(line, " ")
            instructions = push!(instructions, inst[3])
        elseif !isempty(line)
            st = split(line, ",")
            x = parse(Int, st[1])
            y = parse(Int, st[2])
            juliacoords = (y+1, x+1)
            if juliacoords[1] > maxX
                maxX = juliacoords[1]
            end
            if juliacoords[2] > maxY
                maxY = juliacoords[2]
            end
            coords = push!(coords, juliacoords)
        end
    end
    grid = zeros(Int, maxX, maxY)
    for c in coords
        grid[c[1], c[2]] = 1
    end
    return grid, instructions
end

function foldH(loc, grid)
    cols = size(grid)[2]
    rows = loc - 1
    res = zeros(Int, rows, cols)
    top = grid[1:loc-1, :]
    low = grid[loc+1:size(grid)[1], :]
    for i in 1:rows
        for j in 1:cols
            if top[i, j] == 1 || low[rows+1-i, j] == 1
                res[i,j] = 1
            end
        end
    end
    return res
end

function foldV(loc, grid)
    cols = loc - 1
    rows = size(grid)[1]
    res = zeros(Int, rows, cols)
    left = grid[:, 1:loc-1]
    right = grid[:, loc+1:size(grid)[2]]
    for i in 1:rows
        for j in 1:cols
            if left[i,j] == 1 || right[i, cols+1-j] == 1
                res[i,j] = 1
            end
        end
    end
    return res
end

function solve(filename)
    grid, inst = createMap(filename)
    #println(grid)
    inst1 = inst[1]
    if inst1[1] == 'x'
        loc = parse(Int, inst1[3:length(inst1)]) + 1
        grid = foldV(loc, grid)
    else
        loc = parse(Int, inst1[3:length(inst1)]) + 1
        grid = foldH(loc, grid)
    end
    ndots = count(x -> x == 1, grid)
    println("number of dots: "*string(ndots))
end

function visualize(grid)
    for i in 1:size(grid)[1]
        line = ""
        for j in 1:size(grid)[2]
            if grid[i,j] == 1
                line = line * "⬜"
            else
                line = line * "⬛"
            end
        end
        println(line)
    end
end

function solve2(filename)
    grid, inst = createMap(filename)
    for ins in inst
        if ins[1] == 'x'
            println(ins)
            loc = parse(Int, ins[3:length(ins)]) + 1
            grid = foldV(loc, grid)
        else
            println(ins)
            loc = parse(Int, ins[3:length(ins)]) + 1
            grid = foldH(loc, grid)
        end
    end
    visualize(grid)
end
#solve("example")
solve("input")

solve2("input")