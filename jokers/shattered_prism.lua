if not Jen then return nil end


local joker = {
  name = "Enlightened Prism",
  config = {
    extra = {}
  },
  pos = { x = 0, y = 0 },
  soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
  rarity = 'jen_transcendent',
  cost = 333333333333333333333333333333333,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  immutable = true,
  unique = true,
  debuff_immune = true,
  no_doe = true,
  loc_vars = function(self, info_queue, center)
    return {
      vars = { 1.333, "{e333###333}e333###333" }
    }
  end,
  misc_badge = {
    colour = G.C.polterworx,
    text_colour = G.C.CRY_VERDANT,
    text = {
      'Legend of Kosmos',
      'notmario'
    }
  },
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play then
      local count = 0
      for _, card in pairs(G.consumeables.cards) do
        if card.ability.set == "Colour" then
          count = count + 3
        end
      end
      if count > 0 then
        return {
          message = localize('k_again_ex'),
          repetitions = count,
          card = card
        }
      end
    end
    if context.individual and context.cardarea == G.play then
      local text, disp_text, poker_hands, scoring_hand, non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
      if non_loc_disp_text == "Three of a Kind" then
        return {
          eeemult = 1.333,
          colour = G.C.dark_edition,
          card = card
        }
      end
    end
  end
}

return joker
