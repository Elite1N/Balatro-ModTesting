--- MOD_NAME: KaijuMod
--- MOD_ID: KaijuMod
--- MOD_AUTHOR: EliteIN
--- MOD_DESCRIPTION: A retarded mod that adds jokers to the game.
--- MOD_VERSION: 1.0.0

local mod_name = 'KaijuMod'

local jokers = {
    chicken = {
    name = "chicken",
    text = {
        "At the start of each round,",
        "generate an {C:attention}Egg{} Joker."
    },
    config = {},
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    atlas = nil,
    soul_pos = nil,
    calculate = function(self, context)
        if self.debuff then return nil end
        if context.start_of_round and not (context.individual or context.repetition) then
            -- Add the existing Egg joker by its slug
            SMODS.Joker.give("j_egg")
            return {
                message = "Egg Joker generated!",
                card = self
            }
        end
    end,
    loc_def = function(self)
        return {}
    end
}
    
}

function SMODS.INIT.KaijuMod()
    --Create and register jokers
    for k, v in pairs(jokers) do --for every joker in 'jokers'
        local joker = SMODS.Joker:new(v.name, k, v.config, v.pos, { name = v.name, text = v.text }, v.rarity, v.cost,
        v.unlocked, v.discovered, v.blueprint_compat, v.eternal_compat, v.effect, v.atlas, v.soul_pos)
        joker:register()

        if not v.atlas then --if atlas=nil then use single sprites. In this case you have to save your sprite as slug.png (for example j_sample_wee.png)
            SMODS.Sprite:new("j_" .. k, SMODS.findModByID(mod_name).path, "j_" .. k .. ".jpg", 71, 95, "asset_atli")
                :register()
        end

        SMODS.Jokers[joker.slug].calculate = v.calculate
        SMODS.Jokers[joker.slug].loc_def = v.loc_def

        --if tooltip is present, add jokers tooltip
        if (v.tooltip ~= nil) then
            SMODS.Jokers[joker.slug].tooltip = v.tooltip
        end
    end
end