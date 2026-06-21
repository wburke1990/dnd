lh, pCol, sX, sY = nil, nil, nil, nil
function onDropped()
    local selfScale = self.getScale()
    sX, sY = math.ceil(selfScale.x*180), math.ceil(selfScale.z*180)
end
function onPickedUp()
    pCol = self.held_by_color
    if math.abs(Player[pCol].lift_height - 0.03) > 0.005 then
        lh = Player[pCol].lift_height
    end
    Player[pCol].lift_height = 0.03
end
local function returnLiftHeight()
    if pCol and lh then
        Player[pCol].lift_height = lh
        pCol, lh = nil, nil
    end
end
function onCollisionEnter() returnLiftHeight() end
function onDestroy() returnLiftHeight() end
