using Statistics

function isopening(char)
    if char == '(' || char == '[' || char == '{' || char == '<'
        return true
    else
        return false
    end
end

function isclosing(char)
    if char == ')' || char == ']' || char == '}' || char == '>'
        return true
    else
        return false
    end
end

function iscounterpart(openingchar, char)
    if openingchar == '(' && char == ')'
        return true
    elseif openingchar == '[' && char == ']'
        return true
    elseif openingchar == '{' && char == '}'
        return true
    elseif openingchar == '<' && char == '>'
        return true
    else
        return false
    end    
end

function getclosingsequence(opseq)
    seq = reverse(opseq)
    cs = Char[]
    for el in seq
        if el == '('
            cs = push!(cs, ')')
        elseif el == '['
            cs = push!(cs, ']')
        elseif el == '{'
            cs = push!(cs, '}')
        elseif el == '<'
            cs = push!(cs, '>')
        end
    end
    return cs
end

function getPoints(cseq)
    score = 0
    for el in cseq
        score *= 5
        if el == ')'
            score += 1
        elseif el == ']'
            score += 2
        elseif el == '}'
            score += 3
        elseif el == '>'
            score += 4
        end
    end
    return score
end

function solve(filename)
    values = readlines(filename*".txt")
    illegals = []
    remainingopeners = []
    for line in values
        currentchunkopener = 'b'
        openers = Char[]
        firstillegal = nothing
        for el in line
            #println(el)
            #println(currentchunkopener)
            if isnothing(firstillegal) == false
                break
            elseif currentchunkopener == 'b' && isopening(el) == false
                firstillegal = el
                illegals = push!(illegals, el)
                break
            elseif currentchunkopener == 'b'
                openers = push!(openers, el)
                currentchunkopener = el
            else
                if isopening(el)
                    openers = push!(openers, el)
                    currentchunkopener = el
                else
                    if iscounterpart(currentchunkopener, el)
                        pop!(openers)
                        if length(openers) > 0
                            currentchunkopener = last(openers)
                        else
                            currentchunkopener = 'b'
                        end
                    else
                        firstillegal = el
                        break
                    end
                end    
            end            
        end
        illegals = push!(illegals, firstillegal)
        remainingopeners = push!(remainingopeners, openers)
    end
    points = 0
    for el in illegals
        if isnothing(el) == false
            if el == ')'
                points += 3
            elseif el == ']'
                points += 57
            elseif el == '}'
                points += 1197
            elseif el == '>'
                points += 25137
            end
        end
    end
    println("Points for corrupted: "*string(points))
    deletionindices = Int[]
    for (i,el) in enumerate(illegals)
        if isnothing(el) == false
            deletionindices = push!(deletionindices, i)
        end
    end
    values = deleteat!(values, deletionindices)
    remainingopeners = deleteat!(remainingopeners, deletionindices)
    closingsequences = []
    points = Int[]
    for el in remainingopeners
        cs = getclosingsequence(el)
        closingsequences = push!(closingsequences, cs)
        points = push!(points, getPoints(cs))
    end
    completionpoints = Int(median(sort(points)))
    println("Points for incomplete: "*string(completionpoints))
end

solve("smalltest")
solve("input")