function parseInput(filename)
    values = readlines(filename*".txt")
    polymer = values[1]
    replacement = Dict{String, String}()
    for i in 3:length(values)
        st = values[i]
        st = split(st, "->")
        first = strip(st[1])
        scd = strip(st[2])
        replacement[first] = scd
    end
    return polymer, replacement
end

function applyReplacement(st, repval)
    
end

function solve(filename)
    polymer, dict = parseInput(filename)
    steps = 40
    for _ in 1:steps
        newpol = ""
        for p in 1:length(polymer)-1
            pair = polymer[p:p+1]
            rep = dict[pair]
            newpol = newpol *pair[1]*rep
            if p == length(polymer) - 1
                newpol = newpol * pair[2]
            end
        end
        polymer = newpol
    end
    #println(polymer)
    countdict = Dict{String,Int}()
    for char in polymer
        c = count(x -> x == char, polymer)
        countdict[string(char)] = c
    end
    mincount = minimum(values(countdict))
    maxcount = maximum(values(countdict))
    res = maxcount - mincount
    println(res)
end

function solve2(filename)
    polymer, dict = parseInput(filename)
    steps = 40
    k = collect(keys(dict))
    pairs = Dict{String, Int}(i => 0 for i in k)
    for i in 1:length(polymer)-1
        pair = polymer[i:i+1]
        pairs[pair] += 1
    end    
    for _ in 1:steps
        change = Dict{String,Int}(i => 0 for i in k)
        for (p,c) in pairs
            oldpair = p
            rep = dict[p]
            new1 = p[1]*rep
            new2 = rep*p[2]
            change[oldpair] -= c
            change[new1] += c
            change[new2] += c
        end
        for (k, v) in pairs
            pairs[k] += change[k]
        end
    end
    letters = unique(collect(values(dict)))
    countdict = Dict{String, Int}(l => 0 for l in letters)
    for p in pairs
        pstring = p[1]
        countdict[string(pstring[1])] += p[2]
    end
    last = string(polymer[length(polymer)])
    countdict[last] += 1
    mincount = minimum(values(countdict))
    maxcount = maximum(values(countdict))
    res = maxcount - mincount
    println(res)
end

#solve("example")
#solve("input")
solve2("example")
solve2("input")