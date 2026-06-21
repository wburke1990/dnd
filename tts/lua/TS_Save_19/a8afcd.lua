isFromTTT = true
tttEffectLabel = 'rainSound'

parentGuidString = "3b705d"

function onObjectDestroy(object)
    if self != nil and object != nil and object.getGUID() != nil and ("" .. object.getGUID()) == parentGuidString then self.destruct() end
end

