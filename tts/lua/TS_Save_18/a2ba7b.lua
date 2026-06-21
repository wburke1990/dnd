function onload()
    axis = 1
    xMod = 90
    yMod = 0
    zMod = 0
    record = {}
    self.createButton({
        label="Lay\nDown", click_function="layDown", function_owner=self,
        position={0,0.15,-0.3}, width=1600, height=1300, font_size=350
    })
    self.createButton({
        label="Axis: X", click_function="changeAxis", function_owner=self,
        position={0,0.15,1.45}, width=1200, height=300, font_size=200
    })
end

function onObjectPickedUp(color, object)
    record[color] = object
end

function changeAxis()
    if     axis == 1 then xMod=0 yMod=90 zMod=0 axis=2 updateButton("Y")
    elseif axis == 2 then xMod=0 yMod=0 zMod=90 axis=3 updateButton("Z")
    elseif axis == 3 then xMod=-90 yMod=0 zMod=0 axis=4 updateButton("-X")
    elseif axis == 4 then xMod=0 yMod=-90 zMod=0 axis=5 updateButton("-Y")
    elseif axis == 5 then xMod=0 yMod=0 zMod=-90 axis=6 updateButton("-Z")
    elseif axis == 6 then xMod=90 yMod=0 zMod=0 axis=1 updateButton("X")
    end
end

function updateButton(axisName)
    self.editButton({index=1, label="Axis: "..axisName})
end

function layDown(o, colorClicked)
    if record[colorClicked] then
        local targetObject = record[colorClicked]
        local targetRotation = targetObject.getRotation()
        local targetRotX = targetRotation.x + xMod
        local targetRotY = targetRotation.y + yMod
        local targetRotZ = targetRotation.z + zMod
        targetObject.setRotationSmooth({targetRotX, targetRotY, targetRotZ})
    else
        printToColor("No record of last object held.", colorClicked, {0.8, 0.8, 0.8})
    end
end
