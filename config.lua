

SMODS.current_mod.config_tab = function()
    ----- UI_DEF METHOD V2
    local ui_root = UI_DEF.TEMPLATE.BACKDROP:Clone();
    local ui_text_group = UI_DEF:Node(UITYPE_ROW, UI_DEF:CenterMiddle(UI_DEF:Padding(0.01)));
    local ui_toggle_group = UI_DEF:Node(UITYPE_ROW, UI_DEF:CenterMiddle(UI_DEF:Padding(0.01)));
    local ui_text = UI_DEF:Text("+ \"RNG BOX (OST)\" & \"Ma Egg (OST)\"", UI_DEF:CenterMiddle({
        colour = G.C.UI.TEXT_INACTIVE, scale = 0.4
    }));

    ui_text_group:AddNode(ui_text);
    ui_toggle_group:AddNode(
        create_toggle({
            label = "     Enable Intro Cutscene",
            ref_table = SMODS.Mods["WISLER"].config,
            ref_value = "enable_intro"
        })
    );
    ui_toggle_group:AddNode(
        create_toggle({
            label = "     Enable Alibi Theme",
            ref_table = SMODS.Mods["WISLER"].config,
            ref_value = "enable_alibi_theme"
        })
    );

    ui_root:AddNode(ui_toggle_group);
    ui_root:AddNode(ui_text_group);

    return ui_root;
end

return {
    ["enable_alibi_theme"] = true,
    ["enable_intro"] = false
}