return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  opts = {
    -- Default values: Range
    stiffness = 0.7,                      -- 0.6      [0, 1]
    trailing_stiffness = 0.52,             -- 0.45     [0, 1]
    stiffness_insert_mode = 0.60,          -- 0.5      [0, 1]
    trailing_stiffness_insert_mode = 0.60, -- 0.5      [0, 1]
    damping = 1,                       -- 0.85     [0, 1]
    damping_insert_mode = 1,           -- 0.9      [0, 1]
    distance_stop_animating = 0.1,        -- 0.1      > 0

    smear_insert_mode = true,
    smear_between_neighbor_lines = true,
    smear_between_buffers = true,
  },
}
