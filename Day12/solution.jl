
struct Graph
    vertices::Set{String}
    edges::Set{Tuple}
end

function generateGraph(filename)
    values = readlines(filename*".txt")
    edges = Set()
    vert = Set()
    for line in values
        st = split(line, '-')
        v1 = string(st[1])
        v2 = string(st[2])
        vert = push!(vert, v1)
        vert = push!(vert, v2)
        if !((v2,v1) in edges)
            edges = push!(edges, (v1,v2))
        end
    end
    return Graph(vert, edges)
end

function getNeighbors(vertex, graph)
    ngb = Set()
    for e in graph.edges
        if e[1] == vertex
            ngb = push!(ngb, e[2])
        elseif e[2] == vertex
            ngb = push!(ngb, e[1])
        end
    end
    return ngb
end

function dfs(graph::Graph, node::String, stop::String, visited::Dict, currentpath::Vector{String}, paths)
    visited[node] = true
    if (node == stop)
        println(currentpath)
        paths = push!(paths, currentpath)
        currentpath = String[]
    end
    neighbors = getNeighbors(node, graph)
    for n in neighbors
        if isuppercase(n[1]) || (islowercase(n[1]) && visited[n] == false)
            currentpath = push!(currentpath, n)
            dfs(graph, n, stop, visited, currentpath, paths)
            currentpath = deleteat!(currentpath, findlast(x -> x == n, currentpath))
        end
    end
    visited[node] = false
end

function dfsparttwo(graph::Graph, node::String, stop::String, visited::Dict, currentpath::Vector{String}, paths, visitedtwice::Bool)
  
    visited[node] = true
    if (node == stop)
        #println("path ended")
        #println(currentpath)
        paths = push!(paths, currentpath)
        currentpath = String[]
        visitedtwice = false
    end
    neighbors = getNeighbors(node, graph)
    
    for n in neighbors
        if n in currentpath
            visited[n] = true
        end

        if visitedtwice
            check = true
            for el in currentpath
                if islowercase(el[1]) && count(x -> x == el, currentpath) > 1
                    check = false
                    break
                end
            end
            if check
                visitedtwice = false
            end
        end
         
        if isuppercase(n[1]) || (islowercase(n[1]) && visited[n] == false) || (islowercase(n[1]) && n in currentpath && visitedtwice == false && n != "start" && n != "end")
            
            if islowercase(n[1]) && n in currentpath
                visitedtwice = true
            end
            currentpath = push!(currentpath, n)
            dfsparttwo(graph, n, stop, visited, currentpath, paths, visitedtwice)
            currentpath = deleteat!(currentpath, findlast(x -> x == n, currentpath))
        end
    end
    visited[node] = false
end

function findPaths(graph::Graph, start::String, stop::String)
    paths = []
    visited = Dict(x => false for x in graph.vertices)
    currentpath = String[]
    currentpath = push!(currentpath, start)
    dfs(graph, start, stop, visited, currentpath, paths)
    return paths

end

function findPathsparttwo(graph::Graph, start::String, stop::String)
    paths = []
    visited = Dict(x => false for x in graph.vertices)
    currentpath = String[]
    currentpath = push!(currentpath, start)
    visitedtwice = false
    dfsparttwo(graph, start, stop, visited, currentpath, paths, visitedtwice)
    return paths
end

function solve(filename)
    graph = generateGraph(filename)
    println(graph.edges)
    paths = findPaths(graph, "start", "end")
    println(length(paths))
end

function solve2(filename)
    graph = generateGraph(filename)
    paths = findPathsparttwo(graph, "start", "end")
    println(length(paths))
end

#solve("input")
#solve("smallexample")
solve2("smallexample")
solve2("midexample")
solve2("largeexample")
solve2("input")