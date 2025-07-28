SMODS.Booster {
    key = "alibi_pack_1",
    weight = 5,
    kind = 'eddy_alibi',
    cost = 4,

    loc_txt = {
        name = "Alibi Pack",
        group_name = "Alibi Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:eddy_alibi}Alibi{C:joker} Jokers{}",
        }
    },

    atlas = "Boosters",
    pos = { x = 0, y = 0 },
    config = { extra = 2, choose = 1 },

    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        info_queue[#info_queue+1] = G.P_CENTERS.j_eddy_edward

        return {
            vars = { cfg.choose, cfg.extra }
        };
    end,

    in_pool = function(self, args)
        if next(SMODS.find_card("j_eddy_edward")) then
            return true;
        end

        return false;
    end,

    ease_background_colour = function(self)
        ease_background_colour({new_colour = G.C.BLACK, contrast = 1})
    end,

    create_card = function(self, card, i)
        return { set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "eddy_alibi", rarity = "eddy_alibi" }
    end,
}