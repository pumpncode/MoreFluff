if not Jen then return nil end


local joker = {
  -- name = "Triangle",
  config = {
    extra = {}
  },
  pos = { x = 0, y = 0 },
  soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 }},
  rarity = 'jen_transcendent',
  cost = 333,
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
      vars = { 1.333 }
    }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      local text, disp_text, poker_hands, scoring_hand, non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
      if non_loc_disp_text == "Three of a Kind" then
        return {
          eemult = 1.333,
          colour = G.C.dark_edition,
          card = card
        }
      end
    end
  end
}

return joker
