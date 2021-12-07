mutable struct Board
    values::Array{Int}
    marked::BitArray
    #marked = iszero.(zeros((5,5)))
end

function step(instruction, board)
    for (coord, val) in enumerate(board.values)
        if val == instruction
            board.marked[coord] = true
        end
    end
end

function check(board)
    for row in eachrow(board.marked)
        if all(row .== true)
            return true
        end
    end
    for col in eachcol(board.marked)
        if all(col .== true)
            return true
        end
    end
    return false
end

function computeScore(board, instruction)
    score = 0
    for (coord, val) in enumerate(board.values)
        if board.marked[coord] == false
            score += val
        end
    end
    println("sum: "*string(score))
    println("instruction: "*string(instruction))
    return score * instruction
end

function solve(filename)
    #load txt file
    values = readlines(filename*".txt")
    #first line is instructions
    instructions = values[1]
    instructions = split(instructions,',')
    instructions = parse.(Int, instructions)
    #next line is empty -> board from line 3-7
    start = 3
    stop = 7    
    boards = Board[]
    while stop <= length(values)   
        boardstring = values[start:stop]
        intboard = fill(0, (5,5))   
        i = 1  
        for row in boardstring           
            row = split(row, ' ')
            row = filter(!isempty, row)
            introw = parse.(Int, row)
            for (j, val) in enumerate(introw)
                intboard[i,j] = val
            end  
            i += 1          
        end
        marked = iszero.(ones((5,5)))
        board = Board(copy(intboard), copy(marked))
        boards = push!(boards, board)
        start += 6
        stop += 6
    end
    score = nothing
    for ins in instructions
        for b in boards
            step(ins, b)
            if check(b) == true
                score = computeScore(b, ins)
                println("Winning score: "*string(score))
                break
            end
        end
        if !isnothing(score)
            break
        end
    end

    
end

solve("input")
solve("smalltest")

function solve2(filename)
    #load txt file
    values = readlines(filename*".txt")
    #first line is instructions
    instructions = values[1]
    instructions = split(instructions,',')
    instructions = parse.(Int, instructions)
    #next line is empty -> board from line 3-7
    start = 3
    stop = 7    
    boards = Board[]
    while stop <= length(values)   
        boardstring = values[start:stop]
        intboard = fill(0, (5,5))   
        i = 1  
        for row in boardstring           
            row = split(row, ' ')
            row = filter(!isempty, row)
            introw = parse.(Int, row)
            for (j, val) in enumerate(introw)
                intboard[i,j] = val
            end  
            i += 1          
        end
        marked = iszero.(ones((5,5)))
        board = Board(copy(intboard), copy(marked))
        boards = push!(boards, board)
        start += 6
        stop += 6
    end
    scores = Int[]
    winningboards = Board[]
    score = nothing
    boardsMarked = zeros(length(boards))
    for ins in instructions
        for (j,b) in enumerate(boards)
            if boardsMarked[j] == 0
                step(ins, b)
                if check(b) == true
                    score = computeScore(b, ins)
                    winningboards = push!(winningboards, b)
                    scores = push!(scores, score)
                    boardsMarked[j] = 1
                end
            end
        end
    end 
    println("Winning score: "*string(score))
    println("All scores: ")
    println(scores)   
end

solve2("smalltest")
solve2("input")