local BoardStates = {
    ---Score = Locations where the Score is calculated
    ---NextState(key) = the keys represent the playable Locations on the Board
    ---NextState(value) = if a domino is played on the Location in the Key, the Value is the next State
    StartWithSpinner = {
        Score = {},
        NextState = {
            Spinner="Spinner"
        }
    },
    StartWithAny = {
        Score = {},
        NextState = {
            Spinner="Spinner",
            North="North"
        }
    },
    Spinner = {
        Score = {
            "Spinner"
        },
        NextState = {
            North="SpinnerNorth"
        }
    },
    North = {
        Score = {
            "North"
        },
        NextState = {
            Spinner="SpinnerNorth",
            North="North",
            South="North"
        }
    },
    SpinnerNorth = {
        Score = {
            "Spinner","North"
        },
        NextState = {
            North="SpinnerNorth",
            South="South"
        }
    },
    South = {
        Score = {
            "North","South"
        },
        NextState = {
            North="South",
            South="South",
            East="East",
            West="West"
        }
    },
    East = {
        Score = {
            "North","South","East"
        },
        NextState = {
            North="East",
            South="East",
            East="East",
            West="West"
        }
    },
    West = {
        Score = {
            "North","South","West"
        },
        NextState = {
            North="West",
            South="West",
            East="East",
            West="West"
        }
    },
    Full = {
        Score = {
            "North","South","East","West"
        },
        NextState = {
            North="Full",
            South="Full",
            East="Full",
            West="Full"
        }
    },
}

return BoardStates