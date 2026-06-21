function onLoad()
    self.interactable = false;
    self.createButton({
    label = "CUSTOMIZE BOARD",
    click_function = "onButtonClick",
    function_owner = self,
    width = 1200,
    height = 250,
    color = {1, 1, 1, 1.0},
    position = {-18.2,10.8,12.5},
    rotation = {0, 90, 270},
    font_size = 120
})
end

function onButtonClick()
    if self.interactable == false then
        self.interactable = true;
        self.setColorTint({1, 1, 1})
        self.editButton({ label = "LOCK BOARD" })

    else
        self.interactable = false;
        self.editButton({ label = "CUSTOMIZE BOARD"})

    end
end
