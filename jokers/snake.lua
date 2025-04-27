local joker = {
  name = "Snake",
  config = {
    extra = 3
  },
  pos = {x = 3, y = 7},
  rarity = 2,
  cost = 7,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  loc_vars = function(self, info_queue, center)
    return {
      vars = { center.ability.extra }
    }
  end,
  calculate = function(self, card, context)
  end
}

return joker
