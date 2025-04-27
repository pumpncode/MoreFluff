local joker = {
  name = "Less Fluff",
  config = {
    extra = {
      x_mult = 5,
      joker_slots_lost = 1,
    }
  },
  pos = {x = 3, y = 7},
  rarity = 3,
  cost = 10,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  loc_vars = function(self, info_queue, center)
    return {
      vars = { center.ability.extra.x_mult, center.ability.extra.joker_slots_lost }
    }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
      return {
        xmult = card.ability.extra.x_mult,
      }
    end
  end,
	add_to_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.joker_slots_lost
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.joker_slots_lost
	end
}

if JokerDisplay then
  JokerDisplay.Definitions["j_mf_lessfluff"] = {
    text = {
      {
        border_nodes = {
          { text = "X" },
          { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" },
        },
      }
    },
  }
end

return joker
