
-- THE MAN HIMSELF
SMODS.Joker{
    key = "edward",
    loc_txt = {
        name = "Edward Robinson",
        text = {
            "Prevents Debuffs on all {C:attention}Aces{}"
        }
    },

    atlas = "Edward",
    pos = {x = 0, y = 0},
    cost = 3,

    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal

    calculate = function(self, card, context)
        -- ROUND_SPECIFIC_DATA.eddy = ROUND_SPECIFIC_DATA.eddy or {
        --     buffed_aces = false;
        -- };

        if context.debuff_card then
            if context.debuff_card:get_id() == 14 then
                local calculations = {
                    prevent_debuff = true
                };
                
                return calculations;
            end
        end

        if context.setting_blind then
            local calculations = {
                message = 'Re-buffed!',
                colour = G.C.eddy_alibi
            };

            return calculations
        end
    end,

    in_pool = function(self, a, b)
        return true
    end
}

-- Edward Robinson Jr.
function AcesCount()
    local ace_count = 0;
    
    if not G.deck then return 0 end
    for i, _card in ipairs(G.deck.cards) do
        if _card:get_id() == 14 then ace_count = ace_count + 1; end
    end

    return ace_count or 0;
end

SMODS.Joker{
    key = "junior",
    loc_txt = {
        name = "Edward Robinson Jr.",
        text = {
            "At end of round, gain {C:gold}$1{}",
            "for every {C:attention}Ace{} in full deck",
            "{C:inactive}(currently {C:gold}$#1#{C:inactive}){}"
        }
    },

    atlas = "Edward",
    pos = {x = 4, y = 0},
    cost = 3,

    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal

    calculate = function(self, card, context)
        -- todo
        -- if context.main_eval and context.end_of_round then
        -- end
    end,

    loc_vars = function(self, info_queue, car)
        return {
            vars = {
                AcesCount()
            }
        };
    end,

    calc_dollar_bonus = function(self, card)
        local ace_count = AcesCount();

        return ace_count or 0;
    end,

    in_pool = function(self, a, b)
        return true
    end
}

-- Chad McBundles??
SMODS.Joker{
    key = "mcbundles",
    loc_txt = {
        name = "Chad McBundles",
        text = {
            "Retriggers all of {C:attention}Edward Robinson's Alibis{}"
        }
    },

    atlas = "Edward",
    pos = {x = 1, y = 0},
    cost = 3,

    rarity = 3,

    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_eddy_edward
    end,

    calculate = function(self, card, context)
        if context.retrigger_joker_check then
            if context.other_card.config.center.rarity == "eddy_alibi" and context.other_card.config.center.config.can_retrigger ~= false then
                -- sendTraceMessage("ATTEMPTED TO RETRIGGER ALIBI!!", "CHAD MCBUNDLES");
                
                return {
                    repetitions = 1
                }
            end
        end
    end,

    in_pool = function(self, a, b)
        return true
    end
}

-- ANIME KID
SMODS.Joker{
    key = "anime_kid",
    loc_txt = {
        name = "Anime Kid",
        text = {
            "{C:green,E:1}#2# in #3#{} chance to {C:attention}prevent death",
            "\n",
            "First time this Joker fails to trigger,",
            "{C:attention}prevent death anyway{} and add {X:mult,C:white}X4{} Mult",
            "to this Joker permanently",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}"
        }
    },

    atlas = "Edward",
    pos = {x = 2, y = 0},
    soul_pos = {x = 2, y = 1},
    cost = 10,

    config = {
        extra = {
            odds = 3,
            Xmult = 1,
            toggled = false
        }
    },

    rarity = 4,

    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal

    loc_vars = function(self, info_queue, card)
        local num, denom = SMODS.get_probability_vars(card, card.ability.extra.odds, 5, 'anime_kid');
        -- sendTraceMessage(inspect(card.ability.extra), "IS ANIME KID TOGGLED?");

        return {
            vars = {
                card.ability.extra.Xmult,
                num, denom
            }
        };
    end,

    calculate = function(self, card, context)
        -- Detect game over
        if context.end_of_round and context.game_over and context.main_eval then
            -- Do probability check
            local anime_kid_succeeds = SMODS.pseudorandom_probability(card, "anime_kid", card.ability.extra.odds, 5, "anime_kid");

            if anime_kid_succeeds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up();
                        G.hand_text_area.game_chips:juice_up();
                        play_sound("tarot1");

                        return true;
                    end
                }));

                return {
                    Xmult = card.ability.extra.Xmult,
                    message = "NOT LIKE THIS!",
                    saved = "j_eddy_anime_kid",
                    colour = G.C.BLACK
                };
            else
                if not card.ability.extra.toggled then
                    card.ability.extra.toggled = true;
                    card.ability.extra.Xmult = card.ability.extra.Xmult + 4;
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card:juice_up();
                            G.hand_text_area.blind_chips:juice_up();
                            G.hand_text_area.game_chips:juice_up();
                            play_sound("tarot1");

                            return true;
                        end
                    }));
                    
                    return {
                        message = "BRING IT ON!!",
                        saved = "j_eddy_anime_kid",
                        colour = G.C.RED
                    };
                end
            end
        end

        if context.joker_main then
            if card.ability.extra.toggled then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end,

    in_pool = function(self, a, b)
        return true
    end
}

-- SKULLMASK
SMODS.Joker{
    key = "skullmask",
    loc_txt = {
        name = "Skullmask",
        text = {
            "When a hand is played, {C:attention}destroys",
            "a random card in hand and adds its",
            "{C:chips}Chips{} to this {C:mult}Mult{}, or {X:mult,C:white}X0.75{} Mult",
            "if card is a {C:attention}face card{}",
            "\n",
            "If {C:attention}Edward Robinson{} is present,",
            "replace destroyed card with an {C:attention}Ace{}",
            "of the same suit",
            "{C:inactive}(Currently {C:mult}+#2# Mult{C:inactive}, {X:mult,C:white}X#1#{C:inactive} Mult){}"
        }
    },

    atlas = "Edward",
    pos = {x = 3, y = 0},
    soul_pos = {x = 3, y = 1},
    cost = 10,

    config = {
        extra = {
            Xmult = 1,
            mult = 0,
            destroy = true
        }
    },

    rarity = 4,

    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_eddy_edward

        return {
            vars = {
                card.ability.extra.Xmult,
                card.ability.extra.mult
            }
        };
    end,

    calculate = function(self, card, context)
        -- Return vars
        if context.destroy_card and card.ability.extra.destroy then
            local card_to_destroy = pseudorandom_element(G.hand.cards, "skullmask");

            if context.destroy_card == card_to_destroy then
                card.ability.extra.destroy = false;

                local mult_to_add = card_to_destroy:get_chip_bonus();
                local is_face_card = card_to_destroy:is_face();

                if is_face_card then
                    card.ability.extra.Xmult = card.ability.extra.Xmult + 0.75;
                else
                    card.ability.extra.mult = card.ability.extra.mult + mult_to_add;
                end

                if next(SMODS.find_card("j_eddy_edward")) then
                    local _card = SMODS.add_card { set = "Base", rank = "Ace", area = G.deck, suit = card_to_destroy.base.suit };
                    G.GAME.blind:debuff_card(_card);
                    G.deck:sort();

                    SMODS.calculate_context({ playing_card_added = true, cards = { _card } });

                    return {
                        message = "X-Aced!",
                        remove = true
                    };
                end

                return {
                    message = "X",
                    remove = true
                };
            end
        end

        if context.joker_main then
            card.ability.extra.destroy = true;

            return {
                mult = card.ability.extra.mult,
                Xmult = card.ability.extra.Xmult
            };
        end
    end,

    in_pool = function(self, a, b)
        return true
    end
}

-- EEE EEEE
local scrabbleTable = {
    { 
        keys = {"a", "e", "i", "o", "u", "l", "n", "s", "t", "r"},
        value = 1
    },
    { 
        keys = {"d", "g"},
        value = 2
    },
    { 
        keys = {"b", "c", "m", "p"},
        value = 3
    },
    { 
        keys = {"f", "h", "v", "w", "y"},
        value = 4
    },
    { 
        keys = {"k"},
        value = 5
    },
    { 
        keys = {"j", "x"},
        value = 8
    },
    { 
        keys = {"q", "z"},
        value = 10
    }
};

function scrabbleTable:valueOf(letter)
    for index, tab in ipairs(scrabbleTable) do
        for i, key in ipairs(tab.keys) do
            if key == letter then
                return tab.value;
            end
        end
    end

    return 0;
end

function FirstLetterFromID(id)
    if id == 2 or id == 3 or id == 10 then return "t" end
    if id == 4 or id == 5 then return "f" end
    if id == 6 or id == 7 then return "s" end
    if id == 8 then return "e" end
    if id == 9 then return "n" end
    if id == 11 then return "j" end
    if id == 12 then return "q" end
    if id == 13 then return "k" end
    if id == 14 then return "a" end
end

SMODS.Joker{
    key = "scrabble",
    loc_txt = {
        name = "Those Who Know",
        text = {
            "When first card is {C:attention}scored{},",
            "add {X:mult,C:white}X1/10{} of its rank's first letter's",
            "{C:attention}Scrabble value{} to this {X:mult,C:white}Mult{}",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}"
        }
    },

    atlas = "Edward",
    pos = {x = 5, y = 0},
    soul_pos = {x = 5, y = 1},
    cost = 10,

    config = {
        -- todo
        extra = {
            Xmult = 1.0
        }
    },

    rarity = 4,

    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Xmult
            }
        };
    end,

    calculate = function(self, card, context)
        -- todo
        if context.individual and context.cardarea == G.play then
            if context.other_card == context.scoring_hand[1] then
                local letter = FirstLetterFromID(context.other_card:get_id());
                local scrabble_value = scrabbleTable:valueOf(letter);

                card.ability.extra.Xmult = card.ability.extra.Xmult + (scrabble_value / 10);
                card:juice_up();

                return {
                    message = letter:upper() .. "!"
                };
            end
        end

        if context.joker_main then
            return {
                Xmult = card.ability.extra.Xmult
            };
        end
    end,

    in_pool = function(self, a, b)
        return true
    end
}

SMODS.Joker{
    key = "rng",
    loc_txt = {
        name = "RNG Box",
        text = {
            "Does nothing except play {C:attention}RNG Box (OST){}",
            "{C:inactive}\"Cover me!\"{}"
        }
    },

    atlas = "Bilmop",
    pos = {x = 0, y = 0},
    cost = 0,

    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal

    in_pool = function(self, a, b)
        return false; -- TODO: introduce way to get it
    end
}

SMODS.Joker {
    key = "eggmo",
    loc_txt = {
        name = "eggmo",
        text = {
            "Does nothing except play {C:attention}Ma Egg (OST){}",
            "{C:inactive}\"He was Eggmong Us, until he wasn't.\"{}",
            "{C:inactive}...how has he not shattered?{}"
        }
    },

    atlas = "eggmo",
    pos = {x = 0, y = 0},
    cost = 0,

    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal

    in_pool = function(self, a, b)
        return false; -- TODO: introduce way to get it
    end
}

SMODS.Joker {
    key = "egg_mong_us",
    loc_txt = {
        name = "Egg mong us",
        text = {
            "{C:inactive}Eggmong Us never sus{}"
        }
    },

    atlas = "eggmo",
    pos = {x = 1, y = 0},
    cost = 0,

    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal

    in_pool = function(self, a, b)
        return false; -- TODO: introduce way to get it
    end
}

-- SETTINGS CAMEL SHIT --
SETTINGS_SELECTION = {
    {
        base = G.SETTINGS,
        options = {
            {
                key = "GAMESPEED",
                values = {0.5, 1, 2, 4}
            },
            {
                key = "play_button_pos",
                values = {1, 2}
            }
        }
    },

    {
        base = G.SETTINGS.WINDOW,
        options = {
            {
                key = "screenmode",
                values = {"Borderless", "Windowed", "Fullscreen"}
            },
            {
                key = "vsync",
                values = {1, 0}
            }
        }
    },

    {
        base = G.SETTINGS.SOUND,
        options = {
            {
                key = "volume",
                values = {0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100}
            },
            {
                key = "music_volume",
                values = {0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100}
            },
            {
                key = "game_sounds_volume",
                values = {0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100}
            }
        }
    },

    {
        base = G.SETTINGS.GRAPHICS,
        options = {
            {
                key = "texture_scaling",
                values = {1, 2}
            },
            {
                key = "shadows",
                values = {"On", "Off"}
            },
            {
                key = "crt",
                values = {0, 25, 50, 75, 100}
            },
            {
                key = "bloom",
                values = {1, 2}
            }
        }
    },
};

function SettingsCamel()
    local _base = pseudorandom_element(SETTINGS_SELECTION, "settings_camel");
    local option = pseudorandom_element(_base.options, "settings_camel");
    local randomized_option = pseudorandom_element(option.values);

    sendTraceMessage("ATTEMPTED SETTINGS CAMEL: " .. option.key .. ", " .. randomized_option, "SETTINGS CAMEL");

    _base.base[option.key] = randomized_option;
    
    if _base.base == G.SETTINGS.WINDOW then 
        G.FUNCS.apply_window_changes(true);
    end
    
    G:save_settings();
end

SMODS.Joker{
    key = "settings_camel",
    loc_txt = {
        name = "settings camel",
        text = {
            "settings camel",
            "\n",
            "something dire happens when this joker triggers"
        }
    },

    atlas = "Bilmop",
    pos = {x = 1, y = 0},
    cost = 0,

    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal

    calculate = function(self, card, context)
        if context.joker_main then
            SettingsCamel();
            
            return {
                message = "?",
                colour = G.C.BLACK
            };
        end
    end,

    in_pool = function(self, a, b)
        return true; -- TODO: introduce way to get it
    end
}
