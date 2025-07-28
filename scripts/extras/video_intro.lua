INTRO_CUTSCENE = nil;
INTRO_PLAYING = false;
INTRO_COMPLETE = false;

local splash = G.splash_screen;
function G:splash_screen()
    -- sendTraceMessage("CAUGHT THE SPLASH SCREEN!");

    local winWidth, winHeight = love.graphics.getDimensions();
    WINDOW_DIMENSIONS = {
        width = winWidth,
        height = winHeight
    };

    G.STATES["WISLER_INTRO"] = 228;
    G:prep_stage(G.STAGES.SANDBOX, G.STATES.WISLER_INTRO, true);
    INTRO_CUTSCENE = love.graphics.newVideo("Mods/Wisler/assets/videos/intro.ogv");
    INTRO_CUTSCENE:play();

    -- G:main_menu();
    -- splash(G);
end

local game_draw = G.draw;
WINDOW_DIMENSIONS = { width = 0, height = 0 };
function G:draw()
    if INTRO_COMPLETE then 
        game_draw(G);

        return;
    end

    if INTRO_CUTSCENE ~= nil then
        if INTRO_CUTSCENE:isPlaying() and not INTRO_PLAYING then
            INTRO_PLAYING = true;
        end

        if INTRO_PLAYING and not INTRO_CUTSCENE:isPlaying() then
            INTRO_COMPLETE = true;
                    
            if G.SETTINGS.skip_splash == 'Yes' then 
                G:main_menu();
            else
                customSplash(G);
            end

            return;
        end

        if INTRO_CUTSCENE:isPlaying() then
            love.graphics.clear();
            love.graphics.draw(INTRO_CUTSCENE, 0, 0, 0, WINDOW_DIMENSIONS.width / 1920, WINDOW_DIMENSIONS.height / 1080);
        end
    end
end

function customSplash(G)
    G:prep_stage(G.STAGES.MAIN_MENU, G.STATES.SPLASH, true);
    G.E_MANAGER:add_event(Event({
        func = (function()
            discover_card()
            return true
        end)
      }))


    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            G.TIMERS.TOTAL = 0
            G.TIMERS.REAL = 0
            --Prep the splash screen shaders for both the background(colour swirl) and the foreground(white flash), starting at black
            G.SPLASH_BACK = Sprite(-30, -13, G.ROOM.T.w+60, G.ROOM.T.h+22, G.ASSET_ATLAS["ui_1"], {x = 2, y = 0})
            G.SPLASH_BACK:define_draw_steps({{
                shader = 'splash',
                send = {
                    {name = 'time', ref_table = G.TIMERS, ref_value = 'REAL'},
                    {name = 'vort_speed', val = 1},
                    {name = 'colour_1', ref_table = G.C, ref_value = 'BLUE'},
                    {name = 'colour_2', ref_table = G.C, ref_value = 'WHITE'},
                    {name = 'mid_flash', val = 0},
                    {name = 'vort_offset', val = (2*90.15315131*os.time())%100000},
                }}})
            G.SPLASH_BACK:set_alignment({
                major = G.ROOM_ATTACH,
                type = 'cm',
                offset = {x=0,y=0}
            })
            G.SPLASH_FRONT = Sprite(0,-20, G.ROOM.T.w*2, G.ROOM.T.h*4, G.ASSET_ATLAS["ui_1"], {x = 2, y = 0})
            G.SPLASH_FRONT:define_draw_steps({{
                shader = 'flash',
                send = {
                    {name = 'time', ref_table = G.TIMERS, ref_value = 'REAL'},
                    {name = 'mid_flash', val = 1}
                }}})
            G.SPLASH_FRONT:set_alignment({
                major = G.ROOM_ATTACH,
                type = 'cm',
                offset = {x=0,y=0}
            })

            --spawn in splash card
            local SC = nil
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2,func = (function()
                local SC_scale = 1.2
                SC = Card(G.ROOM.T.w/2 - SC_scale*G.CARD_W/2, 10. + G.ROOM.T.h/2 - SC_scale*G.CARD_H/2, SC_scale*G.CARD_W, SC_scale*G.CARD_H, G.P_CARDS.empty, G.P_CENTERS['j_eddy_edward'])
                SC.T.y = G.ROOM.T.h/2 - SC_scale*G.CARD_H/2
                SC.ambient_tilt = 1
                SC.states.drag.can = false
                SC.states.hover.can = false
                SC.no_ui = true
                G.VIBRATION = G.VIBRATION + 2
                play_sound('whoosh1', 0.7, 0.2)
                play_sound('introPad1', 0.704, 0.6)
            return true;end)}))

            --dissolve fool card and start to fade in the vortex
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 1.8,func = (function() --|||||||||||
                SC:start_dissolve({G.C.WHITE, G.C.WHITE},true, 12, true)
                play_sound('magic_crumple', 1, 0.5)
                play_sound('splash_buildup', 1, 0.7)
            return true;end)}))

            --create all the cards and suck them in
            function make_splash_card(args)
                args = args or {}
                local angle = math.random()*2*3.14
                local card_size = (args.scale or 1.5)*(math.random() + 1)
                local card_pos = args.card_pos or {
                    x = (18 + card_size)*math.sin(angle),
                    y = (18 + card_size)*math.cos(angle)
                }
                local card = Card(  card_pos.x + G.ROOM.T.w/2 - G.CARD_W*card_size/2,
                                    card_pos.y + G.ROOM.T.h/2 - G.CARD_H*card_size/2,
                                    card_size*G.CARD_W, card_size*G.CARD_H, pseudorandom_element(G.P_CARDS), G.P_CENTERS.c_base)
                if math.random() > 0.8 then card.sprite_facing = 'back'; card.facing = 'back' end
                card.no_shadow = true
                card.states.hover.can = false
                card.states.drag.can = false
                card.vortex = true and not args.no_vortex
                card.T.r = angle
                return card, card_pos
            end

            G.vortex_time = G.TIMERS.REAL
            local temp_del = nil

            for i = 1, 200 do
                temp_del = temp_del or 3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay = temp_del,
                    func = (function()
                    local card, card_pos = make_splash_card({scale = 2 - i/300})
                    local speed = math.max(2. - i*0.005, 0.001)
                    ease_value(card.T, 'scale', -card.T.scale, nil, nil, nil, 1.*speed, 'elastic')
                    ease_value(card.T, 'x', -card_pos.x, nil, nil, nil, 0.9*speed)
                    ease_value(card.T, 'y', -card_pos.y, nil, nil, nil, 0.9*speed)
                    local temp_pitch = i*0.007 + 0.6
                    local temp_i = i
                    G.E_MANAGER:add_event(Event({
                        blockable = false,
                        func = (function()
                            if card.T.scale <= 0 then
                                if temp_i < 30 then 
                                    play_sound('whoosh1', temp_pitch + math.random()*0.05, 0.25*(1 - temp_i/50))
                                end

                                if temp_i == 15 then
                                    play_sound('whoosh_long',0.9, 0.7)
                                end
                                G.VIBRATION = G.VIBRATION + 0.1
                                card:remove()
                                return true
                            end
                        end)}))
                        return true
                    end)}))
                    temp_del = temp_del + math.max(1/(i), math.max(0.2*(170-i)/500, 0.016))
            end

            --when faded to white, spit out the 'Fool's' cards and slowly have them settle in to place
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 2.,func = (function()
                G.SPLASH_BACK:remove()
                G.SPLASH_BACK = G.SPLASH_FRONT
                G.SPLASH_FRONT = nil
                G:main_menu('splash')
            return true;end)}))
        return true
    end)
    }))
end