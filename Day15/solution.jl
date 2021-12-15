using DataStructures

struct Graph
    vertices::Vector{Int}
    edges::Set{Tuple{Tuple, Int}}
end

function getNeighbors(arr, (i, j))
    maxrow = size(arr, 1)
    maxcol = size(arr, 2)
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
            neighboridxs = push!(neighboridxs, (maxrow,maxcol-1))
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

function toGraph(filename, part2 = false)
    values = readlines(filename*".txt")
    values = split.(values, "")
    intvalues = Vector{Int}[]
    for line in values
        convline = parse.(Int, line)
        intvalues = push!(intvalues, convline)
    end
    valarr = zeros(Int, size(intvalues)[1],size(intvalues[1])[1])
    for i in 1:length(intvalues)
        for j in 1:length(intvalues[1])
            valarr[i,j] = intvalues[i][j]
        end
    end
    if part2
        origvalarr = copy(valarr)
        arrs = []
        for i in 1:5
            line = []
            for j in 1:5
                arr = copy(origvalarr)
                toadd_x = i - 1
                toadd_y = j - 1
                toadd = toadd_x + toadd_y
                for k in 1:size(origvalarr,1)
                    for l in 1:size(origvalarr,2)
                        if origvalarr[k,l] + toadd != 9
                            arr[k,l] = (origvalarr[k,l] + toadd) % 9
                            if arr[k,l] == 0
                                arr[k,l] = 1
                            end
                        else
                            arr[k,l] = 9
                        end
                    end
                end
                line = push!(line, arr)
            end
            arrs = push!(arrs, line)
        end
        larrs = []
        for line in arrs
            larr = line[1]
            for i in 1:4
                larr = hcat(larr,line[i+1])
            end
            larrs = push!(larrs, larr)
        end
        valarr = larrs[1]
        for i in 1:4
            valarr = vcat(valarr,larrs[i+1])
        end
    end

    vertices = Int[]
    edges = Set{Tuple{Tuple,Int}}()
    for i in 1:size(valarr)[1]
        for j in 1:size(valarr)[2]
            vidx = ((i-1) * size(valarr)[2]) + j
            vertices = push!(vertices,vidx)
            ngb = getNeighbors(valarr, (i,j))
            for n in ngb  
                org = vidx
                nidx = ((n[1]-1) * size(valarr)[2]) + n[2]
                weight = valarr[n[1], n[2]]
                edges = push!(edges, ((org,nidx),weight))
            end
        end
    end
    graph = Graph(vertices, edges)
    return graph, valarr
end

function get2Dcoords(x,valarr)
    row = Int(floor(x/size(valarr, 2))) + 1        
    col = Int(x % (size(valarr, 2)))
    if col == 0
        col = size(valarr, 2)
        row = row - 1
    end
    return (row,col)
end

function dijkstra(graph, start, stop, valarr)
    dist = zeros(size(graph.vertices))
    previous = zeros(Int, size(graph.vertices))
    for (i,el) in enumerate(dist)
        dist[i] = Inf
        previous[i] = -1
    end
    dist[start] = 0
    
    G = PriorityQueue()
    for v in graph.vertices
        G = enqueue!(G, v, dist[v])
    end
    
    while isempty(G) == false 
        u = dequeue!(G)       
        if u == stop
            break
        end
        ngb = getNeighbors(valarr, get2Dcoords(u, valarr))
        for n in ngb
            d = dist[u] + valarr[n[1], n[2]]
            n = (n[1]-1) * size(valarr, 2) + n[2]
            if d < dist[n]
                dist[n] = d
                G[n] = d
                previous[n] = u
            end
        end
    end
    return dist, previous
end

function solve(filename, part2 = false)
    graph, valarr = toGraph(filename, part2)
    stopcoord = length(graph.vertices)
    dist, prev = dijkstra(graph, 1, stopcoord, valarr)
   
    println(dist[stopcoord])
end

solve("example")
solve("example", true)
solve("input")
solve("input", true)
#solve("test")
#solve("test2")