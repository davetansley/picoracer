game = {
    horizon=70,
    stripeoffsets={0,0,0}, -- 1 for grass, 2 for verge, 3 forstripe
    speed=0,
    bend=0
}

function game:init()
    -- set state functions
    update=function ()
        game:update()
    end
    draw=function ()
        game:draw()
    end
xm=128
ym=32
    cls(0)
end

function game:update()

    if btn(0) 
    then 
        self.bend+=0.01
        self.bend=self.bend>=1 and 1 or self.bend
    end
    if btn(1) 
    then 
        self.bend-=0.01
        self.bend=self.bend<=-1 and -1 or self.bend
    end
    if btnp(2) 
    then 
        self.speed=self.speed>=10 and 10 or self.speed+1
    end
    if btnp(3) 
    then 
        self.speed=self.speed<=0 and 0 or self.speed-1
    end

end

function game:draw()
--    self:draw_sin()
printh("draw")
    self:draw_sky()
    self:draw_road()
    print("speed: "..self.speed,4,4,0)
    print("bend: "..self.bend,4,11,0)
end

p8cos = cos function cos(angle) return p8cos(angle/(3.1415*2)) end
p8sin = sin function sin(angle) return -p8sin(angle/(3.1415*2)) end

function game:draw_sin()
    cls(0)
    if btn(0) 
    then 
        --xm+=1
        ym-=1
    end
    if btn(1) 
    then 
        --xm-=1
        ym+=1
    end

    for x=1,128,1 do
        y=y*20
        printh(x0)
        pset(x,y+64,7)
        pset(x,64)
    end

end

-- Screen elements
function game:draw_sky()
    rectfill(0,0,127,self.horizon-1,12)
end

function game:get_color(value, position, length, c1, c2)
    local x0 = abs(value/length) 
    local x1 = 2*((1-1.5*x0)^2+0.01*position)
    local y = p8sin (x1)
return y<=0 and c2 or c1
    
end

-- start at the bottom of the screen
-- draw one line, consisting of: grass, verge, road, verge, grass
-- move up
function game:draw_road()

    local roadwidthhalf,vergewidth,stripewidth,roadcentre,grassstripe,vergestripe,centrestripe = 40,10,4,64,self.stripeoffsets[1],self.stripeoffsets[2],self.stripeoffsets[3]
    local vergelength,stripelength,grasslength = 100,100,100

    -- recalculate initial offsets for next frame
    self.stripeoffsets[1]=self.stripeoffsets[1]>=grasslength and 0 or self.stripeoffsets[1]+self.speed
    self.stripeoffsets[2]=self.stripeoffsets[2]>=vergelength and 0 or self.stripeoffsets[2]+self.speed
    self.stripeoffsets[3]=self.stripeoffsets[3]>=stripelength and 0 or self.stripeoffsets[3]+self.speed

    local pos = -1 * (128-self.horizon)
    for y=128,self.horizon,-1 do 
    
        -- work out bend offset for this row - at bottom of screen, will be zero
        -- left is negative, right is positive
        local mult = (128-y)/(128-self.horizon)
        mult = mult^3
        local bendoffset = mult * self.bend * 100

        -- 0 - -(128-self.horizon)
        printh(pos)
        local grasscolour = self:get_color(pos,grassstripe, grasslength, 3, 11)
        local vergecolour = self:get_color(pos,vergestripe, vergelength, 7, 8)
        local stripecolor = self:get_color(pos,centrestripe, stripelength, 5, 7)
        pos += 1

        for x=0,127 do
            local colour 
            if x < roadcentre-roadwidthhalf-vergewidth+bendoffset
            then
                colour = grasscolour
            elseif x < roadcentre-roadwidthhalf+bendoffset 
            then 
                colour = vergecolour 
            elseif x < roadcentre+roadwidthhalf+bendoffset
            then
                if x < roadcentre+stripewidth/2+bendoffset and x >= roadcentre-stripewidth/2+bendoffset
                then
                    colour = stripecolor
                else
                    colour = 5 --road
                end
            elseif x < roadcentre+roadwidthhalf+vergewidth+bendoffset 
            then 
                colour = vergecolour
            else 
                colour = grasscolour
            end
            pset(x,y,colour)
        end

        -- decrease width for perspective
        roadwidthhalf-=0.35
        vergewidth-=0.1    

    end

end
