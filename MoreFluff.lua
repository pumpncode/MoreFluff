--- STEAMODDED HEADER
--- MOD_NAME: More Fluff
--- MOD_ID: MoreFluff
--- PREFIX: mf
--- MOD_AUTHOR: [notmario, CHECK CREDITS IN MOD TAB]
--- MOD_DESCRIPTION: Back, despite popular demand
--- BADGE_COLOR: 814BA8
--- DEPENDENCIES: [Talisman>=2.0.0, Steamodded>=1.0.0~BETA-0312b]
--- VERSION: 1.4.0

local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path
mf_config = SMODS.current_mod.config
local folder = string.match(mod_path, "[Mm]ods.*")

if mf_config["Jokers"] == nil then
  mf_config["Jokers"] = true
end
if mf_config["Colour Cards"] == nil then
  mf_config["Colour Cards"] = true
end
if mf_config["Music"] == nil then
  mf_config["Music"] = true
end
if mf_config["45 Degree Rotated Tarot Cards"] == nil then
  mf_config["45 Degree Rotated Tarot Cards"] = true
end
if mf_config["Achievements"] == nil then
  mf_config["Achievements"] = true
end
if mf_config["Huger Joker"] == nil then
  mf_config["Huger Joker"] = false
end
if mf_config["Programmer Art"] == nil then
  mf_config["Programmer Art"] = false
end
if mf_config["Disable Art Credits"] == nil then
  mf_config["Disable Art Credits"] = false
end
-- if mf_config["Unfinished"] == nil then
--   mf_config["Unfinished"] = false
-- end

if Cryptid then
  SMODS.load_mod_config(SMODS.Mods.Cryptid)
end

SMODS.Sound({
	key = "music_colourpack",
	path = "music_colourpack.ogg",
	select_music_track = function()
		return (
      mf_config["Music"] and 
      (
        G.pack_cards
        and G.pack_cards.cards
        and G.pack_cards.cards[1]
        and G.pack_cards.cards[1].ability.set == "Colour"
      )
    )
	end,
})

SMODS.Sound({
	key = "music_rotarot",
	path = "music_rotarot.ogg",
	select_music_track = function()
		return (
      mf_config["Music"] and 
      (
        G.pack_cards
        and G.pack_cards.cards
        and G.pack_cards.cards[1]
        and G.pack_cards.cards[1].ability.set == "Rotarot"
      )
    )
	end,
})

SMODS.Sound({
  key = "music_modded",
  path = "music_modded.ogg",
  select_music_track = function()
    return (
      mf_config["Music"] and
      (
        (SMODS.OPENED_BOOSTER or {}).ability or {}).modded_pack 
        and G.booster_pack and not G.booster_pack.REMOVED
      )
      and 2
  end,
})

-- comment out the shit you dont want
local joker_list = {
  -- common
  "basepaul_card",
  "clownfish",
  "expansion_pack",
  "hollow",
  "jester",
  "lollipop",
  "luckycharm",
  "monochrome",
  "mspaint",
  "simplified",
  "spiral",
  "treasuremap",
  "philosophical",

  -- uncommon
  "badlegaldefence",
  "clipart",

  -- uncommon (spire) - these should be together in the collection and in class order
  "dropkick",
  "bladedance",
  "hyperbeam",
  "blasphemy",
  "dramaticentrance",

  -- other uncommons
  "coupon_catalogue",
  "css",
  "globe",
  "goldencarrot",
  "hallofmirrors",
  "impostor",
  "tonersoup",
  "loadeddisk",
  "stylemeter",
  "teacup",
  "recycling",
  "virtual",

  -- rare
  "bloodpact",
  "bowlingball",
  "cba",
  "fleshprison",
  "hugejoker",
  "jankman",
  "mashupalbum",
  "pixeljoker",
  "rainbowjoker",
  "rosetinted",
  "the_solo",

  -- legendary!!
  "triangle",

  -- 1.3
  "junkmail",
  "flintandsteel",
  "gemstonejoker",
  "missingjoker",
  "rot_cartomancer",
  -- "selfinsert", -- cut this one for now
  "stonejokerjoker",
  "talljoker",
  "tealjoker",
  "yuckyrat",
  "allicantdo",
  "brass",
  "complexitycreep",
  "hyperjimbo",
  "top10",
  "widejoker",
  "marigold",

  -- busted shit
  "colorem",
  "shattered_prism",
}

if not mf_config["Jokers"] then
  joker_list = {}
end

function has(table, elem)
  for i = 1,#table do
    if table[i] == elem then
      return true
    end
  end
  return false
end

-- I don't think these are needed anymore since Talisman is a dependency but idk lol -- Jevonn
local to_big = to_big or function(num)
  return num
end
local to_number = to_number or function(jevonn_was_here)
  return jevonn_was_here
end

for _, v in ipairs(joker_list) do
  print(v)
  local joker = SMODS.load_file("jokers/"..v..".lua")()
  if not joker then
    goto continue
  end
  joker.key = v
  joker.atlas = "mf_jokers"
  if v == "hyperjimbo" then
    joker.atlas = "mf_hyperjimbo"
  end
  if v == "rot_cartomancer" then
    joker.atlas = "mf_rot_cartomancer"
  end
  if v == "shattered_prism" then
    joker.atlas = "almanactriangle"
  end
  if not joker.pos then
    joker.pos = { x = 0, y = 0 }
  end

  local joker_obj = SMODS.Joker(joker)
  for k_, v_ in pairs(joker) do
    if type(v_) == 'function' then
      joker_obj[k_] = joker[k_]
    end
  end

  ::continue::
end

-- if mf_config["Unfinished"] then

--   local ortalab_jokers = {
--     -- common
--     "clintcondition",
--     "sheetsuggestion",

--     -- uncommon
--     "devilsknife",

--     -- rare
--     "twotrucks"
--   }

--   local familiar_jokers = {
--     -- common
--     "jimbojjoker"
--   }

--   if not mf_config["Jokers"] then
--     ortalab_jokers = {}
--     familiar_jokers = {}
--   end

--   for _, v in ipairs(ortalab_jokers) do
--     print(v)
--     local joker = SMODS.load_file("jokers/ortalab/"..v..".lua")()
--     if not joker then
--       goto eunitnoc
--     end
--     joker.key = v
--     joker.atlas = "mf_srekoj"
--     if not joker.pos then
--       joker.pos = { x = 0, y = 0 }
--     end

--     local joker_obj = SMODS.Joker(joker)
--     for k_, v_ in pairs(joker) do
--       if type(v_) == 'function' then
--         joker_obj[k_] = joker[k_]
--       end
--     end
--     joker_obj.jank_force_badge = {
--       name = "ffulF eroM",
--       col = G.C.GREEN
--     }

--     ::eunitnoc::
--   end

--   for _, v in ipairs(familiar_jokers) do
--     print(v)
--     local joker = SMODS.load_file("jokers/familiar/"..v..".lua")()
--     if not joker then
--       goto continue_fam
--     end
--     joker.key = v
--     joker.atlas = "mf_srekoj"
--     if not joker.pos then
--       joker.pos = { x = 0, y = 0 }
--     end
--     joker.pos.x = joker.pos.x + 10

--     local joker_obj = SMODS.Joker(joker)
--     for k_, v_ in pairs(joker) do
--       if type(v_) == 'function' then
--         joker_obj[k_] = joker[k_]
--       end
--     end
--     joker_obj.jank_force_badge = {
--       name = "Ectoplasm",
--       col = G.C.DARK_EDITION
--     }

--     ::continue_fam::
--   end
-- end

local smods_cmb = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
  if not SMODS.config.no_mod_badges and obj and obj.jank_force_badge then
    local mod_name = obj.jank_force_badge.name
    local size = 0.9
    local font = G.LANG.font
    local max_text_width = 2 - 2*0.05 - 4*0.03*size - 2*0.03
    local calced_text_width = 0
    -- Math reproduced from DynaText:update_text
    for _, c in utf8.chars(mod_name) do
        local tx = font.FONT:getWidth(c)*(0.33*size)*G.TILESCALE*font.FONTSCALE + 2.7*1*G.TILESCALE*font.FONTSCALE
        calced_text_width = calced_text_width + tx/(G.TILESIZE*G.TILESCALE)
    end
    local scale_fac =
        calced_text_width > max_text_width and max_text_width/calced_text_width
        or 1
    badges[#badges + 1] = {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.R, config={align = "cm", colour = obj.jank_force_badge.col, r = 0.1, minw = 2, minh = 0.36, emboss = 0.05, padding = 0.03*size}, nodes={
          {n=G.UIT.B, config={h=0.1,w=0.03}},
          {n=G.UIT.O, config={object = DynaText({string = mod_name or 'ERROR', colours = {G.C.WHITE},float = true, shadow = true, offset_y = -0.05, silent = true, spacing = 1*scale_fac, scale = 0.33*size*scale_fac})}},
          {n=G.UIT.B, config={h=0.1,w=0.03}},
        }}
      }}
  else
    smods_cmb(obj, badges)
  end
end

local artpack_suffix = "_refresh.png"
if mf_config["Programmer Art"] then artpack_suffix = ".png" end

SMODS.Atlas({ 
  key = "mf_jokers", 
  atlas_table = "ASSET_ATLAS", 
  path = "mf_jokers" .. artpack_suffix, 
  px = 71, 
  py = 95 
})
SMODS.Atlas({ 
  key = "mf_mv", 
  atlas_table = "ASSET_ATLAS", 
  path = "mf_mv.png", 
  px = 71, 
  py = 95 
})
SMODS.Shader({
  key="dissolvegreen",
  path="dissolvegreen.fs"
})
SMODS.Atlas({ 
  key = "mf_hyperjimbo", 
  atlas_table = "ASSET_ATLAS", 
  path = "mf_hyperjimbo.png", 
  px = 95, 
  py = 95 
})
SMODS.Atlas({ 
  key = "mf_srekoj", 
  atlas_table = "ASSET_ATLAS", 
  path = "mf_srekoj.png", 
  px = 71, 
  py = 95 
})
SMODS.Atlas({ 
  key = "mf_rot_cartomancer", 
  atlas_table = "ASSET_ATLAS", 
  path = "mf_rot_cartomancer.png", 
  px = 112, 
  py = 112
})
SMODS.Atlas({ 
  key = "mf_colours", 
  atlas_table = "ASSET_ATLAS", 
  path = "mf_colours" .. artpack_suffix, 
  px = 71, 
  py = 95 
})
SMODS.Atlas({ 
  key = "mf_rotarots", 
  atlas_table = "ASSET_ATLAS", 
  path = "mf_rotarots.png", 
  px = 107, 
  py = 107
})
SMODS.Atlas({ 
  key = "mf_rotarotpacks", 
  atlas_table = "ASSET_ATLAS", 
  path = "mf_rotarotpacks.png", 
  px = 106, 
  py = 106
})
SMODS.Atlas({ 
  key = "mf_oddities", 
  atlas_table = "ASSET_ATLAS", 
  path = "mf_oddities.png", 
  px = 71, 
  py = 95 
})
SMODS.Atlas({ 
  key = "mf_packs", 
  atlas_table = "ASSET_ATLAS", 
  path = "mf_packs.png", 
  px = 71, 
  py = 95 
})
SMODS.Atlas({ 
  key = "mf_vouchers", 
  atlas_table = "ASSET_ATLAS", 
  path = "mf_vouchers.png", 
  px = 71, 
  py = 95 
})
SMODS.Atlas({ 
  key = "mf_enhancers", 
  atlas_table = "ASSET_ATLAS", 
  path = "mf_enhancers.png", 
  px = 71, 
  py = 95 
})
SMODS.Atlas({
  key = "modicon",
  path = "mf_icon.png",
  px = 32,
  py = 32
})
if CardSleeves then
  SMODS.Atlas({
    key = "mf_sleeves", 
    atlas_table = "ASSET_ATLAS", 
    path = "mf_sleeves.png", 
    px = 73, 
    py = 95 
  })
end
SMODS.Atlas({
  key = "tags",
  path = "mf_tags.png",
  px = 34,
  py = 34
})
if Jen then
  SMODS.Atlas({ 
    key = "almanactriangle", 
    atlas_table = "ASSET_ATLAS", 
    path = "almanactriangle.png", 
    px = 71, 
    py = 95 
  })
end

-- add a way for these to be disabled
if mf_config["Colour Cards"] then
  init_cols = SMODS.load_file("other/colours.lua")()
  init_cols()
else
  function colour_end_of_round_effects()

  end
end

-- modded pack
init_moddedpack = SMODS.load_file("other/moddedpack.lua")()
init_moddedpack()

-- add a way for these to be disabled
if mf_config["45 Degree Rotated Tarot Cards"] then
  init_enhancers = SMODS.load_file("other/enhancers.lua")()
  init_enhancers()
  init_rotarots = SMODS.load_file("other/rotarots.lua")()
  init_rotarots()
end

-- clutch tag
SMODS.Tag({
  key = "clutch",
  atlas = "mf_tags",
  config = {
    extra = 4
  },
  pos = { x = 1, y = 1 },
  unlocked = true,
  discovered = true,
  loc_vars = function(self, info_queue)
    return { vars = { self.config.extra } }
  end,
  apply = function(self, tag, context)
    if context.type == "final_scoring_step" then
      SMODS.calculate_effect({xmult=4}, tag)
    end
    if context.type == "eval" then
      tag:yep("X", G.C.RED, function()
        return true
      end)
      tag.triggered = true
    end
  end,
})


-- maybe another day

-- if OddityAPI then
--   init_odds = SMODS.load_file("other/oddities.lua")()
--   init_odds()
-- end

SMODS.Back({
	name = "Gros Michel Deck",
	key = "grosmichel",
	config = { mf_grosmichel = true },
	pos = { x = 0, y = 0 },
	atlas = "mf_enhancers",
  unlocked = true,
})

if CardSleeves then
  CardSleeves.Sleeve({
    name = "Gros Michel Sleeve",
    key="grosmichel",
    atlas="mf_sleeves",
    pos = { x = 0, y = 0 },
    unlocked = true,
    loc_vars = function(self)
      local key
      if self.get_current_deck_key() ~= "b_mf_grosmichel" then
        key = self.key
      else
        key = self.key .. "_alt"
      end
      return { key = key }
    end,
    apply = function(self)
      if self.get_current_deck_key() ~= "b_mf_grosmichel" then
        G.E_MANAGER:add_event(Event({
          func = function()
            local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_gros_michel', nil)
            card:add_to_deck()
            G.jokers:emplace(card)
            return true
          end
        }))
      else
        G.E_MANAGER:add_event(Event({
          func = function()
            local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_cavendish', nil)
            card:add_to_deck()
            G.jokers:emplace(card)
            return true
          end
        }))
      end
    end
  })
end

if has(joker_list, "philosophical") then
  SMODS.Back({
    name = "Philosophical Deck",
    key = "philosophical",
    config = { mf_philosophical = true },
    pos = { x = 1, y = 0 },
    atlas = "mf_enhancers",
    unlocked = true,
  })

  if CardSleeves then
    CardSleeves.Sleeve({
      name = "Philosophical Sleeve",
      key="philosophical",
      atlas="mf_sleeves",
      pos = { x = 1, y = 0 },
      unlocked = true,
      loc_vars = function(self)
        local key
        if self.get_current_deck_key() ~= "b_mf_philosophical" then
          key = self.key
        else
          key = self.key .. "_alt"
        end
        return { key = key }
      end,
      apply = function(self)
        G.E_MANAGER:add_event(Event({
          func = function()
            for i = 1,5 do
              local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_mf_philosophical', nil)
              card:add_to_deck()
              G.jokers:emplace(card)
            end
            return true
          end
        }))
      end
    })
  end
end

if mf_config["Colour Cards"] then
  SMODS.Back({
    name = "Rainbow Deck",
    key = "rainbow",
    config = { voucher = 'v_mf_paintroller', consumables = {'c_mf_white'} },
    pos = { x = 2, y = 0 },
    atlas = "mf_enhancers",
    unlocked = true,
  })

  if CardSleeves then
    CardSleeves.Sleeve({
      key = "rainbow",
      name = "Rainbow Sleeve",
      atlas = "mf_sleeves",
      pos = { x = 2, y = 0 },
      unlocked = true,
      loc_vars = function(self)
        local key
        if self.get_current_deck_key() ~= "b_mf_rainbow" then
          key = self.key
          self.config = { voucher = 'v_mf_paintroller', consumables = { 'c_mf_white' } }
        else
          key = self.key .. "_alt"
          self.config = { voucher = "v_mf_colourtheory" }
        end
        return { key = key }
      end
    })
  end
end

if has(joker_list, "blasphemy") then
  SMODS.Back({
    name = "Blasphemous Deck",
    key = "blasphemy",
    config = { mf_blasphemy = true },
    pos = { x = 3, y = 0 },
    atlas = "mf_enhancers",
    unlocked = true,
  })
  if CardSleeves then
    CardSleeves.Sleeve({
      name = "Blasphemous Sleeve",
      key="blasphemy",
      atlas="mf_sleeves",
      pos = { x = 3, y = 0 },
      unlocked = true,
      loc_vars = function(self)
        local key
        if self.get_current_deck_key() ~= "b_mf_blasphemy" then
          key = self.key
        else
          key = self.key .. "_alt"
        end
        return { key = key }
      end,
      apply = function(self)
        if self.get_current_deck_key() ~= "b_mf_blasphemy" then
          G.E_MANAGER:add_event(Event({
            func = function()
              local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_mf_blasphemy', nil)
              card:add_to_deck()
              card:set_edition({negative = true})
              card:set_eternal(true)
              G.jokers:emplace(card)
              return true
            end
          }))
        else
          G.E_MANAGER:add_event(Event({
            func = function()
              local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_mf_blasphemy', nil)
              card:add_to_deck()
              card:set_edition({negative = true})
              G.jokers:emplace(card)
              return true
            end
          }))
        end
      end
    })
  end
end

local old_back_apply_to_run = Back.apply_to_run
function Back.apply_to_run(self)
  old_back_apply_to_run(self)
  if self.effect.config.mf_grosmichel then
    sendDebugMessage(G.GAME.selected_sleeve)
    if not (CardSleeves and (G.GAME.selected_sleeve or "sleeve_casl_none") == "sleeve_mf_grosmichel") then
      G.E_MANAGER:add_event(Event({
        func = function()
          local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_gros_michel', nil)
          card:add_to_deck()
          G.jokers:emplace(card)
          return true
        end
      }))
    end
  end
  if self.effect.config.mf_philosophical then
    G.E_MANAGER:add_event(Event({
      func = function()
        for i = 1,5 do
          local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_mf_philosophical', nil)
          card:add_to_deck()
          G.jokers:emplace(card)
        end
        return true
      end
    }))
  end
  if self.effect.config.mf_blasphemy then
    if not (CardSleeves and (G.GAME.selected_sleeve or "sleeve_casl_none") == "sleeve_mf_blasphemy") then
      G.E_MANAGER:add_event(Event({
        func = function()
          local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_mf_blasphemy', nil)
          card:add_to_deck()
          card:set_edition({negative = true})
          card:set_eternal(true)
          G.jokers:emplace(card)
          return true
        end
      }))
    end
  end
end

if mf_config["Achievements"] then
  SMODS.Atlas({
    key = "mf_achievements",
    path = "mf_achievements.png",
    px = 66,
    py = 66,
  })

  SMODS.Achievement({
    key = "mf_ten_colour_rounds",
    order = 1,
    bypass_all_unlocked = true,
    atlas = "mf_achievements",
    --reset_on_startup = true,
    unlock_condition = function(self, args)
      if
        args.type == "mf_ten_colour_rounds"
      then
        return true
      end
    end,
  })
  SMODS.Achievement({
    key = "mf_whos_paul",
    order = 2,
    bypass_all_unlocked = true,
    atlas = "mf_achievements",
    --reset_on_startup = true,
    unlock_condition = function(self, args)
      if
        args.type == "mf_trigger_paul"
      then
        return true
      end
    end,
  })
  SMODS.Achievement({
    key = "mf_jank_it_up",
    order = 3,
    bypass_all_unlocked = true,
    atlas = "mf_achievements",
    --reset_on_startup = true,
    unlock_condition = function(self, args)
      if args.type == "modify_jokers" then
        local jankman_count = 0
  
        if G.jokers then
          for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center.key == "j_mf_jankman" then
              jankman_count = jankman_count + 1
            end
          end
        end
  
        if jankman_count >= 3 then
          return true
        end
      end
    end,
  })
  SMODS.Achievement({
    key = "mf_dropkick_ten_hands",
    order = 4,
    bypass_all_unlocked = true,
    atlas = "mf_achievements",
    --reset_on_startup = true,
    unlock_condition = function(self, args)
      if
        args.type == "mf_dropkick_ten_hands"
      then
        return true
      end
    end,
  })
  SMODS.Achievement({
    key = "mf_negative_philosophical",
    order = 5,
    bypass_all_unlocked = true,
    atlas = "mf_achievements",
    --reset_on_startup = true,
    unlock_condition = function(self, args)
      if args.type == "modify_jokers" then
        if G.jokers then
          for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center.key == "j_mf_philosophical" and 
              (G.jokers.cards[i].edition and G.jokers.cards[i].edition.negative) then
              return true
            end
          end
        end
  
        return false
      end
    end,
  })
  SMODS.Achievement({
    key = "mf_huge_and_pixel",
    order = 6,
    bypass_all_unlocked = true,
    atlas = "mf_achievements",
    --reset_on_startup = true,
    unlock_condition = function(self, args)
      if args.type == "modify_jokers" then
        local has_huge = false
        local has_pixel = false
        if G.jokers then
          for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center.key == "j_mf_hugejoker" then
              has_huge = true
            end
            if G.jokers.cards[i].config.center.key == "j_mf_pixeljoker" then
              has_pixel = true
            end
          end
        end
  
        return has_huge and has_pixel
      end
    end,
  })
end

-- cryptid pool additions
if Cryptid then
  if Cryptid.aliases then
    local aliases = {
      paul = "basepaul card",
      basepaul = "basepaul card",
      bowling = "bowling ball",
      cba = "card buffer advanced",
      clipart = "clipart joker",
      coupon = "coupon catalogue",
      dramatic = "dramatic entrance",
      expansion = "expansion pack",
      carrot = "golden carrot",
      hollow = "hollow joker",
      huge = "huge joker",
      beam = "hyper beam",
      jank = "jankman",
      loaded = "loaded disk",
      mashup = "mashup album",
      mspaint = "ms paint joker",
      philosophical = "philosophical joker",
      rainbow = "rainbow joker",
      rose = "rose-tinted glasses",
      rosetinted = "rose-tinted glasses",
      ["rose-tinted"] = "rose-tinted glasses",
      rosetintedglasses = "rose-tinted glasses",
      simplified = "simplified joker",
      simplifiedjoker = "simplified joker",
      style = "stylemeter",
      solo = "the solo",
      treasure = "treasure map",
      virtual = "virtual joker",
      ooffoo = "00FF00",
      lime = "00FF00",
      toner = "i sip toner soup",
      tonersoup = "i sip toner soup",
      isiptonersoup = "i sip toner soup",
      junkmail = "junk mail",
      flintandsteel = "flint and steel",
      firestarter = "flint and steel",
      peakcinema = "flint and steel",
      gemstone = "gemstone joker",
      missingtexture = "missing texture",
      rot_cartomancer = "cartomancer!",
      stonejokerjoker = "stonejoker joker",
      sjj = "stonejoker joker",
      tall = "tall joker",
      teal = "teal joker",
      yucky = "yucky rat", 
      judas = "all i can't do",
      brass = "brass joker",
      complexitycreep = "complexity creep",
      averagebalatromod = "complexity creep",
      topten = "top 10 jokers from one through ten",
      clickbait = "top 10 jokers from one through ten",
      wide = "wide joker",
    }
    for k, v in pairs(aliases) do
      Cryptid.aliases[k] = v
    end
  end
end

--- hooks

SMODS.DrawStep({
	key = "spire_mv",
	order = -5,
	func = function(self)
    if not G.mf_mv_spr then return nil end
    if mf_config["Programmer Art"] then return nil end
    local my_key = self.config.center.key

    if 
      my_key ~= "j_mf_dramaticentrance" and
      my_key ~= "j_mf_dropkick" and
      my_key ~= "j_mf_bladedance" and
      my_key ~= "j_mf_hyperbeam" and
      my_key ~= "j_mf_blasphemy"
    then
      return nil
    end

    G.mf_mv_spr.role.draw_major = self

    local cost = math.floor(
      self.cost +
      (self.ability.extra_value or 0) * 2 +
      0.5
    )

    local base_cost = ({
      j_mf_dramaticentrance = 6,
      j_mf_dropkick = 8,
      j_mf_bladedance = 8,
      j_mf_hyperbeam = 8,
      j_mf_blasphemy = 5,
    })[my_key]

    local shader = "dissolve"
    if cost ~= base_cost then shader = "mf_dissolvegreen" end

    if cost > 99 then
      G.mf_mv_spr:set_sprite_pos({x=0, y=3})
      G.mf_mv_spr:draw_shader(shader, nil, nil, nil, self.children.center)
    elseif cost <= 9 then
      G.mf_mv_spr:set_sprite_pos({x=cost, y=0})
      G.mf_mv_spr:draw_shader(shader, nil, nil, nil, self.children.center)
    else
      G.mf_mv_spr:set_sprite_pos({x=math.floor(cost/10), y=1})
      G.mf_mv_spr:draw_shader(shader, nil, nil, nil, self.children.center)
      G.mf_mv_spr:set_sprite_pos({x=cost%10, y=2})
      G.mf_mv_spr:draw_shader(shader, nil, nil, nil, self.children.center)
    end
	end,
	conditions = { vortex = false, facing = "front" },
})

mf_hyperjimbo_dt = 0

local game_updateref = Game.update
function Game:update(dt)
  game_updateref(self, dt)

  mf_hyperjimbo_dt = mf_hyperjimbo_dt + dt
	if G.P_CENTERS and G.P_CENTERS.j_mf_hyperjimbo and mf_hyperjimbo_dt > 0.07 then
		mf_hyperjimbo_dt = mf_hyperjimbo_dt - 0.07
		local jimballobj = G.P_CENTERS.j_mf_hyperjimbo
		if jimballobj.pos.x == 5 and jimballobj.pos.y == 9 then
			jimballobj.pos.x = 0
			jimballobj.pos.y = 0
		elseif jimballobj.pos.x < 5 then
			jimballobj.pos.x = jimballobj.pos.x + 1
		elseif jimballobj.pos.y < 9 then
			jimballobj.pos.x = 0
			jimballobj.pos.y = jimballobj.pos.y + 1
		end
	end
end

local update_round_evalref = Game.update_round_eval
function Game:update_round_eval(dt)
  update_round_evalref(self, dt)
  
  for _, other_card in pairs(G.deck.cards) do
    SMODS.debuff_card(other_card, false, "allicantdo")
  end

  -- thanks feder
  -- does CA even have a 1.0.0 port?
  if G.bladedance_temp_ids then
    for _, remove_id in ipairs(G.bladedance_temp_ids) do
      for k, card in ipairs(G.playing_cards) do
        if card.unique_val == remove_id then
          G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
            func = function()
            G.deck:remove_card(card)
            G.hand:remove_card(card)
            G.discard:remove_card(card)
            card:start_dissolve(nil, false)
            card = nil
          return true; end})) 
        end
      end
      -- for k, card in ipairs(G.hand.cards) do
      --     if card.unique_val == remove_id then
      --         G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
      --             func = function()
      --             G.hand:remove_card(card)
      --             hand:remove()
      --             card = nil
      --         return true; end})) 
      --     end
      -- end
    end
    G.bladedance_temp_ids = {}
  end
  if G.missingjoker_revert then
    for _, joker in pairs(G.missingjoker_revert) do
      joker:set_ability(G.P_CENTERS["j_mf_missingjoker"])
      joker:juice_up()
    end
    G.missingjoker_revert = {}
  end
  if G.do_colour_end_of_round_stuff then
    colour_end_of_round_effects()

    G.do_colour_end_of_round_stuff = false
  end
end

local old_g_funcs_check_for_buy_space = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
  if card.ability.name == "Philosophical Joker" and card.ability.extra >= 1 then
    return true
  end
  return old_g_funcs_check_for_buy_space(card)
end

local old_g_funcs_can_select_card = G.FUNCS.can_select_card
G.FUNCS.can_select_card = function(e)
  if e.config.ref_table.ability.name == "Philosophical Joker" and e.config.ref_table.ability.extra >= 1 then 
    e.config.colour = G.C.GREEN
    e.config.button = 'use_card'
  else
    old_g_funcs_can_select_card(e)
  end
end

local update_blind_selectref = Game.update_blind_select
function Game:update_blind_select(dt)
  update_blind_selectref(self, dt)
  G.do_colour_end_of_round_stuff = true
end

-- config menu

G.FUNCS.mf_change_artpack = function(args)
  mf_config["Programmer Art"] = (args.to_val == "Programmer")
end

local morefluffTabs = function() return {
	{
		label = localize("mf_config_features"),
		chosen = true,
		tab_definition_function = function()
			mf_nodes = {}
			settings = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {} }
      settings.nodes[#settings.nodes + 1] =
        create_option_cycle({label = localize('mf_config_progart'), scale = 0.8, options = {"Refreshed", "Programmer"}, opt_callback = 'mf_change_artpack', current_option = (mf_config["Programmer Art"] and 2 or 1)})
      settings.nodes[#settings.nodes + 1] =
        create_toggle({ label = localize("mf_config_disablecred"), ref_table = mf_config, ref_value = "Disable Art Credits" })
      settings.nodes[#settings.nodes + 1] =
        create_toggle({ label = localize("mf_config_jokers"), ref_table = mf_config, ref_value = "Jokers" })
      settings.nodes[#settings.nodes + 1] =
        create_toggle({ label = localize("mf_config_music"), ref_table = mf_config, ref_value = "Music" })
      settings.nodes[#settings.nodes + 1] =
        create_toggle({ label = localize("mf_config_colour_cards"), ref_table = mf_config, ref_value = "Colour Cards" })
      settings.nodes[#settings.nodes + 1] =
        create_toggle({ label = localize("mf_config_rotarot_cards"), ref_table = mf_config, ref_value = "45 Degree Rotated Tarot Cards" })
      settings.nodes[#settings.nodes + 1] =
        create_toggle({ label = localize("mf_config_achievements"), ref_table = mf_config, ref_value = "Achievements" })
      -- settings.nodes[#settings.nodes + 1] =
      --   create_toggle({ label = localize("mf_config_unfinished"), ref_table = mf_config, ref_value = "Unfinished" })
      settings.nodes[#settings.nodes + 1] =
        create_toggle({ label = localize("mf_config_huger_joker"), ref_table = mf_config, ref_value = "Huger Joker" })
			config = { n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = { settings } }
			mf_nodes[#mf_nodes + 1] = config
			return {
				n = G.UIT.ROOT,
				config = {
					emboss = 0.05,
					minh = 6,
					r = 0.1,
					minw = 10,
					align = "cm",
					padding = 0.2,
					colour = G.C.BLACK,
				},
				nodes = mf_nodes,
			}
		end,
	},
	{
		label = localize("mf_credits"),
		chosen = false,
		tab_definition_function = function()
      local text_scale = 0.85
      local mf_cred_nodes = {n=G.UIT.ROOT, config={align = "cm", padding = 0.2, colour = G.C.BLACK, minh = 6, minw = 6}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0.1, r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
              {n=G.UIT.T, config={text = "developer / music / programmer art: notmario", scale = text_scale*0.6, colour = G.C.SECONDARY_SET.Colour, shadow = true}},
            }},
          }},
          {n=G.UIT.R, config={align = "cm", padding = 0.1, r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
              {n=G.UIT.T, config={text = "Art Contributors (Refresh)", scale = text_scale*0.7, colour = G.C.UI.WHITE, shadow = true}},
            }},
            {n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
              {n=G.UIT.C, config={align = "tl", padding = 0.05, minw = 2.5}, nodes={
                {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                  {n=G.UIT.T, config={text = 'Multi / MVBit: Colour Cards', scale = text_scale*0.5, colour = G.C.UI.WHITE, shadow = true}},
                }},
              }},
            }},
            {n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
              {n=G.UIT.C, config={align = "tl", padding = 0.05, minw = 2.5}, nodes={
                {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                  {n=G.UIT.T, config={text = 'Some Jokers by footlongdingledong', scale = text_scale*0.5, colour = G.C.UI.WHITE, shadow = true}},
                }},
              }},
            }},
          }}
        }}
			return {
				n = G.UIT.ROOT,
				config = {
					emboss = 0.05,
					minh = 6,
					r = 0.1,
					minw = 10,
					align = "cm",
					-- padding = 0.2,
					colour = G.C.BLACK,
				},
				nodes = { mf_cred_nodes },
			}
		end,
	},
  -- {
  --   label = localize("mf_config_maj"),
  --   chosen = true,
	-- 	tab_definition_function = function()
	-- 		local mynodes = {}
	-- 		return {
	-- 			n = G.UIT.ROOT,
	-- 			config = {
	-- 				emboss = 0.05,
	-- 				minh = 6,
	-- 				r = 0.1,
	-- 				minw = 10,
	-- 				align = "cm",
	-- 				padding = 0.2,
	-- 				colour = G.C.BLACK,
	-- 			},
	-- 			nodes = mynodes,
	-- 		}
	-- 	end,
  -- },
} end
SMODS.current_mod.extra_tabs = morefluffTabs

local mainmenuref2 = Game.main_menu
Game.main_menu = function(change_context)
  if Jen and Jen.fusions then
    Jen.add_fusion(
      'Fracture Triangle',3333,
      "j_mf_shattered_prism",
      'j_mf_triangle',
      'j_jen_godsmarble'
    )
    --print("Fusions successfully applied!")
  end
  G.mf_mv_spr = Sprite(
    0, 0, 71, 95, G.ASSET_ATLAS["mf_mv"], {x = 0, y = 0}
  ) -- im dumb and stupide
  local ret = mainmenuref2(change_context)
  return ret
end

-- -- thank you mr cryptid
-- local g_main_menu = Game.main_menu
-- function Game:main_menu(change_context)
--   local ret = g_main_menu(self, change_context)
--   local newcard = Card(
--     G.title_top.T.x,
--     G.title_top.T.y,
--     G.CARD_W,
--     G.CARD_H,
--     G.P_CARDS.empty,
--     G.P_CENTERS.j_mf_philosophical,
--     { bypass_discovery_center = true }
--   )
--   -- recenter the title
--   G.title_top.T.w = G.title_top.T.w + G.CARD_W * 0.7675 -- uh if i do this again then it gets really big so uh. Manually it is then
--   G.title_top.T.x = G.title_top.T.x - 0.8
--   G.title_top:emplace(newcard)
--   -- make the card look the same way as the title screen Ace of Spades
--   newcard.T.w = newcard.T.w * 1.1 * 1.2
--   newcard.T.h = newcard.T.h * 1.1 * 1.2
--   newcard.no_ui = true
--   newcard.states.visible = false

--   G.E_MANAGER:add_event(Event({
--     trigger = "after",
--     delay = 0,
--     blockable = false,
--     blocking = false,
--     func = function()
--       if change_context == "splash" then
--         newcard.states.visible = true
--         newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, true, 2.5)
--       else
--         newcard.states.visible = true
--         newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, nil, 1.2)
--       end
--       return true
--     end,
--   }))

--   return ret
-- end