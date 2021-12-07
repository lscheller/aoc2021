function main()
    #load txt file
    values = readlines("input.txt")
    #parse all values to int 
    values = parse.(Int, values)
    #detect increases and count them
    inc_count = 0
    noninc_count = 0
    curr = -Inf
    for v in values
        println(string(v)*" > "*string(curr)*"?")
        if curr == -Inf
            #first entry of the list, don't count increases
            curr = v
            #println("First")
        elseif v > curr
            inc_count += 1
            curr = v
            #println("Yes!")
        else 
            noninc_count += 1
            curr = v
            #println("No...")
        end
    end
    println(inc_count)
    println(noninc_count)
    println(size(values, 1))
    println(1 + inc_count + noninc_count)
end

main()