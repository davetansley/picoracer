titlescreen = {
    showfor=300,
    timer=0 
}

function titlescreen:init()
    -- set state functions
    update=function ()
        titlescreen:update()
    end
    draw=function ()
        titlescreen:draw()
    end
end

function titlescreen:update()
    if (btnp(5)) game:init()
end

function titlescreen:draw()
    cls(0)
    print("press ❎ to start",30,120,7)
end

