SMODS.Joker {
    key = "elusiveScholar",
    loc_txt = {
        name = "elusiveScholar",
        text = {
            {
                "{C:chips}+#1#{} Chips if {C:attention}played hand{}",
                "contains only {C:attention}Aces{}"
            },
            {
                '{C:green}1 in 4.13{} chance of being destroyed',
                'at the {C:attention}end of round{}',
            }
        }
    },

    atlas = "homelatro_jokers",
	rarity = 'hmlt_player',
    pos = {x = 0, y = 0},
    cost = 4,
    
	config = { extra = { chips = 120 } },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } };
	end,

    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal

    calculate = function(self, card, context)
        if context.joker_main then
            local handIsAces = true;

            for idx, _card in ipairs(G.play.cards) do
                if _card:get_id() ~= 14 then
                    handIsAces = false;
                end
            end

            if handIsAces then
                return {
                    chips = card.ability.extra.chips,
                    message = "Aces Only!"
                };
            end
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			if SMODS.pseudorandom_probability(card, 'elusiveScholar', 1, 4.13, 'elusiveScholar_ded') then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('slice1')
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0,
							blockable = false,
							func = function()
								card:remove()
								return true
							end
						}))
						return true
					end
				}));

                G.GAME.pool_flags.eddy_elusiveScholar_extinct = true;
                return {
                    message = "ded"
                };
            else
                return {
                    message = "Happen!"
                };
            end
        end
    end,

    no_pool_flag = "eddy_elusiveScholar_extinct"
}