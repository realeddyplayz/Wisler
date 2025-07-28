---------- UI TYPE VARIABLES -----------
UITYPE_ROOT   = G.UIT.ROOT;
UITYPE_ROW    = G.UIT.R;
UITYPE_BOX    = G.UIT.B;
UITYPE_TEXT   = G.UIT.T;
UITYPE_COLUMN = G.UIT.C;
UITYPE_SLIDER = G.UIT.S;
UITYPE_INPUT  = G.UIT.I;
UITYPE_OBJECT = G.UIT.O;

---------- NodeType DEF ----------------
NodeType = {};

---------- NodeType FUNCS --------------
function NodeType:AddNode(node)
    self.nodes = self.nodes or {};
    self.nodes[#self.nodes + 1] = node;
    return self;
end

function NodeType:SetConfig(config)
    self.config = UI_DEF:Validate(config)
end

function NodeType:SetType(type)
    self.type = type or UITYPE_ROOT;
end

function NodeType:New(base)
    base = base or {
        n = UITYPE_ROOT,
        config = {},
        nodes = {}
    };

    setmetatable(base, self);
    self.__index = self;
    return base;
end

function NodeType:Clone()
    local clone = {};
    
    for k, v in pairs(self) do 
        clone[k] = v; 
    end

    return setmetatable(clone, getmetatable(self));
end

---------- UI_DEF BASIS ----------------
UI_DEF = {};

---------- TEMPLATE --------------------
UI_DEF.TEMPLATE = {};
UI_DEF.TEMPLATE.BACKDROP = NodeType:New({
    n = UITYPE_ROOT, 
    config = { r = 0.1, minw = 8, align = "tm", padding = 0.2, colour = G.C.BLACK }
});

---------- BASIC GENERATION ------------
function UI_DEF:Validate(tbl)
    return tbl or {};
end

function UI_DEF:Node(type, config, nodes)
    if type == nil then type = UITYPE_ROOT end

    return NodeType:New({
        n = type,
        config = UI_DEF:Validate(config),
        nodes = UI_DEF:Validate(nodes)
    });
end

function UI_DEF:Box(h, w, config)
    config = config or {};
    config.h = h or 2;
    config.w = w or 8;

    return NodeType:New({
        n = UITYPE_BOX,
        config = config,
        nodes = {}
    });
end

function UI_DEF:Text(text, config, nodes)
    config = config or {};
    nodes = nodes or {};

    config.text = text;

    return NodeType:New({
        n = UITYPE_TEXT,
        config = config,
        nodes = {}
    });
end

-- Padding
function UI_DEF:Padding(padding, config)
    config = UI_DEF:Validate(config);
    
    config.padding = padding;

    return config;
end

-- Alignment
function UI_DEF:Align(align, config)
    config = UI_DEF:Validate(config);
    config.align = align;

    return config;
end

function UI_DEF:TopLeft(config)      return UI_DEF:Align("tl", config); end
function UI_DEF:TopMiddle(config)    return UI_DEF:Align("tm", config); end
function UI_DEF:TopRight(config)     return UI_DEF:Align("tr", config); end
function UI_DEF:CenterLeft(config)   return UI_DEF:Align("cl", config); end
function UI_DEF:CenterMiddle(config) return UI_DEF:Align("cm", config); end
function UI_DEF:CenterRight(config)  return UI_DEF:Align("cr", config); end
function UI_DEF:BottomLeft(config)   return UI_DEF:Align("bl", config); end
function UI_DEF:BottomMiddle(config) return UI_DEF:Align("bm", config); end
function UI_DEF:BottomRight(config)  return UI_DEF:Align("br", config); end