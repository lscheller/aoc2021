function getTarget(filename)
    values = readlines(filename*".txt")
    values = split(values[1], ':')
    values = values[2]
    values = split(values, ',')
    xstring = values[1]
    xstring = split(xstring, '=')
    xstring = xstring[2]
    xstring = split(xstring, "..")
    x1 = parse(Int, xstring[1])
    x2 = parse(Int, xstring[2])
    ystring = values[2]
    ystring = split(ystring, '=')
    ystring = ystring[2]
    ystring = split(ystring, "..")
    y1 = parse(Int, ystring[1])
    y2 = parse(Int, ystring[2])

    return (x1,x2), (y1, y2)
end

function step((x,y), (vx, vy))
    newx = x + vx
    newy = y + vy
    newvx = vx - sign(vx)
    newvy = vy - 1
    return (newx, newy), (newvx, newvy)
end

function checkTrajectory(startpos, startv, target)
    v = startv
    pos = startpos
    maxy = pos[2]
    valid = false
    while (pos[2] >= target[2][1] && pos[1] <= target[1][2])         
        pos, v = step(pos, v)
        if pos[2] > maxy
            maxy = pos[2]
        end
        if pos[1] >= target[1][1] && pos[1] <= target[1][2] && pos[2] >= target[2][1] && pos[2] <= target[2][2]
            valid = true
        end
    end
    return valid, maxy
end

function solve(filename)
    xtarget, ytarget = getTarget(filename)
    pos = (0,0)
    maxy = 0
    optv = (1,1)
    valcount = 0
    for vx in -1000:1000
        for vy in -1000:1000
            v = (vx, vy)
            valid, my = checkTrajectory(pos, v, (xtarget, ytarget))
            if valid == true && my > maxy
                maxy = my
                optv = v
            end
            if valid == true
                valcount += 1
            end
        end
    end
    println(maxy)
    println(optv)
    println(valcount)
end

solve("input")
#solve("example")