return {
  {
    "mfussenegger/nvim-dap",

    -- Make sure this runs AFTER powershell.nvim
    dependencies = {
      "TheLeoP/powershell.nvim",
    },

    config = function(_, _)
      local dap = require("dap")

      -- Ensure table exists
      dap.configurations.ps1 = dap.configurations.ps1 or {}

      -- Avoid duplicates on reload
      for _, cfg in ipairs(dap.configurations.ps1) do
        if cfg.name == "PowerShell: Launch Current File (with args)" then
          return
        end
      end

      table.insert(dap.configurations.ps1, {
        name = "PowerShell: Launch Current File (with args)",
        type = "ps1",
        request = "launch",

        script = "${file}",
        cwd = "${workspaceFolder}",

        args = function()
          local input = vim.fn.input("PowerShell args: ")
          if input == "" then
            return {}
          end
          return vim.split(input, " ")
        end,
      })
    end,
  },
}
