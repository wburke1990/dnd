titleText, headerText, noteText, noteTrueText, castingText, rangeText, durationText, spellLevel = ""
artificerButton, bardButton, clericButton, druidButton, paladinButton, rangerButton, sorcererButton = "False"
warlockButton, wizardButton, verbalButton, somaticButton, materialButton = "False"

function onLoad(saved_data)
    saved_data = JSON.decode(saved_data)
    titleText = saved_data.tt
    headerText = saved_data.ht
    noteText = saved_data.nt
    noteTrueText = saved_data.ntt
    
    castingText = saved_data.ct
    castingTrueText = saved_data.ctt
    rangeText = saved_data.rt
    durationText = saved_data.dt
    spellLevel = saved_data.sl

    artificerButton = saved_data.ab
    bardButton= saved_data.bb
    clericButton = saved_data.cb
    druidButton = saved_data.db
    paladinButton = saved_data.pb
    sorcererButton = saved_data.sb
    warlockButton = saved_data.wb
    wizardButton = saved_data.wzb

    verbalButton = saved_data.vb
    somaticButton = saved_data.smb
    materialButton = saved_data.mb

    Wait.frames(function()
        self.UI.setAttribute("TitleId", "text", titleText)
        self.UI.setAttribute("HeaderId", "text", headerText)
        self.UI.setAttribute("InputId", "text", noteText)
        self.UI.setValue("InputTextId", formatWords(noteText))

        self.UI.setAttribute("CastingId", "text", castingText)
        self.UI.setValue("CastingTextId", formatWords(noteText))
        self.UI.setAttribute("RangeId", "text", rangeText)
        self.UI.setAttribute("DurationId", "text", durationText)
        self.UI.setAttribute("SpellLevelId", "text", spellLevel)

        self.UI.setAttribute("ArtificerId","isOn",artificerButton)
        self.UI.setAttribute("BardId","isOn",bardButton)
        self.UI.setAttribute("ClericId","isOn",clericButton)
        self.UI.setAttribute("DruidId","isOn",druidButton)
        self.UI.setAttribute("PaladinId","isOn",paladinButton)
        self.UI.setAttribute("SorcererId","isOn",sorcererButton)
        self.UI.setAttribute("WarlockId","isOn",warlockButton)
        self.UI.setAttribute("WizardId","isOn",wizardButton)

        self.UI.setAttribute("VerbalId","isOn",verbalButton)
        self.UI.setAttribute("SomaticId","isOn",somaticButton)
        self.UI.setAttribute("MaterialId","isOn",materialButton)

        saved_data = { 
            tt= self.UI.setAttribute("TitleId", "text", titleText),
            ht= self.UI.setAttribute("HeaderId", "text", headerText),
            nt= self.UI.setAttribute("InputId", "text", noteText),
            ntt= self.UI.setValue("InputTextId", formatWords(noteText)),

            ct= self.UI.setAttribute("CastingId", "text", castingText),
            ctt= self.UI.setValue("CastingTextId", formatWords(castingText)),
            rt= self.UI.setAttribute("RangeId", "text", rangeText),
            dt= self.UI.setAttribute("DurationId", "text", durationText),
            sl= self.UI.setAttribute("SpellLevelId", "text", spellLevel),
            
            ab= self.UI.setAttribute("ArtificerId","isOn",artificerButton),
            bb=self.UI.setAttribute("BardId","isOn",bardButton),
            cb=self.UI.setAttribute("ClericId","isOn",clericButton),
            db=self.UI.setAttribute("DruidId","isOn",druidButton),
            pb=self.UI.setAttribute("PaladinId","isOn",paladinButton),
            sb=self.UI.setAttribute("SorcererId","isOn",sorcererButton),
            wb=self.UI.setAttribute("WarlockId","isOn",warlockButton),
            wzb=self.UI.setAttribute("WizardId","isOn",wizardButton),

            vb=self.UI.setAttribute("VerbalId","isOn",verbalButton),
            sb=self.UI.setAttribute("SomaticId","isOn",somaticButton),
            mb=self.UI.setAttribute("MaterialId","isOn",materialButton),
        }

        self.script_state = JSON.encode(saved_data)
        lockUnlock()
    end, 5)

end

function onSave()
    saved_data = {
        tt=titleText, ht=headerText, nt=noteText, ntt=noteTrueText, 
        ct=castingText, ctt=castingTrueText, rt=rangeText, dt=durationText, sl=spellLevel,
        ab=artificerButton, bb=bardButton, cb=bardButton, db=druidButton, pb=paladinButton, 
        rb=rangerButton, sb=sorcererButton, wb=warlockButton, wzb=wizardButton, 
        vb=verbalButton, smb=somaticButton, mb=materialButton
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
    elseif id == "InputId" then
        noteText = value
        noteTrueText = formatWords(value)
        save_data = { nt=noteText, ntt=noteTrueText }
        self.UI.setAttribute("InputId", "text", noteText)
        self.UI.setValue("InputTextId", noteTrueText)
    elseif id == "CastingId" then
        castingText = value
        castingTrueText = formatWords(value)
        save_data = { ct=castingText, ctt=castingTrueText }
        self.UI.setAttribute("CastingId", "text", castingText)
        self.UI.setValue("CastingTextId", castingTrueText)
    elseif id == "RangeId" then
        rangeText = value
        save_data = {rt=rangeText}
        self.UI.setAttribute("rangeText", "text", value)
    elseif id == "DurationId" then
        durationText = value
        save_data = {dt=durationText}
        self.UI.setAttribute("durationText", "text", value)
    elseif id == "SpellLevelId" then
        spellLevel = value
        save_data = {sl=spellLevel}
        self.UI.setAttribute("spellLevel", "text", value)
    end

    --Saves state for onLoad()
    self.script_state = JSON.encode(save_data)
end

function updateButton(player, value, id)
    if id == "ArtificerId" then
        artificerButton = value
        save_data = {at=artificerButton}
        self.UI.setAttribute("artificerButton", "isOn", value)
    elseif id == "BardId" then
        bardButton = value
        save_data = {at=bardButton}
        self.UI.setAttribute("bardButton", "isOn", value)
    elseif id == "ClericId" then
        clericButton = value
        save_data = {at=clericButton}
        self.UI.setAttribute("clericButton", "isOn", value)
    elseif id == "DruidId" then
        druidButton = value
        save_data = {at=druidButton}
        self.UI.setAttribute("druidButton", "isOn", value)
    elseif id == "PaladinId" then
        paladinButton = value
        save_data = {at=paladinButton}
        self.UI.setAttribute("paladinButton", "isOn", value)
    elseif id == "RangerId" then
        rangerButton = value
        save_data = {at=rangerButton}
        self.UI.setAttribute("rangerButton", "isOn", value)
    elseif id == "SorcererId" then
        sorcererButton = value
        save_data = {at=sorcererButton}
        self.UI.setAttribute("sorcererButton", "isOn", value)
    elseif id == "WarlockId" then
        warlockButton = value
        save_data = {at=warlockButton}
        self.UI.setAttribute("warlockButton", "isOn", value)
    elseif id == "WizardId" then
        wizardButton = value
        save_data = {at=wizardButton}
        self.UI.setAttribute("wizardButton", "isOn", value)
    elseif id == "VerbalId" then
        verbalButton = value
        save_data = {at=verbalButton}
        self.UI.setAttribute("verbalButton", "isOn", value)
    elseif id == "SomaticId" then
        somaticButton = value
        save_data = {at=somaticButton}
        self.UI.setAttribute("somaticButton", "isOn", value)
    elseif id == "MaterialId" then
        materialButton = value
        save_data = {at=materialButton}
        self.UI.setAttribute("materialButton", "isOn", value)
    end

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

        self.UI.setAttribute("InputId", "interactable", "True")
        self.UI.setAttribute("CastingId", "interactable", "True")
        self.UI.setAttribute("RangeId", "interactable", "True")
        self.UI.setAttribute("DurationId", "interactable", "True")
        self.UI.setAttribute("SpellLevelId", "interactable", "True")

        self.UI.setAttribute("InputId", "position", "220 0 -40")
        self.UI.setAttribute("InputId", "width", "4100")
        self.UI.setAttribute("InputId", "height", "2900")

        self.UI.setAttribute("CastingId", "position", "35 -165 -40")
        self.UI.setAttribute("CastingId", "width", "1100")
        self.UI.setAttribute("CastingId", "height", "150")

        self.UI.setAttribute("VerbalId", "interactable", "True")
        self.UI.setAttribute("SomaticId", "interactable", "True")
        self.UI.setAttribute("MaterialId", "interactable", "True")

        self.UI.setAttribute("ArtificerId", "interactable", "True")
        self.UI.setAttribute("BardId", "interactable", "True")
        self.UI.setAttribute("ClericId", "interactable", "True")
        self.UI.setAttribute("DruidId", "interactable", "True")
        self.UI.setAttribute("PaladinId", "interactable", "True")
        self.UI.setAttribute("RangerId", "interactable", "True")
        self.UI.setAttribute("SorcererId", "interactable", "True")
        self.UI.setAttribute("WarlockId", "interactable", "True")
        self.UI.setAttribute("WizardId", "interactable", "True")

    elseif isOn == "True" then
        editState = "False"
        self.UI.setAttribute("LockId", "text", "Locked")
        self.UI.setAttribute("LockId", "color", "rgba{1,0, 0, 100}")
        self.UI.setAttribute("LockId", "textColor", "White")
        self.UI.setAttribute("TitleId", "interactable", "False")
        self.UI.setAttribute("HeaderId", "interactable", "False")

        self.UI.setAttribute("InputId", "interactable", "False")
        self.UI.setAttribute("CastingId", "interactable", "False")
        self.UI.setAttribute("RangeId", "interactable", "False")
        self.UI.setAttribute("DurationId", "interactable", "False")
        self.UI.setAttribute("SpellLevelId", "interactable", "False")
        
        self.UI.setAttribute("InputId", "position", "0 20 -40")
        self.UI.setAttribute("InputId", "width", "10")
        self.UI.setAttribute("InputId", "height", "10")

        self.UI.setAttribute("CastingId", "position", "0 -165 -40")
        self.UI.setAttribute("CastingId", "width", "10")
        self.UI.setAttribute("CastingId", "height", "10") 

        self.UI.setAttribute("VerbalId", "interactable", "False")
        self.UI.setAttribute("SomaticId", "interactable", "False")
        self.UI.setAttribute("MaterialId", "interactable", "False")

        self.UI.setAttribute("ArtificerId", "interactable", "False")
        self.UI.setAttribute("BardId", "interactable", "False")
        self.UI.setAttribute("ClericId", "interactable", "False")
        self.UI.setAttribute("DruidId", "interactable", "False")
        self.UI.setAttribute("PaladinId", "interactable", "False")
        self.UI.setAttribute("RangeId", "interactable", "False")
        self.UI.setAttribute("SorcererId", "interactable", "False")
        self.UI.setAttribute("WarlockId", "interactable", "False")
        self.UI.setAttribute("WizardId", "interactable", "False")
    end
end

function formatWords(inputText)
    -- Define a list of words and their corresponding colors.
    local coloredWords = {
        --Damage Types
        ["Acid%f[%W]"] = "<textcolor color=\"#9ac623\">" .. "Ά Acid" .. "</textcolor>",
        ["Cold%f[%W]"] = "<textcolor color=\"#33a8d9\">" .. "Έ Cold" .. "</textcolor>",
        ["Fire%f[%W]"] = "<textcolor color=\"#e65818\">" .. "Ή Fire" .. "</textcolor>",
        ["Force%f[%W]"] = "<textcolor color=\"#ce373b\">" .. "Ί Force" .. "</textcolor>",
        ["Lightning%f[%W]"] = "<textcolor color=\"#2c5fd0\">" .. "Ό Lightning" .. "</textcolor>",
        ["Necrotic%f[%W]"] = "<textcolor color=\"#3fa863\">" .. "Ύ Necrotic" .. "</textcolor>",
        ["Poison%f[%W]"] = "<textcolor color=\"#9730a6\">" .. "Ώ Poison" .. "</textcolor>",
        ["Psychic%f[%W]"] = "<textcolor color=\"#ed4cba\">" .. "ΐ Psychic" .. "</textcolor>",
        ["Radiant%f[%W]"] = "<textcolor color=\"#e6a620\">" .. "Α Radiant" .. "</textcolor>",
        ["Thunder%f[%W]"] = "<textcolor color=\"#8450dd\">" .. "Β Thunder" .. "</textcolor>",
        ["Bludgeoning%f[%W]"] = "<textcolor color=\"#8c6239\">" .. "Γ Bludgeoning" .. "</textcolor>",
        ["Piercing%f[%W]"] = "<textcolor color=\"#998675\">" .. "Δ Piercing" .. "</textcolor>",
        ["Slashing%f[%W]"] = "<textcolor color=\"#808080\">" .. "Ε Slashing" .. "</textcolor>",

        --Misc
        ["Hit Points%f[%W]"] = "<textcolor color=\"#dc402b\">" .. "Ζ Hit Points" .. "</textcolor>",
        ["HP%f[%W]"] = "<textcolor color=\"#dc402b\">" .. "Ζ HP" .. "</textcolor>",
        ["Hit Dice%f[%W]"] = "<textcolor color=\"#dc402b\">" .. "Η Hit Dice" .. "</textcolor>",
        ["Hit Die%f[%W]"] = "<textcolor color=\"#dc402b\">" .. "Η Hit Dice" .. "</textcolor>",
        ["Armor Class%f[%W]"] = "<textcolor color=\"#0075ec\">" .. "Θ Armor Class" .. "</textcolor>",
        ["AC%f[%W]"] = "<textcolor color=\"#0075ec\">" .. "Θ AC" .. "</textcolor>",
        ["Temporary hit points%f[%W]"] = "<textcolor color=\"#e9623e\">" .. "Ι Temporary hit points" .. "</textcolor>",
        ["BP%f[%W]"] = "•",

        --Money
        ["CP%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["SP%f[%W]"] = "<textcolor color=\"#8797a8\">" .. "%1" .. "</textcolor>",
        ["EP%f[%W]"] = "<textcolor color=\"#ca9e47\">" .. "%1" .. "</textcolor>",
        ["GP%f[%W]"] = "<textcolor color=\"#ebb137\">" .. "%1" .. "</textcolor>",
        ["PP%f[%W]"] = "<textcolor color=\"#c4b3c6\">" .. "%1" .. "</textcolor>",

        --Abilities
        ["Strength%f[%W]"] = "<textcolor color=\"#c92f32\">" .. "%1" .. "</textcolor>",
            ["Athletics%f[%W]"] = "<textcolor color=\"#c92f32\">" .. "%1" .. "</textcolor>",
        ["Dexterity%f[%W]"] = "<textcolor color=\"#009d60\">" .. "%1" .. "</textcolor>",
            ["Acrobatics%f[%W]"] = "<textcolor color=\"#009d60\">" .. "%1" .. "</textcolor>",
            ["Sleight of Hand%f[%W]"] = "<textcolor color=\"#009d60\">" .. "%1" .. "</textcolor>",
            ["Stealth%f[%W]"] = "<textcolor color=\"#009d60\">" .. "%1" .. "</textcolor>",
        ["Constitution%f[%W]"] = "<textcolor color=\"#e9623e\">" .. "%1" .. "</textcolor>",
        ["Intelligence%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "%1" .. "</textcolor>",
            ["Arcana%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "%1" .. "</textcolor>",
            ["History%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "%1" .. "</textcolor>",
            ["Investigation%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "%1" .. "</textcolor>",
            ["Nature%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "%1" .. "</textcolor>",
            ["Religion%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "%1" .. "</textcolor>",
        ["Wisdom%f[%W]"] = "<textcolor color=\"#f0ae0e\">" .. "%1" .. "</textcolor>",
            ["Animal Handling%f[%W]"] = "<textcolor color=\"#f0ae0e\">" .. "%1" .. "</textcolor>",
            ["Insight%f[%W]"] = "<textcolor color=\"#f0ae0e\">" .. "%1" .. "</textcolor>",
            ["Medicine%f[%W]"] = "<textcolor color=\"#f0ae0e\">" .. "%1" .. "</textcolor>",
            ["Perception%f[%W]"] = "<textcolor color=\"#f0ae0e\">" .. "%1" .. "</textcolor>",
            ["Survival%f[%W]"] = "<textcolor color=\"#f0ae0e\">" .. "%1" .. "</textcolor>",
        ["Charisma%f[%W]"] = "<textcolor color=\"#e964c2\">" .. "%1" .. "</textcolor>",
            ["Deception%f[%W]"] = "<textcolor color=\"#e964c2\">" .. "%1" .. "</textcolor>",
            ["Intimidation%f[%W]"] = "<textcolor color=\"#e964c2\">" .. "%1" .. "</textcolor>",
            ["Performance%f[%W]"] = "<textcolor color=\"#e964c2\">" .. "%1" .. "</textcolor>",
            ["Persuasion%f[%W]"] = "<textcolor color=\"#e964c2\">" .. "%1" .. "</textcolor>",
        ["Spell Slot%f[%W]"] = "<textcolor color=\"#5f63f7\">" .. "/ Spell Slot" .. "</textcolor>",
        
        --Actions
        ["Action%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "Κ Action" .. "</textcolor>",
        ["Attack action%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "Κ Attack " .. "</textcolor>" .. "action",
        ["Dodge%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "Κ Dodge" .. "</textcolor>",
        ["Dash%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "Κ Dash" .. "</textcolor>",
        ["Disengage%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "Κ Disengage" .. "</textcolor>",
        ["Help%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "Κ Help" .. "</textcolor>",
        ["Hide%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "Κ Hide" .. "</textcolor>",
        ["Influence%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "Κ Influence" .. "</textcolor>",
        ["Magic%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "Κ Magic" .. "</textcolor>",
        ["Ready%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "Κ Ready" .. "</textcolor>",
        ["Search%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "Κ Search" .. "</textcolor>",
        ["Study%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "Κ Study" .. "</textcolor>",
        ["Utilize%f[%W]"] = "<textcolor color=\"#0ea932\">" .. "Κ Utilize" .. "</textcolor>",

        --Other Actions
        ["Bonus action%f[%W]"] = "<textcolor color=\"#f88c23\">" .. "Λ Bonus action" .. "</textcolor>",
        ["Reaction%f[%W]"] = "<textcolor color=\"#ea3da2\">" .. "Μ Reaction" .. "</textcolor>",
        ["Opportunity attack%f[%W]"] = "<textcolor color=\"#ea3da2\">" .. "Μ Opportunity attack" .. "</textcolor>",
        ["Movement%f[%W]"] = "<textcolor color=\"#e8b20e\">" .. "Ν Movement" .. "</textcolor>",
        ["Pulled%f[%W]"] = "<textcolor color=\"#e9623e\">" .. "Ν Pulled" .. "</textcolor>",
        ["Pushed%f[%W]"] = "<textcolor color=\"#e9623e\">" .. "Ν Pushed" .. "</textcolor>",
        ["Transport%f[%W]"] = "<textcolor color=\"#e9623e\">" .. "Ν Transport" .. "</textcolor>",
        ["Teleport%f[%W]"] = "<textcolor color=\"#2e7cc9\">" .. "Ν Teleport" .. "</textcolor>",
        ["Spell Slot%f[%W]"] = "<textcolor color=\"#5f63f7\">" .. "Ξ Spell Slot" .. "</textcolor>",
        
        --No Icons
        ["Advantage%f[%W]"] = "<textcolor color=\"#00a651\">" .. "%1" .. "</textcolor>",
        ["Disadvantage%f[%W]"] = "<textcolor color=\"#ef3d43\">" .. "%1" .. "</textcolor>",
        ["Proficiency Bonus%f[%W]"] = "<textcolor color=\"#16b47e\">" .. "%1" .. "</textcolor>",
        ["Skill%f[%W]"] = "<textcolor color=\"#16b47e\">" .. "%1" .. "</textcolor>",
        
        --Rules
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
        ["Attack Roll%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Ability Check%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Saving Throw%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Total Cover%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Half Cover%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Three Quarters Cover%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Difficult Terrain%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Expertise%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Hover%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Shape Shift%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",
        ["Darkvision%f[%W]"] = "<textcolor color=\"#a7792a\">" .. "%1" .. "</textcolor>",

        --Conditions
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
        ["Speed%f[%W]"] = "Ψ Speed",
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
        --Italic
        {pattern = "Italic{(.-)}Italic", style = "<i>" .. "%1" .. "</i>", 
            start = "Italic{", fin="}Italic"},
        --Spell
        {pattern = "Spell{(.-)}Spell", style = "<textcolor color=\"#704cd9\"><i>" .. "%1" .. "</i></textcolor>", 
            start = "Spell{", fin="}Spell"},
        --Feat
        {pattern = "Feat{(.-)}Feat", style = "<textcolor color=\"#00aeef\">" .. "%1" .. "</textcolor>",
            start ="Feat{", fin="}Feat"},
        --Creature
        {pattern = "Creature{(.-)}creature", style = "<textcolor color=\"#dc402b\">" .. "%1" .. "</textcolor>",
            start ="Creature{", fin="}creature"},
        --Weapons
        {pattern = "Weapon{(.-)}Weapon", style = "<textcolor color=\"#f88c23\">" .. "%1" .. "</textcolor>",
            start ="Weapon{", fin="}Weapon"},
        --Objects/Items
        {pattern = "Item{(.-)}Item", style = "<textcolor color=\"#0f5cbc\">" .. "%1" .. "</textcolor>",
            start ="Item{", fin="}Item"},

        --Artificer feature
        {pattern = "Artificer{(.-)}Artificer", style = "<textcolor color=\"#da881f\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Artificer{", fin="}Artificer"},
        --Barbarian feature
        {pattern = "Barbarian{(.-)}Barbarian", style = "<textcolor color=\"#e9623e\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Barbarian{", fin="}Barbarian"},
        --Bard feature
        {pattern = "Bard{(.-)}Bard", style = "<textcolor color=\"#cd73c6\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Bard{", fin="}Bard"},
        --Blood Hunter feature
        {pattern = "Blood{(.-)}Blood", style = "<textcolor color=\"#992d2f\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Blood{", fin="}Blood"},
        --Cleric feature
        {pattern = "Cleric{(.-)}Cleric", style = "<textcolor color=\"#8797a8\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Cleric{", fin="}Cleric"},
        --Druid feature
        {pattern = "Druid{(.-)}Druid", style = "<textcolor color=\"#839124\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Druid{", fin="}Druid"},
        --Fighter feature
        {pattern = "Fighter{(.-)}Fighter", style = "<textcolor color=\"#a85b3d\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Fighter{", fin="}Fighter"},
        --Monk feature
        {pattern = "Monk{(.-)}Monk", style = "<textcolor color=\"#23adcc\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Monk{", fin="}Monk"},
        --Paladin feature
        {pattern = "Paladin{(.-)}Paladin", style = "<textcolor color=\"#ebb137\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Paladin{", fin="}Paladin"},
        --Psion feature
        {pattern = "Psion{(.-)}Psion", style = "<textcolor color=\"#ff3891\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Psion{", fin="}Psion"},
        --Ranger feature
        {pattern = "Ranger{(.-)}Ranger", style = "<textcolor color=\"#2f865a\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Ranger{", fin="}Ranger"},
        --Rogue feature
        {pattern = "Rogue{(.-)}Rogue", style = "<textcolor color=\"#707070\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Rogue{", fin="}Rogue"},
        --Sorcerer feature
        {pattern = "Sorcerer{(.-)}Sorcerer", style = "<textcolor color=\"#c92f32\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Sorcerer{", fin="}Sorcerer"},
        --Warlock feature
        {pattern = "Warlock{(.-)}Warlock", style = "<textcolor color=\"#9645c4\"><i>" .. "%1" .. "</i></textcolor>",
            start ="Warlock{", fin="}Warlock"},
        --Wizard feature
        {pattern = "Wizard{(.-)}Wizard", style = "<textcolor color=\"#376cdb\"><i>" .. "%1" .. "</i></textcolor>",
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
