--[[    Character Sheet Template    by: MrStump ]]
--[[    Written Code                by: NightStorm ]]

--Set to true when editing
    disableSave = false
--Remember to set this to false once you are done making changes
--Then, after you save & apply it, save your game too

--Button Colors (r,g,b, values of 0-1)
    buttonColorRed = {0.94,0.125,0.121, 100}
    buttonColorYellow = {1,0.65,0, 100}
    buttonColorGreen = {0,0.75,0.33, 100}
    buttonColorBlue = {0.2,0.59,1, 100}
    buttonColorPink = {0.91,0.23,0.63, 100}
    buttonColorWhite = {1,1,1, 0.01}
    
    --Change text color
    buttonColorBlack = {0,0,0, 100}
    --Dark version color code
    buttonFontColorDark = {1,1,1, 95}

--Change scale of button (Avoid changing if possible)
    buttonScale = {0.11,0.11,0.11}

--This is the button placement information
defaultButtonData = {
    --Add Checkbox
        checkbox = {
        --[[    CHECKBOX INFORMATION
                pos   = the position (pasted from the helper tool)
                size  = height/width/font_size for checkbox
                state = default starting value for checkbox (true=checked, false=not) ]]
            --Armor Proficiencies
                --Light Armor Proficiency
                    {   pos   = {-1.317,0.12,0.527},
                        size  = 250,
                        state = false },
                --Medium Armor Proficiency
                    {   pos   = {-1.203,0.12,0.527},
                        size  = 250,
                        state = false },
                --Heavy Armor Proficiency
                    {   pos   = {-1.073,0.12,0.527},
                        size  = 250,
                        state = false },
                --Shield Armor Proficiency
                    { pos   = {-0.967,0.12,0.527},
                        size  = 250,
                        state = false },
                --Armor Class
                    { pos   = {0.692,0.12,-0.461},
                        size  = 250,
                        state = false },
                --Temp Bonus
                    { pos   = {0.954,0.12,-0.461},
                        size  = 250,
                        state = false },
                --Attunement 1
                    { pos   = {0.502,0.12,0.481},
                        size  = 250,
                        state = false },
                --Attunement 2
                    {   pos   = {0.502,0.12,0.562},
                        size  = 250,
                        state = false },
                --Attunement 3
                    {   pos   = {0.502,0.12,0.642},
                        size  = 250,
                        state = false },
                --Attunement 4
                    {   pos   = {0.502,0.12,0.724},
                        size  = 250,
                        state = false },
                --Attunement 5
                    {   pos   = {0.502,0.12,0.806},
                        size  = 250,
                        state = false },
                --Attunement 6
                    {   pos   = {0.502,0.12,0.887},
                        size  = 250,
                        state = false },
            --Weapon Proficiencies
                --Simple Weapon Proficiency
                    {   pos   = {-1.317,0.12,0.563},
                        size  = 250,
                        state = false },
                --Martial Weapon Proficiency
                    {   pos   = {-1.203,0.12,0.563},
                        size  = 250,
                        state = false }, },
    --Color Checkbox
        --Green Checkboxes (for death saving throws)
            checkboxg= {
                --First Death Save Success checkbox
                    {   pos   = {1.295,0.12,-0.921},
                        size  = 325,
                        state = false },
                --Second Death Save Success checkbox
                    {   pos   = {1.361,0.12,-0.921},
                        size  = 325,
                        state = false },
                --Third Death Save Success checkbox
                    {   pos   = {1.429,0.12,-0.921},
                        size  = 325,
                        state = false }, },
        --Red Checkboxes (for death saving throws)
            checkboxr= {
                --First Death Save Failure checkbox
                    {   pos   = {1.282,0.12,-0.812},
                        size  = 325,
                        state = false },
                --Second Death Save Failure checkbox
                    {   pos   = {1.348,0.12,-0.812},
                        size  = 325,
                        state = false },
                --Third Death Save Failure checkbox
                    {   pos   = {1.416,0.12,-0.812},
                        size  = 325,
                        state = false }, },
    --Heroic Inspiration Checkbox
        checkboxinspire= {
               {    pos   = {0.208,0.12,-0.906},
                  size  = 400,
                  state = false }, },
    --Saving Throws
        --STR Saving Throw checkbox
            checkboxstrst= {
                {   pos   = {-1.422,0.12,-0.343},
                    size  = 250,
                    state = false }, },
        --DEX Saving Throw checkbox
            checkboxdexst= {
                {   pos   = {-1.422,0.12,-0.246},
                    size  = 250,
                    state = false }, },
        --CON Saving Throw checkbox
            checkboxconst= {
                {   pos   = {-1.422,0.12,-0.148},
                    size  = 250,
                    state = false }, },
        --INT Saving Throw checkbox
            checkboxintst= {
                {   pos   = {-1.138,0.12,-0.343},
                    size  = 250,
                    state = false }, },
        --WIS Saving Throw checkbox
            checkboxwisst= {
                {   pos   = {-1.138,0.12,-0.246},
                    size  = 250,
                    state = false }, },
        --CHA Saving Throw checkbox
            checkboxchast= {
                {   pos   = {-1.138,0.12,-0.148},
                    size  = 250,
                    state = false }, },
    --Skills
        --DEX Skill Acrobatics checkbox
            checkboxdexskill1= {
                {   pos   = {-0.763,0.12,-0.091},
                    size  = 250,
                    state = false,
                    value = 0 }, },
        --WIS Skill Animal Handling checkbox
            checkboxwisskill1= {
                {   pos   = {-0.763,0.12,-0.032},
                    size  = 250,
                    state = false }, },
        --INT Skill Arcana checkbox
            checkboxintskill1= {
                {   pos   = {-0.763,0.12,0.027},
                    size  = 250,
                    state = false,
                    value = 0 }, },
        --STR Skill Athletics checkbox
            checkboxstrskill1= {
                {   pos   = {-0.763,0.12,0.086},
                    size  = 250,
                    state = false,
                    value = 0 }, },
        --CHA Skill Deception checkbox
            checkboxchaskill1= {
                {   pos   = {-0.763,0.12,0.145},
                    size  = 250,
                    state = false }, },
        --INT Skill History checkbox
            checkboxintskill2= {
                {   pos   = {-0.763,0.12,0.204},
                    size  = 250,
                    state = false,
                    value = 0 }, },
        --WIS Skill Insight checkbox
            checkboxwisskill2= {
                {   pos   = {-0.763,0.12,0.263},
                    size  = 250,
                    state = false }, },
        --CHA Skill Intimidation checkbox
            checkboxchaskill2= {
                {   pos   = {-0.763,0.12,0.322},
                    size  = 250,
                    state = false }, },
        --INT Skill Investigation checkbox
            checkboxintskill3= {
                {   pos   = {-0.763,0.12,0.381},
                    size  = 250,
                    state = false,
                    value = 0 }, },
        --WIS Skill Medicine checkbox
            checkboxwisskill3= {
                {   pos   = {-0.763,0.11,0.440},
                    size  = 250,
                    state = false }, },
        --INT Skill Nature checkbox
            checkboxintskill4= {
                {   pos   = {-0.763,0.12,0.499},
                    size  = 250,
                    state = false,
                    value = 0 }, },
        --WIS Skill Perception checkbox
            checkboxwisskill4= {
                {   pos   = {-0.763,0.11,0.558},
                    size  = 250,
                    state = false }, },
        --CHA Skill Performance checkbox
            checkboxchaskill3= {
                {   pos   = {-0.763,0.11,0.617},
                    size  = 250,
                    state = false }, },
        --CHA Skill Persuassion checkbox
            checkboxchaskill4= {
                {   pos   = {-0.763,0.11,0.676},
                    size  = 250,
                    state = false }, },
        --INT Skill Religion checkbox
            checkboxintskill5= {
                {   pos   = {-0.763,0.12,0.732},
                    size  = 250,
                    state = false,
                    value = 0 }, },
        --DEX Skill Sleight of Hand checkbox
            checkboxdexskill2= {
                {   pos   = {-0.763,0.12,0.792},
                    size  = 250,
                    state = false,
                    value = 0 }, },
        --DEX Skill Stealth checkbox
            checkboxdexskill3= {
                {   pos   = {-0.763,0.12,0.849},
                    size  = 250,
                    state = false,
                    value = 0 }, },
        --WIS Skill Survival checkbox
            checkboxwisskill5= {
                {   pos   = {-0.763,0.11,0.908},
                    size  = 250,
                    state = false }, },
    --Add Lockable Checkbox
        checkboxlock = {
            {   pos   = {-0.803,0.12,-0.928},
                size  = 200,
                state = true    },  },
    --Add Long Rest Button
        longrest = {
            {   pos   = {-0.302,0.1,-0.96},
                size  = 180,
                state = true    },  },
    --Ability Score Counters
        --STR Score counter
            strcounterscore = {
                {   pos           = {-1.373,0.12,-0.473},
                    size          = 200,
                    value         = 10,
                    hideBG        = true,
                    savingThrow   = {-1.283,0.1,-0.343},
                    athleticsPos  = {-0.701,0.12,0.087} }, },
        --DEX Score counter
            dexcounterscore = {
                {   pos               = {-1.161,0.12,-0.473},
                    size              = 200,
                    value             = 10,
                    hideBG            = true,
                    savingThrow       = {-1.283,0.1,-0.246},
                    acrobaticsPos     = {-0.701,0.12,-0.09},
                    sleightOfHandPos  = {-0.701,0.12,0.795},
                    stealtPos         = {-0.701,0.12,0.854} }, },
        --CON Score counter
            concounterscore = {
                {   pos               = {-0.946,0.12,-0.473},
                    size              = 200,
                    value             = 10,
                    savingThrow       = {-1.283,0.1,-0.147},
                    hideBG            = true }, },
        --INT Score counter
            intcounterscore = {
                {   pos               = {-0.734,0.12,-0.473},
                    size              = 200,
                    value             = 10,
                    hideBG            = true,
                    savingThrow       = {-0.998,0.1,-0.343},
                    arcanaPos         = {-0.701,0.12,0.028},
                    historyPos        = {-0.701,0.12,0.205},
                    investigationPos  = {-0.701,0.12,0.382},
                    naturePos         = {-0.701,0.12,0.500},
                    religionPos       = {-0.701,0.12,0.736} }, },
        --WIS Score counter
            wiscounterscore = {
                {   pos               = {-0.521,0.12,-0.473},
                    size              = 200,
                    value             = 10,
                    hideBG            = true,
                    savingThrow       = {-0.998,0.1,-0.246},
                    animalHandlingPos = {-0.701,0.12,-0.031},
                    insightPos        = {-0.701,0.12,0.264},
                    medicinePos       = {-0.701,0.12,0.441},
                    perceptionPos     = {-0.701,0.12,0.559},
                    survivalPos       = {-0.701,0.12,0.913} }, },
        --CHA Score counter
            chacounterscore = {
                {   pos             = {-0.308,0.12,-0.473},
                    size            = 200,
                    value           = 10,
                    hideBG          = true,
                    savingThrow     = {-0.998,0.1,-0.147},
                    deceptionPos    = {-0.701,0.12,0.146},
                    intimidationPos = {-0.701,0.12,0.323},
                    performancePos  = {-0.701,0.12,0.618},
                    persuasionPos   = {-0.701,0.12,0.677} }, },
        --Level XP counter
            xpcounter = {
                {   pos    = {0.21,0.12,-0.763},
                    size   = 300,
                    value  = 0,
                    xpbar  = {0.515,0.1,-0.763},
                    hideBG = true }, },
    --Add Counters
        counter = {
        --[[    COUNTER INFORMATION
                pos    = the position (pasted from the helper tool)
                size   = height/width/font_size for counter
                value  = default starting value for counter
                hideBG = if background of counter is hidden (true=hidden, false=not) ]]
        --AC (Armor Class) counter
            {   pos    = {0.692,0.12,-0.547},
                size   = 400,
                value  = 10,
                hideBG = true,
                color = buttonColorBlue },
        --Long Jump
            {   pos    = {-0.578,0.12,-0.313},
                size   = 150,
                value  = 0,
                hideBG = true,
                modifier = 0.035,
                color = buttonColorBlack },
        --High Jump
            {   pos    = {-0.578,0.12,-0.276},
                size   = 150,
                value  = 0,
                hideBG = true,
                modifier = 0.035,
                color = buttonColorBlack },
        --Temp AC counter
            {   pos    = {0.954,0.12,-0.547},
                size   = 400,
                value  = 0,
                hideBG = true,
                color = buttonColorBlue },
        --Exhaustion counter
            {   pos    = {0.445,0.12,-0.558},
                size   = 450,
                value  = 0,
                hideBG = true,
                color = buttonColorRed  },
        --Attack Hit Bonus
            --Attack Bonus 1 counter
                {   pos    = {0.101,0.12,-0.334},
                    size   = 250,
                    value  = 0,
                    hideBG = true,
                    color = buttonColorBlack },
            --Attack Bonus 2 counter
                {   pos    = {0.101,0.12,-0.266},
                    size   = 250,
                    value  = 0,
                    hideBG = true,
                    color = buttonColorBlack },
            --Attack Bonus 3 counter
                {   pos    = {0.101,0.12,-0.199},
                    size   = 250,
                    value  = 0,
                    hideBG = true,
                    color = buttonColorBlack },
            --Attack Bonus 4 counter
                {   pos    = {0.948,0.12,-0.334},
                    size   = 250,
                    value  = 0,
                    hideBG = true,
                    color = buttonColorBlack },
            --Attack Bonus 5 counter
                {   pos    = {0.948,0.12,-0.266},
                    size   = 250,
                    value  = 0,
                    hideBG = true,
                    color = buttonColorBlack },
            --Attack Bonus 6 counter
                {   pos    = {0.948,0.12,-0.199},
                    size   = 250,
                    value  = 0,
                    hideBG = true,
                    color = buttonColorBlack }, },
    --Speed Counters
        counterspeed = {
            --Base Walking Speed
                {   pos    = {-0.616,0.12,-0.366},
                    size   = 300,
                    value  = 0,
                    hideBG = true,
                    modifier = 0.06,
                    color = buttonColorBlack },
            --Climb Speed
                {   pos    = {-0.32,0.12,-0.386},
                    size   = 150,
                    value  = 0,
                    hideBG = true,
                    modifier = 0.045,
                    color = buttonColorBlack },
            --Swim Speed
                {   pos    = {-0.32,0.12,-0.349},
                    size   = 150,
                    value  = 0,
                    hideBG = true,
                    modifier = 0.045,
                    color = buttonColorBlack },
            --Fly Speed
                {   pos    = {-0.32,0.12,-0.313},
                    size   = 150,
                    value  = 0,
                    hideBG = true,
                    modifier = 0.045,
                    color = buttonColorBlack },
            --Burrow Speed
                {   pos    = {-0.32,0.12,-0.276},
                    size   = 150,
                    value  = 0,
                    hideBG = true,
                    modifier = 0.045,
                    color = buttonColorBlack }, },
    --Adds Initiative Counters
        counterinit = {
            {   pos    = {0.187,0.12,-0.558},
                size   = 450,
                value  = 0,
                hideBG = true }, },
    --Proficiency Bonus Counter
        counterprof = {{   
            pos    = {-0.072,0.12,-0.558},
            size   = 450,
            value  = 2,
            hideBG = true }, },
    --Add Prof Bonus Counters
        --Prof Skill Bonus 1 Acrobatics
            counterprofs1 = {{   
                pos    = {-0.616,0.11,-0.09},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 2 Animal Handling
            counterprofs2 = {{
                pos    = {-0.616,0.11,-0.031},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 3 Arcana
            counterprofs3 = {{
                pos    = {-0.616,0.11,0.028},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 4 Athletics
            counterprofs4 = {{   
                pos = {-0.616,0.11,0.087}, 
                size = 200, 
                value = 0, 
                hideBG = true }, },
        --Prof Skill Bonus 5 Deception
            counterprofs5 = {{   
                pos = {-0.616,0.11,0.146}, 
                size = 200, 
                value = 0, 
                hideBG = true }, },
        --Prof Skill Bonus 6 History
            counterprofs6 = {{
                pos    = {-0.616,0.12,0.205},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 7 Insight
            counterprofs7 = {{
                pos    = {-0.616,0.12,0.264},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 8 Intimidation
            counterprofs8 = {{
                pos    = {-0.616,0.12,0.323},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 9 Investigation
            counterprofs9 = {{
                pos    = {-0.616,0.11,0.382},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 10 Medicine
            counterprofs10 = {{
                pos    = {-0.616,0.11,0.441},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 11 Nature
            counterprofs11 = {{
                pos    = {-0.616,0.11,0.500},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 12 Perception
            counterprofs12 = {{
                pos    = {-0.616,0.11,0.559},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 13 Performance
            counterprofs13 = {{
                pos    = {-0.616,0.11,0.618},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 14 Persuassion
            counterprofs14 = {{
                pos    = {-0.616,0.11,0.677},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 15 Religion
            counterprofs15 = {{
                pos    = {-0.616,0.11,0.736},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 16 Sleight of Hand
            counterprofs16 = {{
                pos    = {-0.616,0.11,0.795},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 17 Stealth
            counterprofs17 = {{
                pos    = {-0.616,0.11,0.854},
                size   = 200,
                value  = 0,
                hideBG = true }, },
        --Prof Skill Bonus 18 Survival
            counterprofs18 = {{
                pos    = {-0.616,0.11,0.913},
                size   = 200,
                value  = 0,
                hideBG = true }, }, 
    --Add Editable Textbox
        textbox = {
            --[[    TEXTBOX INFORMATION
                pos       = the position (pasted from the helper tool)
                rows      = how many lines of text you want for this box
                width     = how wide the text box is
                font_size = size of text. This and "rows" effect overall height
                label     = what is shown when there is no text. "" = nothing
                value     = text entered into box. "" = nothing
                alignment = Number to indicate how you want text aligned
                            (1=Automatic, 2=Left, 3=Center, 4=Right, 5=Justified)   ]]
            --Header Textboxes
                --Character Name textbox
                    {   pos       = {-1.067,0.12,-0.788},
                        rows      = 1,
                        width     = 3250,
                        font_size = 220,
                        label     = "Character Name",
                        value     = "", 
                        alignment = 3 },
                --Class Name textbox
                    {   pos       = {-0.540,0.12,-0.868},
                        rows      = 1,
                        width     = 1000,
                        font_size = 140,
                        label     = "Class Name",
                        value     = "",
                        alignment = 1 },
                --Subclass textbox
                    {   pos       = {-0.310,0.12,-0.868},
                        rows      = 1,
                        width     = 1000,
                        font_size = 140,
                        label     = "Subclass",
                        value     = "",
                        alignment = 1 },
                --Alignment textbox
                    {   pos       = {-0.080,0.12,-0.868},
                        rows      = 1,
                        width     = 1000,
                        font_size = 140,
                        label     = "Alignment",
                        value     = "",
                        alignment = 1 },
                --Species textbox
                    {   pos       = {-0.540,0.12,-0.777},
                        rows      = 1,
                        width     = 1000,
                        font_size = 140,
                        label     = "Species",
                        value     = "",
                        alignment = 1 },
                --Size textbox
                    {   pos       = {-0.310,0.12,-0.777},
                        rows      = 1,
                        width     = 1000,
                        font_size = 140,
                        label     = "Size",
                        value     = "",
                        alignment = 1 },
                --Background textbox
                    {   pos       = {-0.080,0.12,-0.777},
                        rows      = 1,
                        width     = 1000,
                        font_size = 140,
                        label     = "Background",
                        value     = "",
                        alignment = 1 },
                --Experience textbox
                    {   pos       = {0.360,0.12,-0.763},
                        rows      = 1,
                        width     = 750,
                        font_size = 150,
                        label     = "Experience",
                        value     = "",
                        alignment = 4 },
                --Max Hit Dice textbox
                    {   pos       = {0.805,0.12,-0.785},
                        rows      = 1,
                        width     = 800,
                        font_size = 105,
                        label     = "...",
                        value     = "",
                        alignment = 3 },
                --Spent Hit Dice textbox
                    {   pos       = {1.11,0.12,-0.785},
                        rows      = 1,
                        width     = 800,
                        font_size = 105,
                        label     = "...",
                        value     = "",
                        alignment = 3 },
            --Misc Textboxes
                --Defense Properties textbox
                    {   pos       = {1.284,0.12,-0.575},
                        rows      = 6,
                        width     = 1500,
                        font_size = 110,
                        label     = "Resistant to:\n\n"..
                                    "Immune to:\n\n"..
                                    "Vulnerable to:",
                        value     = "",
                        alignment = 2 },
                --Saving Throws textbox
                    {   pos       = {-1.158,0.12,-0.07},
                        rows      = 2,
                        width     = 2500,
                        font_size = 120,
                        label     = "Bonus to Saving Throws",
                        value     = "",
                        alignment = 2 },
                --Senses Misc textbox
                    {   pos       = {-1.158,0.12,0.386},
                        rows      = 3,
                        width     = 2500,
                        font_size = 120,
                        label     = "Misc Senses",
                        value     = "",
                        alignment = 2 },
                --Weapons Misc textbox
                    {   pos       = {-1.153,0.12,0.623},
                        rows      = 3,
                        width     = 2550,
                        font_size = 120,
                        label     = "Specific Weapon Proficiencies",
                        value     = "",
                        alignment = 2 },
                --Tools Misc textbox
                    {   pos       = {-1.153,0.12,0.743},
                        rows      = 4,
                        width     = 2550,
                        font_size = 120,
                        label     = "Tool Proficiencies",
                        value     = "",
                        alignment = 2 },
                --Languages textbox
                    {   pos       = {-1.152,0.12,0.879},
                        rows      = 4,
                        width     = 2600,
                        font_size = 120,
                        label     = "Languages Known",
                        value     = "",
                        alignment = 2 },
                --Attunement 1
                    {   pos       = {0.765,0.12,0.481},
                        rows      = 1,
                        width     = 2000,
                        font_size = 150,
                        label     = "Attunned Magic Item",
                        value     = "",
                        alignment = 2 },
                --Attunement 2
                    {   pos       = {0.765,0.12,0.562},
                        rows      = 1,
                        width     = 2000,
                        font_size = 150,
                        label     = "Attunned Magic Item",
                        value     = "",
                        alignment = 2 },
                --Attunement 3
                    {   pos       = {0.765,0.12,0.644},
                        rows      = 1,
                        width     = 2000,
                        font_size = 150,
                        label     = "Attunned Magic Item",
                        value     = "",
                        alignment = 2 },
                --Attunement 4
                    {   pos       = {0.765,0.12,0.725},
                        rows      = 1,
                        width     = 2000,
                        font_size = 150,
                        label     = "Attunned Magic Item",
                        value     = "",
                        alignment = 2 },
                --Attunement 5
                    {   pos       = {0.765,0.12,0.807},
                        rows      = 1,
                        width     = 2000,
                        font_size = 150,
                        label     = "Attunned Magic Item",
                        value     = "",
                        alignment = 2 },
                --Attunement 6
                    {   pos       = {0.765,0.12,0.889},
                        rows      = 1,
                        width     = 2000,
                        font_size = 150,
                        label     = "Attunned Magic Item",
                        value     = "",
                        alignment = 2 },     
            --Weapon texboxes
                --Weapon Name1 textbox
                    {   pos       = {-0.073,0.12,-0.334},  
                        rows      = 1,
                        width     = 950,
                        font_size = 110,
                        label     = "Weapon",
                        value     = "",
                        alignment = 2 },
                --Weapon Name2 textbox
                    {   pos       = {-0.073,0.12,-0.266},
                        rows      = 1,
                        width     = 950,
                        font_size = 110,
                        label     = "Weapon",
                        value     = "",
                        alignment = 2 },
                --Weapon Name3 textbox
                    {   pos       = {-0.073,0.12,-0.199},
                        rows      = 1,
                        width     = 950,
                        font_size = 110,
                        label     = "Weapon",
                        value     = "",
                        alignment = 2 },
                --Weapon Name4 textbox
                    {   pos       = {0.776,0.12,-0.334},
                        rows      = 1,
                        width     = 950,
                        font_size = 110,
                        label     = "Weapon",
                        value     = "",
                        alignment = 2 },
                --Weapon Name5 textbox
                    {   pos       = {0.776,0.12,-0.266},
                        rows      = 1,
                        width     = 950,
                        font_size = 110,
                        label     = "Weapon",
                        value     = "",
                        alignment = 2 },
                --Weapon Name6 textbox
                    {   pos       = {0.776,0.12,-0.199},
                        rows      = 1,
                        width     = 950,
                        font_size = 110,
                        label     = "Weapon",
                        value     = "",
                        alignment = 2 },
            --Damage textboxes
                --Damage Name1 textbox
                    {   pos       = {0.269,0.12,-0.334},
                        rows      = 1,
                        width     = 900,
                        font_size = 120,
                        label     = "Damage",
                        value     = "",
                        alignment = 2 },
                --Damage Name2 textbox
                    {   pos       = {0.269,0.12,-0.266},
                        rows      = 1,
                        width     = 900,
                        font_size = 120,
                        label     = "Damage",
                        value     = "",
                        alignment = 2 },
                --Damage Name3 textbox
                    {   pos       = {0.269,0.12,-0.199},
                        rows      = 1,
                        width     = 900,
                        font_size = 120,
                        label     = "Damage",
                        value     = "",
                        alignment = 2 },
                --Damage Name4 textbox
                    {   pos       = {1.117,0.12,-0.334},
                        rows      = 1,
                        width     = 900,
                        font_size = 120,
                        label     = "Damage",
                        value     = "",
                        alignment = 2 },
                --Damage Name5 textbox
                    {   pos       = {1.117,0.11,-0.266},
                        rows      = 1,
                        width     = 900,
                        font_size = 120,
                        label     = "Damage",
                        value     = "",
                        alignment = 2 },
                --Damage Name6 textbox
                    {   pos       = {1.117,0.12,-0.199},
                        rows      = 1,
                        width     = 900,
                        font_size = 120,
                        label     = "Damage",
                        value     = "",
                        alignment = 2 },             
            --Range textboxes
                --Range Name1 textbox
                    {   pos       = {0.500,0.12,-0.334},
                        rows      = 1,
                        width     = 950,
                        font_size = 120,
                        label     = "Range/DADV",
                        value     = "",
                        alignment = 2 },
                --Range Name2 textbox
                    {   pos       = {0.500,0.12,-0.266},
                        rows      = 1,
                        width     = 950,
                        font_size = 120,
                        label     = "Range/DADV",
                        value     = "",
                        alignment = 2 },
                --Range Name3 textbox
                    {   pos       = {0.500,0.12,-0.199},
                        rows      = 1,
                        width     = 950,
                        font_size = 120,
                        label     = "Range/DADV",
                        value     = "",
                        alignment = 2 },
                --Range Name4 textbox
                    {   pos       = {1.345,0.12,-0.334},
                        rows      = 1,
                        width     = 950,
                        font_size = 120,
                        label     = "Range/DADV",
                        value     = "",
                        alignment = 2 },
                --Range Name5 textbox
                    {   pos       = {1.345,0.12,-0.266},
                        rows      = 1,
                        width     = 950,
                        font_size = 120,
                        label     = "Range/DADV",
                        value     = "",
                        alignment = 2 },
                --Range Name6 textbox
                    {   pos       = {1.345,0.12,-0.199},
                        rows      = 1,
                        width     = 950,
                        font_size = 120,
                        label     = "Range/DADV",
                        value     = "",
                        alignment = 2 },
            --Class Resource textbox
              --Resource 1
                    {   pos       = {-0.037,0.1,0.514},
                        rows      = 1,
                        width     = 1100,
                        font_size = 130,
                        label     = "Name",
                        value     = "",
                        alignment = 3 },
              --Resource 2
                    {   pos       = {0.252,0.1,0.514},
                        rows      = 1,
                        width     = 1100,
                        font_size = 130,
                        label     = "Name",
                        value     = "",
                        alignment = 3 },
              --Resource 3
                    {   pos       = {-0.037,0.1,0.757},
                        rows      = 1,
                        width     = 1100,
                        font_size = 130,
                        label     = "Name",
                        value     = "",
                        alignment = 3 },
              --Resource 4
                    {   pos       = {0.253,0.1,0.757},
                        rows      = 1,
                        width     = 1100,
                        font_size = 130,
                        label     = "Name",
                        value     = "",
                        alignment = 3 }, },
    --Consumable Textboxes
        numbox = {
            --Class Resource Total 1
                {   pos       = {-0.097,0.1,0.601}, 
                    rows      = 1,
                    width     = 360,
                    font_size = 200,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 },
            --Class Resource Total 2
                {   pos       = {0.191,0.1,0.601}, 
                    rows      = 1,
                    width     = 360,
                    font_size = 200,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 },
            --Class Resource Total 3
                {   pos       = {-0.099,0.1,0.844}, 
                    rows      = 1,
                    width     = 360,
                    font_size = 200,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 },
            --Class Resource Total 4
                {   pos       = {0.193,0.1,0.844}, 
                    rows      = 1,
                    width     = 360,
                    font_size = 200,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 },
            --Maximum Hit Points (Max HP) 5
                {   pos       = {0.715,0.1,-0.873}, 
                    rows      = 1,
                    width     = 360,
                    font_size = 200,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorRed,
                    alignment = 3 },
            --Temporary Hit Points (Temp HP) 6
                {   pos       = {1.013,0.1,-0.873},
                    rows      = 1,
                    width     = 360,
                    font_size = 200,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorYellow,
                    alignment = 3 },
            --Bonus to Max HP (Max HP Bonus)
                {   pos       = {1.161,0.1,-0.873},
                    rows      = 1,
                    width     = 360,
                    font_size = 200,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorPink,
                    alignment = 3 },
            --Ammo 1
                {   pos         = {1.389,0.12,0.547},
                    rows        = 1,
                    width       = 450,
                    font_size   = 250,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Ammo 2
                {   pos         = {1.388,0.12,0.83},
                    rows        = 1,
                    width       = 450,
                    font_size   = 250,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 }, },
    --Class Resources Used Values
        numbox2 = {
            --Used Value 1
                {   pos         = {0.025,0.1,0.601},
                    rows        = 1,
                    width       = 450,
                    font_size   = 200,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Used Value 2
                {   pos         = {0.316,0.1,0.601},
                    rows        = 1,
                    width       = 450,
                    font_size   = 200,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Used Value 3
                {   pos         = {0.025,0.1,0.844},
                    rows        = 1,
                    width       = 450,
                    font_size   = 200,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Used Value 4
                {   pos         = {0.316,0.1,0.844},
                    rows        = 1,
                    width       = 450,
                    font_size   = 200,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Current HP
                {   pos       = {0.863,0.1,-0.873},
                    rows      = 1,
                    width     = 360,
                    font_size = 200,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorRed,
                    alignment = 3 }, },
    --Bonus Saving Throws
        --STR Saving Throw bonus
            bonusstrst = {{
                pos    = {-1.217,0.1,-0.343},
                size   = 180,
                value  = 0,
                hideBG = true }, },
        --DEX Saving Throw bonus
            bonusdexst = {{
                pos    = {-1.217,0.1,-0.245},
                size   = 180,
                value  = 0,
                hideBG = true }, },
        --CON Saving Throw bonus
            bonusconst = {{
                pos    = {-1.217,0.1,-0.147},
                size   = 180,
                value  = 0,
                hideBG = true }, },
        --INT Saving Throw bonus
            bonusintst = {{
                pos    = {-0.932,0.1,-0.343},
                size   = 180,
                value  = 0,
                hideBG = true }, },
        --WIS Saving Throw bonus
            bonuswisst = {{
                pos    = {-0.932,0.1,-0.245},
                size   = 180,
                value  = 0,
                hideBG = true }, },
        --CHA Saving Throw bonus
            bonuschast = {{
                pos    = {-0.932,0.1,-0.147},
                size   = 180,
                value  = 0,
                hideBG = true }, },
}

--======================
--Lua beyond this point
--======================

--Save function
    function updateSave()
        saved_data = JSON.encode(ref_buttonData)
        if disableSave==true then saved_data="" end
        self.script_state = saved_data
    end

--Startup procedure
    function onload(saved_data)
    if disableSave==true then saved_data="" end
        if saved_data ~= "" then
            local loaded_data = JSON.decode(saved_data)
            ref_buttonData = loaded_data
        else
            ref_buttonData = defaultButtonData
    end

--Call Functions
    spawnedButtonCount = 0
    --Ability Score Counters
        createDexScoreCounter() --Index 0-8
        createStrScoreCounter() --Index 9-14
        createConScoreCounter() --Index 15-19
        createIntScoreCounter() --Index 20-30
        createWisScoreCounter() --Index 31-42
        createChaScoreCounter() --Index 43-51
        createXPLevelCounter() --Index 52-55
    --Checkbox
        createCheckbox()
        createCheckboxRed()
        createCheckboxGreen()
        createCheckboxInspiration()
    --Checkbox Saving Throws
        createCheckboxStrST()
        createCheckboxDexST()
        createCounterInit()
        createCheckboxConST()
        createCheckboxIntST()
        createCheckboxWisST()
        createCheckboxChaST()
    --Skills Checkboxes and Counters
        --DEX Acrobatics 1
            createCounterProfS1()
            createCheckboxDexSkill1()
        --WIS Animal Handling 2
            createCounterProfS2()
            createCheckboxWisSkill1()
        --INT Arcana 3
            createCounterProfS3()
            createCheckboxIntSkill1()
        --STR Athletics 4
            createCounterProfS4()
            createCheckboxStrSkill1()
        --CHA Deception 5
            createCounterProfS5()
            createCheckboxChaSkill1()
        --INT History 6
            createCounterProfS6()
            createCheckboxIntSkill2()
        --WIS Insight 7
            createCounterProfS7()
            createCheckboxWisSkill2()
        --CHA Intimidation 8
            createCounterProfS8()
            createCheckboxChaSkill2()
        --INT Investigation 9
            createCounterProfS9()
            createCheckboxIntSkill3()
        --WIS Medicine 10
            createCounterProfS10()
            createCheckboxWisSkill3()
        --INT Nature 11
            createCounterProfS11()
            createCheckboxIntSkill4()
        --WIS Medicine 12
            createCounterProfS12()
            createCheckboxWisSkill4()
        --CHA Performance 13
            createCounterProfS13()
            createCheckboxChaSkill3()
        --CHA Persuassion 14
            createCounterProfS14()
            createCheckboxChaSkill4()
        --INT Religion 15
            createCounterProfS15()
            createCheckboxIntSkill5()
        --DEX Sleight of Hand 16
            createCounterProfS16()
            createCheckboxDexSkill2()
        --DEX Stealth 17
            createCounterProfS17()
            createCheckboxDexSkill3()
        --WIS Survival 18
            createCounterProfS18()
            createCheckboxWisSkill5()
    --Counters
        createCounter()
        createCounterSpeed()
        createCounterProf()
    --Misc
        createCheckboxLock()
        createLongRest()
        createTextbox()
        createNumbox()
        createNumbox2()
    --Bonus to Saving Throws
        createBonusStrST()
        createBonusDexST()
        createBonusConST()
        createBonusIntST()
        createBonusWisST()
        createBonusChaST()
    end

--============================
--Click functions for buttons
--============================
    
    --===================
    --Checkbox Functions
    --===================
        --Click function for Checkboxes
            function click_checkbox(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state == true then
                    if ref_buttonData.checkbox[tableIndex].state == true then
                        ref_buttonData.checkbox[tableIndex].state = false
                        self.editButton({index=buttonIndex, label=""})
                    else
                        ref_buttonData.checkbox[tableIndex].state = true
                        self.editButton({index=buttonIndex, label=string.char(9679)})
                    end
                elseif ref_buttonData.checkboxlock[1].state == false and tableIndex == 5 or --AC Shield
                ref_buttonData.checkboxlock[1].state == false and tableIndex == 6 then --Temp AC Magic
                    if ref_buttonData.checkbox[tableIndex].state == true then
                        ref_buttonData.checkbox[tableIndex].state = false
                        self.editButton({index=buttonIndex, label=""})
                    else
                        ref_buttonData.checkbox[tableIndex].state = true
                        self.editButton({index=buttonIndex, label=string.char(9679)})
                    end
                end
                updateSave()
            end

        --Click function for Red Checkboxes (Failed Saving Throw)
            function click_checkboxr(tableIndex, buttonIndex)
                if ref_buttonData.checkboxr[tableIndex].state == true then
                    ref_buttonData.checkboxr[tableIndex].state = false
                    self.editButton({index=buttonIndex, label=""})
                else
                    ref_buttonData.checkboxr[tableIndex].state = true
                    self.editButton({index=buttonIndex, label=string.char(10007)})
                end
                updateSave()
            end

        --Click function for Green Checkboxes (Success Saving Throw)
            function click_checkboxg(tableIndex, buttonIndex)
                if ref_buttonData.checkboxg[tableIndex].state == true then
                    ref_buttonData.checkboxg[tableIndex].state = false
                    self.editButton({index=buttonIndex, label=""})
                else
                    ref_buttonData.checkboxg[tableIndex].state = true
                    self.editButton({index=buttonIndex, label=string.char(10003)})
                end
                updateSave()
            end

    --======================
    --Saving Throw Functions
    --======================
        --Checkbox for Strength Saving Throws
            function click_checkboxstrst(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.strcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveBonus = ref_buttonData.bonusstrst[tableIndex].value
                        if ref_buttonData.checkboxstrst[tableIndex].state == false then
                            ref_buttonData.checkboxstrst[tableIndex].state = true
                            self.editButton({index=buttonIndex, label=string.char(9679)})
                            --When checked just equal ability mod
                            self.editButton({index=11, label=(saveMod + saveProf + saveBonus)})
                        elseif ref_buttonData.checkboxstrst[tableIndex].state == true then
                            ref_buttonData.checkboxstrst[tableIndex].state = false
                            self.editButton({index=buttonIndex, label=""})
                            --When checked add prof bonus
                            self.editButton({index=11, label=(saveMod + saveBonus)})
                        end
                    updateSave()
                end
            end

        --Checkbox for Dexterity Saving Throws
            function click_checkboxdexst(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.dexcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveBonus = ref_buttonData.bonusdexst[tableIndex].value
                        if ref_buttonData.checkboxdexst[tableIndex].state == false then
                            ref_buttonData.checkboxdexst[tableIndex].state = true
                            self.editButton({index=buttonIndex, label=string.char(9679)})
                            --When checked just equal ability mod
                            self.editButton({index=2, label=(saveMod + saveProf + saveBonus)})
                        elseif ref_buttonData.checkboxdexst[tableIndex].state == true then
                            ref_buttonData.checkboxdexst[tableIndex].state = false
                            self.editButton({index=buttonIndex, label=""})
                            --When checked add prof bonus
                            self.editButton({index=2, label=(saveMod + saveBonus)})
                        end
                    updateSave()
                end
            end

        --Checkbox for Constitution Saving Throws
            function click_checkboxconst(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.concounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveBonus = ref_buttonData.bonusconst[tableIndex].value
                        if ref_buttonData.checkboxconst[tableIndex].state == false then
                            ref_buttonData.checkboxconst[tableIndex].state = true
                            self.editButton({index=buttonIndex, label=string.char(9679)})
                            --When checked just equal ability mod
                            self.editButton({index=17, label=(saveMod + saveProf + saveBonus)})
                        elseif ref_buttonData.checkboxconst[tableIndex].state == true then
                            ref_buttonData.checkboxconst[tableIndex].state = false
                            self.editButton({index=buttonIndex, label=""})
                            --When checked add prof bonus
                            self.editButton({index=17, label=(saveMod + saveBonus)})
                        end
                    updateSave()
                end
            end

        --Checkbox for Intelligence Saving Throws
            function click_checkboxintst(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveBonus = ref_buttonData.bonusintst[tableIndex].value
                        if ref_buttonData.checkboxintst[tableIndex].state == false then
                            ref_buttonData.checkboxintst[tableIndex].state = true
                            self.editButton({index=buttonIndex, label=string.char(9679)})
                            --When checked just equal ability mod
                            self.editButton({index=22, label=(saveMod + saveProf + saveBonus)})
                        elseif ref_buttonData.checkboxintst[tableIndex].state == true then
                            ref_buttonData.checkboxintst[tableIndex].state = false
                            self.editButton({index=buttonIndex, label=""})
                            --When checked add prof bonus
                            self.editButton({index=22, label=(saveMod + saveBonus)})
                        end
                    updateSave()
                end
            end

        --Checkbox for Wisdom Saving Throws
            function click_checkboxwisst(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveBonus = ref_buttonData.bonuswisst[tableIndex].value
                        if ref_buttonData.checkboxwisst[tableIndex].state == false then
                            ref_buttonData.checkboxwisst[tableIndex].state = true
                            self.editButton({index=buttonIndex, label=string.char(9679)})
                            --When checked just equal ability mod
                            self.editButton({index=33, label=(saveMod + saveProf + saveBonus)})
                        elseif ref_buttonData.checkboxwisst[tableIndex].state == true then
                            ref_buttonData.checkboxwisst[tableIndex].state = false
                            self.editButton({index=buttonIndex, label=""})
                            --When checked add prof bonus
                            self.editButton({index=33, label=(saveMod + saveBonus)})
                        end
                    updateSave()
                end
            end

        --Checkbox for Charisma Saving Throws
            function click_checkboxchast(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.chacounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveBonus = ref_buttonData.bonuschast[tableIndex].value
                        if ref_buttonData.checkboxchast[tableIndex].state == false then
                            ref_buttonData.checkboxchast[tableIndex].state = true
                            self.editButton({index=buttonIndex, label=string.char(9679)})
                            --When checked just equal ability mod
                            self.editButton({index=45, label=(saveMod + saveProf + saveBonus)})
                        elseif ref_buttonData.checkboxchast[tableIndex].state == true then
                            ref_buttonData.checkboxchast[tableIndex].state = false
                            self.editButton({index=buttonIndex, label=""})
                            --When checked add prof bonus
                            self.editButton({index=45, label=(saveMod + saveBonus)})
                        end
                    updateSave()
                end
            end

    --============================
    --Skill Score Checkboxes
    --============================
        --Checkbox for DEX 1 Acrobatics
            function click_checkboxdexskill1(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.dexcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs1[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxdexskill1[tableIndex].state == true and ref_buttonData.checkboxdexskill1[tableIndex].value == 1 then
                            ref_buttonData.checkboxdexskill1[tableIndex].state = true
                            ref_buttonData.checkboxdexskill1[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=3, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxdexskill1[tableIndex].state == false then
                            ref_buttonData.checkboxdexskill1[tableIndex].state = true
                            ref_buttonData.checkboxdexskill1[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=3, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxdexskill1[tableIndex].state == true and ref_buttonData.checkboxdexskill1[tableIndex].value == 2 then
                            ref_buttonData.checkboxdexskill1[tableIndex].state = false
                            ref_buttonData.checkboxdexskill1[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=3, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Checkbox for WIS 2 Animal Handling
            function click_checkboxwisskill1(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs2[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill1[tableIndex].state == true and ref_buttonData.checkboxwisskill1[tableIndex].value == 1 then
                            ref_buttonData.checkboxwisskill1[tableIndex].state = true
                            ref_buttonData.checkboxwisskill1[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=34, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill1[tableIndex].state == false then
                            ref_buttonData.checkboxwisskill1[tableIndex].state = true
                            ref_buttonData.checkboxwisskill1[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=34, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill1[tableIndex].state == true and ref_buttonData.checkboxwisskill1[tableIndex].value == 2 then
                            ref_buttonData.checkboxwisskill1[tableIndex].state = false
                            ref_buttonData.checkboxwisskill1[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=34, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Checkbox for INT 3 Arcana
            function click_checkboxintskill1(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs3[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxintskill1[tableIndex].state == true and ref_buttonData.checkboxintskill1[tableIndex].value == 1 then
                            ref_buttonData.checkboxintskill1[tableIndex].state = true
                            ref_buttonData.checkboxintskill1[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=23, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill1[tableIndex].state == false then
                            ref_buttonData.checkboxintskill1[tableIndex].state = true
                            ref_buttonData.checkboxintskill1[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=23, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill1[tableIndex].state == true and ref_buttonData.checkboxintskill1[tableIndex].value == 2 then
                            ref_buttonData.checkboxintskill1[tableIndex].state = false
                            ref_buttonData.checkboxintskill1[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=23, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Checkbox for STR 4 Athletics
            function click_checkboxstrskill1(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.strcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs4[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxstrskill1[tableIndex].state == true and ref_buttonData.checkboxstrskill1[tableIndex].value == 1 then
                            ref_buttonData.checkboxstrskill1[tableIndex].state = true
                            ref_buttonData.checkboxstrskill1[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=12, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxstrskill1[tableIndex].state == false then
                            ref_buttonData.checkboxstrskill1[tableIndex].state = true
                            ref_buttonData.checkboxstrskill1[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=12, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxstrskill1[tableIndex].state == true and ref_buttonData.checkboxstrskill1[tableIndex].value == 2 then
                            ref_buttonData.checkboxstrskill1[tableIndex].state = false
                            ref_buttonData.checkboxstrskill1[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=12, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Checkbox for CHA 5 Deception
            function click_checkboxchaskill1(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.chacounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs5[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill1[tableIndex].state == true and ref_buttonData.checkboxchaskill1[tableIndex].value == 1 then
                            ref_buttonData.checkboxchaskill1[tableIndex].state = true
                            ref_buttonData.checkboxchaskill1[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=46, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill1[tableIndex].state == false then
                            ref_buttonData.checkboxchaskill1[tableIndex].state = true
                            ref_buttonData.checkboxchaskill1[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=46, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill1[tableIndex].state == true and ref_buttonData.checkboxchaskill1[tableIndex].value == 2 then
                            ref_buttonData.checkboxchaskill1[tableIndex].state = false
                            ref_buttonData.checkboxchaskill1[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=46, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Checkbox for INT 6 History
            function click_checkboxintskill2(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs6[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxintskill2[tableIndex].state == true and ref_buttonData.checkboxintskill2[tableIndex].value == 1 then
                            ref_buttonData.checkboxintskill2[tableIndex].state = true
                            ref_buttonData.checkboxintskill2[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=24, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill2[tableIndex].state == false then
                            ref_buttonData.checkboxintskill2[tableIndex].state = true
                            ref_buttonData.checkboxintskill2[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=24, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill2[tableIndex].state == true and ref_buttonData.checkboxintskill2[tableIndex].value == 2 then
                            ref_buttonData.checkboxintskill2[tableIndex].state = false
                            ref_buttonData.checkboxintskill2[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=24, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Checkbox for WIS 7 Insight
            function click_checkboxwisskill2(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs7[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill2[tableIndex].state == true and ref_buttonData.checkboxwisskill2[tableIndex].value == 1 then
                            ref_buttonData.checkboxwisskill2[tableIndex].state = true
                            ref_buttonData.checkboxwisskill2[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=35, label=(saveMod + (saveProf*2) + saveMiscProf)})
                            self.editButton({index=36, label=(saveMod + (saveProf*2) + saveMiscProf + 10)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill2[tableIndex].state == false then
                            ref_buttonData.checkboxwisskill2[tableIndex].state = true
                            ref_buttonData.checkboxwisskill2[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=35, label=(saveMod + saveProf + saveMiscProf)})
                            self.editButton({index=36, label=(saveMod + saveProf + saveMiscProf + 10)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill2[tableIndex].state == true and ref_buttonData.checkboxwisskill2[tableIndex].value == 2 then
                            ref_buttonData.checkboxwisskill2[tableIndex].state = false
                            ref_buttonData.checkboxwisskill2[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=35, label=(saveMod + saveMiscProf)})
                            self.editButton({index=36, label=(saveMod + saveMiscProf + 10)})
                        end
                    updateSave()
                end
            end

        --Checkbox for CHA 8 Intimidation
            function click_checkboxchaskill2(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.chacounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs8[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill2[tableIndex].state == true and ref_buttonData.checkboxchaskill2[tableIndex].value == 1 then
                            ref_buttonData.checkboxchaskill2[tableIndex].state = true
                            ref_buttonData.checkboxchaskill2[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=47, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill2[tableIndex].state == false then
                            ref_buttonData.checkboxchaskill2[tableIndex].state = true
                            ref_buttonData.checkboxchaskill2[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=47, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill2[tableIndex].state == true and ref_buttonData.checkboxchaskill2[tableIndex].value == 2 then
                            ref_buttonData.checkboxchaskill2[tableIndex].state = false
                            ref_buttonData.checkboxchaskill2[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=47, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Checkbox for INT 9 Investigation
            function click_checkboxintskill3(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs9[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxintskill3[tableIndex].state == true and ref_buttonData.checkboxintskill3[tableIndex].value == 1 then
                            ref_buttonData.checkboxintskill3[tableIndex].state = true
                            ref_buttonData.checkboxintskill3[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=25, label=(saveMod + (saveProf*2) + saveMiscProf)})
                            self.editButton({index=26, label=(saveMod + (saveProf*2) + saveMiscProf + 10)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill3[tableIndex].state == false then
                            ref_buttonData.checkboxintskill3[tableIndex].state = true
                            ref_buttonData.checkboxintskill3[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=25, label=(saveMod + saveProf + saveMiscProf)})
                            self.editButton({index=26, label=(saveMod + saveProf + saveMiscProf + 10)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill3[tableIndex].state == true and ref_buttonData.checkboxintskill3[tableIndex].value == 2 then
                            ref_buttonData.checkboxintskill3[tableIndex].state = false
                            ref_buttonData.checkboxintskill3[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=25, label=(saveMod + saveMiscProf)})
                            self.editButton({index=26, label=(saveMod + saveMiscProf + 10)})
                        end
                    updateSave()
                end
            end

        --Checkbox for WIS 10 Medicine
            function click_checkboxwisskill3(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs10[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill3[tableIndex].state == true and ref_buttonData.checkboxwisskill3[tableIndex].value == 1 then
                            ref_buttonData.checkboxwisskill3[tableIndex].state = true
                            ref_buttonData.checkboxwisskill3[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=37, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill3[tableIndex].state == false then
                            ref_buttonData.checkboxwisskill3[tableIndex].state = true
                            ref_buttonData.checkboxwisskill3[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=37, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill3[tableIndex].state == true and ref_buttonData.checkboxwisskill3[tableIndex].value == 2 then
                            ref_buttonData.checkboxwisskill3[tableIndex].state = false
                            ref_buttonData.checkboxwisskill3[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=37, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Checkbox for INT 11 Nature
            function click_checkboxintskill4(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs11[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxintskill4[tableIndex].state == true and ref_buttonData.checkboxintskill4[tableIndex].value == 1 then
                            ref_buttonData.checkboxintskill4[tableIndex].state = true
                            ref_buttonData.checkboxintskill4[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=27, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill4[tableIndex].state == false then
                            ref_buttonData.checkboxintskill4[tableIndex].state = true
                            ref_buttonData.checkboxintskill4[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=27, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill4[tableIndex].state == true and ref_buttonData.checkboxintskill4[tableIndex].value == 2 then
                            ref_buttonData.checkboxintskill4[tableIndex].state = false
                            ref_buttonData.checkboxintskill4[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=27, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Checkbox for WIS 12 Perception
            function click_checkboxwisskill4(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs12[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill4[tableIndex].state == true and ref_buttonData.checkboxwisskill4[tableIndex].value == 1 then
                            ref_buttonData.checkboxwisskill4[tableIndex].state = true
                            ref_buttonData.checkboxwisskill4[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=38, label=(saveMod + (saveProf*2) + saveMiscProf)})
                            self.editButton({index=39, label=(saveMod + (saveProf*2) + saveMiscProf + 10)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill4[tableIndex].state == false then
                            ref_buttonData.checkboxwisskill4[tableIndex].state = true
                            ref_buttonData.checkboxwisskill4[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=38, label=(saveMod + saveProf + saveMiscProf)})
                            self.editButton({index=39, label=(saveMod + saveProf + saveMiscProf + 10)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill4[tableIndex].state == true and ref_buttonData.checkboxwisskill4[tableIndex].value == 2 then
                            ref_buttonData.checkboxwisskill4[tableIndex].state = false
                            ref_buttonData.checkboxwisskill4[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=38, label=(saveMod + saveMiscProf)})
                            self.editButton({index=39, label=(saveMod + saveMiscProf + 10)})
                        end
                    updateSave()
                end
            end

        --Checkbox for CHA 13 Performance
            function click_checkboxchaskill3(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.chacounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs13[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill3[tableIndex].state == true and ref_buttonData.checkboxchaskill3[tableIndex].value == 1 then
                            ref_buttonData.checkboxchaskill3[tableIndex].state = true
                            ref_buttonData.checkboxchaskill3[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=48, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill3[tableIndex].state == false then
                            ref_buttonData.checkboxchaskill3[tableIndex].state = true
                            ref_buttonData.checkboxchaskill3[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=48, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill3[tableIndex].state == true and ref_buttonData.checkboxchaskill3[tableIndex].value == 2 then
                            ref_buttonData.checkboxchaskill3[tableIndex].state = false
                            ref_buttonData.checkboxchaskill3[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=48, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Checkbox for CHA 14 Persuassion
            function click_checkboxchaskill4(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.chacounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs14[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill4[tableIndex].state == true and ref_buttonData.checkboxchaskill4[tableIndex].value == 1 then
                            ref_buttonData.checkboxchaskill4[tableIndex].state = true
                            ref_buttonData.checkboxchaskill4[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=49, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill4[tableIndex].state == false then
                            ref_buttonData.checkboxchaskill4[tableIndex].state = true
                            ref_buttonData.checkboxchaskill4[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=49, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill4[tableIndex].state == true and ref_buttonData.checkboxchaskill4[tableIndex].value == 2 then
                            ref_buttonData.checkboxchaskill4[tableIndex].state = false
                            ref_buttonData.checkboxchaskill4[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=49, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Checkbox for INT 15 Religion
            function click_checkboxintskill5(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs15[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxintskill5[tableIndex].state == true and ref_buttonData.checkboxintskill5[tableIndex].value == 1 then
                            ref_buttonData.checkboxintskill5[tableIndex].state = true
                            ref_buttonData.checkboxintskill5[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=28, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill5[tableIndex].state == false then
                            ref_buttonData.checkboxintskill5[tableIndex].state = true
                            ref_buttonData.checkboxintskill5[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=28, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill5[tableIndex].state == true and ref_buttonData.checkboxintskill5[tableIndex].value == 2 then
                            ref_buttonData.checkboxintskill5[tableIndex].state = false
                            ref_buttonData.checkboxintskill5[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=28, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Checkbox for DEX 16 Sleight of Hand
            function click_checkboxdexskill2(tableIndex, buttonIndex)
                    if ref_buttonData.checkboxlock[1].state then
                        local saveMod = math.floor(((ref_buttonData.dexcounterscore[tableIndex].value - 10) / 2))
                        local saveProf = ref_buttonData.counterprof[tableIndex].value
                        local saveMiscProf = ref_buttonData.counterprofs16[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxdexskill2[tableIndex].state == true and ref_buttonData.checkboxdexskill2[tableIndex].value == 1 then
                            ref_buttonData.checkboxdexskill2[tableIndex].state = true
                            ref_buttonData.checkboxdexskill2[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=4, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxdexskill2[tableIndex].state == false then
                            ref_buttonData.checkboxdexskill2[tableIndex].state = true
                            ref_buttonData.checkboxdexskill2[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=4, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxdexskill2[tableIndex].state == true and ref_buttonData.checkboxdexskill2[tableIndex].value == 2 then
                            ref_buttonData.checkboxdexskill2[tableIndex].state = false
                            ref_buttonData.checkboxdexskill2[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=4, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end
    
        --Checkbox for DEX 17 Stealth
            function click_checkboxdexskill3(tableIndex, buttonIndex)
                    if ref_buttonData.checkboxlock[1].state then
                        local saveMod = math.floor(((ref_buttonData.dexcounterscore[tableIndex].value - 10) / 2))
                        local saveProf = ref_buttonData.counterprof[tableIndex].value
                        local saveMiscProf = ref_buttonData.counterprofs17[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxdexskill3[tableIndex].state == true and ref_buttonData.checkboxdexskill3[tableIndex].value == 1 then
                            ref_buttonData.checkboxdexskill3[tableIndex].state = true
                            ref_buttonData.checkboxdexskill3[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=5, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxdexskill3[tableIndex].state == false then
                            ref_buttonData.checkboxdexskill3[tableIndex].state = true
                            ref_buttonData.checkboxdexskill3[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=5, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxdexskill3[tableIndex].state == true and ref_buttonData.checkboxdexskill3[tableIndex].value == 2 then
                            ref_buttonData.checkboxdexskill3[tableIndex].state = false
                            ref_buttonData.checkboxdexskill3[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=5, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Checkbox for WIS 18 Survival
            function click_checkboxwisskill5(tableIndex, buttonIndex)
                if ref_buttonData.checkboxlock[1].state then
                    local saveMod = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs18[tableIndex].value
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill5[tableIndex].state == true and ref_buttonData.checkboxwisskill5[tableIndex].value == 1 then
                            ref_buttonData.checkboxwisskill5[tableIndex].state = true
                            ref_buttonData.checkboxwisskill5[tableIndex].value = 2
                            self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679)})
                            self.editButton({index=40, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill5[tableIndex].state == false then
                            ref_buttonData.checkboxwisskill5[tableIndex].state = true
                            ref_buttonData.checkboxwisskill5[tableIndex].value = 1
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679)})
                            self.editButton({index=40, label=(saveMod + saveProf + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill5[tableIndex].state == true and ref_buttonData.checkboxwisskill5[tableIndex].value == 2 then
                            ref_buttonData.checkboxwisskill5[tableIndex].state = false
                            ref_buttonData.checkboxwisskill5[tableIndex].value = 0
                            self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=""})
                            self.editButton({index=40, label=(saveMod + saveMiscProf)})
                        end
                    updateSave()
                end
            end

    --============================
    --Counter Displays
    --============================
        --Applies value to Basic Counter display
            function click_counter(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state == true then
                    ref_buttonData.counter[tableIndex].value = ref_buttonData.counter[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counter[tableIndex].value})
                elseif ref_buttonData.checkboxlock[1].state == false and tableIndex == 4 or --Temp AC Bonus
                ref_buttonData.checkboxlock[1].state == false and tableIndex == 5 then --Exhaustion 
                    ref_buttonData.counter[tableIndex].value = ref_buttonData.counter[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counter[tableIndex].value})
                end
                updateSave()
            end

        --Applies value to Multi Counter display
            function click_counterspeed(tableIndex, buttonIndex, amount)
              if ref_buttonData.checkboxlock[1].state then
                ref_buttonData.counterspeed[tableIndex].value = ref_buttonData.counterspeed[tableIndex].value + amount
                self.editButton({index=buttonIndex, label=ref_buttonData.counterspeed[tableIndex].value})
                updateSave()
              end
            end

    --============================
    --Skill Proficiency Counters
    --============================
        --Applies value to Proficency Counter display
            function click_counterprof(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprof[tableIndex].value = ref_buttonData.counterprof[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprof[tableIndex].value})

                    local saveModStr = math.floor(((ref_buttonData.strcounterscore[tableIndex].value - 10) / 2))
                    local saveModDex = math.floor(((ref_buttonData.dexcounterscore[tableIndex].value - 10) / 2))
                    local saveModCon = math.floor(((ref_buttonData.concounterscore[tableIndex].value - 10) / 2))
                    local saveModInt = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                    local saveModWis = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                    local saveModCha = math.floor(((ref_buttonData.chacounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value

                    --Strength Saving Throw Score
                        if ref_buttonData.checkboxstrst[tableIndex].state == true then
                            self.editButton({index=11, label=(saveModStr + saveProf)})
                        elseif ref_buttonData.checkboxstrst[tableIndex].state == false then
                            self.editButton({index=11, label=(saveModStr)})
                        end
                    --Dexterity Saving Throw Score
                        if ref_buttonData.checkboxdexst[tableIndex].state == true then
                            self.editButton({index=2, label=(saveModDex + saveProf)})
                        elseif ref_buttonData.checkboxdexst[tableIndex].state == false then
                            self.editButton({index=2, label=(saveModDex)})
                        end
                    --Constitution Saving Throw Score
                        if ref_buttonData.checkboxconst[tableIndex].state == true then
                            self.editButton({index=17, label=(saveModCon + saveProf)})
                        elseif ref_buttonData.checkboxconst[tableIndex].state == false then
                            self.editButton({index=17, label=(saveModCon)})
                        end
                    --Intelligence Saving Throw Score
                        if ref_buttonData.checkboxintst[tableIndex].state == true then
                            self.editButton({index=22, label=(saveModInt + saveProf)})
                        elseif ref_buttonData.checkboxintst[tableIndex].state == false then
                            self.editButton({index=22, label=(saveModInt)})
                        end
                    --Wisdom Saving Throw Score
                        if ref_buttonData.checkboxwisst[tableIndex].state == true then
                            self.editButton({index=33, label=(saveModWis + saveProf)})
                        elseif ref_buttonData.checkboxwisst[tableIndex].state == false then
                            self.editButton({index=23, label=(saveModWis)})
                        end
                    --Charisma Saving Throw Score
                        if ref_buttonData.checkboxchast[tableIndex].state == true then
                            self.editButton({index=45, label=(saveModCha + saveProf)})
                        elseif ref_buttonData.checkboxchast[tableIndex].state == false then
                            self.editButton({index=45, label=(saveModCha)})
                        end

                    --DEX 1 Acrobatics Score
                        --Expertise Check
                        if ref_buttonData.checkboxdexskill1[tableIndex].state == true and ref_buttonData.checkboxdexskill1[tableIndex].value == 1 then
                            self.editButton({index=3, label=(saveModDex + saveProf + ref_buttonData.counterprofs1[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxdexskill1[tableIndex].state == false then
                            self.editButton({index=3, label=(saveModDex + ref_buttonData.counterprofs1[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxdexskill1[tableIndex].state == true and ref_buttonData.checkboxdexskill1[tableIndex].value == 2 then
                            self.editButton({index=3, label=(saveModDex + (saveProf*2) + ref_buttonData.counterprofs1[tableIndex].value)})
                        end
                    --WIS 2 Animal Handling Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill1[tableIndex].state == true and ref_buttonData.checkboxwisskill1[tableIndex].value == 1 then
                            self.editButton({index=34, label=(saveModWis + saveProf + ref_buttonData.counterprofs2[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill1[tableIndex].state == false then
                            self.editButton({index=34, label=(saveModWis + ref_buttonData.counterprofs2[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill1[tableIndex].state == true and ref_buttonData.checkboxwisskill1[tableIndex].value == 2 then
                            self.editButton({index=34, label=(saveModWis + (saveProf*2) + ref_buttonData.counterprofs2[tableIndex].value)})
                        end
                    --INT 3 Arcana Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill1[tableIndex].state == true and ref_buttonData.checkboxintskill1[tableIndex].value == 1 then
                            self.editButton({index=23, label=(saveModInt + saveProf + ref_buttonData.counterprofs4[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill1[tableIndex].state == false then
                            self.editButton({index=23, label=(saveModInt + ref_buttonData.counterprofs4[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill1[tableIndex].state == true and ref_buttonData.checkboxintskill1[tableIndex].value == 2 then
                            self.editButton({index=23, label=(saveModInt + (saveProf*2) + ref_buttonData.counterprofs4[tableIndex].value)})
                        end
                    --STR 4 Athletics Score
                        --Expertise Check
                        if ref_buttonData.checkboxstrskill1[tableIndex].state == true and ref_buttonData.checkboxstrskill1[tableIndex].value == 1 then
                            self.editButton({index=12, label=(saveModStr + saveProf + ref_buttonData.counterprofs4[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxstrskill1[tableIndex].state == false then
                            self.editButton({index=12, label=(saveModStr + ref_buttonData.counterprofs4[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxstrskill1[tableIndex].state == true and ref_buttonData.checkboxstrskill1[tableIndex].value == 2 then
                            self.editButton({index=12, label=(saveModStr + (saveProf*2) + ref_buttonData.counterprofs4[tableIndex].value)})
                        end
                    --CHA 5 Deception Score
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill1[tableIndex].state == true and ref_buttonData.checkboxchaskill1[tableIndex].value == 1 then
                            self.editButton({index=46, label=(saveModCha + saveProf + ref_buttonData.counterprofs5[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill1[tableIndex].state == false then
                            self.editButton({index=46, label=(saveModCha + ref_buttonData.counterprofs5[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill1[tableIndex].state == true and ref_buttonData.checkboxchaskill1[tableIndex].value == 2 then
                            self.editButton({index=46, label=(saveModCha + (saveProf*2) + ref_buttonData.counterprofs5[tableIndex].value)})
                        end
                    --INT 6 History Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill2[tableIndex].state == true and ref_buttonData.checkboxintskill2[tableIndex].value == 1 then
                            self.editButton({index=24, label=(saveModInt + saveProf + ref_buttonData.counterprofs6[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill2[tableIndex].state == false then
                            self.editButton({index=24, label=(saveModInt + ref_buttonData.counterprofs6[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill2[tableIndex].state == true and ref_buttonData.checkboxintskill2[tableIndex].value == 2 then
                            self.editButton({index=24, label=(saveModInt + (saveProf*2) + ref_buttonData.counterprofs6[tableIndex].value)})
                        end
                    --WIS 7 Insight Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill2[tableIndex].state == true and ref_buttonData.checkboxwisskill2[tableIndex].value == 1 then
                            self.editButton({index=35, label=(saveModWis + saveProf + ref_buttonData.counterprofs7[tableIndex].value)})
                            self.editButton({index=36, label=(saveModWis + saveProf + ref_buttonData.counterprofs7[tableIndex].value + 10)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill2[tableIndex].state == false then
                            self.editButton({index=35, label=(saveModWis + ref_buttonData.counterprofs7[tableIndex].value)})
                            self.editButton({index=36, label=(saveModWis + ref_buttonData.counterprofs7[tableIndex].value + 10)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill2[tableIndex].state == true and ref_buttonData.checkboxwisskill2[tableIndex].value == 2 then
                            self.editButton({index=35, label=(saveModWis + (saveProf*2) + ref_buttonData.counterprofs7[tableIndex].value)})
                            self.editButton({index=36, label=(saveModWis + (saveProf*2) + ref_buttonData.counterprofs7[tableIndex].value + 10)})
                        end
                    --CHA 8 Intimidation Score
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill2[tableIndex].state == true and ref_buttonData.checkboxchaskill2[tableIndex].value == 1 then
                            self.editButton({index=47, label=(saveModCha + saveProf + ref_buttonData.counterprofs8[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill2[tableIndex].state == false then
                            self.editButton({index=47, label=(saveModCha + ref_buttonData.counterprofs8[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill2[tableIndex].state == true and ref_buttonData.checkboxchaskill2[tableIndex].value == 2 then
                            self.editButton({index=47, label=(saveModCha + (saveProf*2) + ref_buttonData.counterprofs8[tableIndex].value)})
                        end
                    --INT 9 Investigation Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill3[tableIndex].state == true and ref_buttonData.checkboxintskill3[tableIndex].value == 1 then
                            self.editButton({index=25, label=(saveModInt + saveProf + ref_buttonData.counterprofs9[tableIndex].value)})
                            self.editButton({index=26, label=(saveModInt + saveProf + ref_buttonData.counterprofs9[tableIndex].value + 10)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill3[tableIndex].state == false then
                            self.editButton({index=25, label=(saveModInt + ref_buttonData.counterprofs9[tableIndex].value)})
                            self.editButton({index=26, label=(saveModInt + ref_buttonData.counterprofs9[tableIndex].value + 10)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill3[tableIndex].state == true and ref_buttonData.checkboxintskill3[tableIndex].value == 2 then
                            self.editButton({index=25, label=(saveModInt + (saveProf*2) + ref_buttonData.counterprofs9[tableIndex].value)})
                            self.editButton({index=26, label=(saveModInt + (saveProf*2) + ref_buttonData.counterprofs9[tableIndex].value + 10)})
                        end
                    --WIS 10 Medicine Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill3[tableIndex].state == true and ref_buttonData.checkboxwisskill3[tableIndex].value == 1 then
                            self.editButton({index=37, label=(saveModWis + saveProf + ref_buttonData.counterprofs10[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill3[tableIndex].state == false then
                            self.editButton({index=37, label=(saveModWis + ref_buttonData.counterprofs10[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill3[tableIndex].state == true and ref_buttonData.checkboxwisskill3[tableIndex].value == 2 then
                            self.editButton({index=37, label=(saveModWis + (saveProf*2) + ref_buttonData.counterprofs10[tableIndex].value)})
                        end
                    --INT 11 Nature Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill4[tableIndex].state == true and ref_buttonData.checkboxintskill4[tableIndex].value == 1 then
                            self.editButton({index=27, label=(saveModInt + saveProf + ref_buttonData.counterprofs11[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill4[tableIndex].state == false then
                            self.editButton({index=27, label=(saveModInt + ref_buttonData.counterprofs11[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill4[tableIndex].state == true and ref_buttonData.checkboxintskill4[tableIndex].value == 2 then
                            self.editButton({index=27, label=(saveModInt + (saveProf*2) + ref_buttonData.counterprofs11[tableIndex].value)})
                        end
                    --WIS 12 Perception Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill4[tableIndex].state == true and ref_buttonData.checkboxwisskill4[tableIndex].value == 1 then
                            self.editButton({index=38, label=(saveModWis + saveProf + ref_buttonData.counterprofs12[tableIndex].value)})
                            self.editButton({index=39, label=(saveModWis + saveProf + ref_buttonData.counterprofs12[tableIndex].value + 10)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill4[tableIndex].state == false then
                            self.editButton({index=38, label=(saveModWis + ref_buttonData.counterprofs12[tableIndex].value)})
                            self.editButton({index=39, label=(saveModWis + ref_buttonData.counterprofs12[tableIndex].value + 10)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill4[tableIndex].state == true and ref_buttonData.checkboxwisskill4[tableIndex].value == 2 then
                            self.editButton({index=38, label=(saveModWis + (saveProf*2) + ref_buttonData.counterprofs12[tableIndex].value)})
                            self.editButton({index=39, label=(saveModWis + (saveProf*2) + ref_buttonData.counterprofs12[tableIndex].value + 10)})
                        end
                    --CHA 13 Performance Score
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill3[tableIndex].state == true and ref_buttonData.checkboxchaskill3[tableIndex].value == 1 then
                            self.editButton({index=48, label=(saveModCha + saveProf + ref_buttonData.counterprofs13[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill3[tableIndex].state == false then
                            self.editButton({index=48, label=(saveModCha + ref_buttonData.counterprofs13[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill3[tableIndex].state == true and ref_buttonData.checkboxchaskill3[tableIndex].value == 2 then
                            self.editButton({index=48, label=(saveModCha + (saveProf*2) + ref_buttonData.counterprofs13[tableIndex].value)})
                        end
                    --CHA 14 Persuassion Score
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill4[tableIndex].state == true and ref_buttonData.checkboxchaskill4[tableIndex].value == 1 then
                            self.editButton({index=49, label=(saveModCha + saveProf + ref_buttonData.counterprofs14[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill4[tableIndex].state == false then
                            self.editButton({index=49, label=(saveModCha + ref_buttonData.counterprofs14[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill4[tableIndex].state == true and ref_buttonData.checkboxchaskill4[tableIndex].value == 2 then
                            self.editButton({index=49, label=(saveModCha + (saveProf*2) + ref_buttonData.counterprofs14[tableIndex].value)})
                        end
                    --INT 15 Religion Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill5[tableIndex].state == true and ref_buttonData.checkboxintskill5[tableIndex].value == 1 then
                            self.editButton({index=28, label=(saveModInt + saveProf + ref_buttonData.counterprofs15[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill5[tableIndex].state == false then
                            self.editButton({index=28, label=(saveModInt + ref_buttonData.counterprofs15[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill5[tableIndex].state == true and ref_buttonData.checkboxintskill5[tableIndex].value == 2 then
                            self.editButton({index=28, label=(saveModInt + (saveProf*2) + ref_buttonData.counterprofs15[tableIndex].value)})
                        end
                    --DEX 16 Sleight of Hand Score
                        --Expertise Check
                        if ref_buttonData.checkboxdexskill2[tableIndex].state == true and ref_buttonData.checkboxdexskill2[tableIndex].value == 1 then
                            self.editButton({index=4, label=(saveModDex + saveProf + ref_buttonData.counterprofs16[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxdexskill2[tableIndex].state == false then
                            self.editButton({index=4, label=(saveModDex + ref_buttonData.counterprofs16[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxdexskill2[tableIndex].state == true and ref_buttonData.checkboxdexskill2[tableIndex].value == 2 then
                            self.editButton({index=4, label=(saveModDex + (saveProf*2) + ref_buttonData.counterprofs16[tableIndex].value)})
                        end
                    --DEX 17 Stealth Score
                        --Expertise Check
                        if ref_buttonData.checkboxdexskill3[tableIndex].state == true and ref_buttonData.checkboxdexskill3[tableIndex].value == 1 then
                            self.editButton({index=5, label=(saveModDex + saveProf + ref_buttonData.counterprofs17[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxdexskill3[tableIndex].state == false then
                            self.editButton({index=5, label=(saveModDex + ref_buttonData.counterprofs17[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxdexskill3[tableIndex].state == true and ref_buttonData.checkboxdexskill3[tableIndex].value == 2 then
                            self.editButton({index=5, label=(saveModDex + (saveProf*2) + ref_buttonData.counterprofs17[tableIndex].value)})
                        end
                    --WIS 18 Survival Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill5[tableIndex].state == true and ref_buttonData.checkboxwisskill5[tableIndex].value == 1 then
                            self.editButton({index=40, label=(saveModWis + saveProf + ref_buttonData.counterprofs18[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill5[tableIndex].state == false then
                            self.editButton({index=40, label=(saveModWis + ref_buttonData.counterprofs18[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill5[tableIndex].state == true and ref_buttonData.checkboxwisskill5[tableIndex].value == 2 then
                            self.editButton({index=40, label=(saveModWis + (saveProf*2) + ref_buttonData.counterprofs18[tableIndex].value)})
                        end
                    
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 1 Counter display: Acrobatics
            function click_counterprofs1(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs1[tableIndex].value = ref_buttonData.counterprofs1[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs1[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.dexcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs1[tableIndex].value

                    --Acrobatics Score
                        --Expertise Check
                        if ref_buttonData.checkboxdexskill1[tableIndex].state == true and ref_buttonData.checkboxdexskill1[tableIndex].value == 1 then
                            self.editButton({index=3, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxdexskill1[tableIndex].state == false then
                            self.editButton({index=3, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxdexskill1[tableIndex].state == true and ref_buttonData.checkboxdexskill1[tableIndex].value == 2 then
                            self.editButton({index=3, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 2 Counter display: Animal Handling
            function click_counterprofs2(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs2[tableIndex].value = ref_buttonData.counterprofs2[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs2[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs2[tableIndex].value

                    --Animal Handling Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill1[tableIndex].state == true and ref_buttonData.checkboxwisskill1[tableIndex].value == 1 then
                            self.editButton({index=34, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill1[tableIndex].state == false then
                            self.editButton({index=34, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill1[tableIndex].state == true and ref_buttonData.checkboxwisskill1[tableIndex].value == 2 then
                            self.editButton({index=34, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 3 Counter display: Arcana
            function click_counterprofs3(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs3[tableIndex].value = ref_buttonData.counterprofs3[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs3[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs3[tableIndex].value

                    --Arcana Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill1[tableIndex].state == true and ref_buttonData.checkboxintskill1[tableIndex].value == 1 then
                            self.editButton({index=23, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill1[tableIndex].state == false then
                            self.editButton({index=23, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill1[tableIndex].state == true and ref_buttonData.checkboxintskill1[tableIndex].value == 2 then
                            self.editButton({index=23, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 4 Counter display: Athletics
            function click_counterprofs4(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs4[tableIndex].value = ref_buttonData.counterprofs4[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs4[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.strcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs4[tableIndex].value

                    --Athletics Score
                        --Expertise Check
                        if ref_buttonData.checkboxstrskill1[tableIndex].state == true and ref_buttonData.checkboxstrskill1[tableIndex].value == 1 then
                            self.editButton({index=12, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxstrskill1[tableIndex].state == false then
                            self.editButton({index=12, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxstrskill1[tableIndex].state == true and ref_buttonData.checkboxstrskill1[tableIndex].value == 2 then
                            self.editButton({index=12, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 5 Counter display: Deception
            function click_counterprofs5(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs5[tableIndex].value = ref_buttonData.counterprofs5[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs5[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.chacounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs5[tableIndex].value

                    --Deception Score
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill1[tableIndex].state == true and ref_buttonData.checkboxchaskill1[tableIndex].value == 1 then
                            self.editButton({index=46, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill1[tableIndex].state == false then
                            self.editButton({index=46, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill1[tableIndex].state == true and ref_buttonData.checkboxchaskill1[tableIndex].value == 2 then
                            self.editButton({index=46, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 6 Counter display: History
            function click_counterprofs6(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs6[tableIndex].value = ref_buttonData.counterprofs6[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs6[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs6[tableIndex].value

                    --History Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill2[tableIndex].state == true and ref_buttonData.checkboxintskill2[tableIndex].value == 1 then
                            self.editButton({index=24, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill2[tableIndex].state == false then
                            self.editButton({index=24, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill2[tableIndex].state == true and ref_buttonData.checkboxintskill2[tableIndex].value == 2 then
                            self.editButton({index=24, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 7 Counter display: Insight
            function click_counterprofs7(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs7[tableIndex].value = ref_buttonData.counterprofs7[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs7[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs7[tableIndex].value

                    --Investigation Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill2[tableIndex].state == true and ref_buttonData.checkboxwisskill2[tableIndex].value == 1 then
                            self.editButton({index=35, label=(saveMod + saveProf + saveMiscProf)})
                            self.editButton({index=36, label=(saveMod + saveProf + saveMiscProf + 10)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill2[tableIndex].state == false then
                            self.editButton({index=35, label=(saveMod + saveMiscProf)})
                            self.editButton({index=36, label=(saveMod + saveMiscProf + 10)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill2[tableIndex].state == true and ref_buttonData.checkboxwisskill2[tableIndex].value == 2 then
                            self.editButton({index=35, label=(saveMod + (saveProf*2) + saveMiscProf)})
                            self.editButton({index=36, label=(saveMod + (saveProf*2) + saveMiscProf + 10)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 8 Counter display: Intimidation
            function click_counterprofs8(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs8[tableIndex].value = ref_buttonData.counterprofs8[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs8[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.chacounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs8[tableIndex].value

                    --Intimidation Score
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill2[tableIndex].state == true and ref_buttonData.checkboxchaskill2[tableIndex].value == 1 then
                            self.editButton({index=47, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill2[tableIndex].state == false then
                            self.editButton({index=47, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill2[tableIndex].state == true and ref_buttonData.checkboxchaskill2[tableIndex].value == 2 then
                            self.editButton({index=47, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 9 Counter display: Investigation
            function click_counterprofs9(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs9[tableIndex].value = ref_buttonData.counterprofs9[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs9[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs9[tableIndex].value

                    --Investigation Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill3[tableIndex].state == true and ref_buttonData.checkboxintskill3[tableIndex].value == 1 then
                            self.editButton({index=25, label=(saveMod + saveProf + saveMiscProf)})
                            self.editButton({index=26, label=(saveMod + saveProf + saveMiscProf + 10)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill3[tableIndex].state == false then
                            self.editButton({index=25, label=(saveMod + saveMiscProf)})
                            self.editButton({index=26, label=(saveMod + saveMiscProf + 10)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill3[tableIndex].state == true and ref_buttonData.checkboxintskill3[tableIndex].value == 2 then
                            self.editButton({index=25, label=(saveMod + (saveProf*2) + saveMiscProf)})
                            self.editButton({index=26, label=(saveMod + (saveProf*2) + saveMiscProf + 10)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 10 Counter display: Medicine
            function click_counterprofs10(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs10[tableIndex].value = ref_buttonData.counterprofs10[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs10[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs10[tableIndex].value

                    --Medicine Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill3[tableIndex].state == true and ref_buttonData.checkboxwisskill3[tableIndex].value == 1 then
                            self.editButton({index=37, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill3[tableIndex].state == false then
                            self.editButton({index=37, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill3[tableIndex].state == true and ref_buttonData.checkboxwisskill3[tableIndex].value == 2 then
                            self.editButton({index=37, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 11 Counter display: Nature
            function click_counterprofs11(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs11[tableIndex].value = ref_buttonData.counterprofs11[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs11[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs11[tableIndex].value

                    --Nature Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill4[tableIndex].state == true and ref_buttonData.checkboxintskill4[tableIndex].value == 1 then
                            self.editButton({index=27, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill4[tableIndex].state == false then
                            self.editButton({index=27, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill4[tableIndex].state == true and ref_buttonData.checkboxintskill4[tableIndex].value == 2 then
                            self.editButton({index=27, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 12 Counter display: Perception
            function click_counterprofs12(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs12[tableIndex].value = ref_buttonData.counterprofs12[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs12[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs12[tableIndex].value

                    --Investigation Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill4[tableIndex].state == true and ref_buttonData.checkboxwisskill4[tableIndex].value == 1 then
                            self.editButton({index=38, label=(saveMod + saveProf + saveMiscProf)})
                            self.editButton({index=39, label=(saveMod + saveProf + saveMiscProf + 10)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill4[tableIndex].state == false then
                            self.editButton({index=38, label=(saveMod + saveMiscProf)})
                            self.editButton({index=39, label=(saveMod + saveMiscProf + 10)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill4[tableIndex].state == true and ref_buttonData.checkboxwisskill4[tableIndex].value == 2 then
                            self.editButton({index=38, label=(saveMod + (saveProf*2) + saveMiscProf)})
                            self.editButton({index=39, label=(saveMod + (saveProf*2) + saveMiscProf + 10)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 13 Counter display: Performance
            function click_counterprofs13(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs13[tableIndex].value = ref_buttonData.counterprofs13[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs13[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.chacounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs13[tableIndex].value

                    --Performance Score
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill3[tableIndex].state == true and ref_buttonData.checkboxchaskill3[tableIndex].value == 1 then
                            self.editButton({index=48, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill3[tableIndex].state == false then
                            self.editButton({index=48, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill3[tableIndex].state == true and ref_buttonData.checkboxchaskill3[tableIndex].value == 2 then
                            self.editButton({index=48, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 14 Counter display: Persuassion
            function click_counterprofs14(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs14[tableIndex].value = ref_buttonData.counterprofs14[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs14[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.chacounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs14[tableIndex].value

                    --Persuassion Score
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill4[tableIndex].state == true and ref_buttonData.checkboxchaskill4[tableIndex].value == 1 then
                            self.editButton({index=49, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill4[tableIndex].state == false then
                            self.editButton({index=49, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill4[tableIndex].state == true and ref_buttonData.checkboxchaskill4[tableIndex].value == 2 then
                            self.editButton({index=49, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 15 Counter display: Religion
            function click_counterprofs15(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs15[tableIndex].value = ref_buttonData.counterprofs15[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs15[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs15[tableIndex].value

                    --Religion Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill5[tableIndex].state == true and ref_buttonData.checkboxintskill5[tableIndex].value == 1 then
                            self.editButton({index=28, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill5[tableIndex].state == false then
                            self.editButton({index=28, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill5[tableIndex].state == true and ref_buttonData.checkboxintskill5[tableIndex].value == 2 then
                            self.editButton({index=28, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 16 Counter display: Sleight of Hand 
            function click_counterprofs16(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs16[tableIndex].value = ref_buttonData.counterprofs16[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs16[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.dexcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs16[tableIndex].value

                    --Sleight of Hand Score
                        --Expertise Check
                        if ref_buttonData.checkboxdexskill2[tableIndex].state == true and ref_buttonData.checkboxdexskill2[tableIndex].value == 1 then
                            self.editButton({index=4, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxdexskill2[tableIndex].state == false then
                            self.editButton({index=4, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxdexskill2[tableIndex].state == true and ref_buttonData.checkboxdexskill2[tableIndex].value == 2 then
                            self.editButton({index=4, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end

                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 17 Counter display: Stealth
            function click_counterprofs17(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs17[tableIndex].value = ref_buttonData.counterprofs17[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs17[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.dexcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs17[tableIndex].value

                    --Stealth Score
                        --Expertise Check
                        if ref_buttonData.checkboxdexskill3[tableIndex].state == true and ref_buttonData.checkboxdexskill3[tableIndex].value == 1 then
                            self.editButton({index=5, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxdexskill3[tableIndex].state == false then
                            self.editButton({index=5, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxdexskill3[tableIndex].state == true and ref_buttonData.checkboxdexskill3[tableIndex].value == 2 then
                            self.editButton({index=5, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Skill Proficiency 18 Counter display: Survival
            function click_counterprofs18(tableIndex, buttonIndex, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.counterprofs18[tableIndex].value = ref_buttonData.counterprofs18[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.counterprofs18[tableIndex].value})
                    
                    local saveMod = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveMiscProf = ref_buttonData.counterprofs18[tableIndex].value

                    --Survival Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill5[tableIndex].state == true and ref_buttonData.checkboxwisskill5[tableIndex].value == 1 then
                            self.editButton({index=40, label=(saveMod + saveProf + saveMiscProf)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill5[tableIndex].state == false then
                            self.editButton({index=40, label=(saveMod + saveMiscProf)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill5[tableIndex].state == true and ref_buttonData.checkboxwisskill5[tableIndex].value == 2 then
                            self.editButton({index=40, label=(saveMod + (saveProf*2) + saveMiscProf)})
                        end
                    updateSave()
                end
            end

        --Applies value to Initiative Counter display
            function click_counterinit(tableIndex, buttonIndex, amount)
                local saveMod = math.floor(((ref_buttonData.dexcounterscore[tableIndex].value - 10) / 2))

                ref_buttonData.counterinit[tableIndex].value = ref_buttonData.counterinit[tableIndex].value + amount

                if ref_buttonData.checkboxlock[1].state then
                    self.editButton({index=6, label=(saveMod + ref_buttonData.counterinit[tableIndex].value)})
                    updateSave()
                end
            end
    
    --============================
    --Ability Score Counters
    --============================
        --Strength Ability Counter
            function click_strcounterscore(tableIndex, buttonIndex, buttonIndex2, buttonIndex3, buttonIndex4, amount)
                if ref_buttonData.checkboxlock[1].state then

                    --Strength Ability Score
                        ref_buttonData.strcounterscore[tableIndex].value = ref_buttonData.strcounterscore[tableIndex].value + amount
                        self.editButton({index=buttonIndex, label=ref_buttonData.strcounterscore[tableIndex].value})
                    
                    local saveScore = ref_buttonData.strcounterscore[tableIndex].value
                    local saveMod = math.floor(((ref_buttonData.strcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveBonus = ref_buttonData.bonusstrst[tableIndex].value

                    --Strength Modifier
                        self.editButton({index=buttonIndex2, label=saveMod})

                    --Strength Saving Throw Score
                        if ref_buttonData.checkboxstrst[tableIndex].state == true then
                            self.editButton({index=buttonIndex3, label=(saveMod + saveProf + saveBonus)})
                        elseif ref_buttonData.checkboxstrst[tableIndex].state == false then
                            self.editButton({index=buttonIndex3, label=(saveMod + saveBonus)})
                        end

                    --Athletics Score
                        --Expertise Check
                        if ref_buttonData.checkboxstrskill1[tableIndex].state == true and ref_buttonData.checkboxstrskill1[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex4, label=(saveMod + saveProf + ref_buttonData.counterprofs4[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxstrskill1[tableIndex].state == false then
                            self.editButton({index=buttonIndex4, label=(saveMod + ref_buttonData.counterprofs4[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxstrskill1[tableIndex].state == true and ref_buttonData.checkboxstrskill1[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex4, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs4[tableIndex].value)})
                        end

                    ref_buttonData.strcounterscore[tableIndex].value = saveScore
                    updateSave()
                end
            end

        --Dexterity Ability Counter
            function click_dexcounterscore(tableIndex, buttonIndex, buttonIndex2, buttonIndex3, buttonIndex4, buttonIndex5, buttonIndex6, buttonIndex7, amount)
                if ref_buttonData.checkboxlock[1].state then

                    --Dexterity Ability Score
                        ref_buttonData.dexcounterscore[tableIndex].value = ref_buttonData.dexcounterscore[tableIndex].value + amount
                        self.editButton({index=buttonIndex, label=ref_buttonData.dexcounterscore[tableIndex].value})
                    
                    local saveScore = ref_buttonData.dexcounterscore[tableIndex].value
                    local saveMod = math.floor(((ref_buttonData.dexcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveBonus = ref_buttonData.bonusdexst[tableIndex].value

                    --Dexterity Modifier
                        self.editButton({index=buttonIndex2, label=saveMod})

                    --Dexterity Saving Throw Score
                        if ref_buttonData.checkboxdexst[tableIndex].state == true then
                            self.editButton({index=buttonIndex3, label=(saveMod + saveProf + saveBonus)})
                        elseif ref_buttonData.checkboxdexst[tableIndex].state == false then
                            self.editButton({index=buttonIndex3, label=(saveMod + saveBonus)})
                        end

                    --Acrobatics Score
                        --Expertise Check
                        if ref_buttonData.checkboxdexskill1[tableIndex].state == true and ref_buttonData.checkboxdexskill1[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex4, label=(saveMod + saveProf + ref_buttonData.counterprofs1[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxdexskill1[tableIndex].state == false then
                            self.editButton({index=buttonIndex4, label=(saveMod + ref_buttonData.counterprofs1[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxdexskill1[tableIndex].state == true and ref_buttonData.checkboxdexskill1[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex4, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs1[tableIndex].value)})
                        end

                    --Sleight of Hand Score
                        --Expertise Check
                        if ref_buttonData.checkboxdexskill2[tableIndex].state == true and ref_buttonData.checkboxdexskill2[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex5, label=(saveMod + saveProf + ref_buttonData.counterprofs16[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxdexskill2[tableIndex].state == false then
                            self.editButton({index=buttonIndex5, label=(saveMod + ref_buttonData.counterprofs16[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxdexskill2[tableIndex].state == true and ref_buttonData.checkboxdexskill2[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex5, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs16[tableIndex].value)})
                        end

                    --Stealth Score
                        --Expertise Check
                        if ref_buttonData.checkboxdexskill3[tableIndex].state == true and ref_buttonData.checkboxdexskill3[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex6, label=(saveMod + saveProf + ref_buttonData.counterprofs17[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxdexskill3[tableIndex].state == false then
                            self.editButton({index=buttonIndex6, label=(saveMod + ref_buttonData.counterprofs17[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxdexskill3[tableIndex].state == true and ref_buttonData.checkboxdexskill3[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex6, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs17[tableIndex].value)})
                        end

                    --Initiative Score
                        --Expertise Check
                            self.editButton({index=buttonIndex7, label=(saveMod + ref_buttonData.counterinit[tableIndex].value)})

                    ref_buttonData.dexcounterscore[tableIndex].value = saveScore
                    updateSave()
                end
            end

        --Constitution Ability Counter
            function click_concounterscore(tableIndex, buttonIndex, buttonIndex2, buttonIndex3, amount)
                if ref_buttonData.checkboxlock[1].state then

                    --Constitution Ability Score
                        ref_buttonData.concounterscore[tableIndex].value = ref_buttonData.concounterscore[tableIndex].value + amount
                        self.editButton({index=buttonIndex, label=ref_buttonData.concounterscore[tableIndex].value})
                    
                    local saveScore = ref_buttonData.concounterscore[tableIndex].value
                    local saveMod = math.floor(((ref_buttonData.concounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveBonus = ref_buttonData.bonusconst[tableIndex].value

                    --Constitution Modifier
                        self.editButton({index=buttonIndex2, label=saveMod})

                    --Constitution Saving Throw Score
                        if ref_buttonData.checkboxconst[tableIndex].state == true then
                            self.editButton({index=buttonIndex3, label=(saveMod + saveProf + saveBonus)})
                        elseif ref_buttonData.checkboxconst[tableIndex].state == false then
                            self.editButton({index=buttonIndex3, label=(saveMod + saveBonus)})
                        end

                    ref_buttonData.concounterscore[tableIndex].value = saveScore
                    updateSave()
                end
            end

        --Intelligence Ability Counter
            function click_intcounterscore(tableIndex, buttonIndex, buttonIndex2, buttonIndex3, buttonIndex4, buttonIndex5, buttonIndex6, buttonIndex7, buttonIndex8, buttonIndex9, amount)
                if ref_buttonData.checkboxlock[1].state then

                    --Intelligence Ability Score
                        ref_buttonData.intcounterscore[tableIndex].value = ref_buttonData.intcounterscore[tableIndex].value + amount
                        self.editButton({index=buttonIndex, label=ref_buttonData.intcounterscore[tableIndex].value})
                    
                    local saveScore = ref_buttonData.intcounterscore[tableIndex].value
                    local saveMod = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveBonus = ref_buttonData.bonusintst[tableIndex].value

                    --Intelligence Modifier
                        self.editButton({index=buttonIndex2, label=saveMod})

                    --Intelligence Saving Throw Score
                        if ref_buttonData.checkboxintst[tableIndex].state == true then
                            self.editButton({index=buttonIndex3, label=(saveMod + saveProf + saveBonus)})
                        elseif ref_buttonData.checkboxintst[tableIndex].state == false then
                            self.editButton({index=buttonIndex3, label=(saveMod + saveBonus)})
                        end

                    --Arcana Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill1[tableIndex].state == true and ref_buttonData.checkboxintskill1[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex4, label=(saveMod + saveProf + ref_buttonData.counterprofs3[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill1[tableIndex].state == false then
                            self.editButton({index=buttonIndex4, label=(saveMod + ref_buttonData.counterprofs3[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill1[tableIndex].state == true and ref_buttonData.checkboxintskill1[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex4, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs3[tableIndex].value)})
                        end

                    --History Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill2[tableIndex].state == true and ref_buttonData.checkboxintskill2[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex5, label=(saveMod + saveProf + ref_buttonData.counterprofs6[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill2[tableIndex].state == false then
                            self.editButton({index=buttonIndex5, label=(saveMod + ref_buttonData.counterprofs6[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill2[tableIndex].state == true and ref_buttonData.checkboxintskill2[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex5, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs6[tableIndex].value)})
                        end

                    --Investigation Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill3[tableIndex].state == true and ref_buttonData.checkboxintskill3[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex6, label=(saveMod + saveProf + ref_buttonData.counterprofs9[tableIndex].value)})
                            self.editButton({index=buttonIndex9, label=(saveMod + saveProf + ref_buttonData.counterprofs9[tableIndex].value + 10)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill3[tableIndex].state == false then
                            self.editButton({index=buttonIndex6, label=(saveMod + ref_buttonData.counterprofs9[tableIndex].value)})
                            self.editButton({index=buttonIndex9, label=(saveMod + ref_buttonData.counterprofs9[tableIndex].value + 10)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill3[tableIndex].state == true and ref_buttonData.checkboxintskill3[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex6, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs9[tableIndex].value)})
                            self.editButton({index=buttonIndex9, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs9[tableIndex].value + 10)})
                        end

                    --Nature Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill4[tableIndex].state == true and ref_buttonData.checkboxintskill4[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex7, label=(saveMod + saveProf + ref_buttonData.counterprofs11[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill4[tableIndex].state == false then
                            self.editButton({index=buttonIndex7, label=(saveMod + ref_buttonData.counterprofs11[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill4[tableIndex].state == true and ref_buttonData.checkboxintskill4[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex7, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs11[tableIndex].value)})
                        end

                    --Religion Score
                        --Expertise Check
                        if ref_buttonData.checkboxintskill5[tableIndex].state == true and ref_buttonData.checkboxintskill5[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex8, label=(saveMod + saveProf + ref_buttonData.counterprofs15[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxintskill5[tableIndex].state == false then
                            self.editButton({index=buttonIndex8, label=(saveMod + ref_buttonData.counterprofs15[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxintskill5[tableIndex].state == true and ref_buttonData.checkboxintskill5[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex8, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs15[tableIndex].value)})
                        end

                    ref_buttonData.intcounterscore[tableIndex].value = saveScore
                    updateSave()
                end
            end

        --Wisdom Ability Counter
            function click_wiscounterscore(tableIndex, buttonIndex, buttonIndex2, buttonIndex3, buttonIndex4, buttonIndex5, buttonIndex6, buttonIndex7, buttonIndex8, buttonIndex9, buttonIndex10, amount)
                if ref_buttonData.checkboxlock[1].state then
                    --Wisdom Ability Score
                        ref_buttonData.wiscounterscore[tableIndex].value = ref_buttonData.wiscounterscore[tableIndex].value + amount
                        self.editButton({index=buttonIndex, label=ref_buttonData.wiscounterscore[tableIndex].value})
                    
                    local saveScore = ref_buttonData.wiscounterscore[tableIndex].value
                    local saveMod = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveBonus = ref_buttonData.bonuswisst[tableIndex].value

                    --Wisdom Modifier
                        self.editButton({index=buttonIndex2, label=saveMod})

                    --Wisdom Saving Throw Score
                        if ref_buttonData.checkboxwisst[tableIndex].state == true then
                            self.editButton({index=buttonIndex3, label=(saveMod + saveProf + saveBonus)})
                        elseif ref_buttonData.checkboxwisst[tableIndex].state == false then
                            self.editButton({index=buttonIndex3, label=(saveMod + saveBonus)})
                        end

                    --Animal Handling Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill1[tableIndex].state == true and ref_buttonData.checkboxwisskill1[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex4, label=(saveMod + saveProf + ref_buttonData.counterprofs2[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill1[tableIndex].state == false then
                            self.editButton({index=buttonIndex4, label=(saveMod + ref_buttonData.counterprofs2[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill1[tableIndex].state == true and ref_buttonData.checkboxwisskill1[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex4, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs2[tableIndex].value)})
                        end

                    --Insight Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill2[tableIndex].state == true and ref_buttonData.checkboxwisskill2[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex5, label=(saveMod + saveProf + ref_buttonData.counterprofs7[tableIndex].value)})
                            self.editButton({index=buttonIndex9, label=(saveMod + saveProf + ref_buttonData.counterprofs7[tableIndex].value + 10)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill2[tableIndex].state == false then
                            self.editButton({index=buttonIndex5, label=(saveMod + ref_buttonData.counterprofs7[tableIndex].value)})
                            self.editButton({index=buttonIndex9, label=(saveMod + ref_buttonData.counterprofs7[tableIndex].value + 10)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill2[tableIndex].state == true and ref_buttonData.checkboxwisskill2[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex5, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs7[tableIndex].value)})
                            self.editButton({index=buttonIndex9, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs7[tableIndex].value + 10)})
                        end

                    --Medicine Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill3[tableIndex].state == true and ref_buttonData.checkboxwisskill3[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex6, label=(saveMod + saveProf + ref_buttonData.counterprofs10[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill3[tableIndex].state == false then
                            self.editButton({index=buttonIndex6, label=(saveMod + ref_buttonData.counterprofs10[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill3[tableIndex].state == true and ref_buttonData.checkboxwisskill3[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex6, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs10[tableIndex].value)})
                        end

                    --Perception Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill4[tableIndex].state == true and ref_buttonData.checkboxwisskill4[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex7, label=(saveMod + saveProf + ref_buttonData.counterprofs12[tableIndex].value)})
                            self.editButton({index=buttonIndex10, label=(saveMod + saveProf + ref_buttonData.counterprofs12[tableIndex].value + 10)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill4[tableIndex].state == false then
                            self.editButton({index=buttonIndex7, label=(saveMod + ref_buttonData.counterprofs12[tableIndex].value)})
                            self.editButton({index=buttonIndex10, label=(saveMod + ref_buttonData.counterprofs12[tableIndex].value + 10)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill4[tableIndex].state == true and ref_buttonData.checkboxwisskill4[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex7, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs12[tableIndex].value)})
                            self.editButton({index=buttonIndex10, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs12[tableIndex].value + 10)})
                        end

                    --Survival Score
                        --Expertise Check
                        if ref_buttonData.checkboxwisskill5[tableIndex].state == true and ref_buttonData.checkboxwisskill5[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex8, label=(saveMod + saveProf + ref_buttonData.counterprofs18[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxwisskill5[tableIndex].state == false then
                            self.editButton({index=buttonIndex8, label=(saveMod + ref_buttonData.counterprofs18[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxwisskill5[tableIndex].state == true and ref_buttonData.checkboxwisskill5[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex8, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs18[tableIndex].value)})
                        end

                    ref_buttonData.wiscounterscore[tableIndex].value = saveScore
                    updateSave()
                end
            end

        --Charisma Ability Counter
            function click_chacounterscore(tableIndex, buttonIndex, buttonIndex2, buttonIndex3, buttonIndex4, buttonIndex5, buttonIndex6, buttonIndex7, amount)
                if ref_buttonData.checkboxlock[1].state then

                    --Charisma Ability Score
                        ref_buttonData.chacounterscore[tableIndex].value = ref_buttonData.chacounterscore[tableIndex].value + amount
                        self.editButton({index=buttonIndex, label=ref_buttonData.chacounterscore[tableIndex].value})
                    
                    local saveScore = ref_buttonData.chacounterscore[tableIndex].value
                    local saveMod = math.floor(((ref_buttonData.chacounterscore[tableIndex].value - 10) / 2))
                    local saveProf = ref_buttonData.counterprof[tableIndex].value
                    local saveBonus = ref_buttonData.bonuschast[tableIndex].value

                    --Charisma Modifier
                        self.editButton({index=buttonIndex2, label=saveMod})

                    --Charisma Saving Throw Score
                        if ref_buttonData.checkboxchast[tableIndex].state == true then
                            self.editButton({index=buttonIndex3, label=(saveMod + saveProf + saveBonus)})
                        elseif ref_buttonData.checkboxchast[tableIndex].state == false then
                            self.editButton({index=buttonIndex3, label=(saveMod + saveBonus)})
                        end

                    --Deception Score
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill1[tableIndex].state == true and ref_buttonData.checkboxchaskill1[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex4, label=(saveMod + saveProf + ref_buttonData.counterprofs5[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill1[tableIndex].state == false then
                            self.editButton({index=buttonIndex4, label=(saveMod + ref_buttonData.counterprofs5[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill1[tableIndex].state == true and ref_buttonData.checkboxchaskill1[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex4, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs5[tableIndex].value)})
                        end

                    --Intimidation Score
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill2[tableIndex].state == true and ref_buttonData.checkboxchaskill2[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex5, label=(saveMod + saveProf + ref_buttonData.counterprofs8[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill2[tableIndex].state == false then
                            self.editButton({index=buttonIndex5, label=(saveMod + ref_buttonData.counterprofs8[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill2[tableIndex].state == true and ref_buttonData.checkboxchaskill2[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex5, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs8[tableIndex].value)})
                        end

                    --Performance Score
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill3[tableIndex].state == true and ref_buttonData.checkboxchaskill3[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex6, label=(saveMod + saveProf + ref_buttonData.counterprofs13[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill3[tableIndex].state == false then
                            self.editButton({index=buttonIndex6, label=(saveMod + ref_buttonData.counterprofs13[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill3[tableIndex].state == true and ref_buttonData.checkboxchaskill3[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex6, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs13[tableIndex].value)})
                        end

                    --Persuassion Score
                        --Expertise Check
                        if ref_buttonData.checkboxchaskill4[tableIndex].state == true and ref_buttonData.checkboxchaskill4[tableIndex].value == 1 then
                            self.editButton({index=buttonIndex7, label=(saveMod + saveProf + ref_buttonData.counterprofs14[tableIndex].value)})
                        --Prof Check
                        elseif ref_buttonData.checkboxchaskill4[tableIndex].state == false then
                            self.editButton({index=buttonIndex7, label=(saveMod + ref_buttonData.counterprofs14[tableIndex].value)})
                        --No Prof Check
                        elseif ref_buttonData.checkboxchaskill4[tableIndex].state == true and ref_buttonData.checkboxchaskill4[tableIndex].value == 2 then
                            self.editButton({index=buttonIndex7, label=(saveMod + (saveProf*2) + ref_buttonData.counterprofs14[tableIndex].value)})
                        end

                    ref_buttonData.chacounterscore[tableIndex].value = saveScore
                    updateSave()
                end
            end

    --Inspiration Checkbox
        function click_checkboxinspire(tableIndex, buttonIndex)
            if ref_buttonData.checkboxinspire[tableIndex].state == true then
                ref_buttonData.checkboxinspire[tableIndex].state = false
                self.editButton({index=buttonIndex, label=""})
            else
                ref_buttonData.checkboxinspire[tableIndex].state = true
                self.editButton({index=buttonIndex, label=string.char(10004)})
            end
            updateSave()
        end

    --Level XP Counter
        function click_xpcounter(tableIndex, buttonIndex, buttonIndex2, amount)
            if ref_buttonData.checkboxlock[1].state then
                
                if amount == -1 and tonumber(ref_buttonData.xpcounter[tableIndex].value) < 1 then
                    ref_buttonData.xpcounter[tableIndex].value = 0
                else
                    ref_buttonData.xpcounter[tableIndex].value = ref_buttonData.xpcounter[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.xpcounter[tableIndex].value}) 
                end

            local level = ref_buttonData.xpcounter[tableIndex].value
            local xp = 0

            --XP Values per level
                if level <= 0 then          xp = 'EXP'
                elseif level == 1 then      xp = 300
                elseif level == 2 then      xp = 900
                elseif level == 3 then      xp = 2700
                elseif level == 4 then      xp = 6500
                elseif level == 5 then      xp = 14000
                elseif level == 6 then      xp = 23000
                elseif level == 7 then      xp = 34000
                elseif level == 8 then      xp = 48000
                elseif level == 9 then      xp = 64000
                elseif level == 10 then     xp = 85000
                elseif level == 11 then     xp = 100000
                elseif level == 12 then     xp = 120000
                elseif level == 13 then     xp = 140000
                elseif level == 14 then     xp = 165000
                elseif level == 15 then     xp = 195000
                elseif level == 16 then     xp = 225000
                elseif level == 17 then     xp = 265000
                elseif level == 18 then     xp = 305000
                elseif level == 19 then     xp = 355000
                elseif level >= 20 then     xp = 'MAX'
                end

            --XP Points
                self.editButton({index=buttonIndex2, label= '/ ' .. xp})
            updateSave()

            end
        end

    --Lockable Checkbox (to lock other controls)
        function click_checkboxlock(tableIndex, buttonIndex)
            local msg1 = tostring(tableIndex) -- =1
            local msg2 = tostring(buttonIndex) -- =209
            if ref_buttonData.checkboxlock[tableIndex].state == true then
                ref_buttonData.checkboxlock[tableIndex].state = false
                self.editButton({index=buttonIndex, color=buttonColorRed, font_color=buttonColorWhite, label="Locked"})
            else
                ref_buttonData.checkboxlock[tableIndex].state = true
                self.editButton({index=buttonIndex, color=buttonColorGreen, font_color=buttonColorWhite, label="Unlocked"})
                for i, text in ipairs(ref_buttonData.textbox) do
                    self.editInput({index=i-1, value=ref_buttonData.textbox[i].value})
                end
            end
            updateSave()
        end

    --Button for Long Rests
        function click_longrest(tableIndex, color)
            broadcastToColor("You've Long Rested.", color, buttonColorYellow)
            
            --Sets all depentable values equal to their parent values
            for i, num in ipairs(ref_buttonData.numbox2) do
                ref_buttonData.numbox2[i].value = ref_buttonData.numbox[i].value
                self.editInput({index=i+52, value=ref_buttonData.numbox2[i].value})
            end

            --Sets Temporary Hit Points to 0
            click_numbox(6, color, 0, false, (ref_buttonData.numbox[6].value * -1))

            updateSave()
        end

    --Updates saved value for text box
        function click_textbox(i, color, value, selected)
            if ref_buttonData.checkboxlock[1].state then
                if selected == false then
                    ref_buttonData.textbox[i].value = value
                    updateSave()
                end
            else
                if selected == true then
                    printOut(color)
                    Wait.time(function() self.editInput({index=i-1,value=ref_buttonData.textbox[i].value}) end,0.12)
                end
            end
        end

    --Updates saved value for numbox (numbers only)
        function click_numbox(i, color, value, selected, amount)
            --If in the Unlocked state or values are not Class Resources/Max HP
            if ref_buttonData.checkboxlock[1].state or i > 5 then
                if amount ~= 0 then
                    if amount == -1 and tonumber(ref_buttonData.numbox[i].value) < 1 and i~=7 then
                        if color == nil then
                            --Prevent no player found error message
                            Wait.time(function() 
                                self.editInput({index=i+43,value=ref_buttonData.numbox[i].value}) end,0.1)
                        elseif i==7 then --Bonus Max HP can be Negative!!
                            ref_buttonData.numbox[7].value = ref_buttonData.numbox[7].value + amount
                            Wait.time(function() 
                                self.editInput({index=50,value=ref_buttonData.numbox[7].value}) end,0.1)
                        else
                            broadcastToColor("Value can't be negative.", color, "Red")
                            self.editInput({index=i+43,value=ref_buttonData.numbox[i].value})
                        end
                    else
                        if i == 7 then
                            ref_buttonData.numbox[5].value = ref_buttonData.numbox[5].value + amount
                            ref_buttonData.numbox[7].value = ref_buttonData.numbox[7].value + amount
                            --Max HP
                            self.editInput({index=48,value=ref_buttonData.numbox[5].value})
                            --Bonus Max HP
                            self.editInput({index=50,value=ref_buttonData.numbox[7].value})
                        elseif i >= 6 and i~= 7 then
                            ref_buttonData.numbox[i].value = tonumber(ref_buttonData.numbox[i].value) + amount
                            self.editInput({index=i+43,value=ref_buttonData.numbox[i].value})
                        else
                            ref_buttonData.numbox[i].value = tonumber(ref_buttonData.numbox[i].value) + amount
                            self.editInput({index=i+43,value=ref_buttonData.numbox[i].value})
                            if tonumber(ref_buttonData.numbox2[i].value) > tonumber(ref_buttonData.numbox[i].value) then
                                ref_buttonData.numbox2[i].value = ref_buttonData.numbox[i].value
                                self.editInput({index=i+52,value=ref_buttonData.numbox2[i].value})
                            end
                        end
                    end
                end
                if selected == false then
                    if tonumber(value) ~= nil and (tonumber(value) < 1000 and tonumber(value) > -1) then
                        if i == 7 then
                            if tonumber(value) == 0 then
                                if tonumber(ref_buttonData.numbox[7].value) > 0 or tonumber(ref_buttonData.numbox[7].value) < 0 then
                                    ref_buttonData.numbox[5].value = ref_buttonData.numbox[5].value - ref_buttonData.numbox[7].value
                                    ref_buttonData.numbox[7].value = value
                                end
                            else
                                ref_buttonData.numbox[5].value = ref_buttonData.numbox[5].value + value
                                ref_buttonData.numbox[7].value = value
                            end
                            --Max HP
                            self.editInput({index=48,value=ref_buttonData.numbox[5].value})
                            --Bonus Max HP
                            self.editInput({index=50,value=ref_buttonData.numbox[7].value})
                            --Current HP
                            if tonumber(ref_buttonData.numbox2[5].value) > tonumber(ref_buttonData.numbox[5].value) then
                                ref_buttonData.numbox2[5].value = ref_buttonData.numbox[5].value
                                self.editInput({index=57,value=ref_buttonData.numbox2[5].value})
                            end
                        elseif i >= 6 and i~= 7 then
                            ref_buttonData.numbox[i].value = value
                            self.editInput({index=i+43,value=ref_buttonData.numbox[i].value})
                        else
                            ref_buttonData.numbox[i].value = value
                            self.editInput({index=i+43,value=ref_buttonData.numbox[i].value})
                            
                            if tonumber(ref_buttonData.numbox2[i].value) > tonumber(ref_buttonData.numbox[i].value) then
                                ref_buttonData.numbox2[i].value = ref_buttonData.numbox[i].value
                                self.editInput({index=i+52,value=ref_buttonData.numbox2[i].value})
                            end
                        end
                    elseif tonumber(value) < 0 and i==7 then --Bonus Max HP can be Negative!!
                        ref_buttonData.numbox[7].value = value
                        ref_buttonData.numbox[5].value = ref_buttonData.numbox[5].value + ref_buttonData.numbox[7].value
                            --Max HP
                            self.editInput({index=48,value=ref_buttonData.numbox[5].value})
                            --Bonus Max HP
                            self.editInput({index=50,value=ref_buttonData.numbox[7].value})
                            --Current HP
                            if tonumber(ref_buttonData.numbox2[5].value) > tonumber(ref_buttonData.numbox[5].value) then
                                ref_buttonData.numbox2[5].value = ref_buttonData.numbox[5].value
                                self.editInput({index=57,value=ref_buttonData.numbox2[5].value})
                            end
                    else
                        broadcastToColor("Enter a valid number.", color, "Red")
                        if tonumber(value) < 0 then
                            ref_buttonData.numbox[i].value = 0
                            Wait.time(function() self.editInput({index=i+43,value=ref_buttonData.numbox[i].value}) end,0.1)
                        else
                            Wait.time(function() self.editInput({index=i+43,value=ref_buttonData.numbox[i].value}) end,0.1)
                        end
                    end
                end
            else
                if selected == true then
                    printOut(color)
                    Wait.time(function() self.editInput({index=i+43,value=ref_buttonData.numbox[i].value}) end,0.1)
                end
            end
            updateSave()
        end

    --Updates saved value for numbox2 (numbers only)
        function click_numbox2(i, color, value, selected, amount)
            if amount ~= 0 then
                if amount == -1 and tonumber(ref_buttonData.numbox2[i].value) < 1 then
                    if color == nil then
                        --Prevent no player found error message
                        self.editInput({index=i+52,value=ref_buttonData.numbox2[i].value})
                    else
                        broadcastToColor("Value can't be negative.", color, "Red")
                        self.editInput({index=i+52,value=ref_buttonData.numbox2[i].value})
                    end
                else
                    if amount == 1 and tonumber(ref_buttonData.numbox2[5].value) >= tonumber(ref_buttonData.numbox[5].value + ref_buttonData.numbox[7].value) then
                        if color == nil then --Prevent no player found error message
                        else broadcastToColor("Number can't be higher than " .. tonumber(ref_buttonData.numbox[5].value + ref_buttonData.numbox[7].value) , color, "Red") end
                        self.editInput({index=i+52,value=ref_buttonData.numbox2[i].value})
                    elseif amount == 1 and tonumber(ref_buttonData.numbox2[i].value) >= tonumber(ref_buttonData.numbox[i].value) then
                        if color == nil then --Prevent no player found error message
                        else broadcastToColor("Number can't be higher than " .. tonumber(ref_buttonData.numbox[i].value) , color, "Red") end 
                        self.editInput({index=i+52,value=ref_buttonData.numbox2[i].value})
                    else
                        ref_buttonData.numbox2[i].value = ref_buttonData.numbox2[i].value + amount
                        self.editInput({index=i+52,value=ref_buttonData.numbox2[i].value})
                    end
                end
            end

            if selected == false or selected == true  then
                if tonumber(value) ~= nil and (tonumber(value) < 1000 and tonumber(value) > -1) then
                    --Current HP Set to Max HP
                    if tonumber(ref_buttonData.numbox2[5].value) > tonumber(ref_buttonData.numbox[5].value + ref_buttonData.numbox[7].value) then
                        broadcastToColor("Number can't be higher than " .. tonumber(ref_buttonData.numbox[5].value) , color, "Red")
                        if color == nil then end --Prevent no player found error message 
                        Wait.time(function() self.editInput({index=i+52,value=tonumber(ref_buttonData.numbox[5].value)}) end,0.1)
                    --Set Dependent NumBoxes equal to their Parent Values, can't exceed them
                    elseif tonumber(ref_buttonData.numbox2[i].value) > tonumber(ref_buttonData.numbox[i].value) then
                        broadcastToColor("Number can't be higher than " .. tonumber(ref_buttonData.numbox[i].value) , color, "Red")
                        if color == nil then end --Prevent no player found error message 
                        ref_buttonData.numbox2[i].value = ref_buttonData.numbox[i].value
                        Wait.time(function() self.editInput({index=i+52,value=tonumber(ref_buttonData.numbox2[i].value)}) end,0.1)
                    else
                        ref_buttonData.numbox2[i].value = value
                    end
                else
                    broadcastToColor("Enter a valid number.", color, "Red")
                    Wait.time(function() self.editInput({index=i+52,value=ref_buttonData.numbox2[i].value}) end,0.1)
                end
            end
            updateSave()
        end

    --Applies Bonus to Strength Saving Throw display
        function click_bonusstrst(tableIndex, buttonIndex, amount)
            if ref_buttonData.checkboxlock[1].state then
                ref_buttonData.bonusstrst[tableIndex].value = ref_buttonData.bonusstrst[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.bonusstrst[tableIndex].value})

                local saveMod = math.floor(((ref_buttonData.strcounterscore[tableIndex].value - 10) / 2))
                local saveProf = ref_buttonData.counterprof[tableIndex].value
                local saveBonus = ref_buttonData.bonusstrst[tableIndex].value

                --Prof Check
                    if ref_buttonData.checkboxstrst[tableIndex].state == true then
                        self.editButton({index=11, label=(saveMod + saveProf + saveBonus)})
                --No Prof Check
                    elseif ref_buttonData.checkboxstrst[tableIndex].state == false then
                        self.editButton({index=11, label=(saveMod + saveBonus)})
                    end
                updateSave()
            end
        end

    --Applies Bonus to Dexterity Saving Throw display +++
        function click_bonusdexst(tableIndex, buttonIndex, amount)
            if ref_buttonData.checkboxlock[1].state then
                ref_buttonData.bonusdexst[tableIndex].value = ref_buttonData.bonusdexst[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.bonusdexst[tableIndex].value})

                local saveMod = math.floor(((ref_buttonData.dexcounterscore[tableIndex].value - 10) / 2))
                local saveProf = ref_buttonData.counterprof[tableIndex].value
                local saveBonus = ref_buttonData.bonusdexst[tableIndex].value

                --Prof Check
                    if ref_buttonData.checkboxdexst[tableIndex].state == true then
                        self.editButton({index=2, label=(saveMod + saveProf + saveBonus)})
                --No Prof Check
                    elseif ref_buttonData.checkboxdexst[tableIndex].state == false then
                        self.editButton({index=2, label=(saveMod + saveBonus)})
                    end
                updateSave()
            end
        end

    --Applies Bonus to Constitution Saving Throw display
        function click_bonusconst(tableIndex, buttonIndex, amount)
            if ref_buttonData.checkboxlock[1].state then
                ref_buttonData.bonusconst[tableIndex].value = ref_buttonData.bonusconst[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.bonusconst[tableIndex].value})

                local saveMod = math.floor(((ref_buttonData.concounterscore[tableIndex].value - 10) / 2))
                local saveProf = ref_buttonData.counterprof[tableIndex].value
                local saveBonus = ref_buttonData.bonusconst[tableIndex].value

                --Prof Check
                    if ref_buttonData.checkboxconst[tableIndex].state == true then
                        self.editButton({index=17, label=(saveMod + saveProf + saveBonus)})
                --No Prof Check
                    elseif ref_buttonData.checkboxconst[tableIndex].state == false then
                        self.editButton({index=17, label=(saveMod + saveBonus)})
                    end
                updateSave()
            end
        end

    --Applies Bonus to Intelligence Saving Throw display
        function click_bonusintst(tableIndex, buttonIndex, amount)
            if ref_buttonData.checkboxlock[1].state then
                ref_buttonData.bonusintst[tableIndex].value = ref_buttonData.bonusintst[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.bonusintst[tableIndex].value})

                local saveMod = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))
                local saveProf = ref_buttonData.counterprof[tableIndex].value
                local saveBonus = ref_buttonData.bonusintst[tableIndex].value

                --Prof Check
                    if ref_buttonData.checkboxintst[tableIndex].state == true then
                        self.editButton({index=22, label=(saveMod + saveProf + saveBonus)})
                --No Prof Check
                    elseif ref_buttonData.checkboxintst[tableIndex].state == false then
                        self.editButton({index=22, label=(saveMod + saveBonus)})
                    end
                updateSave()
            end
        end

    --Applies Bonus to Wisdom Saving Throw display
        function click_bonuswisst(tableIndex, buttonIndex, amount)
            if ref_buttonData.checkboxlock[1].state then
                ref_buttonData.bonuswisst[tableIndex].value = ref_buttonData.bonuswisst[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label =ref_buttonData.bonuswisst[tableIndex].value})

                local saveMod = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))
                local saveProf = ref_buttonData.counterprof[tableIndex].value
                local saveBonus = ref_buttonData.bonuswisst[tableIndex].value

                --Prof Check
                    if ref_buttonData.checkboxwisst[tableIndex].state == true then
                        self.editButton({index=33, label=(saveMod + saveProf + saveBonus)})
                --No Prof Check
                    elseif ref_buttonData.checkboxwisst[tableIndex].state == false then
                        self.editButton({index=33, label=(saveMod + saveBonus)})
                    end
                updateSave()
            end
        end

    --Applies Bonus to Charisma Saving Throw display
        function click_bonuschast(tableIndex, buttonIndex, amount)
            if ref_buttonData.checkboxlock[1].state then
                ref_buttonData.bonuschast[tableIndex].value = ref_buttonData.bonuschast[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label =ref_buttonData.bonuschast[tableIndex].value})

                local saveMod = math.floor(((ref_buttonData.chacounterscore[tableIndex].value - 10) / 2))
                local saveProf = ref_buttonData.counterprof[tableIndex].value
                local saveBonus = ref_buttonData.bonuschast[tableIndex].value

                --Prof Check
                    if ref_buttonData.checkboxchast[tableIndex].state == true then
                        self.editButton({index=45, label=(saveMod + saveProf + saveBonus)})
                --No Prof Check
                    elseif ref_buttonData.checkboxchast[tableIndex].state == false then
                        self.editButton({index=45, label=(saveMod + saveBonus)})
                    end
                updateSave()
            end
        end

    --Message that Sheet is Locked
        function printOut(col)    
            broadcastToColor("Unable to edit, Sheet is Locked", col, "Red")
        end

    --Dud function for background on a counter
        function click_none() end

--Button creation
    --Default Checkboxes
        --Makes Checkboxes
            function createCheckbox()
                for i, data in ipairs(ref_buttonData.checkbox) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkbox"..i
                    local func = function() click_checkbox(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=buttonColorBlack
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes Red Checkboxes
            function createCheckboxRed()
                for i, data in ipairs(ref_buttonData.checkboxr) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxr"..i
                    local func = function() click_checkboxr(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=buttonColorRed
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes Green Checkboxes
            function createCheckboxGreen()
                for i, data in ipairs(ref_buttonData.checkboxg) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxg"..i
                    local func = function() click_checkboxg(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=buttonColorGreen
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes Inspiration Checkboxes
            function createCheckboxInspiration()
                for i, data in ipairs(ref_buttonData.checkboxinspire) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxinspire"..i
                    local func = function() click_checkboxinspire(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    if data.state==true then label=string.char(10004) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=buttonColorGreen
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end

    --Saving Throw Checkboxes
        --Makes STR Saving Throw Checkboxes
            function createCheckboxStrST()
                for i, data in ipairs(ref_buttonData.checkboxstrst) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxstrst"..i
                    local func = function() click_checkboxstrst(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=buttonColorBlack
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes DEX Saving Throw Checkboxes
            function createCheckboxDexST()
                for i, data in ipairs(ref_buttonData.checkboxdexst) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxdexst"..i
                    local func = function() click_checkboxdexst(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=buttonColorBlack
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes CON Saving Throw Checkboxes
            function createCheckboxConST()
                for i, data in ipairs(ref_buttonData.checkboxconst) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxconst"..i
                    local func = function() click_checkboxconst(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=buttonColorBlack
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes INT Saving Throw Checkboxes
            function createCheckboxIntST()
                for i, data in ipairs(ref_buttonData.checkboxintst) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxintst"..i
                    local func = function() click_checkboxintst(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=buttonColorBlack
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes WIS Saving Throw Checkboxes
            function createCheckboxWisST()
                for i, data in ipairs(ref_buttonData.checkboxwisst) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxwisst"..i
                    local func = function() click_checkboxwisst(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=buttonColorBlack
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes CHA Saving Throw Checkboxes
            function createCheckboxChaST()
                for i, data in ipairs(ref_buttonData.checkboxchast) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxchast"..i
                    local func = function() click_checkboxchast(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=buttonColorBlack
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end

    --Skill Checkboxes
        --Makes DEX 1 Acrobatics Checkbox
            function createCheckboxDexSkill1()
                for i, data in ipairs(ref_buttonData.checkboxdexskill1) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxdexskill1"..i
                    local func = function() click_checkboxdexskill1(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxdexskill1[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes WIS 2 Animal Handling Checkbox
            function createCheckboxWisSkill1()
                for i, data in ipairs(ref_buttonData.checkboxwisskill1) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxwisskill1"..i
                    local func = function() click_checkboxwisskill1(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxwisskill1[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes INT 3 Arcana Checkbox
            function createCheckboxIntSkill1()
                for i, data in ipairs(ref_buttonData.checkboxintskill1) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxintskill1"..i
                    local func = function() click_checkboxintskill1(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxintskill1[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes STR 4 Athletics Checkbox
            function createCheckboxStrSkill1()
                for i, data in ipairs(ref_buttonData.checkboxstrskill1) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxstrskill1"..i
                    local func = function() click_checkboxstrskill1(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxstrskill1[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes CHA 5 Deception Checkbox
            function createCheckboxChaSkill1()
                for i, data in ipairs(ref_buttonData.checkboxchaskill1) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxchaskill1"..i
                    local func = function() click_checkboxchaskill1(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxchaskill1[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes INT 6 Arcana Checkbox
            function createCheckboxIntSkill2()
                for i, data in ipairs(ref_buttonData.checkboxintskill2) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxintskill2"..i
                    local func = function() click_checkboxintskill2(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxintskill2[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes WIS 7 Insight Checkbox
            function createCheckboxWisSkill2()
                for i, data in ipairs(ref_buttonData.checkboxwisskill2) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxwisskill2"..i
                    local func = function() click_checkboxwisskill2(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxwisskill2[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes CHA 8 Intimidation Checkbox
            function createCheckboxChaSkill2()
                for i, data in ipairs(ref_buttonData.checkboxchaskill2) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxchaskill2"..i
                    local func = function() click_checkboxchaskill2(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxchaskill2[i].value == 2 then
                        fontColor=buttonColorRed
                    end

                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end 
        --Makes INT 9 Investigation Checkbox
            function createCheckboxIntSkill3()
                for i, data in ipairs(ref_buttonData.checkboxintskill3) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxintskill3"..i
                    local func = function() click_checkboxintskill3(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxintskill3[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes WIS 10 Medicine Checkbox
            function createCheckboxWisSkill3()
                for i, data in ipairs(ref_buttonData.checkboxwisskill3) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxwisskill3"..i
                    local func = function() click_checkboxwisskill3(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxwisskill3[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end     
        --Makes INT 11 Nature Checkbox
            function createCheckboxIntSkill4()
                for i, data in ipairs(ref_buttonData.checkboxintskill4) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxintskill4"..i
                    local func = function() click_checkboxintskill4(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxintskill4[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes WIS 12 Perception Checkbox
            function createCheckboxWisSkill4()
                for i, data in ipairs(ref_buttonData.checkboxwisskill4) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxwisskill4"..i
                    local func = function() click_checkboxwisskill4(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxwisskill4[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end     
        --Makes CHA 13 Performance Checkbox
            function createCheckboxChaSkill3()
                for i, data in ipairs(ref_buttonData.checkboxchaskill3) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxchaskill3"..i
                    local func = function() click_checkboxchaskill3(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxchaskill3[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end 
        --Makes CHA 14 Persuassion Checkbox
            function createCheckboxChaSkill4()
                for i, data in ipairs(ref_buttonData.checkboxchaskill4) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxchaskill4"..i
                    local func = function() click_checkboxchaskill4(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxchaskill4[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end     
        --Makes INT 15 Religion Checkbox
            function createCheckboxIntSkill5()
                for i, data in ipairs(ref_buttonData.checkboxintskill5) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxintskill5"..i
                    local func = function() click_checkboxintskill5(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxintskill5[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes DEX 16 Sleight of Hand Checkbox
            function createCheckboxDexSkill2()
                for i, data in ipairs(ref_buttonData.checkboxdexskill2) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxdexskill2"..i
                    local func = function() click_checkboxdexskill2(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxdexskill2[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes DEX 17 Stealth Checkbox
            function createCheckboxDexSkill3()
                for i, data in ipairs(ref_buttonData.checkboxdexskill3) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxdexskill3"..i
                    local func = function() click_checkboxdexskill3(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxdexskill3[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end
        --Makes WIS 18 Survival Checkbox
            function createCheckboxWisSkill5()
                for i, data in ipairs(ref_buttonData.checkboxwisskill5) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkboxwisskill5"..i
                    local func = function() click_checkboxwisskill5(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    local fontColor=buttonColorBlack
                    if ref_buttonData.checkboxwisskill5[i].value == 2 then
                        fontColor=buttonColorRed
                    end
                    if data.state==true then label=string.char(9679) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=fontColor
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end     
        
    --Makes Counters
        function createCounter()
            for i, data in ipairs(ref_buttonData.counter) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=data.color
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterAdd"..i
                local func = function() click_counter(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterSub"..i
                local func = function() click_counter(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

    --Score Modifier counters
        --Creates Strength Counters (Strength Mod, Strength Saving Throw, Strength Skills)
            function createStrScoreCounter()
                for i, data in ipairs(ref_buttonData.strcounterscore) do
                --Creates Score: Index 9
                    local displayStrScore = spawnedButtonCount
                    --Sets up label
                    local label = data.value
                    --Sets height/width for display
                    local size = data.size
                    if data.hideBG == true then size = 0 end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.pos, height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Modifier: Index 10
                    local displayStrMod = spawnedButtonCount
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.0024)
                    --Sets up label
                    local label = math.floor(((data.value - 10) / 2))
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position={data.pos[1] + 0.002, data.pos[2], data.pos[3] - offsetDistance*2.2}, 
                            height=size, width=size,
                            font_size=data.size*2, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                
                --Creates Saving Throw: Index 11
                    local displayStrST = spawnedButtonCount
                    --Sets up label
                    local label = data.value
                    --Check for Prof bonus (Might have to be changed to Expertise rules)
                    if ref_buttonData.checkboxstrst[i].state == true then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value
                    elseif ref_buttonData.checkboxstrst[i].state == false then
                        label = math.floor(((data.value - 10) / 2))
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.savingThrow, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Strength Skill 1 Athletics: Index 12
                    local displayStrSkill1 = spawnedButtonCount
                    if ref_buttonData.checkboxstrskill1[i].state == true and ref_buttonData.checkboxstrskill1[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs4[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxstrskill1[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs4[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxstrskill1[i].state == true and ref_buttonData.checkboxstrskill1[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs4[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.athleticsPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1: Index 13
                    local funcName = "strcounterscoreAdd"..i
                    local func = function() click_strcounterscore(i, displayStrScore, displayStrMod, displayStrST, displayStrSkill1, 1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "+"
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                    local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                    --Sets up size
                    local size = data.size / 2
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1: Index 14
                    local funcName = "strcounterscoreSub"..i
                    local func = function() click_strcounterscore(i, displayStrScore, displayStrMod, displayStrST, displayStrSkill1, -1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "-"
                    --Set up position
                    local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end

        --Creates Dexterity Counters (Dexterity Mod, Dexterity Saving Throw, Dexterity Skills)
            function createDexScoreCounter()
                for i, data in ipairs(ref_buttonData.dexcounterscore) do
                --Creates Score: Index 0
                    local displayDexScore = spawnedButtonCount
                    --Sets up label
                    local label = data.value
                    --Sets height/width for display
                    local size = data.size
                    if data.hideBG == true then size = 0 end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.pos, height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Modifier: Index 1
                    local displayDexMod = spawnedButtonCount
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.0024)
                    --Sets up label
                    local label = math.floor(((data.value - 10) / 2))
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position={data.pos[1] + 0.002, data.pos[2], data.pos[3] - offsetDistance*2.2}, 
                            height=size, width=size,
                            font_size=data.size*2, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                
                --Creates Saving Throw: Index 2
                    local displayDexST = spawnedButtonCount
                    --Sets up label
                    local label = data.value
                    --Check for Prof bonus
                    if ref_buttonData.checkboxdexst[i].state == true then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value
                    elseif ref_buttonData.checkboxdexst[i].state == false then
                        label = math.floor(((data.value - 10) / 2))
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.savingThrow, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Dexterity Skill 1 Acrobatics: Index 3
                    local displayDexSkill1 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxdexskill1[i].state == true and ref_buttonData.checkboxdexskill1[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs1[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxdexskill1[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs1[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxdexskill1[i].state == true and ref_buttonData.checkboxdexskill1[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs1[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.acrobaticsPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Dexterity Skill 2 Sleight of Hand: Index 4
                    local displayDexSkill2 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxdexskill2[i].state == true and ref_buttonData.checkboxdexskill2[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs16[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxdexskill2[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs16[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxdexskill2[i].state == true and ref_buttonData.checkboxdexskill2[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs16[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.sleightOfHandPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Dexterity Skill 3 Stealth: Index 5
                    local displayDexSkill3 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxdexskill3[i].state == true and ref_buttonData.checkboxdexskill3[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs17[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxdexskill3[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs17[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxdexskill3[i].state == true and ref_buttonData.checkboxdexskill3[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs17[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.stealtPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Initiative: Index 6
                    local displayInit = spawnedButtonCount
                    local label = math.floor(((data.value - 10) / 2) + ref_buttonData.counterinit[i].value)
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=ref_buttonData.counterinit[i].pos, 
                            height=size, width=size,
                            font_size=data.size*2.5, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorGreen })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1: Index 7
                    local funcName = "dexcounterscoreAdd"..i
                    local func = function() click_dexcounterscore(i, displayDexScore, displayDexMod, displayDexST, displayDexSkill1, displayDexSkill2, displayDexSkill3, displayInit, 1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "+"
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                    local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                    --Sets up size
                    local size = data.size / 2
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1: Index 8
                    local funcName = "dexcounterscoreSub"..i
                    local func = function() click_dexcounterscore(i, displayDexScore, displayDexMod, displayDexST, displayDexSkill1, displayDexSkill2, displayDexSkill3, displayInit, -1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "-"
                    --Set up position
                    local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end

        --Creates Constitution Counters (Constitution Mod, Strength Saving Throw)
            function createConScoreCounter()
                for i, data in ipairs(ref_buttonData.concounterscore) do
                --Creates Score: Index 15
                    local displayConScore = spawnedButtonCount
                    --Sets up label
                    local label = data.value
                    --Sets height/width for display
                    local size = data.size
                    if data.hideBG == true then size = 0 end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.pos, height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Modifier: Index 16
                    local displayConMod = spawnedButtonCount
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.0024)
                    --Sets up label
                    local label = math.floor(((data.value - 10) / 2))
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position={data.pos[1] + 0.002, data.pos[2], data.pos[3] - offsetDistance*2.2}, 
                            height=size, width=size,
                            font_size=data.size*2, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                
                --Creates Saving Throw: Index 17
                    local displayConST = spawnedButtonCount
                    --Sets up label
                    local label = data.value
                    --Check for Prof bonus
                    if ref_buttonData.checkboxconst[i].state == true then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value
                    elseif ref_buttonData.checkboxconst[i].state == false then
                        label = math.floor(((data.value - 10) / 2))
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.savingThrow, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1: Index 18
                    local funcName = "concounterscoreAdd"..i
                    local func = function() click_concounterscore(i, displayConScore, displayConMod, displayConST, 1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "+"
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                    local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                    --Sets up size
                    local size = data.size / 2
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1: Index 19
                    local funcName = "concounterscoreSub"..i
                    local func = function() click_concounterscore(i, displayConScore, displayConMod, displayConST, -1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "-"
                    --Set up position
                    local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end

        --Creates Intelligence Counters (Intelligence Mod, Intelligence Saving Throw, Intelligence Skills)
            function createIntScoreCounter()
                for i, data in ipairs(ref_buttonData.intcounterscore) do
                --Creates Score: Index 20
                    local displayIntScore = spawnedButtonCount
                    --Sets up label
                    local label = data.value
                    --Sets height/width for display
                    local size = data.size
                    if data.hideBG == true then size = 0 end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.pos, height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Modifier: Index 21
                    local displayIntMod = spawnedButtonCount
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.0024)
                    --Sets up label
                    local label = math.floor(((data.value - 10) / 2))
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position={data.pos[1] + 0.002, data.pos[2], data.pos[3] - offsetDistance*2.2}, 
                            height=size, width=size,
                            font_size=data.size*2, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                
                --Creates Saving Throw: Index 22
                    local displayIntST = spawnedButtonCount
                    --Sets up label
                    local label = data.value
                    --Check for Prof bonus (Might have to be changed to Expertise rules)
                    if ref_buttonData.checkboxintst[i].state == true then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value
                    elseif ref_buttonData.checkboxintst[i].state == false then
                        label = math.floor(((data.value - 10) / 2))
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.savingThrow, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Intelligence Skill 1 Arcana: Index 23
                    local displayIntSkill1 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxintskill1[i].state == true and ref_buttonData.checkboxintskill1[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs3[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxintskill1[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs3[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxintskill1[i].state == true and ref_buttonData.checkboxintskill1[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs3[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.arcanaPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Intelligence Skill 2 History: Index 24
                    local displayIntSkill2 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxintskill2[i].state == true and ref_buttonData.checkboxintskill2[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs6[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxintskill2[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs6[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxintskill2[i].state == true and ref_buttonData.checkboxintskill2[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs6[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.historyPos,
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Intelligence Skill 3 Investigation: Index 25
                    local displayIntSkill3 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxintskill3[i].state == true and ref_buttonData.checkboxintskill3[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs9[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxintskill3[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs9[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxintskill3[i].state == true and ref_buttonData.checkboxintskill3[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs9[i].value
                    end
                    --Creates button and counts it (Investigation Score)
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.investigationPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                    local displayIntPasInv = spawnedButtonCount

                    --Creates button and counts it (Passive Investigation Sense): Index 26
                        self.createButton({
                            label=(label + 10), click_function="click_none", function_owner=self,
                            position={-1.392,0.12,0.302}, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Intelligence Skill 4 Nature: Index 27
                    local displayIntSkill4 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxintskill4[i].state == true and ref_buttonData.checkboxintskill4[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs11[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxintskill4[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs11[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxintskill4[i].state == true and ref_buttonData.checkboxintskill4[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs11[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.naturePos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Intelligence Skill 5 Religion: Index 28
                    local displayIntSkill5 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxintskill5[i].state == true and ref_buttonData.checkboxintskill5[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs15[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxintskill5[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs15[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxintskill5[i].state == true and ref_buttonData.checkboxintskill5[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs15[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.religionPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1: Index 29
                    local funcName = "intcounterscoreAdd"..i
                    local func = function() click_intcounterscore(i, displayIntScore, displayIntMod, displayIntST, displayIntSkill1, displayIntSkill2 ,displayIntSkill3 , displayIntSkill4 , displayIntSkill5, displayIntPasInv, 1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "+"
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                    local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                    --Sets up size
                    local size = data.size / 2
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1: Index 30
                    local funcName = "intcounterscoreSub"..i
                    local func = function() click_intcounterscore(i, displayIntScore, displayIntMod, displayIntST, displayIntSkill1, displayIntSkill2 , displayIntSkill3 , displayIntSkill4 , displayIntSkill5, displayIntPasInv, -1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "-"
                    --Set up position
                    local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end

        --Creates Wisdom Counters (Wisdom Mod, Wisdom Saving Throw, Wisdom Skills)
            function createWisScoreCounter()
                for i, data in ipairs(ref_buttonData.wiscounterscore) do
                --Creates Score: Index 31
                    local displayWisScore = spawnedButtonCount
                    --Sets up label
                    local label = data.value
                    --Sets height/width for display
                    local size = data.size
                    if data.hideBG == true then size = 0 end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.pos, height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Modifier: Index 32
                    local displayWisMod = spawnedButtonCount
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.0024)
                    --Sets up label
                    local label = math.floor(((data.value - 10) / 2))
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position={data.pos[1] + 0.002, data.pos[2], data.pos[3] - offsetDistance*2.2}, 
                            height=size, width=size,
                            font_size=data.size*2, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                
                --Creates Saving Throw: Index 33
                    local displayWisST = spawnedButtonCount
                    --Sets up label
                    local label = data.value
                    --Check for Prof bonus
                    if ref_buttonData.checkboxwisst[i].state == true then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value
                    elseif ref_buttonData.checkboxwisst[i].state == false then
                        label = math.floor(((data.value - 10) / 2))
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.savingThrow, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Wisdom Skill 1 Animal Handling: Index 34
                    local displayWisSkill1 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxwisskill1[i].state == true and ref_buttonData.checkboxwisskill1[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs2[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxwisskill1[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs2[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxwisskill1[i].state == true and ref_buttonData.checkboxwisskill1[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs2[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.animalHandlingPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Wisdom Skill 2 Insight: Index 35
                    local displayWisSkill2 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxwisskill2[i].state == true and ref_buttonData.checkboxwisskill2[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs7[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxwisskill2[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs7[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxwisskill2[i].state == true and ref_buttonData.checkboxwisskill2[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs7[i].value
                    end
                    --Creates button and counts it (Insight Score)
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.insightPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                    local displayWisPasIns = spawnedButtonCount

                    --Creates button and counts it (Passive Insight Sense): Index 36
                        self.createButton({
                            label=(label + 10), click_function="click_none", function_owner=self,
                            position={-1.392,0.12,0.209}, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Wisdom Skill 3 Medicine: Index 37
                    local displayWisSkill3 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxwisskill3[i].state == true and ref_buttonData.checkboxwisskill3[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs10[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxwisskill3[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs10[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxwisskill3[i].state == true and ref_buttonData.checkboxwisskill3[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs10[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.medicinePos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Wisdom Skill 4 Perception: Index 38
                    local displayWisSkill4 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxwisskill4[i].state == true and ref_buttonData.checkboxwisskill4[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs12[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxwisskill4[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs12[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxwisskill4[i].state == true and ref_buttonData.checkboxwisskill4[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs12[i].value
                    end
                    --Creates button and counts it (Perception Score)
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.perceptionPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                    local displayWisPasPer = spawnedButtonCount

                    --Creates button and counts it (Passive Perception Sense): Index 39
                        self.createButton({
                            label=(label + 10), click_function="click_none", function_owner=self,
                            position={-1.392,0.12,0.118}, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Wisdom Skill 5 Survival: Index 40
                    local displayWisSkill5 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxwisskill5[i].state == true and ref_buttonData.checkboxwisskill5[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs18[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxwisskill5[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs18[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxwisskill5[i].state == true and ref_buttonData.checkboxwisskill5[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs18[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.survivalPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1: Index 41
                    local funcName = "wiscounterscoreAdd"..i
                    local func = function() click_wiscounterscore(i, displayWisScore, displayWisMod, displayWisST, displayWisSkill1, displayWisSkill2 ,displayWisSkill3 , displayWisSkill4 , displayWisSkill5, displayWisPasIns, displayWisPasPer, 1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "+"
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                    local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                    --Sets up size
                    local size = data.size / 2
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                
                --Sets up subtract 1: Index 42
                    local funcName = "wiscounterscoreSub"..i
                    local func = function() click_wiscounterscore(i, displayWisScore, displayWisMod, displayWisST, displayWisSkill1, displayWisSkill2 ,displayWisSkill3 , displayWisSkill4 , displayWisSkill5, displayWisPasIns, displayWisPasPer, -1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "-"
                    --Set up position
                    local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end

        --Creates Charisma Counters (Charisma Mod, Charisma Saving Throw, Charisma Skills)
            function createChaScoreCounter()
                for i, data in ipairs(ref_buttonData.chacounterscore) do
                --Creates Score: Index 43
                    local displayChaScore = spawnedButtonCount
                    --Sets up label
                    local label = data.value
                    --Sets height/width for display
                    local size = data.size
                    if data.hideBG == true then size = 0 end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.pos, height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Modifier: Index 44
                    local displayChaMod = spawnedButtonCount
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.0024)
                    --Sets up label
                    local label = math.floor(((data.value - 10) / 2))
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position={data.pos[1] + 0.002, data.pos[2], data.pos[3] - offsetDistance*2.2}, 
                            height=size, width=size,
                            font_size=data.size*2, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                
                --Creates Saving Throw: Index 45
                    local displayChaST = spawnedButtonCount
                    --Sets up label
                    local label = data.value
                    --Check for Prof bonus
                    if ref_buttonData.checkboxchast[i].state == true then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value
                    elseif ref_buttonData.checkboxchast[i].state == false then
                        label = math.floor(((data.value - 10) / 2))
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.savingThrow, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Charisma Skill 1 Deception: Index 46
                    local displayChaSkill1 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxchaskill1[i].state == true and ref_buttonData.checkboxchaskill1[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs5[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxchaskill1[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs5[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxchaskill1[i].state == true and ref_buttonData.checkboxchaskill1[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs5[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.deceptionPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Charisma Skill 2 Intimidation: Index 47
                    local displayChaSkill2 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxchaskill2[i].state == true and ref_buttonData.checkboxchaskill2[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs8[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxchaskill2[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs8[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxchaskill2[i].state == true and ref_buttonData.checkboxchaskill2[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs8[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.intimidationPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Charisma Skill 3 Performance: Index 48
                    local displayChaSkill3 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxchaskill3[i].state == true and ref_buttonData.checkboxchaskill3[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs13[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxchaskill3[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs13[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxchaskill3[i].state == true and ref_buttonData.checkboxchaskill3[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs13[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.performancePos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Charisma Skill 4 Persuassion: Index 49
                    local displayChaSkill4 = spawnedButtonCount
                    --Expertise Check
                    if ref_buttonData.checkboxchaskill4[i].state == true and ref_buttonData.checkboxchaskill4[i].value == 1 then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprof[i].value + ref_buttonData.counterprofs14[i].value
                    --Prof Check
                    elseif ref_buttonData.checkboxchaskill4[i].state == false then
                        label = math.floor(((data.value - 10) / 2)) + ref_buttonData.counterprofs14[i].value
                    --No Prof Check
                    elseif ref_buttonData.checkboxchaskill4[i].state == true and ref_buttonData.checkboxchaskill4[i].value == 2 then
                        label = math.floor(((data.value - 10) / 2)) + (ref_buttonData.counterprof[i].value*2) + ref_buttonData.counterprofs14[i].value
                    end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.persuasionPos, 
                            height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1: Index 50
                    local funcName = "chacounterscoreAdd"..i
                    local func = function() click_chacounterscore(i, displayChaScore, displayChaMod, displayChaST, displayChaSkill1, displayChaSkill2, displayChaSkill3, displayChaSkill4, 1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "+"
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                    local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                    --Sets up size
                    local size = data.size / 2
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1: Index 51
                    local funcName = "chacounterscoreSub"..i
                    local func = function() click_chacounterscore(i, displayChaScore, displayChaMod, displayChaST, displayChaSkill1, displayChaSkill2, displayChaSkill3, displayChaSkill4, -1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "-"
                    --Set up position
                    local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end

    --Creates Level Counters
        function createXPLevelCounter()
            for i, data in ipairs(ref_buttonData.xpcounter) do
                --Creates Score: Index 52
                    local displayLevel = spawnedButtonCount
                    --Sets up label
                    local label = data.value
                    --Sets height/width for display
                    local size = data.size
                    if data.hideBG == true then size = 0 end
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.pos, height=size, width=size,
                            font_size=data.size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Creates Modifier: Index 53
                    local displayLevelxp = spawnedButtonCount
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.0024)
                    --Sets up level xp label
                    local label = 'EXP'
                    
                    --Creates Level EXP cap
                        self.createButton({
                            label=label, click_function="click_none", function_owner=self,
                            position=data.xpbar, 
                            height=size, width=size,
                            font_size=150, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1: Index 54
                    local funcName = "xpcounterAdd"..i
                    local func = function() click_xpcounter(i, displayLevel, displayLevelxp, 1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "+"
                    --Sets up position
                    local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.0018)
                    local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                    --Sets up size
                    local size = data.size / 2
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1: Index 55
                    local funcName = "xpcounterSub"..i
                    local func = function() click_xpcounter(i, displayLevel, displayLevelxp, -1) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = "-"
                    --Set up position
                    local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                    --Creates button and counts it
                        self.createButton({
                            label=label, click_function=funcName, function_owner=self,
                            position=pos, height=size, width=size,
                            font_size=size, scale=buttonScale,
                            color=buttonColorWhite, font_color=buttonColorBlack })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end

    --Create Speed Counter
        function createCounterSpeed()
            for i, data in ipairs(ref_buttonData.counterspeed) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterspeedAdd5"..i
                local func = function() click_counterspeed(i, displayNumber, 5) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+5"
                --Sets up position
                local pos = {data.pos[1] + data.modifier, data.pos[2], data.pos[3]}
                --Sets up size
                local size = (data.size / 2)
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterspeedSub5"..i
                local func = function() click_counterspeed(i, displayNumber, -5) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-5"
                --Set up position
                local pos = {data.pos[1] - data.modifier, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProf()
            for i, data in ipairs(ref_buttonData.counterprof) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofAdd"..i
                local func = function() click_counterprof(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofSub"..i
                local func = function() click_counterprof(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS1()
            for i, data in ipairs(ref_buttonData.counterprofs1) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs1Add"..i
                local func = function() click_counterprofs1(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs1Sub"..i
                local func = function() click_counterprofs1(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS2()
            for i, data in ipairs(ref_buttonData.counterprofs2) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs2Add"..i
                local func = function() click_counterprofs2(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs2Sub"..i
                local func = function() click_counterprofs2(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS3()
            for i, data in ipairs(ref_buttonData.counterprofs3) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs3Add"..i
                local func = function() click_counterprofs3(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs3Sub"..i
                local func = function() click_counterprofs3(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS4()
            for i, data in ipairs(ref_buttonData.counterprofs4) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs4Add"..i
                local func = function() click_counterprofs4(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs4Sub"..i
                local func = function() click_counterprofs4(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS5()
            for i, data in ipairs(ref_buttonData.counterprofs5) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs5Add"..i
                local func = function() click_counterprofs5(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs5Sub"..i
                local func = function() click_counterprofs5(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS6()
            for i, data in ipairs(ref_buttonData.counterprofs6) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs6Add"..i
                local func = function() click_counterprofs6(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs6Sub"..i
                local func = function() click_counterprofs6(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS7()
            for i, data in ipairs(ref_buttonData.counterprofs7) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs7Add"..i
                local func = function() click_counterprofs7(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs7Sub"..i
                local func = function() click_counterprofs7(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS8()
            for i, data in ipairs(ref_buttonData.counterprofs8) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs8Add"..i
                local func = function() click_counterprofs8(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs8Sub"..i
                local func = function() click_counterprofs8(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS9()
            for i, data in ipairs(ref_buttonData.counterprofs9) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs9Add"..i
                local func = function() click_counterprofs9(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs9Sub"..i
                local func = function() click_counterprofs9(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS10()
            for i, data in ipairs(ref_buttonData.counterprofs10) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs10Add"..i
                local func = function() click_counterprofs10(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs10Sub"..i
                local func = function() click_counterprofs10(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS11()
            for i, data in ipairs(ref_buttonData.counterprofs11) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs11Add"..i
                local func = function() click_counterprofs11(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs11Sub"..i
                local func = function() click_counterprofs11(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS12()
            for i, data in ipairs(ref_buttonData.counterprofs12) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs12Add"..i
                local func = function() click_counterprofs12(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs12Sub"..i
                local func = function() click_counterprofs12(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS13()
            for i, data in ipairs(ref_buttonData.counterprofs13) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs13Add"..i
                local func = function() click_counterprofs13(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs13Sub"..i
                local func = function() click_counterprofs13(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS14()
            for i, data in ipairs(ref_buttonData.counterprofs14) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs14Add"..i
                local func = function() click_counterprofs14(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs14Sub"..i
                local func = function() click_counterprofs14(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS15()
            for i, data in ipairs(ref_buttonData.counterprofs15) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs15Add"..i
                local func = function() click_counterprofs15(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs15Sub"..i
                local func = function() click_counterprofs15(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS16()
            for i, data in ipairs(ref_buttonData.counterprofs16) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs16Add"..i
                local func = function() click_counterprofs16(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs16Sub"..i
                local func = function() click_counterprofs16(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS17()
            for i, data in ipairs(ref_buttonData.counterprofs17) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs17Add"..i
                local func = function() click_counterprofs17(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs17Sub"..i
                local func = function() click_counterprofs17(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterProfS18()
            for i, data in ipairs(ref_buttonData.counterprofs18) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterprofs18Add"..i
                local func = function() click_counterprofs18(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterprofs18Sub"..i
                local func = function() click_counterprofs18(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createCounterInit()
            for i, data in ipairs(ref_buttonData.counterinit) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = ' '
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterinitAdd"..i
                local func = function() click_counterinit(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size*2, width=size*2,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterinitSub"..i
                local func = function() click_counterinit(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size*2, width=size*2,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end
    
    --Create Long Rest Button 
        function createLongRest()
                for i, data in ipairs(ref_buttonData.longrest) do
                    --Sets up display
                    local displayNumber = spawnedButtonCount
                    --Sets up label
                    local label = string.char(9728) .. " Long Rest "
                    --Sets height/width for display
                    local size = data.size
                    if data.hideBG == true then size = 0 end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function="click_longrest", function_owner=self,
                        position=data.pos, height=data.size*1.45, width=data.size*6,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorYellow, font_color=buttonColorWhite
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end

    --Create Textboxes
        function createTextbox()
            for i, data in ipairs(ref_buttonData.textbox) do
                --Sets up reference function
                local funcName = "textbox"..i
                local func = function(_,col,val,sel) click_textbox(i,col,val,sel) end
                self.setVar(funcName, func)

                self.createInput({
                    input_function = funcName,
                    function_owner = self,
                    label          = data.label,
                    alignment      = data.alignment,
                    position       = data.pos,
                    scale          = buttonScale,
                    width          = data.width,
                    height         = (data.font_size*data.rows)+24,
                    font_size      = data.font_size,
                    color          = {0,0,0,0},
                    font_color     = buttonColorBlack,
                    value          = data.value,
                })
            end
        end

        function createNumbox()
            for i, data in ipairs(ref_buttonData.numbox) do
                --Sets up reference function
                local funcName = "numbox"..i
                local func = function(_,col,val,sel,amt) click_numbox(i,col,val,sel,0) end
                self.setVar(funcName, func)

                local widthSize = (data.font_size*1.7)
                self.createInput({
                    input_function = funcName,
                    function_owner = self,
                    label          = data.label,
                    alignment      = data.alignment,
                    position       = data.pos,
                    scale          = {0.15,0.15,0.15},
                    width          = data.width,
                    height         = data.font_size*1.2,
                    font_size      = data.font_size,
                    color          = buttonColorWhite,
                    font_color     = data.font_color,
                    value          = data.value,
                })
                --Sets up add 1
                local funcName = "numboxAdd"..i
                local func = function() click_numbox(i,col,val,sel,1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (widthSize/2 + widthSize/4) * (buttonScale[1] * 0.003)
                local pos = {data.pos[1] + 0.025, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Sets up size
                local size = (data.font_size / 1.3)
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=data.font_size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "numboxSub"..i
                local func = function() click_numbox(i,col,val,sel,-1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - 0.025, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=data.font_size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createNumbox2()
            for i, data in ipairs(ref_buttonData.numbox2) do
                --Sets up reference function
                local funcName = "numbox2"..i
                local func = function(_,col,val,sel,amt) click_numbox2(i,col,val,sel,0) end
                self.setVar(funcName, func)

                local widthSize = (data.font_size*1.7)
                self.createInput({
                    input_function = funcName,
                    function_owner = self,
                    label          = data.label,
                    alignment      = data.alignment,
                    position       = data.pos,
                    scale          = {0.15,0.15,0.15},
                    width          = data.width,
                    height         = data.font_size*1.2,
                    font_size      = data.font_size,
                    color          = buttonColorWhite,
                    font_color     = data.font_color,
                    value          = data.value,
                })
                --Sets up add 1
                local funcName = "numbox2Add"..i
                local func = function() click_numbox2(i,col,val,sel,1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (widthSize/2 + widthSize/4) * (buttonScale[1] * 0.003)
                local pos = {data.pos[1] + 0.025, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Sets up size
                local size = (data.font_size / 1.3)
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=data.font_size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "numbox2Sub"..i
                local func = function() click_numbox2(i,col,val,sel,-1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - 0.025, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=data.font_size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        --Makes Counters
        function createBonusStrST()
            for i, data in ipairs(ref_buttonData.bonusstrst) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "bonusstrstAdd"..i
                local func = function() click_bonusstrst(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position +
                local widthSize = (data.size*1.7)
                local offsetDistance = (widthSize/2 + widthSize/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + 0.0125, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "bonusstrstSub"..i
                local func = function() click_bonusstrst(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position -
                local pos = {data.pos[1] - 0.0125, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createBonusDexST()
            for i, data in ipairs(ref_buttonData.bonusdexst) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "bonusdexstAdd"..i
                local func = function() click_bonusdexst(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position +
                local widthSize = (data.size*1.7)
                local offsetDistance = (widthSize/2 + widthSize/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + 0.0125, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "bonusdexstSub"..i
                local func = function() click_bonusdexst(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position -
                local pos = {data.pos[1] - 0.0125, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createBonusConST()
            for i, data in ipairs(ref_buttonData.bonusconst) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "bonusconstAdd"..i
                local func = function() click_bonusconst(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position +
                local widthSize = (data.size*1.7)
                local offsetDistance = (widthSize/2 + widthSize/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + 0.0125, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "bonusconstSub"..i
                local func = function() click_bonusconst(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position -
                local pos = {data.pos[1] - 0.0125, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createBonusIntST()
            for i, data in ipairs(ref_buttonData.bonusintst) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "bonusintstAdd"..i
                local func = function() click_bonusintst(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position +
                local widthSize = (data.size*1.7)
                local offsetDistance = (widthSize/2 + widthSize/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + 0.0125, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "bonusintstSub"..i
                local func = function() click_bonusintst(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position -
                local pos = {data.pos[1] - 0.0125, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createBonusWisST()
            for i, data in ipairs(ref_buttonData.bonuswisst) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "bonuswisstAdd"..i
                local func = function() click_bonuswisst(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position +
                local widthSize = (data.size*1.7)
                local offsetDistance = (widthSize/2 + widthSize/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + 0.0125, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "bonuswisstSub"..i
                local func = function() click_bonuswisst(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position -
                local pos = {data.pos[1] - 0.0125, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        function createBonusChaST()
            for i, data in ipairs(ref_buttonData.bonuschast) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "bonuschastAdd"..i
                local func = function() click_bonuschast(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position +
                local widthSize = (data.size*1.7)
                local offsetDistance = (widthSize/2 + widthSize/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + 0.0125, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "bonuschastSub"..i
                local func = function() click_bonuschast(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position -
                local pos = {data.pos[1] - 0.0125, data.pos[2], data.pos[3] + (offsetDistance/2)}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColorWhite, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

    --Create Checkbox Lock
        function createCheckboxLock()
        for i, data in ipairs(ref_buttonData.checkboxlock) do
            --Sets up reference function
            local buttonNumber = spawnedButtonCount
            local funcName = "checkboxlock"..i
            local func
            if i == 1 then
                func = function() click_checkboxlock(i, buttonNumber) end
            else
                func = function() click_checkbox(i, buttonNumber) end
            end
            self.setVar(funcName, func)
            --Sets up label
            if data.state==false then label="Locked" color=buttonColorRed end
            if data.state==true then label="Unlocked" color=buttonColorGreen end
            --Creates button and counts it
            self.createButton({
                label=label, click_function=funcName, function_owner=self,
                position=data.pos, height=data.size*1.5, width=data.size*4.5,
                font_size=data.size, scale=buttonScale,
                color=color, font_color=buttonColorWhite
            })
            spawnedButtonCount = spawnedButtonCount + 1
            end
        end