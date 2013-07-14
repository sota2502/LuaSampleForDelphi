local CANVAS_WIDTH  = 320
local CANVAS_HEIGHT = 240
local ICON_WIDTH    = 32
local ICON_HEIGHT   = 32

function move_for_lua(x, y, vx, vy)
    if ( x < 0 ) then
        vx = 1
        ChangeImageGlue();
    elseif ( x + ICON_WIDTH > CANVAS_WIDTH ) then
        vx = -1
        ChangeImageGlue();
    end

    if ( y < 0 ) then
        vy = 1
        ChangeImageGlue();
    elseif ( y + ICON_HEIGHT > CANVAS_HEIGHT ) then
        vy = -1
        ChangeImageGlue();
    end

    x = x + vx
    y = y + vy

    return x, y, vx, vy
end