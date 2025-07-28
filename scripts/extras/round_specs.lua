DRAWN_CARDS = {}; -- used for Ace-priority draws // see draw_card.lua
ROUND_SPECIFIC_DATA = {};
local endRound = end_round;
function end_round()
    DRAWN_CARDS = {};
    ROUND_SPECIFIC_DATA = {};

    return endRound();
end