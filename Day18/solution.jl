using JSON
using AbstractTrees

mutable struct BinaryNode{T}
    data::T
    parent::BinaryNode{T}
    left::BinaryNode{T}
    right::BinaryNode{T}

    # Root constructor
    BinaryNode{T}(data) where T = new{T}(data)
    # Child node constructor
    BinaryNode{T}(data, parent::BinaryNode{T}) where T = new{T}(data, parent)
end

BinaryNode(data) = BinaryNode{typeof(data)}(data)

function leftchild(data, parent::BinaryNode)
    #!isdefined(parent, :left) || error("left child is already assigned")
    node = typeof(parent)(data, parent)
    parent.left = node
end
function rightchild(data, parent::BinaryNode)
    #!isdefined(parent, :right) || error("right child is already assigned")
    node = typeof(parent)(data, parent)
    parent.right = node
end

function AbstractTrees.children(node::BinaryNode)
    if isdefined(node, :left)
        if isdefined(node, :right)
            return (node.left, node.right)
        end
        return (node.left,)
    end
    isdefined(node, :right) && return (node.right,)
    return ()
end

AbstractTrees.printnode(io::IO, node::BinaryNode) = print(io, node.data)

Base.eltype(::Type{<:TreeIterator{BinaryNode{T}}}) where T = BinaryNode{T}
Base.IteratorEltype(::Type{<:TreeIterator{BinaryNode{T}}}) where T = Base.HasEltype()

function arrToTree(arr, parent = nothing)
    if length(arr) > 0
        if isnothing(parent)
            root = BinaryNode{Union{Int, Nothing}}(nothing)
        else
            root = parent
        end
        if typeof(arr[1]) == Int
            left = leftchild(arr[1], root)
        else
            left = leftchild(nothing, root)
            arrToTree(arr[1], left)
        end
        if typeof(arr[2]) == Int
            right = rightchild(arr[2], root)
        else
            right = rightchild(nothing, root)
            arrToTree(arr[2], right)
        end
        
        return root
    end
end

function readInput(filename)
    values = readlines(filename*".txt")
    numbers = []
    for line in values
        n = JSON.parse(line)
        numbers = push!(numbers, n)
    end
    return numbers
end

function explode(t)
    leaves = [l for l in AbstractTrees.Leaves(t)]
    #find deepest pair
    deepest, deepidx = deepestPair(t)
    #find left and right neighbor
    lidx = ridx = nothing
    if deepidx > 1
        lidx = deepidx - 1
    end
    if deepidx + 1 < length(leaves)
        ridx = deepidx + 2
    end
    lngb = rngb = nothing
    if isnothing(lidx) == false
        lngb = leaves[lidx].data
    end
    if isnothing(ridx) == false
        rngb = leaves[ridx].data
    end
    #compute new values for neighbors
    new_l = nothing
    if isnothing(lngb) == false
        new_l = deepest.left.data + lngb
    end
    new_r = nothing
    if isnothing(rngb) == false
        new_r = deepest.right.data + rngb
    end
    #change values of left and right neighbors
    
    if isnothing(new_l) == false
        lneigh = leaves[lidx]
        p = lneigh.parent
        if isleft(p, lneigh)
            lneigh = leftchild(new_l, p)
        else
            lneigh = rightchild(new_l,p)
        end
        if isdefined(p, :parent) == false
            t.left = p
        end
    end
    if isnothing(new_r) == false
        rneigh = leaves[ridx]        
        p = rneigh.parent         
        if isleft(p, rneigh)            
            rneigh = leftchild(new_r, p)
        else
            rneigh = rightchild(new_r, p)
        end
        if isdefined(p, :parent) == false
            t.right = p
        end
    end
    #replace deepest pair root with 0
    if isleft(deepest.parent, deepest)
        deepest = leftchild(0, deepest.parent)
    else
        deepest = rightchild(0, deepest.parent)
    end
    
    return t

end

function countparents(t)
    count = 0
    while isdefined(t, :parent)
        count += 1
        t = t.parent
    end
    return count
end

function deepestPair(t)
    leaves = [l for l in AbstractTrees.Leaves(t)]
    max_depth = 0
    pair = t
    deepestindex = 0
    for (i,l) in enumerate(leaves)
        is_left = isleft(l.parent, l)
        if typeof(l.data) == Int
            if (is_left && typeof(l.parent.right.data) == Int) || (is_left == false && typeof(l.parent.left.data) == Int)
                d = countparents(l)
                if d > max_depth
                    pair = l.parent
                    deepestindex = i
                    max_depth = d
                end
            end
        end
    end

    return pair, deepestindex
end

function isleft(parent, child)
    if parent.left == child
        return true
    else
        return false
    end
end

function leftneighbor(t, pair)
    pairleft = pair.left.data
    leaves = [l.data for l in AbstractTrees.Leaves(t)]
    lidx = findfirst(x -> x == pairleft, leaves)
    if leaves[lidx + 1] != pair.right.data
        checked_leaves = copy(leaves)
        for i in 1:lidx
            checked_leaves[i] = -1
        end
        lidx = findfirst(x -> x == pairleft, checked_leaves)
    end
    if lidx == 1
        return nothing, 0
    else 
        return leaves[lidx - 1], lidx - 1
    end
end

function rightneighbor(t, pair)
    pairright = pair.right.data
    leaves = [l.data for l in AbstractTrees.Leaves(t)]
    ridx = findfirst(x -> x == pairright, leaves)
    while ridx == 1 || leaves[ridx - 1] != pair.left.data
        checked_leaves = copy(leaves)
        for i in 1:ridx
            checked_leaves[i] = -1
        end
        ridx = findfirst(x -> x == pairright, checked_leaves)               
    end 
    if ridx == length(leaves)
        return nothing, 0
    else 
        return leaves[ridx + 1], ridx + 1
    end
end

function getNeighbors(t, pair)
    pairleft = pair.left.data
    pairright = pair.right.data
    leaves = [l.data for l in AbstractTrees.Leaves(t)]
    lidx = ridx = nothing
    for i in 1:length(leaves)-1
        if leaves[i] == pairleft && leaves[i+1] == pairright
            if i > 1
                lidx = i-1
            end
            if i+1 < length(leaves)
                ridx = i+2
            end
            break
        end
    end
    return lidx, ridx
end

function treedepth(t)
    if typeof(t.data) == Int
        return 0
    end
    ld = treedepth(t.left)
    rd = treedepth(t.right)
    return 1 + max(ld, rd)
       
end

function needsEx(t)
    d = treedepth(t)
    if d > 4
        return true
    else
        return false
    end
end

function needsSplit(t)
    leaves = [l for l in AbstractTrees.Leaves(t)]
    for l in leaves
        if l.data >= 10
            return true
        end
    end
    return false
end

function split_sn(t)
    leaves = [l for l in AbstractTrees.Leaves(t)]
    for l in leaves
        if l.data >= 10
            p = l.parent
            new_l = floor(l.data/2)
            new_r = ceil(l.data/2)
            if isleft(p, l)
                sp = leftchild(nothing, p)
                p = p.left
                nl = leftchild(new_l, p)
                nr = rightchild(new_r,p)
            else
                sp = rightchild(nothing, p)
                p = p.right
                nl = leftchild(new_l, p)
                nr = rightchild(new_r,p)
            end
            break
        end
    end
    return t
end

function add(t1, t2)
    root = BinaryNode{Union{Int,Nothing}}(nothing)
    l = leftchild(nothing, root)
    r = rightchild(nothing, root)
    l.left = t1.left
    t1.left.parent = l
    l.right = t1.right
    t1.right.parent = l
    r.left = t2.left
    t2.left.parent = r
    r.right = t2.right
    t2.right.parent = r
    while needsEx(root) || needsSplit(root)
        while needsEx(root)
            root = explode(root)
        end
        if needsSplit(root)
            root = split_sn(root)
        end
    end 
    return root
end

function getMagnitude(t)
    if typeof(t.left.data) == Int && typeof(t.right.data) == Int
        return 3*t.left.data + 2*t.right.data
    elseif typeof(t.left.data) == Int
        return 3*t.left.data + 2*getMagnitude(t.right)
    elseif typeof(t.right.data) == Int
        return 3* getMagnitude(t.left) + 2*t.right.data
    else
        return 3 * getMagnitude(t.left) + 2 * getMagnitude(t.right)
    end
end

function solve(filename)
    numbers = readInput(filename)
    trees = []
    for n in numbers
        tree = arrToTree(n)
        trees = push!(trees, tree)
    end 
    t1 = deepcopy(trees[1])
    for (i, t) in enumerate(trees)       
        if i != length(trees)
            t_next = deepcopy(trees[i+1])
            t1 = add(t1, t_next)
        end
    end
    println(getMagnitude(t1))
    
    maxMagn = 0
    max_i = 0
    max_j = 0
    for i in 1:length(trees)
        for j in 1:length(trees)
            t = deepcopy(trees)
            if i != j
                m = getMagnitude(add(t[i], t[j]))
                if m > maxMagn
                    maxMagn = m
                    max_i = i
                    max_j = j
                end
            end
        end
    end
    println("Max magnitude: "*string(maxMagn))
    println("Lines: "*string(max_i)*" and "*string(max_j))
end

#solve("example")
solve("input")