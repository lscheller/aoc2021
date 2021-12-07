function solution()
    values = readlines("smalltest.txt")
    values = parse.(Int, values)
    windowindices = [1, 2, 3]
    prevsum = -Inf
    count = 0
    while windowindices[3] <= length(values)
        currsum = values[windowindices[1]] + values[windowindices[2]] + values[windowindices[3]]
        if prevsum > 0 && currsum > prevsum
            count += 1
        end
        windowindices .+= 1
        prevsum = currsum
    end
    println(count)
end

solution()