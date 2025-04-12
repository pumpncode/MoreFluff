local huger = SMODS.current_mod.config["Huger Joker"]
local scale = 1.5
if huger then
  scale = 2
end

local joker = {
  name = "Wide Joker",
  config = {
    extra = {
      powmult = 1.14
    }
  },
  pos = {x = 3, y = 3},
  rarity = 3,
  cost = 9,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  display_size = { w = 71.0 * scale, h = 95 / scale },
	pools = { ["Meme"] = true },
  loc_vars = function(self, info_queue, center)
    return {
      vars = { center.ability.extra.powmult }
    }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
      return {
        emult = card.ability.powmult
      }
    end
  end
}

return joker
