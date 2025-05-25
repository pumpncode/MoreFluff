local joker = {
  name = "Lightning Strikes Thrice",
  config = {
    extra = {
      retriggers = 2,
    }
  },
  pos = {x = 0, y = 0},
  rarity = 2,
  cost = 5,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  loc_vars = function(self, info_queue, center)
    play_sound('mf_lightningstrikesthrice')
    return {
      vars = { center.ability.extra.retriggers }
    }
  end,
  calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self and context.other_context.discard then
      return {
        message = localize('k_again_ex'),
        repetitions = card.ability.extra.retriggers,
        card = card
      }
		end
    if context.mf_seal_repetition and context.seal_context.discard then
      return {
        message = localize('k_again_ex'),
        repetitions = card.ability.extra.retriggers,
        card = card
      }
    end
  end
}

return joker
