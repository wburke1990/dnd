function onload()
    --Right Arrow
    self.createButton({
        label=string.char(8594), click_function="next", function_owner=self, color= {1,1,1},
        position={0.654,0.2,-1.208}, rotation={0,0,0}, height=80, width=120, font_size=50, font_color={0,0,0},
    })
    --Left Arrow
    self.createButton({
        label=string.char(8592), click_function="back", function_owner=self, color= {1,1,1}, 
        position={-0.248,0.2,-1.208}, rotation={0,0,0}, height=80, width=120, font_size=50, font_color={0,0,0},
    })
end

--Go to right object state
function next()
    self.setState(3)
end

--Go to left object state
function back()
    self.setState(1)
end