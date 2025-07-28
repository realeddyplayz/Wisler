SMODS.Atlas {
	key = 'UpgradeCards',
	path = 'Upgrade Cards.png',
	px = 71,
	py = 95,
};

SMODS.Consumable {
	key = 'eddy_up',
	set = 'upgrd_upgrade',

	atlas = 'UpgradeCards',
	pos = { x = 0, y = 0 },
    soul_pos = { x = 0, y = 1 },

	config = { extra = { bonus = 25 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bonus } };
	end,

    loc_txt = {
        name = "Eddy-Up!",
        text = {
            "Gives all {C:attention}Aces{} in {C:attention}full deck{}",
            "{C:chips}+#1#{} Chips",
        }
    },

	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}));

		for i = 1, #G.hand.cards do
			local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:get_id() == 14 then
						G.hand.cards[i]:flip()
						play_sound('card1', percent)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end

					return true;
				end
			}));
		end

		delay(0.2);

		for i = 1, #G.playing_cards do
			if G.playing_cards[i]:get_id() == 14 then
				G.playing_cards[i].ability.perma_bonus = G.playing_cards[i].ability.perma_bonus or 0
				G.playing_cards[i].ability.perma_bonus = G.playing_cards[i].ability.perma_bonus + card.ability.extra.bonus
			end
		end

		for i = 1, #G.hand.cards do
			local percent = 0.85 + (i - 0.999) / (#G.playing_cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if G.hand.cards[i]:get_id() == 14 then
						G.hand.cards[i]:flip()
						play_sound('tarot2', percent, 0.6)
						G.hand.cards[i]:juice_up(0.3, 0.3)
					end
					return true
				end
			}))
		end

		delay(0.5);
	end,

	can_use = function(self, card)
		return G.hand and #G.hand.cards > 0
	end
}