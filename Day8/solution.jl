function solve(filename)
    values = readlines(filename*".txt")
    values = split.(values, " | ")

    input = String[]
    output = String[]
    for line in values
        input = push!(input, line[1])
        output = push!(output, line[2])
    end
    input = split.(input, ' ')
    output = split.(output, ' ')

    count = 0
    for line in output
        for el in line
            if length(el) == 2 || length(el) == 4 || length(el) == 3 || length(el) == 7
                count += 1
            end
        end
    end
    println("Count of 1, 4, 7, 8: "*string(count))
end

function find_patterns(input)
    codesperline = []
    zero = one = two = three = four = five = six = seven = eight = nine = ""
    upper_line = mid_line = lower_line = right_upper = right_lower = left_upper = left_lower = ""
    for line in input
        #one
        for el in line
            if length(el) == 2
                one = join(sort(collect(el)))
                break
            end
        end
        #seven
        for el in line
            if length(el) == 3
                seven = join(sort(collect(el)))
                upper_line = replace(el, one => "")
                break
            end
        end
        #four
        for el in line
            if length(el) == 4
                four = join(sort(collect(el)))
                break
            end
        end
        #eight
        for el in line
            if length(el) == 7
                eight = join(sort(collect(el)))
                break
            end
        end
        #three is length five and contains one
        length_five_candidates = []
        length_six_candidates = []
        for el in line
            if length(el) == 5
                length_five_candidates = push!(length_five_candidates, join(sort(collect(el))))
            elseif length(el) == 6
                length_six_candidates = push!(length_six_candidates, join(sort(collect(el))))
            end
        end
        #three
        for el in length_five_candidates
            if stringcontains(one, el)
                three = el
                setdiff!(length_five_candidates, three)
                break
            end
        end
        #six
        for el in length_six_candidates
            if stringcontains(one, el) == false
                six = el
                setdiff!(length_six_candidates, six)
                break
            end
        end
        #nine
        for el in length_six_candidates
            if stringcontains(three, el)
                nine = el
                setdiff!(length_six_candidates, nine)
                break
            end
        end
        #zero
        for el in length_six_candidates
            if stringcontains(nine, el) == false && stringcontains(six, el) == false
                zero = el
                break
            end
        end
        
        #two
        for char in nine
            if occursin(char, three) == false
                left_upper = char
                break
            end
        end
    
        for el in length_five_candidates
            if stringcontains(left_upper, el) == false && el != three
                two = el
                setdiff!(length_five_candidates, two)
                break
            end
        end
        #five
        for el in length_five_candidates
            if stringcontains(three, el) == false && stringcontains(two, el) == false
                five = el
                break
            end
        end
        
        numbers = [zero, one, two, three, four, five, six, seven, eight, nine]
        for (i,n) in enumerate(numbers)
            numbers[i] = join(sort(collect(n)))
        end
        codesperline = push!(codesperline, numbers)
    end
    return codesperline
end

function stringcontains(ptrn, str)
    res = true
    for char in ptrn
        if occursin(char, str) == false
            res = false
            break
        end
    end
    return res
end

function decode(output, codesperline)
    output_numbers = []
    for (i,line) in enumerate(output)
        numbers = codesperline[i]
        decoded = ""
        for el in line
            el = join(sort(collect(el)))
            for i in 0:9
                if el == numbers[i+1]
                    decoded = decoded * string(i)
                    break
                end
            end            
        end
        decoded_int = parse(Int, decoded)
        output_numbers = push!(output_numbers, decoded_int)
    end
    
    sum = 0
    for number in output_numbers
        sum += number
    end
    return sum
end

function solve2(filename)
    values = readlines(filename*".txt")
    values = split.(values, " | ")

    input = String[]
    output = String[]
    for line in values
        input = push!(input, line[1])
        output = push!(output, line[2])
    end
    input = split.(input, ' ')
    output = split.(output, ' ')

    codes = find_patterns(input)
    res = decode(output, codes)
    println("Sum of all numbers: "*string(res))    
end

solve("smalltest")
solve("input")

solve2("smalltest")
solve2("input")