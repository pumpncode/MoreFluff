function init()
  -- for the funny progress bar.
  function progressbar(val, max)
    if max > 10 then
      return val, "/"..max
    end
    return string.rep("#", val), string.rep("#", max - val)
  end

  SMODS.ConsumableType({
    key = "Shape",
    primary_colour = HEX("316ea0"),
    secondary_colour = HEX("316ea0"),
    collection_rows = { 4, 4 },
    loc_txt = {},
    default = "c_mf_black",
    can_stack = false,
    can_divide = false,
  })

  SMODS.UndiscoveredSprite({
    key = "Shape",
    atlas = "mf_shapes",
    path = "mf_shapes.png",
    pos = { x = 0, y = 0 },
    px = 71,
    py = 95,
  })

  G.C.SECONDARY_SET.Shape = HEX("316ea0")

  -- SMODS.Tag({
  --   key = "colour",
  --   atlas = "mf_tags",
  --   pos = { x = 0, y = 0 },
  --   unlocked = true,
  --   discovered = true,
  --   loc_vars = function(self, info_queue)
  --     info_queue[#info_queue + 1] = { set = "Other", key = "p_mf_colour_jumbo_1", specific_vars = { 1, 4 } }
  --     return { vars = {} }
  --   end,
  --   apply = function(self, tag, context)
  --     if context.type == "new_blind_choice" then
  --       tag:yep("+", G.C.SECONDARY_SET.Code, function()
  --         local key = "p_mf_colour_jumbo_1"
  --         local card = Card(
  --           G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
  --           G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
  --           G.CARD_W * 1.27,
  --           G.CARD_H * 1.27,
  --           G.P_CARDS.empty,
  --           G.P_CENTERS[key],
  --           { bypass_discovery_center = true, bypass_discovery_ui = true }
  --         )
  --         card.cost = 0
  --         card.from_tag = true
  --         G.FUNCS.use_card({ config = { ref_table = card } })
  --         -- uh. should this be here??
  --         if G.GAME.modifiers.cry_force_edition and not G.GAME.modifiers.cry_force_random_edition then
  --           card:set_edition(nil, true, true)
  --         elseif G.GAME.modifiers.cry_force_random_edition then
  --           local edition = Cryptid.poll_random_edition()
  --           card:set_edition(edition, true, true)
  --         end
  --         card:start_materialize()
  --         return true
  --       end)
  --       tag.triggered = true
  --       return true
  --     end
  --   end,
  -- })

  SMODS.Tag({
    key = "absolute",
    atlas = "mf_tags",
    pos = { x = 2, y = 0 },
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue)
      info_queue[#info_queue + 1] = { set = "Other", key = "cry_absolute" }
      return { vars = {} }
    end,
    config = { type = "store_joker_modify", sticker = "cry_absolute" },
    apply = function(self, tag, context)
      if context.type == "store_joker_modify" then
        local _applied = nil
        if Cryptid.forced_edition() then
          tag:nope()
        end
        if not context.card.temp_edition and context.card.ability.set == "Joker" then
          local lock = tag.ID
          G.CONTROLLER.locks[lock] = true
          context.card.temp_edition = true
          tag:yep("+", G.C.DARK_EDITION, function()
            context.card.cry_absolute = true
            context.card.ability.couponed = true
            context.card:set_cost()
            context.card:juice_up(0.5, 0.5)
            context.card.temp_edition = nil
            G.CONTROLLER.locks[lock] = nil
            return true
          end)
          _applied = true
          tag.triggered = true
        end
      end
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = SMODS.find_mod("entr")[1] }, badges)
    end,
  })


  SMODS.Consumable({
    object_type = "Consumable",
    set = "Shape",
    name = "shape_Cloud",
    key = "cloud",
    pos = { x = 0, y = 1 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 5,
    },
    cost = 4,
    atlas = "mf_shapes",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('timpani')
        local n_card = create_card(nil,G.consumeables, nil, nil, nil, nil, 'j_mf_philosophical', 'sup')
        n_card:add_to_deck()
        n_card:set_edition({negative = true}, true)
        G.jokers:emplace(n_card)
        card:juice_up(0.3, 0.5)
        return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = SMODS.find_mod("entr")[1] }, badges)
    end,
  })

  -- spade goes here

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Shape",
    name = "shape_Omega",
    key = "omega",
    pos = { x = 2, y = 1 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 2,
    },
    cost = 4,
    atlas = "mf_shapes",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      local tag_type = "tag_mf_absolute"
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({
          func = (function()
            add_tag(Tag(tag_type))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
            return true
          end)
        }))
        delay(0.2)
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = SMODS.find_mod("entr")[1] }, badges)
    end,
  })

  -- club goes here

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Shape",
    name = "shape_Rectangle",
    key = "rectangle",
    pos = { x = 0, y = 2 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 1,
    },
    cost = 4,
    atlas = "mf_shapes",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({
          func = (function()
            local _edition = poll_edition('standard_edition'..G.GAME.round_resets.ante, 2, true)
            local _seal = SMODS.poll_seal({mod = 10})
            local n_card = SMODS.create_card {set = (pseudorandom(pseudoseed('stdset'..G.GAME.round_resets.ante)) > 0.4) and "Enhanced" or "Base", edition = _edition, seal = _seal, area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "sta"}
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            n_card.playing_card = G.playing_card
            n_card:add_to_deck()
            G.hand:emplace(n_card)
            card:juice_up(0.3, 0.5)
            table.insert(G.playing_cards, n_card)

            playing_card_joker_effects({n_card})
            play_sound('timpani')

            return true
          end)
        }))
        delay(0.2)
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = SMODS.find_mod("entr")[1] }, badges)
    end,
  })

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Shape",
    name = "shape_Squircle",
    key = "squircle",
    pos = { x = 1, y = 2 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 2,
    },
    cost = 4,
    atlas = "mf_shapes",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      for i = 1, card.ability.val do
      local tag_type = get_next_tag_key()
        G.E_MANAGER:add_event(Event({
          func = (function()
            add_tag(Tag(tag_type))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
            return true
          end)
        }))
        delay(0.2)
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = SMODS.find_mod("entr")[1] }, badges)
    end,
  })

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Shape",
    name = "shape_arrow",
    key = "arrow",
    pos = { x = 2, y = 2 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 5,
    },
    cost = 4,
    atlas = "mf_shapes",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      local tag_type = "tag_entr_solar"
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({
          func = (function()
            add_tag(Tag(tag_type))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
            return true
          end)
        }))
        delay(0.2)
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = SMODS.find_mod("entr")[1] }, badges)
    end,
  })
  
  SMODS.Consumable({
    object_type = "Consumable",
    set = "Shape",
    name = "shape_Circle",
    key = "circle",
    pos = { x = 3, y = 2 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 3,
    },
    cost = 4,
    atlas = "mf_shapes",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      local card_type = "Shape"
      local rng_seed = "circle"
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          play_sound('timpani')
          local n_card = create_card(card_type, G.consumeables, nil, nil, nil, nil, nil, rng_seed)
          n_card:add_to_deck()
          n_card:set_edition({negative = true}, true)
          G.consumeables:emplace(n_card)
          card:juice_up(0.3, 0.5)
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end
  })

  -- heart goes here

  -- diamond goes here

  -- dollar goes here

  -- cog goes here
  
  SMODS.Consumable({
    object_type = "Consumable",
    set = "Shape",
    name = "shape_Star",
    key = "star",
    pos = { x = 0, y = 4 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 2,
    },
    cost = 4,
    atlas = "mf_shapes",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      local card_type = "RPlanet"
      local rng_seed = "star"
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          play_sound('timpani')
          local n_card = create_card(card_type, G.consumeables, nil, nil, nil, nil, nil, rng_seed)
          n_card:add_to_deck()
          n_card:set_edition({negative = true}, true)
          G.consumeables:emplace(n_card)
          card:juice_up(0.3, 0.5)
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end
  })

  -- pentagon goes here

  -- pause goes here
  
  -- curved arrow goes here

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Shape",
    name = "shape_gem",
    key = "gem",
    pos = { x = 0, y = 6 },
    soul_pos = { x = 1, y = 6 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 4,
    },
    cost = 4,
    atlas = "mf_shapes",
    hidden = true,
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          play_sound('timpani')
          local n_card = create_card(nil,G.consumeables, nil, nil, nil, nil, 'c_entr_fervour', 'sup')
          n_card.no_omega = true
          n_card:add_to_deck()
          n_card:set_edition({negative = true}, true)
          G.consumeables:emplace(n_card)
          card:juice_up(0.3, 0.5)
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = SMODS.find_mod("entr")[1] }, badges)
    end,
  })

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Shape",
    name = "shape_house",
    key = "house",
    pos = { x = 0, y = 5 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 4,
    },
    cost = 4,
    atlas = "mf_shapes",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      local tag_type = "tag_entr_ascendant_reference_tag"
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({
          func = (function()
            add_tag(Tag(tag_type))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
            return true
          end)
        }))
        delay(0.2)
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = SMODS.find_mod("entr")[1] }, badges)
    end,
  })

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Shape",
    name = "shape_loss",
    key = "loss",
    pos = { x = 1, y = 5 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 4,
    },
    cost = 4,
    atlas = "mf_shapes",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      local tag_type = "tag_cry_loss"
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({
          func = (function()
            add_tag(Tag(tag_type))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
            return true
          end)
        }))
        delay(0.2)
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = SMODS.find_mod("entr")[1] }, badges)
    end,
  })

  SMODS.Consumable({
    object_type = "Consumable",
    set = "Shape",
    name = "shape_prism",
    key = "prism",
    pos = { x = 2, y = 5 },
    soul_pos = { x = 2, y = 6 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 12,
    },
    cost = 4,
    atlas = "mf_shapes",
    hidden = true,
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          play_sound('timpani')
          local n_card = create_card(nil,G.consumeables, nil, nil, nil, nil, 'c_entr_beyond', 'sup')
          n_card.no_omega = true
          n_card:add_to_deck()
          n_card:set_edition({negative = true}, true)
          G.consumeables:emplace(n_card)
          card:juice_up(0.3, 0.5)
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end,
    set_badges = function (self, card, badges)
      SMODS.create_mod_badges({ mod = SMODS.find_mod("entr")[1] }, badges)
    end,
  })
  
  SMODS.Consumable({
    object_type = "Consumable",
    set = "Shape",
    name = "shape_Brackets",
    key = "brackets",
    pos = { x = 3, y = 5 },
    config = {
      val = 0,
      partial_rounds = 0,
      upgrade_rounds = 4,
    },
    cost = 4,
    atlas = "mf_shapes",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
      return true
    end,
    use = function(self, card, area, copier)
      local card_type = "RCode"
      local rng_seed = "brackets"
      for i = 1, card.ability.val do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          play_sound('timpani')
          local n_card = create_card(card_type, G.consumeables, nil, nil, nil, nil, nil, rng_seed)
          n_card:add_to_deck()
          n_card:set_edition({negative = true}, true)
          G.consumeables:emplace(n_card)
          card:juice_up(0.3, 0.5)
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
      return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
    end
  })

  function colour_end_of_round_effects()
    for i=1, #G.consumeables.cards do
      local _card = G.consumeables.cards[i]
      if Jen then
        local repetitions = Jen.hv('colour', 9) and 3 or 1
        if Jen.hv('colour', 7) and _card.ability.partial_rounds then
          repetitions = repetitions * (_card.ability.partial_rounds + 1)
        end
        if Jen.hv('colour', 8) and _card.ability.upgrade_rounds then
          repetitions = repetitions * math.max(1, _card.ability.upgrade_rounds)
        end
        for rep = 1, repetitions do
         if Jen.hv('colour', 5) and _card.ability.partial_rounds then
          for ii = 1, _card.ability.partial_rounds do
            trigger_colour_end_of_round(_card)
          end
         end
         if Jen.hv('colour', 6) and _card.ability.upgrade_rounds then
          for ii = 1, _card.ability.upgrade_rounds do
            trigger_colour_end_of_round(_card)
          end
         end
         trigger_colour_end_of_round(_card)
        end
      else
       trigger_colour_end_of_round(_card)
      end
    end
  end

  -- Joker Display

  if JokerDisplay then
    local cols = {
      "c_mf_cloud",
      "c_mf_spade",
      "c_mf_omega",
      "c_mf_club",
      "c_mf_rectangle",
      "c_mf_squircle",
      "c_mf_arrow",
      "c_mf_circle",
      "c_mf_heart",
      "c_mf_diamond",
      "c_mf_dollar",
      "c_mf_cog",
      "c_mf_star",
      "c_mf_pentagon",
      "c_mf_pause",
      "c_mf_curvedarrow",
      "c_mf_gem",
      "c_mf_house",
      "c_mf_loss",
      "c_mf_prism",
      "c_mf_brackets",
    }

    for _, col in pairs(cols) do
      if JokerDisplay then
        JokerDisplay.Definitions[col] = {
          text = {
            { ref_table = "card.ability", ref_value = "val", colour = G.C.DARK_EDITION  },
            { text = " (", colour = G.C.UI.TEXT_INACTIVE },
            { ref_table = "card.ability", ref_value = "partial_rounds", colour = G.C.UI.TEXT_INACTIVE },
            { text = "/", colour = G.C.UI.TEXT_INACTIVE },
            { ref_table = "card.ability", ref_value = "upgrade_rounds", colour = G.C.UI.TEXT_INACTIVE },
            { text = ")", colour = G.C.UI.TEXT_INACTIVE },
          }
        }
      end
    end
  end
end

return init
