struct Line
    start::CartesianIndex
    stop::CartesianIndex
end

function length(l::Line)
    return norm(l.stop - l.start)
end

function isvertical(l::Line)
    return l.start[1] == l.stop[1]
end

function ishorizontal(l::Line)
    return l.start[2] == l.stop[2]
end

function isdiagonal(l::Line)
    return abs(l.stop[1] - l.start[1]) == abs(l.stop[2] - l.start[2])
end

function getPointsOnLine(l::Line)
    points = CartesianIndex[]
    if isvertical(l)
        ystart = line.start[2] + 1
        ystop = line.stop[2] + 1
        step = 1
        if ystart > ystop
            step = -1
        end
        x = line.start[1] + 1
        y = ystart
        while y <= ystop
            points = push!(points, CartesianIndex(x,y))
            y += step
        end
    elseif ishorizontal(l)
        xstart = line.start[1] + 1
        xstop = line.stop[1] + 1
        step = 1
        if xstart > xstop
            step = -1
        end
        y = line.start[2] + 1
        x = xstart
        while x <= xstop
            points = push!(points, CartesianIndex(x,y))
            x += step
        end
    elseif isdiagonal(l)
        xstep = 1
        ystep = 1
        xstart = line.start[1] + 1
        ystart = line.start[2] + 1
        xstop = line.stop[1] + 1
        ystop = line.stop[2] + 1
        if xstop > xstart
            xstep = -1
        end
        if ystop > ystart
            ystep = -1
        end
        x = xstart
        y = ystart
        step = 1
        while step <= abs(xstop - xstart) + 1
            points = push!(points, CartesianIndex(x,y))
            x += xstep
            y += ystep
            step += 1
        end 
    end
end

function solve(filename)
    #load txt file
    values = readlines(filename*".txt")
    lines = Line[]
    max_x = 0
    max_y = 0
    for line in values
        parts = split(line, '-')
        first = split(parts[1], ',')
        second = split(parts[2], ',')
        x1 = parse(Int, first[1])
        if x1 > max_x 
            max_x = x1
        end
        x2string = replace(second[1], '>' => ' ')
        x2 = parse(Int, x2string)
        if x2 > max_x
            max_x = x2
        end
        y1 = parse(Int, first[2])
        if y1 > max_y
            max_y = y1
        end
        y2 = parse(Int, second[2])
        if y2 > max_y
            max_y = y2
        end
        start = CartesianIndex(x1, y1)
        stop = CartesianIndex(x2, y2)
        lines = push!(lines, Line(start, stop))
    end

    map = zeros(max_x + 1, max_y + 1)
    for line in lines
        #println(line.start)
        #println(line.stop)
        if isvertical(line)
            #println("vertical")
            ystart = line.start[2] + 1
            ystop = line.stop[2] + 1
            if ystart > ystop
                tmp = ystart
                ystart = ystop
                ystop = tmp
            end
            x = line.start[1] + 1
            y = ystart
            while y <= ystop
                map[x,y] += 1
                y += 1
            end
        elseif ishorizontal(line)
            #println("horizontal")
            xstart = line.start[1] + 1
            xstop = line.stop[1] + 1
            if xstart > xstop
                tmp = xstart
                xstart = xstop
                xstop = tmp
            end
            y = line.start[2] + 1
            x = xstart
            while x <= xstop
                #println("mark: ("*string(x)*", "*string(y)*")")
                map[x,y] += 1
                #println(map[x,y])
                x += 1
            end
        end
    end
    count_morethantwo = 0
    for el in map
        if el >= 2
            count_morethantwo += 1
        end
    end
    println(count_morethantwo)
end

solve("smalltest")
solve("input")

function solve2(filename)
    #load txt file
    values = readlines(filename*".txt")
    lines = Line[]
    max_x = 0
    max_y = 0
    for line in values
        parts = split(line, '-')
        first = split(parts[1], ',')
        second = split(parts[2], ',')
        x1 = parse(Int, first[1])
        if x1 > max_x 
            max_x = x1
        end
        x2string = replace(second[1], '>' => ' ')
        x2 = parse(Int, x2string)
        if x2 > max_x
            max_x = x2
        end
        y1 = parse(Int, first[2])
        if y1 > max_y
            max_y = y1
        end
        y2 = parse(Int, second[2])
        if y2 > max_y
            max_y = y2
        end
        start = CartesianIndex(x1, y1)
        stop = CartesianIndex(x2, y2)
        lines = push!(lines, Line(start, stop))
    end

    map = zeros(max_x + 1, max_y + 1)
    for line in lines
        if isvertical(line)
            ystart = line.start[2] + 1
            ystop = line.stop[2] + 1
            if ystart > ystop
                tmp = ystart
                ystart = ystop
                ystop = tmp
            end
            x = line.start[1] + 1
            y = ystart
            while y <= ystop
                map[x,y] += 1
                y += 1
            end
        elseif ishorizontal(line)
            xstart = line.start[1] + 1
            xstop = line.stop[1] + 1
            if xstart > xstop
                tmp = xstart
                xstart = xstop
                xstop = tmp
            end
            y = line.start[2] + 1
            x = xstart
            while x <= xstop
                map[x,y] += 1
                x += 1
            end
        elseif isdiagonal(line)
            x_right = false
            y_down = false
            xstart = line.start[1] + 1
            ystart = line.start[2] + 1
            xstop = line.stop[1] + 1
            ystop = line.stop[2] + 1
            if xstop > xstart
                x_right = true
            end
            if ystop > ystart
                y_down = true
            end
            xstep = 1
            ystep = 1
            if x_right == false
                xstep = -1
            end
            if y_down ==false
                ystep = -1
            end
            x = xstart
            y = ystart
            step = 1
            while step <= abs(xstop - xstart) + 1
                map[x,y] += 1
                x += xstep
                y += ystep
                step += 1
            end 
        end
    end
    count_morethantwo = 0
    for el in map
        if el >= 2
            count_morethantwo += 1
        end
    end
    println(count_morethantwo)
end

solve2("smalltest")
solve2("input")