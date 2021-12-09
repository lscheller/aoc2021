function checkCorner(arr, corneridx)
    #1 = up left, 2 = up right, three = down left, four = bottom right
    islowpoint = false
    maxrow = size(arr, 1)
    maxcol = size(arr[1], 1)
    if corneridx == 1
        val = arr[1][1]
        if val < arr[1][2] && val < arr[2][1]
            islowpoint = true
        end
    elseif corneridx == 2
        val = arr[1][maxcol]
        if val < arr[1][maxcol-1] && val < arr[2][maxcol]
            islowpoint = true
        end
    elseif corneridx == 3
        val = arr[maxrow][1]
        if val < arr[maxrow-1][1] && val < arr[maxrow][2]
            islowpoint = true
        end
    elseif corneridx == 4
        val = arr[maxrow][maxcol]
        if val < arr[maxrow-1][maxcol] && val < arr[maxrow][maxcol-1]
            islowpoint = true
        end
    end
    return islowpoint
end

function checkOnBoundary(arr, i, j)
     #1 = top row, 2 = left col, three = right col, four = bottom row
     islowpoint = false
     maxrow = size(arr, 1)
     maxcol = size(arr[1], 1)
     if (i,j) == (1,1)
        islowpoint = checkCorner(arr, 1)
     elseif (i,j) == (1, maxcol)
        islowpoint = checkCorner(arr, 2)
     elseif (i,j) == (maxrow, 1)
        islowpoint = checkCorner(arr, 3)
     elseif (i,j) == (maxrow, maxcol)
        islowpoint = checkCorner(arr, 4)
     elseif i == 1
        val = arr[i][j]
        if val < arr[i][j-1] && val < arr[i][j+1] && val < arr[i+1][j]
            islowpoint = true
        end
    elseif j == 1
        val = arr[i][j]
        if val < arr[i-1][j] && val < arr[i+1][j] && val < arr[i][j+1]
            islowpoint = true
        end
    elseif j == maxcol
        val = arr[i][j]
        if val < arr[i-1][maxcol] && val < arr[i+1][maxcol] && val < arr[i][maxcol - 1]
            islowpoint = true
        end
    elseif i == maxrow
        val = arr[i][j]
        if val < arr[maxrow][j-1] && val < arr[maxrow][j+1] && val < arr[maxrow-1][j]
            islowpoint = true
        end
    end
    return islowpoint
end

function checkPoint(arr, i, j)
    islowpoint = false
    maxrow = size(arr, 1)
    maxcol = size(arr[1], 1)
    if i == 1 || i == maxrow || j == 1 || j == maxcol
        islowpoint = checkOnBoundary(arr, i, j)
    else
        val = arr[i][j]
        if val < arr[i][j-1] && val < arr[i][j+1] && val < arr[i-1][j] && val < arr[i+1][j]
            islowpoint = true
        end
    end
    return islowpoint
end

function solve(filename)
    values = readlines(filename*".txt")
    values = split.(values, "")
    intvalues = Vector{Int}[]
    for line in values
        convline = parse.(Int, line)
        intvalues = push!(intvalues, convline)
    end
    #println(intvalues)
    res = 0
    for (i, line) in enumerate(intvalues)
        for (j, el) in enumerate(line)
            if checkPoint(intvalues, i, j)
                res += 1 + el
            end
        end
    end
    return res
end

println("Sum of lowpoints: "*string(solve("smalltest")))
println("Sum of lowpoints: "*string(solve("input")))

function getNeighbors(arr, (i, j))
    maxrow = size(arr, 1)
    maxcol = size(arr[1], 1)
    neighboridxs = Tuple[]
    if i == 1 || i == maxrow || j == 1 || j == maxcol
        if (i,j) == (1,1)
            neighboridxs = push!(neighboridxs, (1,2))
            neighboridxs = push!(neighboridxs, (2,1))
        elseif (i,j) == (1, maxcol)
            neighboridxs = push!(neighboridxs, (1,maxcol-1))
            neighboridxs = push!(neighboridxs, (2,maxcol))
        elseif (i,j) == (maxrow, 1)
            neighboridxs = push!(neighboridxs, (maxrow-1,1))
            neighboridxs = push!(neighboridxs, (maxrow,2))
        elseif (i,j) == (maxrow, maxcol)
            neighboridxs = push!(neighboridxs, (maxrow-1,maxcol))
            neighboridxs = push!(neighboridxs, (maxrow,maxcol))
        elseif i == 1
            neighboridxs = push!(neighboridxs, (i, j-1))
            neighboridxs = push!(neighboridxs, (i, j+1))
            neighboridxs = push!(neighboridxs, (i+1, j))
        elseif j == 1
            neighboridxs = push!(neighboridxs, (i-1, j))
            neighboridxs = push!(neighboridxs, (i, j+1))
            neighboridxs = push!(neighboridxs, (i+1, j))
        elseif j == maxcol
            neighboridxs = push!(neighboridxs, (i-1, maxcol))
            neighboridxs = push!(neighboridxs, (i+1, maxcol))
            neighboridxs = push!(neighboridxs, (i, maxcol - 1))
        elseif i == maxrow
            neighboridxs = push!(neighboridxs, (maxrow, j-1))
            neighboridxs = push!(neighboridxs, (maxrow, j+1))
            neighboridxs = push!(neighboridxs, (maxrow-1, j))
        end
    else
        neighboridxs = push!(neighboridxs, (i, j-1))
        neighboridxs = push!(neighboridxs, (i, j+1))
        neighboridxs = push!(neighboridxs, (i+1, j))
        neighboridxs = push!(neighboridxs, (i-1, j))
    end
    return neighboridxs
end

function getBasin(arr, lowpointcoords)
    neighbors = getNeighbors(arr, lowpointcoords)
    basinidxs = []
    for idx in neighbors
        if arr[idx[1]][idx[2]] != 9
            basinidxs = push!(basinidxs, idx)
        end
    end
    for idx in basinidxs
        i = idx[1]
        j = idx[2]
        candidates = getNeighbors(arr, idx)
        for c in candidates
            ci = c[1]
            cj = c[2]
            if arr[i][j] < arr[ci][cj] && arr[ci][cj] != 9
                basinidxs = push!(basinidxs, c)
            end
        end
    end
    basinidxs = push!(basinidxs, lowpointcoords)
    return unique!(basinidxs)
end

function solve2(filename)
    values = readlines(filename*".txt")
    values = split.(values, "")
    intvalues = Vector{Int}[]
    for line in values
        convline = parse.(Int, line)
        intvalues = push!(intvalues, convline)
    end
    lowpointidx = Tuple[]
    for (i, line) in enumerate(intvalues)
        for (j, el) in enumerate(line)
            if checkPoint(intvalues, i, j)
                lowpointidx = push!(lowpointidx, (i, j))
            end
        end
    end
    basins = []
    basinlengths = []
    for point in lowpointidx
        basin = getBasin(intvalues, point)
        blength = length(basin)
        basins = push!(basins, basin)
        basinlengths = push!(basinlengths, blength)
    end
    sortedlengths = sort(basinlengths, rev=true)
    res = sortedlengths[1] * sortedlengths[2] * sortedlengths[3]
    return res
end

println("Product of basin lengths: "*string(solve2("smalltest")))
println("Product of basin lengths "*string(solve2("input")))