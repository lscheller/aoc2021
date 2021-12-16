tobinary = Dict("0" => "0000", "1" => "0001", "2" => "0010", "3" => "0011", "4" => "0100", "5" => "0101", "6" => "0110", "7" => "0111", "8" => "1000", "9" => "1001", "A" => "1010", "B" => "1011", "C" => "1100", "D" => "1101", "E" => "1110", "F" => "1111")
version_sum = 0

function parseInput(filename)
    line = readlines(filename*".txt")
    binline = ""
    for c in line[1]
        b = tobinary[string(c)]
        binline = binline * b
    end
    return binline
end



function interpretHeader(binline, startidx)
    version = parse(Int, binline[startidx:startidx+2], base = 2)
    type = parse(Int, binline[startidx+3:startidx+5], base = 2)    
    return version, type
end

function interpretLiteral(binline, startidx)
    #pkglength = 6
    fivebits = binline[startidx:startidx+4]
    number = ""
    stopdesignator = false
    while stopdesignator != true
        number = number * fivebits[2:5]
        #pkglength += 5
        if fivebits[1] == '0'
            stopdesignator = true
        end
        startidx += 5
        if startidx+4 < length(binline)
            fivebits = binline[startidx:startidx+4]
        end
    end
    number = parse(Int, number, base = 2)
    
    return number, startidx
end


function readInstructions(binline, idx)
    global version_sum
    packet = Dict()
    v, t = interpretHeader(binline, idx)
    version_sum += v
    packet["version"] = v
    packet["type"] = t
    idx = idx + 6
    if packet["type"] == 4
        packet["val"], idx = interpretLiteral(binline, idx)
    else
        packet["i"] = parse(Int, binline[idx], base = 2)
        idx += 1
        if packet["i"] == 0
            packet["length"] = parse(Int, binline[idx:idx+14], base = 2)
            idx = idx + 15  
            p_end = idx + packet["length"]
            if haskey(packet, "subpackages")
                sp = sp = [packet["subpackages"]]
            else
                sp = []
            end
            while idx < p_end
                subpack, idx = readInstructions(binline, idx)
                sp = push!(sp, subpack)
                packet["subpackages"] = sp
            end
        else
            packet["sub_count"] = parse(Int, binline[idx:idx+10], base = 2)
            idx = idx + 11
            if haskey(packet, "subpackages")
                sp = sp = [packet["subpackages"]]
            else
                sp = []
            end
            for _ in 1:packet["sub_count"]
                subpack, idx = readInstructions(binline, idx)
                sp = push!(sp, subpack)
                packet["subpackages"] = sp                               
            end
        end
        subp_vals = [p["val"] for p in packet["subpackages"]]
        
        if packet["type"] == 0
            #sum 
            packet["val"] = sum(subp_vals)
        elseif packet["type"] == 1
            #product
            packet["val"] = prod(subp_vals)
        elseif packet["type"] == 2
            #minimum
            packet["val"] = minimum(subp_vals)
        elseif packet["type"] == 3
            #maximum
            packet["val"] = maximum(subp_vals)
        elseif packet["type"] == 5
            #greater than
            if subp_vals[1] > subp_vals[2]
                packet["val"] = 1
            else
                packet["val"] = 0
            end
        elseif packet["type"] == 6
            #less than
            if subp_vals[1] < subp_vals[2]
                packet["val"] = 1
            else
                packet["val"] = 0
            end
        elseif packet["type"] == 7
            #equal
            if subp_vals[1] == subp_vals[2]
                packet["val"] = 1
            else
                packet["val"] = 0
            end
        end
    end

    return packet, idx
end

function solve(filename)
    bin = parseInput(filename)
    packets, _ = readInstructions(bin, 1)
    println(version_sum)
    #println(packets)
    println(packets["val"])
end

solve("literal")
version_sum = 0
 solve("op1")
version_sum = 0
solve("op2")
version_sum = 0
solve("input") 
