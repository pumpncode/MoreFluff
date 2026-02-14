-- base standard for MoreFluff

Blockbuster.ValueManipulation.CompatStandard{
    key = "morefluff",
    source_mod = "MoreFluff",
    variable_conventions = {
        full_vars = {
            "odds",
            "hands_lost",
            "rounds", -- bookmove, spapling, treasuremap
            "boss_size", -- fleshpanopticon and -prison
            "upgrade_rounds", -- brass & forge
            "partial_rounds", -- brass & forge
            "loss", -- golden carrot
            "thresh", -- hollow
            "threshold", -- passando
            "check", -- imposter
            "op", -- john balatro
            "val_mult", -- junkmail,
            "speed", -- lightning strikes thrice
        },
        ends_on = {
            "_tally",
            "_chance", -- lucky charm
        },

        starts_with = {
            "c_",
        }
    },
    integer_only_variable_conventions = {
        full_vars = {
            "cards_created",
            "max_highlighted",
            "val" -- This might be used in spots where it doesn't create cards, but it seems its always related to card creation
        },
        ends_on = {
        },
        starts_with = {
        },
    },
    variable_caps = {
        retriggers = 25,
        repetitions = 25,
        val = 25,
    },

    min_max_values = {min = 0, max = 25},
    redirect_objects = {
        mf_morefluff_scaling = {
            -- stacking xmult
            j_mf_allicantdo = true,
            j_mf_lessfluff = true,
            j_mf_the_solo = true,
            j_mf_yuckyrat = true,

            -- stacking xchips,
            j_mf_twotrucks = true,
            -- mult/chips stacking
            j_mf_mashupalbum = true,
            j_mf_monochrome = true
        }
    }, 
    exempt_jokers = {
        -- No values to val manip
        j_mf_badlegaldefence = true,
        j_mf_blahaj = true,
        j_mf_bookmove = true,
        j_mf_brilliant = true,
        j_mf_cba = true,
        j_mf_clipart = true,
        j_mf_css = true,
        j_mf_farmmerge = true,
        j_mf_farmmergecivilisation = true,
        j_mf_flintandsteel = true,
        j_mf_grep = true,
        j_mf_loadeddisk = true,
        j_mf_missingjoker = true,
        j_mf_mspaint = true,
        j_mf_onesliptoolate = true,
        j_mf_recycling = true,
        j_mf_rosetinted = true,
        j_mf_rot_cartomancer = true,
        j_mf_sapling = true,
        j_mf_stonejokerjoker = true,
        j_mf_tonersoup = true,
        j_mf_unregisteredhypercam = true,
        j_mf_devilsknife = true,


        -- Specific reasons
        j_mf_complexity_creep = true, -- This might actually not need to be exempt, I just don't know how to deal with it
        j_mf_hyperjimbo = true, -- safeguard until I figure out what to do with this one
        j_mf_lollipop = true, -- I need to set up a system to deal with values in non extra table to make this work
        j_mf_sudoku = true, -- Table that holds values and a value called my_x_mult that idk what to do with, haha
        j_mf_teacup = true, -- removing value manip would potentially do weird things
        j_mf_wilddrawfour = true
    },

    -- Jokers that will need to have hardcoded exceptions
    -- j_mf_expansion_pack
    -- j_mf_philosophical
    -- j_mf_rainbowjoker
    
}
