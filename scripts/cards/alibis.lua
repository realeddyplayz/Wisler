
------------ ALIBIS ---------------
SMODS.Joker {
    key = "alibis.random",

    loc_txt = {
        name = "Some Random Guy",
        text = {
            "Played {C:attention}Aces{} apply {X:mult,C:white}X#1#{} Mult upon scoring",
            "if {C:attention}Edward Robinson{} is present"
        }
    },

    config = {
        extra = {
            Xmult = 1.5
        }
    };

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_eddy_edward
        
        return {vars = {center.ability.extra.Xmult}}
    end,

    atlas = "Alibis",
    pos = {x = 0, y = 0},
    rarity = "eddy_alibi",
    cost = 4,
    
    blueprint_compat = true, -- can it be blueprinted/brainstormed/other
    eternal_compat = true, -- can it be eternal

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and next(SMODS.find_card("j_eddy_edward")) and not SMODS.has_no_rank(context.other_card) and context.other_card:get_id() == 14 then
            return { Xmult = card.ability.extra.Xmult }
        end
    end,

    in_pool = function(self, a, b)
        return true
    end
}

SMODS.Joker {
    key = "alibis.sadward",

    loc_txt = {
        name = "Sadward",
        text = {
            "Played {C:attention}Aces{} apply {X:chips,C:white}X#1#{} Chips upon scoring",
            "if {C:attention}Edward Robinson{} is present"
        }
    },

    config = {
        extra = {
            xchips = 2
        }
    };

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_eddy_edward
        
        return { vars = {center.ability.extra.xchips} }
    end,

    atlas = "Alibis",
    pos = {x = 1, y = 1},
    rarity = "eddy_alibi",
    cost = 4,
    
    blueprint_compat = true, -- can it be blueprinted/brainstormed/other
    eternal_compat = true, -- can it be eternal

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 14 then
            if not next(SMODS.find_card("j_eddy_edward")) then return end
            return { xchips = card.ability.extra.xchips };
        end
    end,

    in_pool = function(self, a, b)
        return true
    end
}

SMODS.Joker {
    key = "alibis.obese",

    loc_txt = {
        name = "The Problem",
        text = {
            "Played {C:attention}Aces{} add {C:chips}+#1#{} Chips upon scoring",
            "if {C:attention}Edward Robinson{} is present",
            "\n",
            "{C:inactive}\"Is that a picture of me fucking obese??\""
        }
    },

    config = {
        extra = {
            chips = 60
        }
    };

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_eddy_edward
        
        return { vars = {center.ability.extra.chips} }
    end,

    atlas = "Alibis",
    pos = {x = 0, y = 1},
    rarity = "eddy_alibi",
    cost = 4,
    
    blueprint_compat = true, -- can it be blueprinted/brainstormed/other
    eternal_compat = true, -- can it be eternal

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and next(SMODS.find_card("j_eddy_edward")) and not SMODS.has_no_rank(context.other_card) and context.other_card:get_id() == 14 then
            return { 
                chips = card.ability.extra.chips
            };
        end
    end,

    in_pool = function(self, a, b)
        return true
    end
}

SMODS.Joker {
    key = "alibis.robber",

    loc_txt = {
        name = "The Suspect",
        text = {
            "Played {C:attention}Aces{} earn {C:money}$#1#{} upon scoring",
            "if {C:attention}Edward Robinson{} is present"
        }
    },

    config = {
        extra = {
            dollars = 2
        }
    };

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_eddy_edward
        
        return { vars = {center.ability.extra.dollars} }
    end,

    atlas = "Alibis",
    pos = {x = 4, y = 0},
    rarity = "eddy_alibi",
    cost = 4,
    
    blueprint_compat = true, -- can it be blueprinted/brainstormed/other
    eternal_compat = true, -- can it be eternal

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and next(SMODS.find_card("j_eddy_edward")) and not SMODS.has_no_rank(context.other_card) and context.other_card:get_id() == 14 then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars

            return {
                dollars = card.ability.extra.dollars,
                func = function() -- This is for timing purposes, it runs after the dollar manipulation
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        end
    end,

    in_pool = function(self, a, b)
        return true
    end
}

SMODS.Joker {
    key = "alibis.google",
    
    loc_txt = {
        name = "A New Tab",
        text = {
            "{C:attention}Aces{} are always drawn to hand first",
            "if {C:attention}Edward Robinson{} is present"
        }
    },

    config = {
        can_retrigger = false
    },

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_eddy_edward

        return;
    end,

    atlas = "Alibis",
    pos = {x = 1, y = 0},
    rarity = "eddy_alibi",
    cost = 4,
    
    blueprint_compat = false, -- can it be blueprinted/brainstormed/other
    eternal_compat = true, -- can it be eternal
    
    calculate = function(self, card, context)
        if context.setting_blind then
            DRAWN_CARDS = {}; -- This is just reassurance, cuz of my shitty inconsistent code lmao
            
            local calculations = {
                message = 'Aces First!',
                colour = G.C.eddy_alibi
            };

            return calculations
        end
    end,

    in_pool = function(self, a, b)
        return true;
    end
}

SMODS.Joker {
    key = "alibis.eddycoin",
    
    loc_txt = {
        name = "$EDDY",
        text = {
            "Played {C:attention}Aces{} are triggered an additional time",
            "if {C:attention}Edward Robinson{} is present"
        }
    },

    config = { extra = { repetitions = 1 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_eddy_edward

        return { vars = { card.ability.extra.repetitions } };
    end,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card:get_id() == 14 and next(SMODS.find_card("j_eddy_edward")) then
            return {
                repetitions = card.ability.extra.repetitions
            };
        end
    end,

    atlas = "Alibis",
    pos = {x = 2, y = 0},
    rarity = "eddy_alibi",
    cost = 4,
    
    blueprint_compat = true, -- can it be blueprinted/brainstormed/other
    eternal_compat = true, -- can it be eternal

    in_pool = function(self, a, b)
        return true
    end
}

SMODS.Joker {
    key = "alibis.waterbottle",
    
    loc_txt = {
        name = "\"Shut the fuck up, Alex!\"",
        text = {
            "{C:attention}Aces{} in hand are turned into {C:attention}Steel Cards{}",
            "upon scoring if {C:attention}Edward Robinson{} is present"
        }
    },
    
    config = {
        can_retrigger = false
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_eddy_edward;
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel;
    end,

    calculate = function(self, card, context)
        if context.before and next(SMODS.find_card("j_eddy_edward")) and not context.end_of_round then
            local acesSteeled = 0;
            
            for idx, _card in ipairs(G.hand.cards) do
                if _card:get_id() == 14 and _card.config.center ~= G.P_CENTERS.m_steel then
                    local base = _card;

                    if not base.toSteelEvent then
                        acesSteeled = acesSteeled + 1;

                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                base:set_ability('m_steel', true);
                                base:juice_up(0.4, 0.4)
                                play_sound('tarot1', 0.8);

                                base.toSteelEvent = true;
                                return true;
                            end
                        }));
                    end
                end
            end

            if acesSteeled > 0 then
                return {
                    message = 'Steeled!',
                    colour = G.C.WHITE
                };
            end
        end
    end,

    atlas = "Alibis",
    pos = {x = 3, y = 0},
    rarity = "eddy_alibi",
    cost = 4,
    
    blueprint_compat = false, -- can it be blueprinted/brainstormed/other
    eternal_compat = true, -- can it be eternal

    in_pool = function(self, a, b)
        return true;
    end
}

SMODS.Joker {
    key = "alibis.portrait",
    
    loc_txt = {
        name = "Prized Possession",
        text = {
            "Scored {C:attention}face cards{} are converted to {C:attention}Aces{}",
            "if {C:attention}Edward Robinson{} is present",
            "\n",
            "{C:inactive}\"You have a picture of him on your wall!!\""
        }
    },

    config = { 
        can_retrigger = false
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_eddy_edward
    end,

    calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint and next(SMODS.find_card("j_eddy_edward")) then
            local faces = 0

            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_face() and scored_card:get_id() ~= 14 then
                    faces = faces + 1

                    G.E_MANAGER:add_event(Event({
                        trigger = "before",
                        delay = 0.3,
                        func = function()
                            assert(SMODS.change_base(scored_card, nil, 'Ace'));
                            
                            play_sound('tarot1', 0.8);
                            scored_card:juice_up();
                            return true;
                        end
                    }))
                end
            end

            if faces > 0 then
                return {
                    message = "Aced!",
                    colour = G.C.RED
                }
            end
        end
    end,

    atlas = "Alibis",
    pos = {x = 5, y = 0},
    rarity = "eddy_alibi",
    cost = 4,
    
    blueprint_compat = false, -- can it be blueprinted/brainstormed/other
    eternal_compat = true, -- can it be eternal

    in_pool = function(self, a, b)
        return true;
    end
}

SMODS.Joker {
    key = "alibis.function",
    
    loc_txt = {
        name = "Graph the Function",
        text = {
            "Scored {C:attention}face cards{} give {X:mult,C:white}X#1#{} Mult upon scoring",
            "if {C:attention}Edward Robinson{} is present",
            "\n",
            "{C:inactive}\"Oh I get it, he said graph the function!\""
        }
    },

    config = {
        extra = {
            Xmult = 2
        }
    };

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_eddy_edward
        
        return {vars = {center.ability.extra.Xmult}};
    end,

    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and next(SMODS.find_card("j_eddy_edward")) and context.other_card:is_face() then
            return { Xmult = card.ability.extra.Xmult }
        end
    end,

    atlas = "Alibis",
    pos = {x = 2, y = 1},
    rarity = "eddy_alibi",
    cost = 4,
    
    blueprint_compat = true, -- can it be blueprinted/brainstormed/other
    eternal_compat = true, -- can it be eternal

    in_pool = function(self, a, b)
        return true;
    end
}

SMODS.Joker {
    key = "alibis.moty",
    
    loc_txt = {
        name = "Movie of the Year",
        text = {
            "Applies {X:mult,C:white}X1.5{} Mult for every",
            "{C:attention}unscored Ace{} in played hands",
            "if {C:attention}Edward Robinson{} is present"
        }
    },

    config = {
        -- todo
    };

    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_eddy_edward;

        -- todo
    end,

    
    calculate = function(self, card, context)
        -- todo
        if not next(SMODS.find_card("j_eddy_edward")) then return end
        if context.individual and context.cardarea == 'unscored' then
            if context.other_card:get_id() == 14 then
                return { Xmult = 1.5 };
            end
        end
    end,

    atlas = "Alibis",
    pos = {x = 3, y = 1},
    soul_pos = {x = 4, y = 1},
    rarity = "eddy_alibi",
    cost = 4,
    
    blueprint_compat = true, -- can it be blueprinted/brainstormed/other
    eternal_compat = true, -- can it be eternal

    in_pool = function(self, a, b)
        return true;
    end
}
------------ ALIBIS END -----------