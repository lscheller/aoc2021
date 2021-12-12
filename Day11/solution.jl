function getNeighbors(arr, idx)
    i = idx[1]
    j = idx[2]
    maxrow = size(arr)[1]
    maxcol = size(arr)[2]
    neighboridxs = Tuple[]
    if i == 1 || i == maxrow || j == 1 || j == maxcol
        if (i,j) == (1,1)
            neighboridxs = push!(neighboridxs, (1,2))
            neighboridxs = push!(neighboridxs, (2,1))
            neighboridxs = push!(neighboridxs, (2,2))
        elseif (i,j) == (1, maxcol)
            neighboridxs = push!(neighboridxs, (1,maxcol-1))
            neighboridxs = push!(neighboridxs, (2,maxcol))
            neighboridxs = push!(neighboridxs, (2,maxcol-1))
        elseif (i,j) == (maxrow, 1)
            neighboridxs = push!(neighboridxs, (maxrow-1,1))
            neighboridxs = push!(neighboridxs, (maxrow,2))
            neighboridxs = push!(neighboridxs, (maxrow-1,2))
        elseif (i,j) == (maxrow, maxcol)
            neighboridxs = push!(neighboridxs, (maxrow-1,maxcol))
            neighboridxs = push!(neighboridxs, (maxrow,maxcol-1))
            neighboridxs = push!(neighboridxs, (maxrow-1, maxcol-1))
        elseif i == 1
            neighboridxs = push!(neighboridxs, (i, j-1))
            neighboridxs = push!(neighboridxs, (i, j+1))
            neighboridxs = push!(neighboridxs, (i+1, j))
            neighboridxs = push!(neighboridxs, (i+1, j-1))
            neighboridxs = push!(neighboridxs, (i+1, j+1))
        elseif j == 1
            neighboridxs = push!(neighboridxs, (i-1, j))
            neighboridxs = push!(neighboridxs, (i, j+1))
            neighboridxs = push!(neighboridxs, (i+1, j))
            neighboridxs = push!(neighboridxs, (i-1, j+1))
            neighboridxs = push!(neighboridxs, (i+1, j+1))
        elseif j == maxcol
            neighboridxs = push!(neighboridxs, (i-1, maxcol))
            neighboridxs = push!(neighboridxs, (i+1, maxcol))
            neighboridxs = push!(neighboridxs, (i, maxcol - 1))
            neighboridxs = push!(neighboridxs, (i-1, j-1))
            neighboridxs = push!(neighboridxs, (i+1, j-1))
        elseif i == maxrow
            neighboridxs = push!(neighboridxs, (maxrow, j-1))
            neighboridxs = push!(neighboridxs, (maxrow, j+1))
            neighboridxs = push!(neighboridxs, (maxrow-1, j))
            neighboridxs = push!(neighboridxs, (maxrow-1, j-1))
            neighboridxs = push!(neighboridxs, (maxrow-1, j+1))
        end
    else
        neighboridxs = push!(neighboridxs, (i, j-1))
        neighboridxs = push!(neighboridxs, (i, j+1))
        neighboridxs = push!(neighboridxs, (i+1, j))
        neighboridxs = push!(neighboridxs, (i-1, j))
        neighboridxs = push!(neighboridxs, (i-1, j-1))
        neighboridxs = push!(neighboridxs, (i-1, j+1))
        neighboridxs = push!(neighboridxs, (i+1, j-1))
        neighboridxs = push!(neighboridxs, (i+1, j+1))
    end
    return neighboridxs
end

function step(arr)
    hasflashed = zeros(Int, size(arr))
    flashcandidates = Tuple[]
    for c in CartesianIndices(arr)
        arr[c] += 1
        if arr[c] > 9
            i = c[1]
            j = c[2]
            flashcandidates = push!(flashcandidates, (i,j))
        end
    end
    flashcounter = 0
    while (length(flashcandidates) > 0)
        for el in flashcandidates
            if arr[el[1], el[2]] > 9 && hasflashed[el[1], el[2]] == 0
                #println("el: "*string(el))
                flashcounter += 1
                #= if el == (10,10)
                    println(getNeighbors(arr, el))
                end =#
                flashcandidates = append!(flashcandidates, getNeighbors(arr, el))
                hasflashed[el[1], el[2]] = 1
                for idx in getNeighbors(arr, el)
                    #println(idx)
                    arr[idx[1], idx[2]] += 1
                end
                flashcandidates = deleteat!(flashcandidates, findfirst(x -> x == el, flashcandidates))
            elseif arr[el[1], el[2]] <= 9 || hasflashed[el[1], el[2]] != 0
                flashcandidates = deleteat!(flashcandidates, findfirst(x -> x == el, flashcandidates))
            end
        end
    end
    for c in CartesianIndices(arr)
        if arr[c] > 9
            arr[c] = 0
        end
    end
    return flashcounter
end

function solve(filename)
    values = readlines(filename*".txt")
    values = split.(values, "")
    #println(values)
    intvalues = Vector{Int}[]
    for line in values
        convline = parse.(Int, line)
        intvalues = push!(intvalues, convline)
    end
    valarr = zeros(Int, 10,10)
    for i in 1:length(intvalues)
        for j in 1:length(intvalues)
            valarr[i,j] = intvalues[i][j]
        end
    end
    #for i in 1:10
        #println(valarr[i, :])
    #end
    #println(" ")
    #println(getNeighbors(valarr, (1,3)))
    res = 0
    not_synced = true
    i = 1
    res_i = 0
    while not_synced
        stepres = step(valarr)
        res += stepres
        if stepres == 100
            not_synced = false
            res_i = i
        end
        i += 1
        #= if st == 10
            for i in 1:10
            println(valarr[i, :])
            end
            println(res)
        end  =#
    end
    println("Number of total flashes: "*string(res))
    println("synced after step: "*string(res_i))
end

solve("example")
solve("input")

