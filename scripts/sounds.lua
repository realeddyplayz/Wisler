local config = SMODS.current_mod.config;

SMODS.Sound {
    key = "music_alibi",
    path = "music_alibi.ogg",

    select_music_track = function(self)
        if next(SMODS.find_card("j_eddy_edward")) and config["enable_alibi_theme"] then
            return 100;
        end

        return false;
    end,

    pitch = 1.0,
    volume = 0.7
}

SMODS.Sound {
    key = "music_rng",
    path = "music_RNG.ogg",

    select_music_track = function(self)
        if next(SMODS.find_card("j_eddy_rng")) and config["enable_alibi_theme"] then
            return 101;
        end

        return false;
    end,

    pitch = 1.0,
    volume = 0.6
}

SMODS.Sound {
    key = "music_ma_egg",
    path = "music_ma_egg.ogg",

    select_music_track = function(self)
        if next(SMODS.find_card("j_eddy_eggmo")) and config["enable_alibi_theme"] then
            return 101;
        end

        return false;
    end,

    pitch = 1.0,
    volume = 0.6
}