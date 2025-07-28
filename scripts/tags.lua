SMODS.Tag {
    key = "alibi_tag",
    loc_txt = {
        name = "Alibi Tag",
        text = {
            "Gives a free",
            "{C:attention}Alibi Pack"
        }
    },

    atlas = "AlibiTag",
    pos = { x = 0, y = 0 },

    in_pool = function(self, args)
        return next(SMODS.find_card("j_eddy_edward"));
    end,

    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID;
            G.CONTROLLER.locks[lock] = true;

            tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
                local booster = SMODS.create_card { key = 'p_eddy_alibi_pack_1', area = G.play }
                booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
                booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
                booster.T.w = G.CARD_W * 1.27
                booster.T.h = G.CARD_H * 1.27
                booster.cost = 0
                booster.from_tag = true
                G.FUNCS.use_card({ config = { ref_table = booster } })
                booster:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end);

            tag.triggered = true;
            return true;
        end
    end
}