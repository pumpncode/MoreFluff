local joker = {
  name = "Flint and Steel",
  config = {},
  pos = {x = 4, y = 6},
  rarity = 2,
  cost = 4,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = true,
	pools = { ["Meme"] = true },
  loc_vars = function(self, info_queue, center)
    return {
      vars = { }
    }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers then
      if context.before then
        local flint = false
        local steel = false

        for i = 1, #context.scoring_hand do
          local c_card = context.scoring_hand[i]
          if SMODS.has_enhancement(c_card, "m_stone") then flint = true end
          if SMODS.has_enhancement(c_card, "m_steel") then steel = true end
        end

        if flint and steel then -- PEAK CINEMA
          local text,disp_text = G.FUNCS.get_poker_hand_info(context.full_hand)
          card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
          update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level=G.GAME.hands[text].level})
          level_up_hand(context.blueprint_card or card, text, nil, 1)
        end
      end
    end
  end
}

return joker
