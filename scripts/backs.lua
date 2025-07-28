SMODS.Back {
    key = "AlibiDeck",
    loc_txt = {
        name = "Alibi Deck",
        text = { 
            "Start the game with",
            "{C:attention}Edward Robinson{}",
            "and {C:attention}1{} extra Joker slot"
        },
        unlock = {
            "Find {C:attention}Edward Robinson{}",
            "to unlock this Deck"
        }
    },

    atlas = "AlibiDeck",
    pos = { x = 0, y = 0 },
    config = {
        jokers = {"j_eddy_edward"}, 
        joker_slot = 1
    },

    unlocked = false, discovered = false,
    check_for_unlock = function(self, args) 
        if next(SMODS.find_card("j_eddy_edward")) then
            return true;
        end

        return false;
    end
}