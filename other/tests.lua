print("loading tests")

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

--#region All I Can't Do
Balatest.TestPlay {
  name = "allicantdo_debuffs_hand",
  requires = {},
  category = "allicantdo",

  jokers = {"j_mf_allicantdo"},
  execute = function()
    Balatest.wait_for_input()
  end,
  assert = function()
    for i = 1,52 do
      Balatest.assert(G.hand.cards[i].debuff)
    end
  end,
}

Balatest.TestPlay {
  name = "allicantdo_one_high_card",
  requires = {},
  category = "allicantdo",

  jokers = {"j_mf_allicantdo"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(5, "round score")
    Balatest.assert_eq(G.jokers.cards[1].ability.extra.x_mult, 1.1, "xmult")
  end,
}

Balatest.TestPlay {
  name = "allicantdo_five_high_cards",
  requires = {},
  category = "allicantdo",

  jokers = {"j_mf_allicantdo"},
  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '6H' }
  end,
  assert = function()
    Balatest.assert_chips(7)
    Balatest.assert_eq(G.jokers.cards[1].ability.extra.x_mult, 1.5, "xmult")
  end,
}

Balatest.TestPlay {
  name = "allicantdo_straight_flush",
  requires = {},
  category = "allicantdo",

  jokers = {"j_mf_allicantdo"},
  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert_chips(1200)
    Balatest.assert_eq(G.jokers.cards[1].ability.extra.x_mult, 1.5, "xmult")
  end,
}

Balatest.TestPlay {
  name = "allicantdo_scaling",
  requires = {},
  category = "allicantdo",

  jokers = {"j_mf_allicantdo"},
  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '6H' }
    Balatest.play_hand { 'AC', '2C', '3C', '4C', '5C' }
  end,
  assert = function()
    Balatest.assert_chips(1607)
    Balatest.assert_eq(G.jokers.cards[1].ability.extra.x_mult, 2, "xmult")
  end,
}

--#region Bad Legal Defence

Balatest.TestPlay {
  name = "badlegaldefence_smallblind",
  requires = {},
  category = "badlegaldefence",

  jokers = {"j_mf_badlegaldefence"},
  execute = function() -- automatically enters blind
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 0, "should have no consumeable")
  end,
}

Balatest.TestPlay {
  name = "badlegaldefence_bossblind",
  requires = {},
  category = "badlegaldefence",

  jokers = {"j_mf_badlegaldefence"},
  blind = "bl_wheel",
  execute = function() -- automatically enters blind
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1, "should have a consumeable")
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_death", "should have a death")
  end,
}

Balatest.TestPlay {
  name = "badlegaldefence_no_overflow",
  requires = {},
  category = "badlegaldefence",

  jokers = {"j_mf_badlegaldefence"},
  consumeables = {"c_hermit", "c_hermit"},
  blind = "bl_wheel",
  execute = function() -- automatically enters blind
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2, "should have two consumeables")
    Balatest.assert(G.consumeables.cards[1].config.center.key ~= "c_death", "should not have a death")
    Balatest.assert(G.consumeables.cards[2].config.center.key ~= "c_death", "should not have a death")
  end,
}

--#region Basepaul Card

Balatest.TestPlay {
  name = "basepaul_not_paul",
  requires = {},
  category = "basepaulcard",

  jokers = {"j_mf_basepaul_card"},
  execute = function()
    G.PROFILES[G.SETTINGS.profile].name = "chicken jockey"

    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert_chips(1250)
  end,
}

Balatest.TestPlay {
  name = "basepaul_paul",
  requires = {},
  category = "basepaulcard",

  jokers = {"j_mf_basepaul_card"},
  execute = function()
    G.PROFILES[G.SETTINGS.profile].name = "paul"

    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert_chips(12500)
  end,
}

Balatest.TestPlay {
  name = "basepaul_long_name",
  requires = {},
  category = "basepaulcard",

  jokers = {"j_mf_basepaul_card"},
  execute = function()
    G.PROFILES[G.SETTINGS.profile].name = "I am Paul"

    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert_chips(12500)
  end,
}

--#region Blade Dance

Balatest.TestPlay {
  name = "bladedance_functionality",
  requires = {},
  category = "bladedance",

  jokers = {"j_mf_bladedance"},

  no_auto_start = true, -- so we can hook before it begins
  hand_size = 54,
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.start_round()

    Balatest.play_hand { '2S', '3S', '4S', '5S', '6S' }
  end,
  assert = function()
    Balatest.assert_chips(120 * 8 * 1.5 * 1.5)
    Balatest.assert_eq(#G.deck.cards, 52, "should have 52 cards in deck when finished")
  end,
}


--#region Blahaj

Balatest.TestPlay {
  name = "blahaj_swaps_chips_and_mult",
  requires = {},
  category = "blahaj",

  jokers = {"j_joker", "j_mf_blahaj", "j_joker", },
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips((16 + 4) * (1 + 4))
  end,
}

--#region Blasphemy

Balatest.TestPlay {
  name = "blasphemy_functionality",
  requires = {},
  category = "blasphemy",

  jokers = {"j_mf_blasphemy"},
  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert_chips(125 * 8 * 4)
    Balatest.assert_eq(G.GAME.current_round.hands_left, 0, "should have no hands left")
  end,
}

--#region Blood Pact

Balatest.TestPlay {
  name = "bloodpact_one_heart",
  requires = {},
  category = "bloodpact",

  jokers = {"j_mf_bloodpact"},
  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 5)
    Balatest.assert_eq(#G.jokers.cards, 1, "should not have died")
  end,
}

Balatest.TestPlay {
  name = "bloodpact_hearts_flush",
  requires = {},
  category = "bloodpact",

  jokers = {"j_mf_bloodpact"},
  execute = function()
    Balatest.play_hand { 'AH', "3H", "5H", "7H", "9H" }
  end,
  assert = function()
    Balatest.assert_chips(70 * 4 * 5)
    Balatest.assert_eq(#G.jokers.cards, 1, "should not have died")
  end,
}

Balatest.TestPlay {
  name = "bloodpact_one_spade",
  requires = {},
  category = "bloodpact",

  jokers = {"j_mf_bloodpact"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16)
    Balatest.assert_eq(#G.jokers.cards, 0, "should have died")
  end,
}

Balatest.TestPlay {
  name = "bloodpact_one_club",
  requires = {},
  category = "bloodpact",

  jokers = {"j_mf_bloodpact"},
  execute = function()
    Balatest.play_hand { 'AC' }
  end,
  assert = function()
    Balatest.assert_chips(16)
    Balatest.assert_eq(#G.jokers.cards, 0, "should have died")
  end,
}

Balatest.TestPlay {
  name = "bloodpact_one_diamond",
  requires = {},
  category = "bloodpact",

  jokers = {"j_mf_bloodpact"},
  execute = function()
    Balatest.play_hand { 'AD' }
  end,
  assert = function()
    Balatest.assert_chips(16)
    Balatest.assert_eq(#G.jokers.cards, 0, "should have died")
  end,
}

Balatest.TestPlay {
  name = "bloodpact_sneaky_spade",
  requires = {},
  category = "bloodpact",

  jokers = {"j_mf_bloodpact"},
  execute = function()
    Balatest.play_hand { 'AH', 'TS' }
  end,
  assert = function()
    Balatest.assert_chips(16)
    Balatest.assert_eq(#G.jokers.cards, 0, "should have died")
  end,
}

--#region Blunder

Balatest.TestPlay {
  name = "blunder_autoselect",
  requires = {},
  category = "blunder",

  jokers = {"j_mf_blunder"},

  no_auto_start = true, -- so we can hook before it begins
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.start_round()
  end,
  assert = function()
    Balatest.assert_eq(#G.hand.highlighted, 1, "should have selected")
  end,
}

Balatest.TestPlay {
  name = "blunder_xmult",
  requires = {},
  category = "blunder",

  jokers = {"j_mf_blunder"},

  no_auto_start = true, -- so we can hook before it begins
  execute = function()
    Balatest.hook(_G, 'pseudorandom_element', pseudorandom_pick_first)

    Balatest.start_round()

    Balatest.play_hand({})
  end,
  assert = function()
    Balatest.assert_chips(7 * 3)
  end,
}

--#region Book Move

Balatest.TestPlay {
  name = "bookmove_no_rounds",
  requires = {},
  category = "bookmove",

  jokers = {"j_mf_bookmove"},

  deck = { cards = { 
    { r = 'A', s = 'S' }
  } }, -- for brevity

  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 0)
  end,
}

Balatest.TestPlay {
  name = "bookmove_two_rounds",
  requires = {},
  category = "bookmove",

  jokers = {"j_mf_bookmove"},

  deck = { cards = { 
    { r = 'A', s = 'S' }
  } }, -- for brevity

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 0)
  end,
}

Balatest.TestPlay {
  name = "bookmove_three_rounds",
  requires = {},
  category = "bookmove",

  jokers = {"j_mf_bookmove"},

  deck = { cards = { 
    { r = 'A', s = 'S' }
  } }, -- for brevity

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 2)
  end,
}

Balatest.TestPlay {
  name = "bookmove_no_overflow",
  requires = {},
  category = "bookmove",

  jokers = {"j_mf_bookmove","j_joker","j_joker","j_joker","j_joker"},

  deck = { cards = { 
    { r = 'A', s = 'S' }
  } }, -- for brevity

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 5)
  end,
}

Balatest.TestPlay {
  name = "bookmove_fills_five",
  requires = {},
  category = "bookmove",

  jokers = {"j_mf_bookmove","j_joker","j_joker","j_joker"},

  deck = { cards = { 
    { r = 'A', s = 'S' }
  } }, -- for brevity

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 5)
  end,
}

--#region Bowling Ball

Balatest.TestPlay {
  name = "bowlingball_three_high",
  requires = {},
  category = "bowlingball",

  jokers = {"j_mf_bowlingball"},

  execute = function()
    Balatest.play_hand { '3S' }
  end,
  assert = function()
    Balatest.assert_chips((60 + 5 + 3) * (11))
  end,
}

Balatest.TestPlay {
  name = "bowlingball_four_threes",
  requires = {},
  category = "bowlingball",

  jokers = {"j_mf_bowlingball"},

  execute = function()
    Balatest.play_hand { '3S', '3H', '3C', '3D' }
  end,
  assert = function()
    Balatest.assert_chips((60 * 4 + 3 * 4 + 60) * (10 * 4 + 7))
  end,
}

--#region Brass Joker

Balatest.TestPlay {
  name = "brassjoker_no_destroyed",
  requires = {},
  category = "brassjoker",

  jokers = {"j_mf_brass", "j_joker"},

  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 5)
  end,
}

Balatest.TestPlay {
  name = "brassjoker_four_brass_none_destroyed",
  requires = {},
  category = "brassjoker",

  jokers = {"j_mf_brass", "j_joker"},
  consumeables = {"c_mf_rot_justice", "c_mf_rot_justice", "c_mf_rot_justice", "c_mf_rot_justice"},

  blind = "bl_big", -- for chip req.

  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2C' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.highlight { '3S' }
    Balatest.use(G.consumeables.cards[3])
    Balatest.highlight { '3C' }
    Balatest.use(G.consumeables.cards[4])
    Balatest.play_hand { '2S', '2C', '3S', '3C' } -- (20 + 2*6 + 3*6) * 6
    Balatest.play_hand { 'AS' } -- (16) * 5
  end,
  assert = function()
    Balatest.assert_chips((20 + 2*6 + 3*6 ) * 6 + 16 * 5)
  end,
}

Balatest.TestPlay {
  name = "brassjoker_four_brass_all_destroyed",
  requires = {},
  category = "brassjoker",

  jokers = {"j_mf_brass", "j_joker"},
  consumeables = {"c_mf_rot_justice", "c_mf_rot_justice", "c_mf_rot_justice", "c_mf_rot_justice"},
  
  blind = "bl_big", -- for chip req.

  execute = function()
    G.GAME.probabilities.normal = 99
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2C' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.highlight { '3S' }
    Balatest.use(G.consumeables.cards[3])
    Balatest.highlight { '3C' }
    Balatest.use(G.consumeables.cards[4])
    Balatest.play_hand { '2S', '2C', '3S', '3C' } -- (20 + 2*6 + 3*6) * 6
    Balatest.play_hand { 'AS' } -- (16) * 13
  end,
  assert = function()
    Balatest.assert_chips((20 + 2*6 + 3*6) * 6 + 16 * 13)
  end,
}

--#region Brilliant

Balatest.TestPlay {
  name = "brilliant_one_hand",
  requires = {},
  category = "brilliant",

  jokers = {"j_mf_brilliant"},

  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert(#G.consumeables.cards, 1, "should have made a consumeable")
  end,
}

Balatest.TestPlay {
  name = "brilliant_two_hands",
  requires = {},
  category = "brilliant",

  jokers = {"j_mf_brilliant"},

  execute = function()
    Balatest.play_hand { 'AH' }
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert(#G.consumeables.cards, 0, "should not have made a consumeable")
  end,
}

--#region Broom Closet

Balatest.TestPlay {
  name = "broomcloset_default",
  requires = {},
  category = "broomcloset",

  jokers = {"j_mf_broomcloset"},

  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 4)
  end,
}

Balatest.TestPlay {
  name = "broomcloset_purchase",
  requires = {},
  category = "broomcloset",

  jokers = {"j_mf_broomcloset"},

  deck = { cards = { 
    { r = 'A', s = 'H' }
  } }, -- for brevity

  dollars = 99999,

  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.buy(function() return G.shop_jokers.cards[1] end)
    Balatest.exit_shop()
    Balatest.start_round()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16)
  end,
}

Balatest.TestPlay {
  name = "broomcloset_purchase_reset",
  requires = {},
  category = "broomcloset",

  jokers = {"j_mf_broomcloset"},

  deck = { cards = { 
    { r = 'A', s = 'H' }
  } }, -- for brevity

  dollars = 99999,

  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.buy(function() return G.shop_jokers.cards[1] end)
    Balatest.exit_shop()
    Balatest.start_round()
    Balatest.next_round()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 4)
  end,
}

--#region Card Buffer Advanced

Balatest.TestPlay {
  name = "cba_no_others",
  requires = {},
  category = "cba",

  jokers = {"j_mf_cba"},

  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16)
  end,
}

Balatest.TestPlay {
  name = "cba_no_editions",
  requires = {},
  category = "cba",

  jokers = {"j_mf_cba", "j_joker"},

  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 5)
  end,
}

Balatest.TestPlay {
  name = "cba_edition_right",
  requires = {},
  category = "cba",

  jokers = {"j_mf_cba", { id = 'j_joker', edition = 'foil' }},

  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips((16 + 50) * (1 + 4 * 2))
  end,
}

Balatest.TestPlay {
  name = "cba_edition_left",
  requires = {},
  category = "cba",

  jokers = {{ id = 'j_joker', edition = 'foil' }, "j_mf_cba"},

  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips((16 + 50) * (1 + 4 * 2))
  end,
}

Balatest.TestPlay {
  name = "cba_two_editions",
  requires = {},
  category = "cba",

  jokers = {{ id = 'j_joker', edition = 'foil' }, "j_mf_cba", { id = 'j_mf_jester', edition = 'foil' }},

  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips((16 + 50 + 50 + 40) * (1 + 4 * 2))
  end,
}

--#region Clipart Joker

Balatest.TestPlay {
  name = "clipart_creates",
  requires = {},
  category = "clipart",

  jokers = {"j_mf_clipart"},

  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1, "created one")
  end,
}

--#region Clownfish

Balatest.TestPlay {
  name = "clownfish_unenhanced",
  requires = {},
  category = "clownfish",

  jokers = {"j_mf_clownfish"},

  execute = function()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(16)
  end,
}

Balatest.TestPlay {
  name = "clownfish_one_enhanced",
  requires = {},
  category = "clownfish",

  jokers = {"j_mf_clownfish"},
  consumeables = {"c_chariot"},

  execute = function()
    Balatest.highlight { "AH" }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips((5 + 15 + 11) * 5)
  end,
}

Balatest.TestPlay {
  name = "clownfish_five_enhanced",
  requires = {},
  category = "clownfish",

  jokers = {"j_mf_clownfish"},
  consumeables = {"c_chariot","c_chariot","c_chariot","c_chariot","c_chariot"},

  execute = function()
    Balatest.highlight { "AH" }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { "2H" }
    Balatest.use(G.consumeables.cards[2])
    Balatest.highlight { "3H" }
    Balatest.use(G.consumeables.cards[3])
    Balatest.highlight { "4H" }
    Balatest.use(G.consumeables.cards[4])
    Balatest.highlight { "5H" }
    Balatest.use(G.consumeables.cards[5])
    Balatest.play_hand { "AH", "2H", "3H", "4H", "5H" }
  end,
  assert = function()
    Balatest.assert_chips((100 + 11 + 2 + 3 + 4 + 5 + 15*5) * (8 + 4*5))
  end,
}

--#region Complexity Creep

-- later. dear god.

--#region Coupon Catalogue

Balatest.TestPlay {
  name = "couponcatalogue_no_vouchers",
  requires = {},
  category = "couponcatalogue",

  jokers = {"j_mf_coupon_catalogue"},

  execute = function()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(16)
  end,
}

Balatest.TestPlay {
  name = "couponcatalogue_one_voucher",
  requires = {},
  category = "couponcatalogue",

  jokers = {"j_mf_coupon_catalogue"},

  deck = { cards = { 
    { r = 'A', s = 'H' }
  } }, -- for brevity

  dollars = 99999,

  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.use_card { config = { ref_table = G.shop_vouchers.cards[1] } } end)
    Balatest.wait_for_input()
    Balatest.exit_shop()
    Balatest.start_round()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(16 * (1 + 15))
  end,
}

Balatest.TestPlay {
  name = "couponcatalogue_three_vouchers",
  requires = {},
  category = "couponcatalogue",

  jokers = {"j_mf_coupon_catalogue"},

  deck = { cards = { 
    { r = 'A', s = 'H' }
  } }, -- for brevity

  dollars = 99999,

  no_auto_start = true,

  execute = function()
    Balatest.skip_blind("tag_voucher")
    Balatest.skip_blind("tag_voucher")
    Balatest.start_round()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.use_card { config = { ref_table = G.shop_vouchers.cards[1] } } end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.use_card { config = { ref_table = G.shop_vouchers.cards[1] } } end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.use_card { config = { ref_table = G.shop_vouchers.cards[1] } } end)
    Balatest.wait_for_input()
    Balatest.exit_shop()
    Balatest.start_round()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(16 * (1 + 15 * 3))
  end,
}

--#region CSS

Balatest.TestPlay {
  name = "css_high_card",
  requires = {},
  category = "css",

  jokers = {"j_mf_css"},

  execute = function()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 0, "should not have made one")
  end,
}
Balatest.TestPlay {
  name = "css_flush",
  requires = {},
  category = "css",

  jokers = {"j_mf_css"},

  execute = function()
    Balatest.play_hand { "2H", "3H", "4H", "5H", "7H" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1, "should have made one")
  end,
}
Balatest.TestPlay {
  name = "css_no_overflow",
  requires = {},
  category = "css",

  jokers = {"j_mf_css"},
  consumeables = {"c_hermit", "c_hermit"},

  execute = function()
    Balatest.play_hand { "2H", "3H", "4H", "5H", "7H" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2, "should have not made one")
  end,
}

--#region Cue Ball

Balatest.TestPlay {
  name = "cueball_ranked_card",
  requires = {},
  category = "cueball",

  jokers = {"j_mf_cueball"},

  execute = function()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 0, "should not have made one")
  end,
}

Balatest.TestPlay {
  name = "cueball_stone_rigged_off",
  requires = {},
  category = "cueball",

  jokers = {"j_mf_cueball"},
  consumeables = {"c_tower"},

  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.highlight { "AH" }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 0, "should not have made one")
  end,
}

Balatest.TestPlay {
  name = "cueball_stone_rigged_on",
  requires = {},
  category = "cueball",

  jokers = {"j_mf_cueball"},
  consumeables = {"c_tower"},

  execute = function()
    G.GAME.probabilities.normal = 999
    Balatest.highlight { "AH" }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1, "should have made one")
  end,
}

Balatest.TestPlay {
  name = "cueball_two_stones_rigged_on",
  requires = {},
  category = "cueball",

  jokers = {"j_mf_cueball"},
  consumeables = {"c_tower", "c_tower"},

  execute = function()
    G.GAME.probabilities.normal = 999
    Balatest.highlight { "AH" }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { "AS" }
    Balatest.use(G.consumeables.cards[2])
    Balatest.play_hand { "AH", "AS" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2, "should have made two")
  end,
}

--#region Dramatic Entrance

Balatest.TestPlay {
  name = "dramatic_entrance_first_hand",
  requires = {},
  category = "dramaticentrance",

  jokers = {"j_mf_dramaticentrance"},

  execute = function()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(166)
  end,
}

Balatest.TestPlay {
  name = "dramatic_entrance_second_hand",
  requires = {},
  category = "dramaticentrance",

  jokers = {"j_mf_dramaticentrance"},

  execute = function()
    Balatest.play_hand { "AH" }
    Balatest.play_hand { "5S", "5C" }
  end,
  assert = function()
    Balatest.assert_chips(166 + 20 * 2)
  end,
}

--#region Dropkick

Balatest.TestPlay {
  name = "dropkick_non_straight",
  requires = {},
  category = "dropkick",

  jokers = {"j_mf_dropkick"},

  hands = 2,

  execute = function()
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.current_round.hands_left, 1)
  end,
}

Balatest.TestPlay {
  name = "dropkick_straight",
  requires = {},
  category = "dropkick",

  jokers = {"j_mf_dropkick"},

  hands = 1,

  execute = function()
    Balatest.play_hand { "AH", "2S", "3S", "4S", "5S" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.current_round.hands_left, 1)
  end,
}

Balatest.TestPlay {
  name = "dropkick_several_straights",
  requires = {},
  category = "dropkick",

  jokers = {"j_mf_dropkick"},

  hands = 1,

  blind = "bl_wall",

  execute = function()
    Balatest.play_hand { "AH", "2S", "3S", "4S", "5S" }
    Balatest.play_hand { "AS", "2C", "3C", "4C", "5C" }
    Balatest.play_hand { "AC", "2D", "3D", "4D", "5D" }
    Balatest.play_hand { "AD", "2H", "3H", "4H", "5H" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.current_round.hands_left, 1)
  end,
}

--#region Expansion Pack

Balatest.TestPlay {
  name = "expansionpack_creates",
  requires = {},
  category = "expansionpack",

  jokers = {"j_mf_expansion_pack"},

  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 2)
  end,
}

Balatest.TestPlay {
  name = "expansionpack_needs_room",
  requires = {},
  category = "expansionpack",

  jokers = {"j_mf_expansion_pack", "j_joker","j_joker","j_joker","j_joker"},

  execute = function()
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 5)
  end,
}

-- #region Joke Merge Valley

Balatest.TestPlay {
  name = "farmmerge_junk",
  requires = {},
  category = "farmmerge",

  jokers = {"j_mf_farmmerge"},

  execute = function()
    Balatest.discard{"AS", "2S", "3S", "4S", "5S"}
    Balatest.discard{"AC", "2C", "3C"}
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 8)
    Balatest.assert_eq(G.discard.cards[1].added_to_deck)
    Balatest.assert_eq(G.discard.cards[2].added_to_deck)
    Balatest.assert_eq(G.discard.cards[3].added_to_deck)
    Balatest.assert_eq(G.discard.cards[4].added_to_deck)
    Balatest.assert_eq(G.discard.cards[5].added_to_deck)
    Balatest.assert_eq(G.discard.cards[6].added_to_deck)
    Balatest.assert_eq(G.discard.cards[7].added_to_deck)
    Balatest.assert_eq(G.discard.cards[8].added_to_deck)
  end,
}

Balatest.TestPlay {
  name = "farmmerge_merges",
  requires = {},
  category = "farmmerge",

  jokers = {"j_mf_farmmerge"},

  execute = function()
    Balatest.discard{"AS", "AC", "AH"}
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 3)
    Balatest.assert_eq(not G.discard.cards[1].added_to_deck)
    Balatest.assert_eq(not G.discard.cards[2].added_to_deck)
    Balatest.assert_eq(G.discard.cards[3].ability.perma_bonus, 22)
    Balatest.assert(G.discard.cards[3]:is_suit("Hearts"))
  end,
}

Balatest.TestPlay {
  name = "farmmerge_merges_modifications",
  requires = {},
  category = "farmmerge",

  jokers = {"j_mf_farmmerge"},
  consumeables = {"c_chariot", "c_trance", "c_aura"},

  execute = function()
    Balatest.highlight{"AS"}
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight{"AC"}
    Balatest.use(G.consumeables.cards[2])

    Balatest.hook(_G, 'poll_edition', function(old, ...)
      return "e_foil"
    end)

    Balatest.highlight{"AH"}
    Balatest.use(G.consumeables.cards[3])
    Balatest.unhighlight_all()
    Balatest.discard{"AS", "AC", "AH"}
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 3)
    Balatest.assert_eq(not G.discard.cards[1].added_to_deck)
    Balatest.assert_eq(not G.discard.cards[2].added_to_deck)
    Balatest.assert_eq(G.discard.cards[3].ability.perma_bonus, 22)
    Balatest.assert(G.discard.cards[3]:is_suit("Hearts"))
    Balatest.assert(G.discard.cards[3].edition.foil)
    Balatest.assert(G.discard.cards[3].seal == "Blue")
    Balatest.assert(G.discard.cards[3].config.center.key == "m_steel")
  end,
}

Balatest.TestPlay {
  name = "farmmerge_merges_priority",
  requires = {},
  category = "farmmerge",

  jokers = {"j_mf_farmmerge"},
  consumeables = {"c_chariot", "c_justice", "c_trance", "c_talisman", "c_aura", "c_aura"},

  execute = function()
    Balatest.highlight{"AS"}
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight{"AC"}
    Balatest.use(G.consumeables.cards[2])
    Balatest.highlight{"AC"}
    Balatest.use(G.consumeables.cards[3])
    Balatest.highlight{"AH"}
    Balatest.use(G.consumeables.cards[4])

    Balatest.hook(_G, 'poll_edition', function(old, ...)
      return "e_foil"
    end)

    Balatest.highlight{"AS"}
    Balatest.use(G.consumeables.cards[5])
    Balatest.unhighlight_all()

    Balatest.hook(_G, 'poll_edition', function(old, ...)
      return "e_holo"
    end)
    Balatest.highlight{"AH"}
    Balatest.use(G.consumeables.cards[6])
    Balatest.unhighlight_all()

    Balatest.discard{"AS", "AC", "AH"}
  end,
  assert = function()
    Balatest.assert_eq(#G.discard.cards, 3)
    Balatest.assert_eq(not G.discard.cards[1].added_to_deck)
    Balatest.assert_eq(not G.discard.cards[2].added_to_deck)
    Balatest.assert_eq(G.discard.cards[3].ability.perma_bonus, 22)
    Balatest.assert(G.discard.cards[3]:is_suit("Hearts"))
    Balatest.assert(G.discard.cards[3].edition.holo)
    Balatest.assert(G.discard.cards[3].seal == "Gold")
    Balatest.assert(G.discard.cards[3].config.center.key == "m_glass")
  end,
}

-- #region Flesh Prison

Balatest.TestPlay {
  name = "fleshprison_smallblind",
  requires = {},
  category = "fleshprison",

  jokers = {"j_mf_fleshprison"},

  execute = function()
    Balatest.play_hand { "AS", "KS", "QS", "JS", "TS" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 0)
    Balatest.assert_eq(#G.jokers.cards, 1)
  end
}

Balatest.TestPlay {
  name = "fleshprison_bossblind",
  requires = {},
  category = "fleshprison",

  jokers = {"j_mf_fleshprison"},

  blind = "bl_psychic",

  execute = function()
    Balatest.play_hand { "AS", "KS", "QS", "JS", "TS" }
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1)
    Balatest.assert_(G.consumeables.cards[1].config.center.key == "c_soul")
    Balatest.assert_eq(#G.jokers.cards, 0)
  end
}

-- #region Flint and Steel

Balatest.TestPlay {
  name = "flintandsteel_no_trigger",
  requires = {},
  category = "flintandsteel",

  jokers = {"j_mf_flintandsteel"},

  execute = function()
    Balatest.play_hand { "AS" }
    Balatest.play_hand { "AH" }
  end,
  assert = function()
    Balatest.assert_chips(16 * 2)
  end
}

Balatest.TestPlay {
  name = "flintandsteel_one_trigger",
  requires = {},
  category = "flintandsteel",

  jokers = {"j_mf_flintandsteel"},
  consumeables = {"c_tower", "c_chariot"},

  blind = "bl_wall",

  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2C' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.play_hand { "2S", "2C" }
  end,
  assert = function()
    Balatest.assert_chips((15 + 2 + 50) * 2)
  end
}

Balatest.TestPlay {
  name = "flintandsteel_mixed_trigger",
  requires = {},
  category = "flintandsteel",

  jokers = {"j_mf_flintandsteel"},
  consumeables = {"c_tower", "c_chariot"},

  blind = "bl_wall",

  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2C' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.play_hand { "2S", "2C", "2H", "3S", "3C" }
  end,
  assert = function()
    Balatest.assert_chips((40 + 2 + 2 + 50 + 3 + 3) * 3)
  end
}

-- #region Gemstone Joker

Balatest.TestPlay {
  name = "gemstone_no_gemstones",
  requires = {},
  category = "gemstonejoker",
  dollars = 0,
  jokers = {"j_mf_gemstonejoker"},
  execute = function()
    Balatest.play_hand { "AS", "KS", "QS", "JS", "TS" }
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 0)
  end
}

Balatest.TestPlay {
  name = "gemstone_four_gemstones",
  requires = {},
  category = "gemstonejoker",
  dollars = 0,
  jokers = {"j_mf_gemstonejoker"},
  consumeables = {"c_mf_rot_tower","c_mf_rot_tower","c_mf_rot_tower","c_mf_rot_tower"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { '2C' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.highlight { '2H' }
    Balatest.use(G.consumeables.cards[3])
    Balatest.highlight { '2D' }
    Balatest.use(G.consumeables.cards[4])
    Balatest.play_hand { "AS", "KS", "QS", "JS", "TS" }
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 4)
  end
}

--#region Globe

Balatest.TestPlay {
  name = "globe_one_reroll",
  requires = {},
  category = "globe",
  dollars = 99999,
  jokers = {"j_mf_globe"},
  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 1)
  end
}

Balatest.TestPlay {
  name = "globe_three_rerolls",
  requires = {},
  category = "globe",
  dollars = 99999,
  jokers = {"j_mf_globe"},
  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2)
  end
}

Balatest.TestPlay {
  name = "globe_no_overflow", -- crustulum experience...
  requires = {},
  category = "globe",
  dollars = 99999,
  jokers = {"j_mf_globe"},
  consumeables = {"c_soul","c_soul",},
  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
    Balatest.q(function() G.FUNCS.reroll_shop() end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2)
    Balatest.assert(G.consumeables.cards[1].ability.set ~= "Planet", "should not have a planet")
    Balatest.assert(G.consumeables.cards[1].ability.set ~= "Tarot", "should not have a tarot")
    Balatest.assert(G.consumeables.cards[2].ability.set ~= "Planet", "should not have a planet")
    Balatest.assert(G.consumeables.cards[2].ability.set ~= "Tarot", "should not have a tarot")
  end
}

-- #region Golden Carrot

Balatest.TestPlay {
  name = "golden_carrot_one_hand",
  requires = {},
  category = "goldencarrot",
  dollars = 0,
  jokers = {"j_mf_goldencarrot"},
  execute = function()
    Balatest.play_hand { "AS", "KS", "QS", "JS", "TS" }
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 9)
  end
}

Balatest.TestPlay {
  name = "golden_carrot_five_hands",
  requires = {},
  category = "goldencarrot",
  dollars = 0,
  jokers = {"j_mf_goldencarrot"},
  execute = function()
    Balatest.play_hand { "2S" }
    Balatest.play_hand { "2C" }
    Balatest.play_hand { "2H" }
    Balatest.play_hand { "2D" }
    Balatest.play_hand { "AS", "KS", "QS", "JS", "TS" }
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 5)
  end
}

Balatest.TestPlay {
  name = "golden_carrot_eaten",
  requires = {},
  category = "goldencarrot",
  dollars = 0,
  jokers = {"j_mf_goldencarrot"},
  execute = function()
    Balatest.play_hand { "2S" }
    Balatest.play_hand { "2C" }
    Balatest.play_hand { "2H" }
    Balatest.play_hand { "2D" }
    Balatest.play_hand { "3S" }
    Balatest.play_hand { "3C" }
    Balatest.play_hand { "3H" }
    Balatest.play_hand { "3D" }
    Balatest.play_hand { "4S" }
    Balatest.play_hand { "4C" }
  end,
  assert = function()
    Balatest.assert_eq(#G.jokers.cards, 0)
  end
}

-- #region Hall of Mirrors

Balatest.TestPlay {
  name = "hall_of_mirrors_one_six",
  requires = {},
  category = "hallofmirrors",
  jokers = {"j_mf_hallofmirrors"},
  execute = function()
    Balatest.play_hand { "6S" }
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 52 + 3)
  end
}

Balatest.TestPlay {
  name = "hall_of_mirrors_four_sixes",
  requires = {},
  category = "hallofmirrors",
  jokers = {"j_mf_hallofmirrors"},
  execute = function()
    Balatest.play_hand { "6S" }
    Balatest.play_hand { "6H" }
    Balatest.play_hand { "6C" }
    Balatest.play_hand { "6D" }
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 52 + 3 * 4)
  end
}

Balatest.TestPlay {
  name = "hall_of_mirrors_reset",
  requires = {},
  category = "hallofmirrors",
  jokers = {"j_mf_hallofmirrors"},
  execute = function()
    Balatest.play_hand { "6S" }
    Balatest.play_hand { "6H" }
    Balatest.play_hand { "6C" }
    Balatest.play_hand { "6D" }
    Balatest.next_round()
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 52)
  end
}

-- #region Hollow Joker

Balatest.TestPlay {
  name = "hollow_joker_eight_hand_size",
  requires = {},
  category = "hollow",
  jokers = {"j_mf_hollow"},

  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' }
  } },

  hand_size = 8,
  execute = function()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 7)
    Balatest.assert_chips(16 * (1 + 10 * (9 - 7)))
  end
}

Balatest.TestPlay {
  name = "hollow_joker_two_hand_size",
  requires = {},
  category = "hollow",
  jokers = {"j_mf_hollow"},

  deck = { cards = { 
    { r = 'A', s = 'S' },
  } },

  hand_size = 2,
  execute = function()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 1)
    Balatest.assert_chips(16 * (1 + 10 * (9 - 1)))
  end
}

-- #region Huge Joker

Balatest.TestPlay {
  name = "huge_joker_functionality",
  requires = {},
  category = "hugejoker",
  jokers = {"j_mf_hugejoker"},

  execute = function()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_eq(G.hand.config.card_limit, 50)
    Balatest.assert_chips(16 * 3)
  end
}

-- #region Hyper Beam

Balatest.TestPlay {
  name = "hyper_beam_functionality",
  requires = {},
  category = "hyperbeam",
  jokers = {"j_mf_hyperbeam"},

  execute = function()
    Balatest.play_hand { "AS" }
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.current_round.discards_left, 0)
    Balatest.assert_chips(16 * 3)
  end
}

-- #region Hyperjimbo

Balatest.TestPlay {
  name = "hyperjimbo_five_cards",
  requires = {},
  category = "hyperjimbo",

  jokers = {"j_mf_hyperjimbo"},
  execute = function()
    Balatest.play_hand { 'AS', '2S', '3S', '4S', '5S' }
  end,
  assert = function()
    Balatest.assert_chips(1000)
  end,
}

Balatest.TestPlay {
  name = "hyperjimbo_two_pair",
  requires = {},
  category = "hyperjimbo",

  jokers = {"j_mf_hyperjimbo"},
  execute = function()
    Balatest.play_hand { '2C', '2S', '3S', '3C' }
  end,
  assert = function()
    Balatest.assert_chips(78)
  end,
}

Balatest.TestPlay {
  name = "hyperjimbo_four_of_a_kind",
  requires = {},
  category = "hyperjimbo",

  jokers = {"j_mf_hyperjimbo"},
  execute = function()
    Balatest.play_hand { '2C', '2S', '2H', '2D' }
  end,
  assert = function()
    Balatest.assert_chips(926)
  end,
}

-- #region Impostor

Balatest.TestPlay {
  name = "impostor_no_reds",
  requires = {},
  category = "impostor",

  jokers = {"j_mf_impostor"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips(16)
  end,
}

Balatest.TestPlay {
  name = "impostor_one_red",
  requires = {},
  category = "impostor",

  jokers = {"j_mf_impostor"},
  execute = function()
    Balatest.play_hand { 'AH' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 3)
  end,
}

Balatest.TestPlay {
  name = "impostor_two_red",
  requires = {},
  category = "impostor",

  jokers = {"j_mf_impostor"},
  execute = function()
    Balatest.play_hand { 'AH', 'AD' }
  end,
  assert = function()
    Balatest.assert_chips((10 + 11 + 11) * 2)
  end,
}

Balatest.TestPlay {
  name = "impostor_sneaky_red",
  requires = {},
  category = "impostor",

  jokers = {"j_mf_impostor"},
  execute = function()
    Balatest.play_hand { 'AS', '10H' }
  end,
  assert = function()
    Balatest.assert_chips(16 * 3)
  end,
}

Balatest.TestPlay {
  name = "impostor_sneaky_two_red",
  requires = {},
  category = "impostor",

  jokers = {"j_mf_impostor"},
  execute = function()
    Balatest.play_hand { 'AS', '10H', '9D' }
  end,
  assert = function()
    Balatest.assert_chips(16)
  end,
}

-- #region Jankman

Balatest.TestPlay {
  name = "jankman_solo",
  requires = {},
  category = "jankman",

  jokers = {"j_mf_jankman"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 20 )
  end,
}

Balatest.TestPlay {
  name = "jankman_unmodded",
  requires = {},
  category = "jankman",

  jokers = {"j_mf_jankman","j_joker","j_joker","j_joker","j_joker"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 356 )
  end,
}

Balatest.TestPlay {
  name = "jankman_modded",
  requires = {},
  category = "jankman",

  jokers = {"j_mf_jankman","j_mf_globe","j_mf_globe","j_mf_globe","j_mf_globe"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 61 )
  end,
}

Balatest.TestPlay {
  name = "jankman_love_that_janker",
  requires = {},
  category = "jankman",

  jokers = {"j_mf_jankman","j_mf_jankman","j_mf_jankman","j_mf_jankman","j_mf_jankman"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 13674 )
  end,
}

-- #region Jester

Balatest.TestPlay {
  name = "jester_chips",
  requires = {},
  category = "jester",

  jokers = {"j_mf_jester"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 56 )
  end,
}

-- #region Junk Mail

Balatest.TestPlay {
  name = "junkmail_adds_correctly_priced_voucher",
  requires = {},
  category = "jester",

  dollars = 15,

  jokers = {"j_mf_junkmail"},
  execute = function()
    Balatest.end_round()
    Balatest.cash_out()
    Balatest.q(function() G.FUNCS.use_card { config = { ref_table = G.shop_vouchers.cards[2] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 0)
  end,
}

-- #region Less Fluff

Balatest.TestPlay {
  name = "lessfluff_vanilla",
  requires = {},
  category = "lessfluff",

  jokers = {"j_mf_lessfluff", "j_joker", "j_joker"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * 9 )
  end,
}

Balatest.TestPlay {
  name = "lessfluff_modded",
  requires = {},
  category = "lessfluff",

  jokers = {"j_mf_lessfluff", "j_mf_jester", "j_mf_jester"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 * 22 )
  end,
}

Balatest.TestPlay {
  name = "lessfluff_mixed",
  requires = {},
  category = "lessfluff",

  jokers = {"j_joker", "j_joker", "j_mf_lessfluff", "j_mf_jester", "j_mf_jester"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 201 )
  end,
}

-- #region Loaded Disk

Balatest.TestPlay {
  name = "loadeddisk_sell",
  requires = {},
  category = "loadeddisk",

  jokers = {"j_mf_loadeddisk"},
  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2)
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_mf_pink")
    Balatest.assert(G.consumeables.cards[2].config.center.key == "c_mf_yellow")
  end,
}

Balatest.TestPlay {
  name = "loadeddisk_sell_one_remaining",
  requires = {},
  category = "loadeddisk",

  jokers = {"j_mf_loadeddisk"},
  consumeables = {"c_death"},
  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2)
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_death")
    Balatest.assert(G.consumeables.cards[2].config.center.key == "c_mf_pink")
  end,
}

Balatest.TestPlay {
  name = "loadeddisk_sell_no_slots",
  requires = {},
  category = "loadeddisk",

  jokers = {"j_mf_loadeddisk"},
  consumeables = {"c_death","c_death"},
  execute = function()
    Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
    Balatest.wait_for_input()
  end,
  assert = function()
    Balatest.assert_eq(#G.consumeables.cards, 2)
    Balatest.assert(G.consumeables.cards[1].config.center.key == "c_death")
    Balatest.assert(G.consumeables.cards[2].config.center.key == "c_death")
  end,
}

-- #region Lollipop

Balatest.TestPlay {
  name = "lollipop_base_x_mult",
  requires = {},
  category = "lollipop",

  jokers = {"j_mf_lollipop"},
  execute = function()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 28 )
  end,
}

Balatest.TestPlay {
  name = "lollipop_two_rounds_after",
  requires = {},
  category = "lollipop",

  jokers = {"j_mf_lollipop"},

  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
  } }, -- for brevity

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 23 )
  end,
}

Balatest.TestPlay {
  name = "lollipop_eaten",
  requires = {},
  category = "lollipop",

  jokers = {"j_mf_lollipop"},

  deck = { cards = { 
    { r = 'A', s = 'S' },
    { r = 'A', s = 'S' },
  } }, -- for brevity

  execute = function()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.next_round()
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 )
    Balatest.assert_eq(#G.jokers.cards, 0)
  end,
}

-- #region Lucky Charm

Balatest.TestPlay {
  name = "lucky_charm_nope_mult",
  requires = {},
  category = "luckycharm",
  dollars = 0,
  jokers = {"j_mf_luckycharm"},
  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16 )
    Balatest.assert_eq(G.GAME.dollars, 0)
  end,
}

Balatest.TestPlay {
  name = "lucky_charm_nope_cash",
  requires = {},
  category = "luckycharm",
  dollars = 0,
  jokers = {"j_mf_luckycharm"},
  execute = function()
    G.GAME.probabilities.normal = 0
    Balatest.end_round()
    Balatest.cash_out()
  end,
  assert = function()
    Balatest.assert_eq(G.GAME.dollars, 0)
  end,
}

Balatest.TestPlay {
  name = "lucky_charm_yep",
  requires = {},
  category = "luckycharm",
  dollars = 0,
  jokers = {"j_mf_luckycharm"},
  execute = function()
    G.GAME.probabilities.normal = 9999
    Balatest.play_hand { 'AS' }
  end,
  assert = function()
    Balatest.assert_chips( 16*21 )
    Balatest.assert_eq(G.GAME.dollars, 20)
  end,
}

-- #region Marigold

Balatest.TestPlay {
  name = "marigold_doesnt_retrigger_not_marigold",
  requires = {},
  category = "marigold",
  dollars = 0,
  jokers = {"j_mf_marigold", "j_photograph"},
  consumeables = {"c_devil"},
  execute = function()
    Balatest.highlight { '2S' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.play_hand { 'AS', 'KS', 'QS', 'JS', 'TS' }
  end,
  assert = function()
    Balatest.assert_chips( (100 + 11 + 10 + 10 + 10 + 10) * 8 * 2 )
    Balatest.assert_eq(G.GAME.dollars, 3)
  end,
}

Balatest.TestPlay {
  name = "marigold_retriggers_marigold",
  requires = {},
  category = "marigold",
  dollars = 0,
  jokers = {"j_mf_marigold", "j_photograph"},
  consumeables = {"c_mf_rot_devil","c_mf_rot_devil"},
  execute = function()
    Balatest.highlight { '2S', 'AS', 'KS' }
    Balatest.use(G.consumeables.cards[1])
    Balatest.highlight { 'QS', 'JS', 'TS' }
    Balatest.use(G.consumeables.cards[2])
    Balatest.play_hand { 'AS', 'KS', 'QS', 'JS', 'TS' }
  end,
  assert = function()
    Balatest.assert_chips( (100 + (11 + 10 + 10 + 10 + 10) * 3) * 8 * 8 )
    Balatest.assert_eq(G.GAME.dollars, 3)
  end,
}