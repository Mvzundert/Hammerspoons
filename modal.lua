
-- modal_list = {}

function modal_stat(modal, color)
    if not modal_show then
        local mainScreen = hs.screen.mainScreen()
        local mainRes = mainScreen:fullFrame()
        local modal_bg_rect = hs.geometry.rect(mainRes.w-170,mainRes.h-24,170,19)
        local modal_text_rect = hs.geometry.rect(mainRes.w-170,mainRes.h-24,170,19)
        modal_bg = hs.drawing.rectangle(modal_bg_rect)
        modal_bg:setStroke(false)
        modal_bg:setFillColor(black)
        modal_bg:setRoundedRectRadii(2,2)
        modal_bg:setLevel(hs.drawing.windowLevels.status)
        modal_bg:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces+hs.drawing.windowBehaviors.stationary)
        local styledText = hs.styledtext.new("init...",{font={size=14.0,color=white},paragraphStyle={alignment="center"}})
        modal_show = hs.drawing.text(modal_text_rect,styledText)
        modal_show:setLevel(hs.drawing.windowLevels.status)
        modal_show:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces+hs.drawing.windowBehaviors.stationary)
    end
    modal_bg:show()
    modal_bg:setFillColor(color)
    modal_show:show()
    modal_text = string.upper(modal .. ' mode')
    modal_show:setText(modal_text)
end

function exit_others(except)
    for i = 1, #modal_list do
        if modal_list[i] ~= except then
            modal_list[i]:exit()
        end
    end
end
