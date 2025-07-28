----------------------------------------------
------------MOD CODE -------------------------

WISLER = SMODS.current_mod;

if WISLER.config["enable_intro"] then 
    assert(SMODS.load_file("./scripts/extras/video_intro.lua"))();
end

WISLER.optional_features = function()
    return {
        retrigger_joker = true,
    };
end

assert(SMODS.load_file("./scripts/extras/round_specs.lua"))();
assert(SMODS.load_file("./scripts/extras/ui_abstract.lua"))();

assert(SMODS.load_file("./scripts/atlases.lua"))();
assert(SMODS.load_file("./scripts/sounds.lua"))();
assert(SMODS.load_file("./scripts/rarities.lua"))();
assert(SMODS.load_file("./scripts/boosters.lua"))();
assert(SMODS.load_file("./scripts/blinds.lua"))();
assert(SMODS.load_file("./scripts/backs.lua"))();
assert(SMODS.load_file("./scripts/tags.lua"))();

-----------------------------------
-- JOKERS -------------------------

assert(SMODS.load_file("./scripts/cards/jokers.lua"))();
assert(SMODS.load_file("./scripts/cards/alibis.lua"))();

-- JOKERS END ---------------------
-----------------------------------

-----------------------------------
-- CROSSMOD -----------------------

if next(SMODS.find_mod("homelatro")) then
    -- HOMELATRO CROSSMOD

    assert(SMODS.load_file("./crossmod/homelatro/atlases.lua"))();
    assert(SMODS.load_file("./crossmod/homelatro/jokers.lua"))();
end

if next(SMODS.find_mod("upgradecards")) then
    -- UPGRADE-CARDS CROSSMOD

    assert(SMODS.load_file("./crossmod/upgrade_cards/upgrades.lua"))();
end

-----------------------------------
-- CROSSMOD END -------------------

assert(SMODS.load_file("./scripts/extras/draw_card.lua"))();

----------------------------------------------
------------MOD CODE END----------------------