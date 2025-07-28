

local drawCard = draw_card;
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    local newTab = next(SMODS.find_card("j_eddy_edward")) and next(SMODS.find_card("j_eddy_alibis.google"));
    local deckToHand = ((from == G.deck) and (to == G.hand));

    if deckToHand then
        -- sendTraceMessage("Drawn from deck to hand!", "DRAW");
        if newTab then
            -- sendTraceMessage("Alibi requirements met!", "DRAW");

            local aces = {};
            for index, _card in ipairs(G.deck.cards) do
                if _card:get_id() == 14 then
                    if _card.area and _card.area == G.deck then
                        table.insert(aces, _card);
                    end
                end
            end

            for i, _card in ipairs(DRAWN_CARDS) do
                for j, _otherCard in ipairs(aces) do
                    if _card == _otherCard then
                        table.remove(aces, j);
                    end
                end
            end

            local newCard = pseudorandom_element(aces, pseudoseed("alibi"));
            table.insert(DRAWN_CARDS, newCard);

            if #aces < 1 then 
                newCard = false; 
            end

            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.1,
                func = function()
                    if newCard then 
                        if from then newCard = from:remove_card(newCard) end
                        if newCard then drawn = true end

                        local stay_flipped = G.GAME and G.GAME.blind and G.GAME.blind:stay_flipped(to, newCard)
                        
                        if G.GAME.modifiers.flipped_cards and to == G.hand then
                            if pseudorandom(pseudoseed('flipped_card')) < 1/G.GAME.modifiers.flipped_cards then
                                stay_flipped = true
                            end
                        end
                        
                        to:emplace(newCard, nil, stay_flipped)
                    else
                        if to:draw_card_from(from, stay_flipped, discarded_only) then 
                            drawn = true;
                        end
                    end

                    if not mute and drawn then
                        if from == G.deck or from == G.hand or from == G.play or from == G.jokers or from == G.consumeables or from == G.discard then
                            G.VIBRATION = G.VIBRATION + 0.6
                        end
                        play_sound('card1', 0.85 + percent*0.2/100, 0.6*(vol or 1));
                    end

                    if sort then to:sort(); end
                    return true;
                end
            }));
        else
            drawCard(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only);
        end
    end
        
    if not deckToHand then
        drawCard(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only);
    end
end
