titleText, headerText, subHeaderText, footerText, noteText, noteTrueText = ""
attributesText, attributesTrueText, statsText, statsTrueText, traitsText, traitsTrueText, challengeRating = ""
strScore,dexScore,conScore,intScore,wisScore,chaScore = ""
strMod,dexMod,conMod,intMod,wisMod,chaMod = ""
strSave,dexSave,conSave,intSave,wisSave,chaSave = ""

function onLoad(saved_data)
    saved_data = JSON.decode(saved_data)
    titleText = saved_data.tt
    headerText = saved_data.ht
    subHeaderText = saved_data.sht
    footerText = saved_data.ft
    noteText = saved_data.nt
    noteTrueText = saved_data.ntt
    
    attributesText = saved_data.at
    attributesTrueText = saved_data.att
    statsText = saved_data.st
    statsTrueText = saved_data.stt
    traitsText = saved_data.tst
    traitsTrueText = saved_data.ttt
    challengeRating = saved_data.cr

    strScore = saved_data.str
    dexScore = saved_data.dex
    conScore = saved_data.con
    intScore = saved_data.int
    wisScore = saved_data.wis
    chaScore = saved_data.cha

    strMod = saved_data.str1
    dexMod = saved_data.dex1
    conMod = saved_data.con1
    intMod = saved_data.int1
    wisMod = saved_data.wis1
    chaMod = saved_data.cha1

    strSave = saved_data.str2
    dexSave = saved_data.dex2
    conSave = saved_data.con2
    intSave = saved_data.int2
    wisSave = saved_data.wis2
    chaSave = saved_data.cha2

    Wait.frames(function()
        self.UI.setAttribute("TitleId", "text", titleText)
        self.UI.setAttribute("HeaderId", "text", headerText)
        self.UI.setAttribute("SubHeaderId", "text", subHeaderText)
        self.UI.setAttribute("FooterId", "text", footerText)

        self.UI.setAttribute("InputId", "text", noteText)
        self.UI.setValue("InputTextId", formatWords(noteText))

        self.UI.setAttribute("AttributesId", "text", attributesText)
        self.UI.setValue("AttributesTextId", formatWords(noteText))
        
        self.UI.setAttribute("StatsId", "text", statsText)
        self.UI.setValue("StatsTextId", formatWords(noteText))

        self.UI.setAttribute("TraitsId", "text", traitsText)
        self.UI.setValue("TraitsTextId", formatWords(noteText))

        self.UI.setAttribute("ChallengeRatingId", "text", challengeRating)

        self.UI.setAttribute("StrScoreId", "text", strScore)
        self.UI.setAttribute("DexScoreId", "text", dexScore)
        self.UI.setAttribute("ConScoreId", "text", conScore)
        self.UI.setAttribute("IntScoreId", "text", intScore)
        self.UI.setAttribute("WisScoreId", "text", wisScore)
        self.UI.setAttribute("ChaScoreId", "text", chaScore)

        self.UI.setAttribute("StrModId", "text", strMod)
        self.UI.setAttribute("DexModId", "text", dexMod)
        self.UI.setAttribute("ConModId", "text", conMod)
        self.UI.setAttribute("IntModId", "text", intMod)
        self.UI.setAttribute("WisModId", "text", wisMod)
        self.UI.setAttribute("ChaModId", "text", chaMod)

        self.UI.setAttribute("StrSaveId", "text", strSave)
        self.UI.setAttribute("DexSaveId", "text", dexSave)
        self.UI.setAttribute("ConSaveId", "text", conSave)
        self.UI.setAttribute("IntSaveId", "text", intSave)
        self.UI.setAttribute("WisSaveId", "text", wisSave)
        self.UI.setAttribute("ChaSaveId", "text", chaSave)

        saved_data = { 
            tt= self.UI.setAttribute("TitleId", "text", titleText),
            ht= self.UI.setAttribute("HeaderId", "text", headerText),
            sht= self.UI.setAttribute("SubHeaderId", "text", subHeaderText),
            ft= self.UI.setAttribute("FooterId", "text", footerText),

            nt= self.UI.setAttribute("InputId", "text", noteText),
            ntt= self.UI.setValue("InputTextId", formatWords(noteText)),

            at= self.UI.setAttribute("AttributesId", "text", attributesText),
            att= self.UI.setValue("AttributesTextId", formatWords(attributesText)),
            
            st= self.UI.setAttribute("StatsId", "text", statsText),
            stt= self.UI.setValue("StatsTextId", formatWords(statsText)),

            tst= self.UI.setAttribute("TraitsId", "text", traitsText),
            ttt= self.UI.setValue("TraitsTextId", formatWords(traitsText)),

            cr= self.UI.setAttribute("ChallengeRatingId", "text", challengeRating),

            str= self.UI.setAttribute("StrScoreId", "text", strScore),
            dex= self.UI.setAttribute("DexScoreId", "text", dexScore),
            con= self.UI.setAttribute("ConScoreId", "text", conScore),
            int= self.UI.setAttribute("IntScoreId", "text", intScore),
            wis= self.UI.setAttribute("ChaScoreId", "text", chaScore),
            cha= self.UI.setAttribute("ChaScoreId", "text", chaScore),

            str1= self.UI.setAttribute("StrModId", "text", strMod),
            dex1= self.UI.setAttribute("DexModId", "text", dexMod),
            con1= self.UI.setAttribute("ConModId", "text", conMod),
            int1= self.UI.setAttribute("IntModId", "text", intMod),
            wis1= self.UI.setAttribute("ChaModId", "text", chaMod),
            cha1= self.UI.setAttribute("ChaModId", "text", chaMod),

            str2= self.UI.setAttribute("StrSaveId", "text", strSave),
            dex2= self.UI.setAttribute("DexSaveId", "text", dexSave),
            con2= self.UI.setAttribute("ConSaveId", "text", conSave),
            int2= self.UI.setAttribute("IntSaveId", "text", intSave),
            wis2= self.UI.setAttribute("ChaSaveId", "text", chaSave),
            cha2= self.UI.setAttribute("ChaSaveId", "text", chaSave),
        }

        self.script_state = JSON.encode(saved_data)
        lockUnlock()
    end, 5)

end

function onSave()
    saved_data = {
        tt=titleText, ht=headerText, sht=subHeaderText, ft=footerText,
        nt=noteText, ntt=noteTrueText, 
        at=attributesText, att=attributesTrueText, 
        st=statsText, stt=statsTrueText,
        tst=traitsText, ttt=traitsTrueText,
        cr=challengeRating,
        str=strScore,dex=dexScore,con=conScore,int=intScore,wis=wisScore,cha=chaScore,
        str1=strMod,dex1=dexMod,con1=conMod,int1=intMod,wis1=wisMod,cha1=chaMod,
        str2=strSave,dex2=dexSave,con2=conSave,int2=intSave,wis2=wisSave,cha2=chaSave,
    }
    return JSON.encode(saved_data)
end

function inputEndEdit(player, value, id)
    if id == "TitleId" then
        titleText = value
        save_data = {tt=titleText}
        self.UI.setAttribute("titleText", "text", value)
    elseif id == "HeaderId" then
        headerText = value
        save_data = {ht=headerText}
        self.UI.setAttribute("headerText", "text", value)
    elseif id == "SubHeaderId" then
        subHeaderText = value
        save_data = {sht=subHeaderText}
        self.UI.setAttribute("headerText", "text", value)
    elseif id == "FooterId" then
        footerText = value
        save_data = {ft=footerText}
        self.UI.setAttribute("headerText", "text", value)
    elseif id == "InputId" then
        noteText = value
        noteTrueText = formatWords(value)
        save_data = { nt=noteText, ntt=noteTrueText }
        self.UI.setAttribute("InputId", "text", noteText)
        self.UI.setValue("InputTextId", noteTrueText)
    elseif id == "AttributesId" then
        attributesText = value
        attributesTrueText = formatWords(value)
        save_data = { at=attributesText, att=attributesTrueText }
        self.UI.setAttribute("AttributesId", "text", attributesText)
        self.UI.setValue("AttributesTextId", attributesTrueText)
    elseif id == "StatsId" then
        statsText = value
        statsTrueText = formatWords(value)
        save_data = { st=statsText, stt=statsTrueText }
        self.UI.setAttribute("StatsId", "text", statsText)
        self.UI.setValue("StatsTextId", statsTrueText)
    elseif id == "TraitsId" then
        traitsText = value
        traitsTrueText = formatWords(value)
        save_data = { tst=traitsText, ttt=traitsTrueText }
        self.UI.setAttribute("TraitsId", "text", traitsText)
        self.UI.setValue("TraitsTextId", traitsTrueText)

    elseif id == "ChallengeRatingId" then
        challengeRating = value
        save_data = {cr=challengeRating}
        self.UI.setAttribute("challengeRating", "text", value)

    elseif id == "StrScoreId" then
        strScore = value
        save_data = {str=strScore}
        self.UI.setAttribute("strScore", "text", value)
    elseif id == "DexScoreId" then
        dexScore = value
        save_data = {dex=dexScore}
        self.UI.setAttribute("dexScore", "text", value)
    elseif id == "ConScoreId" then
        conScore = value
        save_data = {con=conScore}
        self.UI.setAttribute("conScore", "text", value)
    elseif id == "IntScoreId" then
        intScore = value
        save_data = {int=intScore}
        self.UI.setAttribute("intScore", "text", value)
    elseif id == "WisScoreId" then
        wisScore = value
        save_data = {wis=wisScore}
        self.UI.setAttribute("wisScore", "text", value)
    elseif id == "ChaScoreId" then
        chaScore = value
        save_data = {cha=chaScore}
        self.UI.setAttribute("chaScore", "text", value)

    elseif id == "StrModId" then
        strMod = value
        save_data = {str=strMod}
        self.UI.setAttribute("strMod", "text", value)
    elseif id == "DexModId" then
        dexMod = value
        save_data = {dex=dexMod}
        self.UI.setAttribute("dexMod", "text", value)
    elseif id == "ConModId" then
        conMod = value
        save_data = {str=conMod}
        self.UI.setAttribute("conMod", "text", value)
    elseif id == "IntModId" then
        intMod = value
        save_data = {str=intMod}
        self.UI.setAttribute("intMod", "text", value)
    elseif id == "WisModId" then
        wisMod = value
        save_data = {wis=wisMod}
        self.UI.setAttribute("wisMod", "text", value)
    elseif id == "ChaModId" then
        chaMod = value
        save_data = {cha=chaMod}
        self.UI.setAttribute("chaMod", "text", value)

    elseif id == "StrSaveId" then
        strSave = value
        save_data = {str2=strSave}
        self.UI.setAttribute("strSave", "text", value)
    elseif id == "DexSaveId" then
        dexSave = value
        save_data = {dex2=dexSave}
        self.UI.setAttribute("dexSave", "text", value)
    elseif id == "ConSaveId" then
        conSave = value
        save_data = {con2=conSave}
        self.UI.setAttribute("conSave", "text", value)
    elseif id == "IntSaveId" then
        intSave = value
        save_data = {int2=intSave}
        self.UI.setAttribute("intSave", "text", value)
    elseif id == "WisSaveId" then
        wisSave = value
        save_data = {wis2=wisSave}
        self.UI.setAttribute("wisSave", "text", value)
    elseif id == "ChaSaveId" then
        chaSave = value
        save_data = {cha2=chaSave}
        self.UI.setAttribute("chaSave", "text", value)
    end

    --Saves state for onLoad()
    self.script_state = JSON.encode(save_data)
end

--True means button is on / locked.
editState = "True"

--Lock / Unlock button
function lockUnlock(player, isOn)
    if isOn == "False" then
        editState = "True"
        self.UI.setAttribute("LockId", "text", "Unlocked")
        self.UI.setAttribute("LockId", "color", "rgba{0,0.8, 0.4, 100}")
        self.UI.setAttribute("LockId", "textColor", "White")
        self.UI.setAttribute("TitleId", "interactable", "True")
        self.UI.setAttribute("HeaderId", "interactable", "True")
        self.UI.setAttribute("SubHeaderId", "interactable", "True")
        self.UI.setAttribute("FooterId", "interactable", "True")

        self.UI.setAttribute("InputId", "interactable", "True")
        self.UI.setAttribute("AttributesId", "interactable", "True")
        self.UI.setAttribute("StatsId", "interactable", "True")
        self.UI.setAttribute("TraitsId", "interactable", "True")
        self.UI.setAttribute("ChallengeRatingId", "interactable", "True")

        self.UI.setAttribute("StrScoreId", "interactable", "True")
        self.UI.setAttribute("DexScoreId", "interactable", "True")
        self.UI.setAttribute("ConScoreId", "interactable", "True")
        self.UI.setAttribute("IntScoreId", "interactable", "True")
        self.UI.setAttribute("WisScoreId", "interactable", "True")
        self.UI.setAttribute("ChaScoreId", "interactable", "True")

        self.UI.setAttribute("StrModId", "interactable", "True")
        self.UI.setAttribute("DexModId", "interactable", "True")
        self.UI.setAttribute("ConModId", "interactable", "True")
        self.UI.setAttribute("IntModId", "interactable", "True")
        self.UI.setAttribute("WisModId", "interactable", "True")
        self.UI.setAttribute("ChaModId", "interactable", "True")

        self.UI.setAttribute("StrSaveId", "interactable", "True")
        self.UI.setAttribute("DexSaveId", "interactable", "True")
        self.UI.setAttribute("ConSaveId", "interactable", "True")
        self.UI.setAttribute("IntSaveId", "interactable", "True")
        self.UI.setAttribute("WisSaveId", "interactable", "True")
        self.UI.setAttribute("ChaSaveId", "interactable", "True")

        --Main Actions
        self.UI.setAttribute("InputId", "position", "-210 55 -40")
        self.UI.setAttribute("InputId", "width", "2000")
        self.UI.setAttribute("InputId", "height", "1900")

        --AC, HP, Speed
        self.UI.setAttribute("AttributesId", "position", "180 -110 -40")
        self.UI.setAttribute("AttributesId", "width", "1400")
        self.UI.setAttribute("AttributesId", "height", "225")

        --Initiative, XP
        self.UI.setAttribute("StatsId", "position", "-145 -110 -40")
        self.UI.setAttribute("StatsId", "width", "700")
        self.UI.setAttribute("StatsId", "height", "225")

        --Damages, Senses, Lanugages
        self.UI.setAttribute("TraitsId", "position", "180 -55 -40")
        self.UI.setAttribute("TraitsId", "width", "1400")
        self.UI.setAttribute("TraitsId", "height", "375")

    elseif isOn == "True" then
        editState = "False"
        self.UI.setAttribute("LockId", "text", "Locked")
        self.UI.setAttribute("LockId", "color", "rgba{1,0, 0, 100}")
        self.UI.setAttribute("LockId", "textColor", "White")
        self.UI.setAttribute("TitleId", "interactable", "False")
        self.UI.setAttribute("HeaderId", "interactable", "False")
        self.UI.setAttribute("SubHeaderId", "interactable", "False")
        self.UI.setAttribute("FooterId", "interactable", "False")

        self.UI.setAttribute("InputId", "interactable", "False")
        self.UI.setAttribute("AttributesId", "interactable", "False")
        self.UI.setAttribute("StatsId", "interactable", "False")
        self.UI.setAttribute("TraitsId", "interactable", "False")
        self.UI.setAttribute("ChallengeRatingId", "interactable", "False")

        self.UI.setAttribute("StrScoreId", "interactable", "False")
        self.UI.setAttribute("DexScoreId", "interactable", "False")
        self.UI.setAttribute("ConScoreId", "interactable", "False")
        self.UI.setAttribute("IntScoreId", "interactable", "False")
        self.UI.setAttribute("WisScoreId", "interactable", "False")
        self.UI.setAttribute("ChaScoreId", "interactable", "False")
        
        self.UI.setAttribute("StrModId", "interactable", "False")
        self.UI.setAttribute("DexModId", "interactable", "False")
        self.UI.setAttribute("ConModId", "interactable", "False")
        self.UI.setAttribute("IntModId", "interactable", "False")
        self.UI.setAttribute("WisModId", "interactable", "False")
        self.UI.setAttribute("ChaModId", "interactable", "False")

        self.UI.setAttribute("StrSaveId", "interactable", "False")
        self.UI.setAttribute("DexSaveId", "interactable", "False")
        self.UI.setAttribute("ConSaveId", "interactable", "False")
        self.UI.setAttribute("IntSaveId", "interactable", "False")
        self.UI.setAttribute("WisSaveId", "interactable", "False")
        self.UI.setAttribute("ChaSaveId", "interactable", "False")

        self.UI.setAttribute("InputId", "position", "0 20 -40")
        self.UI.setAttribute("InputId", "width", "10")
        self.UI.setAttribute("InputId", "height", "10")

        self.UI.setAttribute("AttributesId", "position", "0 -165 -40")
        self.UI.setAttribute("AttributesId", "width", "10")
        self.UI.setAttribute("AttributesId", "height", "10") 

        self.UI.setAttribute("StatsId", "position", "0 -165 -40")
        self.UI.setAttribute("StatsId", "width", "10")
        self.UI.setAttribute("StatsId", "height", "10") 

        self.UI.setAttribute("TraitsId", "position", "0 -165 -40")
        self.UI.setAttribute("TraitsId", "width", "10")
        self.UI.setAttribute("TraitsId", "height", "10")
    end
end

function formatWords(inputText)
    -- Define a list of words and their corresponding colors.
    local coloredWords = {
        --Damage Types
        ["Acid%f[%W]"] = "<textcolor color=\"#9ac623\">" .. "<b>Ά Acid</b>" .. "</textcolor>",
        ["Cold%f[%W]"] = "<textcolor color=\"#33a8d9\">" .. "<b>Έ Cold</b>" .. "</textcolor>",
        ["Fire%f[%W]"] = "<textcolor color=\"#e65818\">" .. "<b>Ή Fire</b>" .. "</textcolor>",
        ["Force%f[%W]"] = "<textcolor color=\"#ce373b\">" .. "<b>Ί Force</b>" .. "</textcolor>",
        ["Lightning%f[%W]"] = "<textcolor color=\"#2c5fd0\">" .. "<b>Ό Lightning</b>" .. "</textcolor>",
        ["Necrotic%f[%W]"] = "<textcolor color=\"#3fa863\">" .. "<b>Ύ Necrotic</b>" .. "</textcolor>",
        ["Poison%f[%W]"] = "<textcolor color=\"#9730a6\">" .. "<b>Ώ Poison</b>" .. "</textcolor>",
        ["Psychic%f[%W]"] = "<textcolor color=\"#ed4cba\">" .. "<b>ΐ Psychic</b>" .. "</textcolor>",
        ["Radiant%f[%W]"] = "<textcolor color=\"#e6a620\">" .. "<b>Α Radiant</b>" .. "</textcolor>",
        ["Thunder%f[%W]"] = "<textcolor color=\"#8450dd\">" .. "<b>Β Thunder</b>" .. "</textcolor>",
        ["Bludgeoning%f[%W]"] = "<textcolor color=\"#8c6239\">" .. "<b>Γ Bludgeoning</b>" .. "</textcolor>",
        ["Piercing%f[%W]"] = "<textcolor color=\"#998675\">" .. "<b>Δ Piercing</b>" .. "</textcolor>",
        ["Slashing%f[%W]"] = "<textcolor color=\"#808080\">" .. "<b>Ε Slashing</b>" .. "</textcolor>",

        --Misc
        ["Hit Points%f[%W]"] = "<textcolor color=\"#dc402b\">" .. "<b>Ζ Hit Points</b>" .. "</textcolor>",
        ["HP%f[%W]"] = "<textcolor color=\"#dc402b\">" .. "<b>Ζ HP</b>" .. "</textcolor>",
        ["Hit Dice%f[%W]"] = "<textcolor color=\"#dc402b\">" .. "<b>Η Hit Dice</b>" .. "</textcolor>",
        ["Hit Die%f[%W]"] = "<textcolor color=\"#dc402b\">" .. "<b>Η Hit Dice</b>" .. "</textcolor>",
        ["Armor Class%f[%W]"] = "<textcolor color=\"#0075ec\">" .. "<b>Θ Armor Class</b>" .. "</textcolor>",
        ["AC%f[%W]"] = "<textcolor color=\"#0075ec\">" .. "<b>Θ AC</b>" .. "</textcolor>",
        ["Temporary hit points%f[%W]"] = "<textcolor color=\"#e9623e\">" .. "<b>Ι Temporary hit points</b>" .. "</textcolor>",
        ["BP%f[%W]"] = "•",

        --Money
        ["CP%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "<b>%1</b>" .. "</textcolor>",
        ["SP%f[%W]"] = "<textcolor color=\"#8797a8\">" .. "<b>%1</b>" .. "</textcolor>",
        ["EP%f[%W]"] = "<textcolor color=\"#ca9e47\">" .. "<b>%1</b>" .. "</textcolor>",
        ["GP%f[%W]"] = "<textcolor color=\"#ebb137\">" .. "<b>%1</b>" .. "</textcolor>",
        ["PP%f[%W]"] = "<textcolor color=\"#c4b3c6\">" .. "<b>%1</b>" .. "</textcolor>",

        --Abilities
        ["Strength%f[%W]"] = "<textcolor color=\"#c92f32\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Athletics%f[%W]"] = "<textcolor color=\"#c92f32\">" .. "<b>%1</b>" .. "</textcolor>",
        ["Dexterity%f[%W]"] = "<textcolor color=\"#009d60\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Acrobatics%f[%W]"] = "<textcolor color=\"#009d60\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Sleight of Hand%f[%W]"] = "<textcolor color=\"#009d60\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Stealth%f[%W]"] = "<textcolor color=\"#009d60\">" .. "<b>%1</b>" .. "</textcolor>",
        ["Constitution%f[%W]"] = "<textcolor color=\"#e9623e\">" .. "<b>%1</b>" .. "</textcolor>",
        ["Intelligence%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Arcana%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "<b>%1</b>" .. "</textcolor>",
            ["History%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Investigation%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Nature%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Religion%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "<b>%1</b>" .. "</textcolor>",
        ["Wisdom%f[%W]"] = "<textcolor color=\"#f0ae0e\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Animal Handling%f[%W]"] = "<textcolor color=\"#f0ae0e\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Insight%f[%W]"] = "<textcolor color=\"#f0ae0e\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Medicine%f[%W]"] = "<textcolor color=\"#f0ae0e\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Perception%f[%W]"] = "<textcolor color=\"#f0ae0e\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Survival%f[%W]"] = "<textcolor color=\"#f0ae0e\">" .. "<b>%1</b>" .. "</textcolor>",
        ["Charisma%f[%W]"] = "<textcolor color=\"#e964c2\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Deception%f[%W]"] = "<textcolor color=\"#e964c2\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Intimidation%f[%W]"] = "<textcolor color=\"#e964c2\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Performance%f[%W]"] = "<textcolor color=\"#e964c2\">" .. "<b>%1</b>" .. "</textcolor>",
            ["Persuasion%f[%W]"] = "<textcolor color=\"#e964c2\">" .. "<b>%1</b>" .. "</textcolor>",
        ["Spell Slot%f[%W]"] = "<textcolor color=\"#5f63f7\">" .. "<b>/ Spell Slot</b>" .. "</textcolor>",
        
        --Actions
        ["Actions%f[%W]"] =             "<textsize size=\"70\"><textcolor color=\"#0ea932\"><b>" .. "Κ Actions</b>" .. "</textcolor></textsize>",
        ["Legendary actions%f[%W]"] =   "<textsize size=\"70\"><textcolor color=\"#f0ae0e\"><b>".. "Κ Legendary actions</b>" .. "</textcolor></textsize>",
        ["Regional effects%f[%W]"] =   "<textsize size=\"70\"><textcolor color=\"#ee502c\"><b>".. string.char(9751) .. " Regional effects</b>" .. "</textcolor></textsize>",
        ["Traits%f[%W]"] =              "<textsize size=\"70\"><textcolor color=\"#23adcc\"><b>" .. string.char(9733) .." Traits</b>" .. "</textcolor></textsize>",
        ["Bonus actions%f[%W]"] =       "<textsize size=\"70\"><textcolor color=\"#f88c23\"><b>" .. "Λ Bonus actions</b>" .. "</textcolor></textsize>",
        ["Reactions%f[%W]"] =           "<textsize size=\"70\"><textcolor color=\"#ea3da2\"><b>" .. "Μ Reactions</b>" .. "</textcolor></textsize>",

        ["Action%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "<b>Κ Action</b>" .. "</textcolor>",
        ["Attack action%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "<b>Κ Attack</b> " .. "</textcolor>" .. "action",
        ["Dodge%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "<b>Κ Dodge</b>" .. "</textcolor>",
        ["Dash%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "<b>Κ Dash</b>" .. "</textcolor>",
        ["Disengage%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "<b>Κ Disengage</b>" .. "</textcolor>",
        ["Help%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "<b>Κ Help</b>" .. "</textcolor>",
        ["Hide%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "<b>Κ Hide</b>" .. "</textcolor>",
        ["Influence%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "<b>Κ Influence</b>" .. "</textcolor>",
        ["Magic%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "<b>Κ Magic</b>" .. "</textcolor>",
        ["Ready%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "<b>Κ Ready</b>" .. "</textcolor>",
        ["Search%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "<b>Κ Search</b>" .. "</textcolor>",
        ["Study%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "<b>Κ Study</b>" .. "</textcolor>",
        ["Utilize%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "<b>Κ Utilize</b>" .. "</textcolor>",
        ["Linebreak%f[%W]"] = "<textsize size=\"70\"><b>" .. string.char(8212) .. 
        string.char(8212) .. string.char(8212) .. string.char(8212) .. string.char(8212) ..
        string.char(8212) .. string.char(8212) .. string.char(8212) .. string.char(8212) ..
        string.char(8212) .. string.char(8212) .. string.char(8212) .. string.char(8212) ..
        string.char(8212) .. string.char(8212) .. string.char(8212) .. string.char(8212) ..
        string.char(8212) .. string.char(8212) .. string.char(8212) .. string.char(8212) ..
        string.char(8212) .. string.char(8212) .. string.char(8212) .. string.char(8212) ..
        string.char(8212) .. string.char(8212) .. string.char(8212) .. string.char(8212) .. "</b></textsize>",

        --Other Actions
        ["Bonus action%f[%W]"] = "<textcolor color=\"#f88c23\">" .. "<b>Λ Bonus action</b>" .. "</textcolor>",
        ["Reaction%f[%W]"] = "<textcolor color=\"#ea3da2\">" .. "<b>Μ Reaction</b>" .. "</textcolor>",
        ["Opportunity attack%f[%W]"] = "<textcolor color=\"#ea3da2\">" .. "<b>Μ Opportunity attack</b>" .. "</textcolor>",
        ["Movement%f[%W]"] = "<textcolor color=\"#e8b20e\">" .. "<b>Ν Movement</b>" .. "</textcolor>",
        ["Pulled%f[%W]"] = "<textcolor color=\"#e9623e\">" .. "<b>Ν Pulled</b>" .. "</textcolor>",
        ["Pushed%f[%W]"] = "<textcolor color=\"#e9623e\">" .. "<b>Ν Pushed</b>" .. "</textcolor>",
        ["Transport%f[%W]"] = "<textcolor color=\"#e9623e\">" .. "<b>Ν Transport</b>" .. "</textcolor>",
        ["Teleport%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "<b>Ν Teleport</b>" .. "</textcolor>",
        ["Spell Slot%f[%W]"] = "<textcolor color=\"#5f63f7\">" .. "<b>Ξ Spell Slot</b>" .. "</textcolor>",
        
        --No Icons
        ["Advantage%f[%W]"] = "<textcolor color=\"#00a651\">" .. "%1" .. "</textcolor>",
        ["Disadvantage%f[%W]"] = "<textcolor color=\"#ef3d43\">" .. "%1" .. "</textcolor>",
        ["Proficiency Bonus%f[%W]"] = "<textcolor color=\"#16b47e\">" .. "%1" .. "</textcolor>",
        ["Skill%f[%W]"] = "<textcolor color=\"#16b47e\">" .. "%1" .. "</textcolor>",
        
        --Rules
        ["Initiative%f[%W]"] = "<textcolor color=\"#009d60\">" .. "<b>!! Initiative</b>" .. "</textcolor>",
        ["Resistance%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Vulnerable%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Immune%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Inspiration%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Concentration%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Short Rest%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Long Rest%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Unarmed Strike%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["D20 Test%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Ritual%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Long Jump%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["High Jump%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Lightly Obscured%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Heavily Obscured%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Bright Light%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Dim Light%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Armor Training%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Challenge Rating%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Darkness%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Friendly%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Hostile%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Indifferent%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Carrying Capacity%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Total Cover%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Half Cover%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Three Quarters Cover%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Difficult Terrain%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Expertise%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Hover%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Shape Shift%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",

        --Conditions
        ["XP%f[%W]"] = "<b>" .. "%1" .. "</b>",
        ["Gear%f[%W]"] = "<b>" .. "%1" .. "</b>",
        ["PB%f[%W]"] = "<b>" .. "%1" .. "</b>",
        ["Skills%f[%W]"] = "<b>" .. "%1" .. "</b>",
        ["Senses%f[%W]"] = "<b>" .. "%1" .. "</b>",
        ["Languages%f[%W]"] = "<b>" .. "%1" .. "</b>",
        ["Immunities%f[%W]"] = "<b>" .. "%1" .. "</b>",
        ["Resistances%f[%W]"] = "<b>" .. "%1" .. "</b>",
        ["Vulnerablities%f[%W]"] = "<b>" .. "%1" .. "</b>",

        ["Blinded%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Charmed%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Deafened%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Frightened%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Grappled%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Incapacitated%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Invisible%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Paralyzed%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Petrified%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Poisoned%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Prone%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Restrained%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Stunned%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Unconscious%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",
        ["Exhaustion%f[%W]"] = "<textcolor color=\"#fe6678\"><i>" .. "%1" .. "</i></textcolor>",

        --Spell Schools
        ["Abjuration%f[%W]"] = "<textcolor color=\"#23adcc\">" .. "Ο Abjuration" .. "</textcolor>",
        ["Conjuration%f[%W]"] = "<textcolor color=\"#eeba15\">" .. "Π Conjuration" .. "</textcolor>",
        ["Divination%f[%W]"] = "<textcolor color=\"#678ec2\">" .. "Ρ Divination" .. "</textcolor>",
        ["Enchantment%f[%W]"] = "<textcolor color=\"#e6389e\">" .. "Σ Enchantment" .. "</textcolor>",
        ["Evocation%f[%W]"] = "<textcolor color=\"#ed3c43\">" .. "Τ Evocation" .. "</textcolor>",
        ["Illusion%f[%W]"] = "<textcolor color=\"#905cd5\">" .. "Υ Illusion" .. "</textcolor>",
        ["Necromancy%f[%W]"] = "<textcolor color=\"#009d60\">" .. "Φ Necromancy" .. "</textcolor>",
        ["Transmutation%f[%W]"] = "<textcolor color=\"#de6a37\">" .. "Χ Transmutation" .. "</textcolor>",
        
        --Magic Rarities
        ["Common%f[%W]"] = "<textcolor color=\"#898989\">" .. "Common" .. "</textcolor>",
        ["Uncommon%f[%W]"] = "<textcolor color=\"#56ad0f\">" .. "Unommon" .. "</textcolor>",
        ["Rare%f[%W]"] = "<textcolor color=\"#4990e2\">" .. "Rare" .. "</textcolor>",
        ["Very rare%f[%W]"] = "<textcolor color=\"#a35fc7\">" .. "Very rare" .. "</textcolor>",
        ["Legendary%f[%W]"] = "<textcolor color=\"#f0ae0e\">" .. "Legendary" .. "</textcolor>",
        ["Artifact%f[%W]"] = "<textcolor color=\"#ee502c\">" .. "Artifact" .. "</textcolor>",

        --Speeds
        ["Speed%f[%W]"] = "<b>Ψ Speed</b>",
        ["Burrow speed%f[%W]"] = "Ψ Burrow speed",
        ["Climb speed%f[%W]"] = "Ψ Climb speed",
        ["Fly speed%f[%W]"] = "Ψ Fly speed",
        ["Swim speed%f[%W]"] = "Ψ Swim speed"
    }

    local outputText = inputText
    -- Replace each word with its color-coded version.
    for x, y in pairs(coloredWords) do
        outputText = string.gsub(outputText, x, y)
    end

    --Any keyword between {} pattern will be styled"
    local patternWords = {
        --Italic Bold, Italic, Bold
        {pattern = "IB{(.-)}IB", style = "<i><b>" .. "%1" .. "</b></i>", 
            start = "IB{", fin="}IB"},
        {pattern = "Italic{(.-)}Italic", style = "<i>" .. "%1" .. "</i>", 
            start = "Italic{", fin="}Italic"},
        {pattern = "Bold{(.-)}Bold", style = "<b>" .. "%1" .. "</b>", 
            start = "Bold{", fin="}Bold"},
        --Spell
        {pattern = "Spell{(.-)}Spell", style = "<textcolor color=\"#704cd9\"><i><b>" .. "%1" .. "</b></i></textcolor>", 
            start = "Spell{", fin="}Spell"},
        --Feat
        {pattern = "Feat{(.-)}Feat", style = "<textcolor color=\"#00aeef\"><b>" .. "%1" .. "</b></textcolor>",
            start ="Feat{", fin="}Feat"},
        --Creature
        {pattern = "Creature{(.-)}creature", style = "<textcolor color=\"#dc402b\"><b>" .. "%1" .. "</b></textcolor>",
            start ="Creature{", fin="}creature"},
        --Weapons
        {pattern = "Weapon{(.-)}Weapon", style = "<textcolor color=\"#f88c23\"><b>" .. "%1" .. "</b></textcolor>",
            start ="Weapon{", fin="}Weapon"},
        --Objects/Items
        {pattern = "Item{(.-)}Item", style = "<textcolor color=\"#0f5cbc\"><b>" .. "%1" .. "</b></textcolor>",
            start ="Item{", fin="}Item"},

        --Artificer feature
        {pattern = "Artificer{(.-)}Artificer", style = "<textcolor color=\"#da881f\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Artificer{", fin="}Artificer"},
        --Barbarian feature
        {pattern = "Barbarian{(.-)}Barbarian", style = "<textcolor color=\"#e9623e\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Barbarian{", fin="}Barbarian"},
        --Bard feature
        {pattern = "Bard{(.-)}Bard", style = "<textcolor color=\"#cd73c6\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Bard{", fin="}Bard"},
        --Blood Hunter feature
        {pattern = "Blood{(.-)}Blood", style = "<textcolor color=\"#992d2f\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Blood{", fin="}Blood"},
        --Cleric feature
        {pattern = "Cleric{(.-)}Cleric", style = "<textcolor color=\"#8797a8\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Cleric{", fin="}Cleric"},
        --Druid feature
        {pattern = "Druid{(.-)}Druid", style = "<textcolor color=\"#839124\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Druid{", fin="}Druid"},
        --Fighter feature
        {pattern = "Fighter{(.-)}Fighter", style = "<textcolor color=\"#a85b3d\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Fighter{", fin="}Fighter"},
        --Monk feature
        {pattern = "Monk{(.-)}Monk", style = "<textcolor color=\"#23adcc\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Monk{", fin="}Monk"},
        --Paladin feature
        {pattern = "Paladin{(.-)}Paladin", style = "<textcolor color=\"#ebb137\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Paladin{", fin="}Paladin"},
        --Psion feature
        {pattern = "Psion{(.-)}Psion", style = "<textcolor color=\"#ff3891\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Psion{", fin="}Psion"},
        --Ranger feature
        {pattern = "Ranger{(.-)}Ranger", style = "<textcolor color=\"#2f865a\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Ranger{", fin="}Ranger"},
        --Rogue feature
        {pattern = "Rogue{(.-)}Rogue", style = "<textcolor color=\"#707070\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Rogue{", fin="}Rogue"},
        --Sorcerer feature
        {pattern = "Sorcerer{(.-)}Sorcerer", style = "<textcolor color=\"#c92f32\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Sorcerer{", fin="}Sorcerer"},
        --Warlock feature
        {pattern = "Warlock{(.-)}Warlock", style = "<textcolor color=\"#9645c4\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Warlock{", fin="}Warlock"},
        --Wizard feature
        {pattern = "Wizard{(.-)}Wizard", style = "<textcolor color=\"#376cdb\"><i><b>" .. "%1" .. "</b></i></textcolor>",
            start ="Wizard{", fin="}Wizard"},
    }

    for index, innerTable in pairs(patternWords) do
        local pattern = innerTable.pattern
        local style = innerTable.style
        local start = innerTable.start
        local fin = innerTable.fin
        outputText = string.gsub(outputText, pattern, style)
        outputText = string.gsub(outputText, start, "")
        outputText = string.gsub(outputText, fin, "")
    end
    
    return outputText
end

function callFormat()
if pcall(formatWords) then
      -- no errors while running `foo'
    else
      -- `foo' raised an error: take appropriate actions
      print("Error, reload card.")
  end
end
