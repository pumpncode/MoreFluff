
local joker = {
  name = "Triangle, Planeswalker",
  config = {
    extra = {
      loyalty = 3,
      uses = 1,
      scoring = false,
      x_mult = 3,
    }
  },
  pos = {x = 0, y=9},

  rarity = 3,
  cost = 10,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  demicoloncompat = false,
  
  planeswalker = true,
  planeswalker_costs = { 2, -3, -7 },
  
  pronouns = "she_they",
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue+1] = { key = "planeswalker_explainer", set="Other", specific_vars = { 3 } }
    return {
      vars = { center.ability.extra.x_mult }
    }
  end,
  calculate = function(self, card, context)
    if context.after and context.cardarea == G.jokers then
      card.ability.extra.uses = 1
      card.ability.extra.scoring = false
    end
    if context.individual and context.cardarea == G.play and card.ability.extra.scoring then
      return {
        x_mult = card.ability.extra.x_mult,
        colour = G.C.RED,
        card = card
      }
    end
  end,

  can_loyalty = function(card, idx)
    if card.ability.extra.uses <= 0 then return false end
    if idx == 1 then
      return #G.hand.cards >= 1
    elseif idx == 2 then
      return #G.hand.highlighted >= 1 and #G.hand.highlighted <= 3
    elseif idx == 3 then
      return true
    else return false end
  end,

  loyalty = function(card, idx)
    card.ability.extra.uses = card.ability.extra.uses - 1
    if idx == 1 then
      card.ability.extra.loyalty = card.ability.extra.loyalty + 2
      SMODS.draw_cards(3)
    elseif idx == 2 then
      card.ability.extra.loyalty = card.ability.extra.loyalty - 3
      
      destroyed_cards = {}
      for i=#G.hand.highlighted, 1, -1 do
        destroyed_cards[#destroyed_cards+1] = G.hand.highlighted[i]
      end
      SMODS.destroy_cards(destroyed_cards)
    elseif idx == 3 then
      card.ability.extra.loyalty = card.ability.extra.loyalty - 7
      card.ability.extra.scoring = true
    end
  end
}

return joker
