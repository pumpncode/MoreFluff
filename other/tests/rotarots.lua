local pseudorandom_pick_first = function(orig, _t, ...)
  if seed then math.randomseed(seed) end
  local keys = {}
  for k, v in pairs(_t) do
      keys[#keys+1] = {k = k,v = v}
  end

  if keys[1] and keys[1].v and type(keys[1].v) == 'table' and keys[1].v.sort_id then
    table.sort(keys, function (a, b) return a.v.sort_id < b.v.sort_id end)
  else
    table.sort(keys, function (a, b) return a.k < b.k end)
  end

  local key = keys[1].k
  return _t[key], key 
end

Balatest.TestPlay {
  name = "rotarot_fool_nothingbefore",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_fool"},
  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 0 )
  end
}

Balatest.TestPlay {
  name = "rotarot_fool_copies_colour",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_fool","c_mf_yellow"},
  execute = function()
    Balatest.use(G.consumeables.cards[2])
    Balatest.wait_for_input()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 1 )
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_mf_yellow")
  end
}

Balatest.TestPlay {
  name = "rotarot_fool_copies_rotarot",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_fool","c_mf_rot_hermit"},
  execute = function()
    Balatest.use(G.consumeables.cards[2])
    Balatest.wait_for_input()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 1 )
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_mf_rot_hermit")
  end
}

Balatest.TestPlay {
  name = "rotarot_fool_copies_most_recent",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_fool","c_mf_rot_hermit","c_mf_yellow"},
  execute = function()
    Balatest.use(G.consumeables.cards[2])
    Balatest.wait_for_input()
    Balatest.use(G.consumeables.cards[3])
    Balatest.wait_for_input()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 1 )
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_mf_yellow")
  end
}

Balatest.TestPlay {
  name = "rotarot_magician_one",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_magician"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_yucky") )
  end
}

Balatest.TestPlay {
  name = "rotarot_magician_five",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_magician"},
  execute = function()
    Balatest.highlight { '2S', '3S', '4S', '5S', '6S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S', '3S', '4S', '5S', '6S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_yucky") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[2], "m_mf_yucky") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[3], "m_mf_yucky") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[4], "m_mf_yucky") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[5], "m_mf_yucky") )
  end
}

Balatest.TestPlay {
  name = "yucky_rigged_off",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_magician"},
  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.highlight { '2S', '3S', '4S', '5S', '6C' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '2S', '3S', '4S', '5S', '6C' }
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 5)
  end
}

Balatest.TestPlay {
  name = "yucky_rigged_on",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_magician"},
  execute = function()
    G.GAME.probabilities.normal = 9999
    Balatest.highlight { '2S', '3S', '4S', '5S', '6C' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '2S', '3S', '4S', '5S', '6C' }
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 0)
  end
}

Balatest.TestPlay {
  name = "rotarot_high_priestess",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_high_priestess"},
  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 2 )
    Balatest.assert(G.consumeables.cards[1].ability.set == "Colour")
    Balatest.assert(G.consumeables.cards[2].ability.set == "Colour")
  end
}

Balatest.TestPlay {
  name = "rotarot_high_priestess_one_left",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_high_priestess", "c_death"},
  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 2 )
    Balatest.assert(G.consumeables.cards[1].ability.set ~= "Colour")
    Balatest.assert(G.consumeables.cards[2].ability.set == "Colour")
  end
}

Balatest.TestPlay {
  name = "rotarot_empress_one",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_empress"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_cult") )
  end
}

Balatest.TestPlay {
  name = "rotarot_empress_two",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_empress"},
  execute = function()
    Balatest.highlight { '2S', '3S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S', '3S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_cult") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[2], "m_mf_cult") )
  end
}

Balatest.TestPlay {
  name = "cult_lv_1",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_empress"},
  execute = function()
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '5S' }
  end,
  assert = function()
    Balatest.assert_chips( 20 )
  end
}

Balatest.TestPlay {
  name = "cult_lv_4",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_empress","c_pluto","c_pluto","c_pluto"},
  execute = function()
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.use(G.consumeables.cards[2])
    Balatest.use(G.consumeables.cards[3])
    Balatest.use(G.consumeables.cards[4])
    Balatest.play_hand { '5S' }
  end,
  assert = function()
    Balatest.assert_chips( (35 + 5) * (4 + 4) )
  end
}

Balatest.TestPlay {
  name = "rotarot_emperor",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_emperor"},
  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 2 )
    Balatest.assert(G.consumeables.cards[1].ability.set == "Rotarot")
    Balatest.assert(G.consumeables.cards[2].ability.set == "Rotarot")
  end
}

Balatest.TestPlay {
  name = "rotarot_emperor_one_left",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_emperor", "c_death"},
  execute = function()
    Balatest.use(G.consumeables.cards[1])
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq( #G.consumeables.cards, 2 )
    Balatest.assert(G.consumeables.cards[1].ability.set ~= "Rotarot")
    Balatest.assert(G.consumeables.cards[2].ability.set == "Rotarot")
  end
}

Balatest.TestPlay {
  name = "rotarot_heirophant_one",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_heirophant"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_monus") )
  end
}

Balatest.TestPlay {
  name = "rotarot_heirophant_two",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_heirophant"},
  execute = function()
    Balatest.highlight { '2S', '3S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S', '3S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_monus") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[2], "m_mf_monus") )
  end
}

Balatest.TestPlay {
  name = "monus_lv_1",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_heirophant"},
  execute = function()
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '5S' }
  end,
  assert = function()
    Balatest.assert_chips( 20 )
  end
}

Balatest.TestPlay {
  name = "monus_lv_4",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_heirophant","c_pluto","c_pluto","c_pluto"},
  execute = function()
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.use(G.consumeables.cards[2])
    Balatest.use(G.consumeables.cards[3])
    Balatest.use(G.consumeables.cards[4])
    Balatest.play_hand { '5S' }
  end,
  assert = function()
    Balatest.assert_chips( (35 + 5 + 40) * 4 )
  end
}

Balatest.TestPlay {
  name = "rotarot_lovers_one",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_lovers"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_styled") )
  end
}

Balatest.TestPlay {
  name = "rotarot_lovers_two",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_lovers"},
  execute = function()
    Balatest.highlight { '2S', '3S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S', '3S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_styled") )
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[2], "m_mf_styled") )
  end
}

Balatest.TestPlay {
  name = "styled_seal",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_lovers"},

  deck = { cards = { 
    { r = '2', s = 'S' },
  } },

  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.next_round()
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert( G.hand.cards[1].seal ~= nil )
  end
}

Balatest.TestPlay {
  name = "rotarot_chariot",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_chariot"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2S' }
  end,
  assert = function()
    Balatest.assert( SMODS.has_enhancement(G.hand.highlighted[1], "m_mf_teal") )
  end
}

Balatest.TestPlay {
  name = "chariot_xchips",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_chariot"},
  execute = function()
    Balatest.highlight { '5S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { '5C' }
  end,
  assert = function()
    Balatest.assert_chips( 15 )
  end
}

Balatest.TestPlay {
  name = "rotarot_hermit_zero",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_hermit"},
  dollars = 0,
  execute = function()
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 0 )
  end
}

Balatest.TestPlay {
  name = "rotarot_hermit_five",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_hermit"},
  dollars = 5,
  execute = function()
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 25 )
  end
}

Balatest.TestPlay {
  name = "rotarot_hermit_twenty_four",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_hermit"},
  dollars = 24,
  execute = function()
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 25 )
  end
}

Balatest.TestPlay {
  name = "rotarot_hermit_twenty_five",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_hermit"},
  dollars = 25,
  execute = function()
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 25 )
  end
}

Balatest.TestPlay {
  name = "rotarot_hermit_twenty_six",
  requires = {},
  category = "rotarot",
  consumeables = {"c_mf_rot_hermit"},
  dollars = 26,
  execute = function()
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert_eq( G.GAME.dollars, 50 )
  end
}

Balatest.TestPlay {
  name = "rotarot_wheel_off",
  requires = {},
  category = "rotarot",
  jokers = {"j_joker"},
  consumeables = {"c_mf_rot_wheel"},
  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert( G.jokers.cards[1].edition == nil )
  end
}

Balatest.TestPlay {
  name = "rotarot_wheel_on",
  requires = {},
  category = "rotarot",
  jokers = {"j_joker"},
  consumeables = {"c_mf_rot_wheel"},
  execute = function()
    G.GAME.probabilities.normal = 99999
    Balatest.use(G.consumeables.cards[1])
  end,
  assert = function()
    Balatest.assert( G.jokers.cards[1].edition ~= nil )
  end
}