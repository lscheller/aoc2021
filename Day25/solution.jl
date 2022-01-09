function parseInput(filename)
    values = readlines(filename*".txt")
    values = split.(values, "")
    return values
end

function rightNeighbor(i,m)
    if (i+1) % m == 0
        return i+1
    else return (i+1) % m
    end
end

function downNeighbor(i,n)
    if (i+1)%n == 0
        return i+1
    else
        return (i+1) % n
    end
end

function solve(filename)
    grid = parseInput(filename)
    no_changes = Inf
    no_steps = 0
    n = length(grid)
    m = length(grid[1])
    
    while no_changes > 0
        no_steps += 1
        no_changes = 0
        newGrid = Vector()
        for (i,line) in enumerate(grid)
            newLine = Vector{String}()
            for k in 1:m
                newLine = push!(newLine,line[k])
            end
            for (j,char) in enumerate(line)
                if char == ">" && line[rightNeighbor(j,m)] == "."
                    newLine[rightNeighbor(j,m)] = ">"
                    newLine[j] = "."
                    no_changes += 1
                end
            end
            newGrid = push!(newGrid, newLine)
        end
        grid = newGrid
        
        newGrid = Vector()
        for line in grid
            newLine = Vector{String}()
            for char in line
                newLine = push!(newLine, char)
            end
            newGrid = push!(newGrid, newLine)
        end

        for (i,line) in enumerate(grid)
            for (j,char) in enumerate(line)
                if char == "v" && grid[downNeighbor(i,n)][j] == "."
                    newGrid[downNeighbor(i,n)][j] = "v"
                    newGrid[i][j] = "."
                    no_changes += 1
                end
            end
        end
        grid = newGrid
    end  
    println("Stopped after "*string(no_steps)*" steps.")  
end

solve("input")