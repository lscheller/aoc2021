function solve(filename)
    #load txt file
    values = readlines(filename*".txt")
    count0 = 0
    count1 = 0
    γ = ""
    ϵ = ""
    for i in 1:length(values[1])
        for j in 1:length(values)
            if values[j][i] == '0'
                count0 += 1
            else
                count1 += 1
            end
        end
        if count0 > count1
            γ = γ * "0"
            ϵ = ϵ * "1"
        else
            γ = γ * "1"
            ϵ = ϵ * "0"
        end
        count0 = 0
        count1 = 0
    end
    println(γ)
    println(parse(Int, γ, base = 2))
    γ = parse(Int, γ, base = 2)
    println(ϵ)
    println(parse(Int, ϵ, base = 2))
    ϵ = parse(Int, ϵ, base = 2)
    println("Result: "*string(γ * ϵ))
end

solve("smalltest")
solve("input")

function solve2(filename)
    #load txt file
    values = readlines(filename*".txt")
    count0 = 0
    count1 = 0
    count0_co2 = 0
    count1_co2 = 0
    currMostCommon = '0'
    currLeastCommon = '0'
    values_CO2 = copy(values)
    for i in 1:length(values[1])
        #println("i: "*string(i))
        #println("size of values: "*string(length(values)))
        #println("size of CO2vals: "*string(length(values_CO2)))
        if length(values) > 1 || length(values_CO2) > 1
            #compute most common bit
            for j in 1:length(values)
                if values[j][i] == '0'
                    count0 += 1
                else
                    count1 += 1
                end
            end
            for j in 1:length(values_CO2)
                if values_CO2[j][i] == '0'
                    count0_co2 += 1
                else
                    count1_co2 += 1
                end
            end
            
            #filter out all non-fitting entries
            if length(values) > 1
                if count0 > count1
                    currMostCommon = '0'
                else
                    currMostCommon = '1'
                end
                values = copy(filter!(x -> x[i] == currMostCommon, values))
                count0 = 0
                count1 = 0
                #println(values)
            end
            if length(values_CO2) > 1
                if count0_co2 > count1_co2
                    currLeastCommon = '1'
                else
                    currLeastCommon = '0'
                end
                values_CO2 = copy(filter!(x -> x[i] == currLeastCommon, values_CO2))
                count0_co2 = 0
                count1_co2 = 0
                #println(values_CO2)
            end
        else
            break
        end
    end
    println("Oxygen: "*string(parse(Int, values[1], base = 2)))
    println(values[1])
    println("CO2: "*string(parse(Int, values_CO2[1], base = 2)))
    println(values_CO2[1])
    println("Product: "*string(parse(Int, values[1], base = 2) * parse(Int, values_CO2[1], base = 2)))
end

solve2("smalltest")
solve2("input")
#solve2("addtest")