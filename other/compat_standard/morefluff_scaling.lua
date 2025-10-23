-- This standard is specifically to set up proper compat for scaling jokers from the MoreFluff mod
Blockbuster.ValueManipulation.CompatStandard{
    key = "morefluff_scaling",
    variable_conventions = {

        full_vars = {
            "x_mult",
            "xchips",
            "mult",
            "chips",
            "odds",
        },

        ends_on = {
        },

        starts_with = {
        }
    },

    integer_only_variable_conventions = {
        full_vars = {
        },
        ends_on = {
        },
        starts_with = {
        },
    },

    variable_caps = {
        retriggers = 25,
        repetitions = 25,
    },
    min_max_values = {min = 0, max = 25}, 
    exempt_jokers = {
        
    },
}
