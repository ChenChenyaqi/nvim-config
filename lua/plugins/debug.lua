return {
  -- ========================================================================
  -- 1. Neotest: 测试运行主框架
  -- ========================================================================
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "marilari88/neotest-vitest",
    },
    -- 定义快捷键 (Lazy Load)
    keys = {
      {
        "<leader>ur",
        function()
          require("neotest").run.run()
        end,
        desc = "Run nearest test",
      },
      {
        "<leader>uf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run current file",
      },
      {
        "<leader>ud",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug nearest test",
      },
      {
        "<leader>uo",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "Show test output",
      },
      {
        "<leader>us",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle test summary",
      },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-vitest")({}),
        },
      })
    end,
  },

  -- ========================================================================
  -- 2. DAP: 核心调试功能 + UI 界面优化
  -- ========================================================================
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",

      -- ✨ 新增: 漂亮的调试界面 (变量区、堆栈区、控制台)
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
      },

      -- ✨ 新增: 在代码行旁边显示变量值 (Virtual Text)
      "theHamsta/nvim-dap-virtual-text",
    },

    -- 定义调试相关的快捷键
    keys = {
      -- 断点管理
      {
        "<leader>ub",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>uc",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "Clear All Breakpoints",
      },

      -- 调试流程控制 (习惯使用 F 键，也保留了 Leader 键位)
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Continue",
      },
      {
        "<leader>uC",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Continue",
      },

      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over",
      },
      {
        "<leader>uN",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over (Next)",
      },

      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into",
      },
      {
        "<leader>uI",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into",
      },

      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out",
      },
      {
        "<leader>uO",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out",
      },

      -- 手动开关 UI
      {
        "<leader>uu",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle Debug UI",
      },
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- === 1. 初始化 UI 和 Virtual Text ===
      dapui.setup() -- 默认布局已经很好了
      require("nvim-dap-virtual-text").setup({
        commented = true, -- 在注释位置显示变量值，不干扰代码
      })

      -- === 2. 自动化 UI：调试开始自动打开，结束自动关闭 ===
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- === 3. Mason 与 Adapter 配置 (保持之前的修复逻辑) ===
      require("mason").setup()
      require("mason-nvim-dap").setup({
        ensure_installed = { "js-debug-adapter" },
      })

      -- 动态查找路径的函数 (兼容 src 和 out)
      local function get_debugger_path()
        local mason_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"
        local candidates = {
          mason_path .. "/js-debug/out/src/dapDebugServer.js", -- 优先找编译后的
          mason_path .. "/js-debug/src/dapDebugServer.js", -- 其次找源码
        }
        for _, path in ipairs(candidates) do
          if vim.fn.filereadable(path) == 1 then
            return path
          end
        end
        return candidates[1] -- 默认回退
      end

      if not dap.adapters["pwa-node"] then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = { get_debugger_path(), "${port}" },
          },
        }
      end

      -- === 4. TypeScript/Vitest 调试规则 ===
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Current Test File",
            cwd = "${workspaceFolder}",
            program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
            args = { "run", "${file}" },
            autoAttachChildProcesses = true,
            smartStep = true,
            console = "integratedTerminal",
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Vitest (Watch)",
            cwd = "${workspaceFolder}",
            program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
            args = { "--inspect-brk", "--inspect", "${file}" },
            autoAttachChildProcesses = true,
            smartStep = true,
            console = "integratedTerminal",
          },
        }
      end

      -- === 5. 图标美化 ===
      local sign = vim.fn.sign_define

      -- 1. 正常断点 (红色圆点)
      sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })

      -- 2. 条件断点 (蓝色圆点)
      sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })

      -- 3. 日志断点 (绿色/其他色)
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

      -- 4. 程序暂停行 (黄色箭头 + 行高亮)
      sign("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

      -- 5. 🔥 修复 "R" 问题：拒绝断点 (灰色圆点或警告标)
      -- 当断点无法验证时（通常在调试刚启动还没加载源码时），显示这个图标
      sign("DapBreakpointRejected", { text = "", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

      -- === 6. 颜色高亮定义 (防止配色方案不支持) ===
      -- 如果你的主题没有定义这些组，这里强制设置一下颜色
      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939" }) -- 红
      vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef" }) -- 蓝
      vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379" }) -- 绿/黄
      vim.api.nvim_set_hl(0, "DapBreakpointRejected", { ctermbg = 0, fg = "#888888" }) -- 灰 (Rejected)
    end,
  },
}
