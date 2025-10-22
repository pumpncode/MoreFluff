SMODS.Atlas { 
  key = "mf_stake_stickers", 
  atlas_table = "ASSET_ATLAS", 
  path = "mf_stake_stickers.png", 
  px = 71, 
  py = 95 
}
SMODS.Atlas {
  key = "mf_stakes",
  path = "mf_stakes.png",
  px = 29,
  py = 29
}

SMODS.Stake {
  key = "pink",
  above_stake = "gold",
  applied_stakes = { "gold" },
  atlas = 'mf_stakes',
  pos = { x = 0, y = 0 },
  sticker_atlas = "mf_stake_stickers",
  sticker_pos = { x = 0, y = 0 },
	prefix_config = { applied_stakes = { mod = false } },
  modifiers = function()
    G.E_MANAGER:add_event(Event({
      trigger = "before",
      delay = 0.1,
      func = function()
        SMODS.change_discard_limit(-1)
        return true
      end
    }))
  end,
  colour = HEX("e379dd"),
}

SMODS.Stake {
  key = "lime",
  above_stake = "pink",
  applied_stakes = { "pink" },
  atlas = 'mf_stakes',
  pos = { x = 1, y = 0 },
  sticker_atlas = "mf_stake_stickers",
  sticker_pos = { x = 1, y = 0 },
  modifiers = function()
    G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) + 1
  end,
  colour = HEX("5cf85f"),
}

SMODS.Stake {
  key = "violet",
  above_stake = "lime",
  applied_stakes = { "lime" },
  atlas = 'mf_stakes',
  pos = { x = 2, y = 0 },
  sticker_atlas = "mf_stake_stickers",
  sticker_pos = { x = 2, y = 0 },
  modifiers = function()
    G.GAME.modifiers.ante_4_showdown = true
  end,
  colour = HEX("7859e4"),
}

local gnb = get_new_boss
function get_new_boss()
  local force_showdown = false
  local old_ante = G.GAME.round_resets.ante
  if G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.ante_4_showdown then
    force_showdown = true
  end

  if force_showdown and G.GAME.round_resets.ante % 2 == 0 then
    G.GAME.round_resets.ante = G.GAME.win_ante
  end
  local ret = gnb()
  G.GAME.round_resets.ante = old_ante

  return ret
end

SMODS.Stake {
  key = "jimbo",
  above_stake = "violet",
  applied_stakes = { "violet" },
  atlas = 'mf_stakes',
  pos = { x = 3, y = 0 },
  sticker_atlas = "mf_stake_stickers",
  sticker_pos = { x = 3, y = 0 },
  modifiers = function()
    G.GAME.win_ante = G.GAME.win_ante + 2
  end,
  colour = G.C.RED,
}
