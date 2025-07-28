-----------------------------------
----------- RARITIES --------------

SMODS.Rarity {
    key = "alibi",
    loc_txt = {
        name = "Alibi"
    },

    default_weight = 0.0125, -- Rises if Edward Robinson is present
    badge_colour = HEX('724C3F'),
    get_weight = function(self, weight, object_type)
        local alibis_possessed = { 0 };
        local edward_present = next(SMODS.find_card("j_eddy_edward"));

        -- Check if all Alibis are owned, or if Showman is present
        for index, joker in ipairs(G.jokers.cards) do
            -- sendInfoMessage(inspect(G.P_JOKER_RARITY_POOLS), "POOLS LIST");
            
            if joker.config.center.rarity == "eddy_alibi" and not alibis_possessed[joker.config.center.key] then
                alibis_possessed[1] = alibis_possessed[1] + 1;
                alibis_possessed[joker.config.center.key] = true;
            end

            -- If Showman is present, ignore alibi count
            if joker.config.center.key == "j_ring_leader" and edward_present then
                -- FOUND SHOWMAN
                return 0.125;
            end
        end

        -- Don't pool this rarity if there's nothing to pool ...
        if alibis_possessed[1] >= #G.P_JOKER_RARITY_POOLS["eddy_alibi"] then 
            return 0; 
        end

        -- Else just pool as normal, as long as Edward is present
        if edward_present then
            return 0.125;
        end

        return weight;
    end,

    pools = {
        ["Joker"] = true, --uses self.default_rate when polled
        ["Alibi"] = true
    }
}

--------- RARITIES END ------------
-----------------------------------