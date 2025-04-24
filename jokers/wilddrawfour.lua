local joker = {
  name = "Wild Draw Four",
  config = {
    extra = 4,
  },
  pos = {x = 9, y = 6},
  rarity = 2,
  cost = 4,
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
}

return joker
