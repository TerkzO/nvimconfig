return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    -- local utils = require("utils")
    _Gopts = {
      position = "center",
      hl = "Type",
      wrap = "overflow",
    }

    -- 获取目录中所有lua文件
    local function get_all_files_in_dir(dir)
      local files = {}
      local scan = vim.fn.globpath(dir, "**/*.lua", true, true)
      for _, file in ipairs(scan) do
        table.insert(files, file)
      end
      return files
    end

    -- 加载随机头部图
    local function load_random_header()
      math.randomseed(os.time())
      -- 头部文件路径
      local header_folder = "/home/L1nx32b/.config/nvim/lua/plugins/logo"
      local files = get_all_files_in_dir(header_folder)

      if #files == 0 then
        return nil
      end

      local random_file = files[math.random(#files)]
      -- vim.notify(random_file)
      local relative_path = random_file:sub(#header_folder + 1)
      local module_name = "plugins.logo" .. relative_path:gsub("/", "."):gsub("\\", "."):gsub("%.lua$", "")

      package.loaded[module_name] = nil

      local ok, module = pcall(require, module_name)
      if ok and module then
        -- vim.notify(module)
        return module
      else
        return nil
      end
    end

    local function change_header()
      local new_header = load_random_header()
      if new_header then
        dashboard.config.layout[2] = new_header
        vim.cmd("AlphaRedraw")
      else
        print("No images inside header_img folder.")
      end
    end

    local header = load_random_header()
    if header then
      dashboard.config.layout[2] = header
    else
      print("No images inside header_img folder.")
    end

    -- dashboard.section.tasks = {
    --   type = "text",
    --   val = utils.get_today_tasks(),
    --   opts = {
    --     position = "center",
    --     hl = "Comment",
    --     width = 50,
    --   },
    -- }
    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find File", "<cmd> lua LazyVim.pick() <cr>"),
      dashboard.button("n", "  New File", "<cmd> ene | startinsert <cr>"),
      dashboard.button("g", "  Find Text", "<cmd> lua LazyVim.pick('live_grep') <cr>"),
      dashboard.button("r", "  Recent Files", "<cmd> lua LazyVim.pick('oldfiles') <cr>"),
      dashboard.button("c", "  Config", "<cmd> lua LazyVim.pick.config_files() <cr>"),
      dashboard.button("s", "  Restore Session", "<cmd> lua require('persistence').load() <cr>"),
      dashboard.button("L", "󰒲  Lazy", "<cmd> Lazy <cr>"),
      dashboard.button("q", "  Quit", "<cmd> qa <cr>"),
    }

    -- 设置按钮之间的间距 (对应 snacks 的 gap = 1)
    -- dashboard.section.buttons.opts.spacing = 1
    dashboard.config.layout = {
      -- 头部字符画
      -- img2art - 将png图片转化为ascii
      -- img2art .\116603054_p0.jpg  --scale 0.03  --threshold 50  --save-raw ./test.lua --alpha
      -- function: 将本地图片解析完之后，转换成开箱即用的lua格式并保存在本地
      -- –scale 姑且理解为缩放值，浮点数，调整以确保能适配你的neovim主页
      -- –threshold 这是一个色彩相关的数据，调整以确保生成满足你色彩需求的图片
      -- 剩余的指令就是生成适合alpha配置的dashboard图片标题信息的结构体lua文件
      header,
      { type = "padding", val = 1 }, -- 空格栏隔开内容
      {
        type = "group",
        val = {
          -- {
          --   type = "group",
          --   val = {
          --     {
          --       type = "text",
          --       val = "📅 Tasks for today",
          --       opts = { hl = "Keyword", position = "center" },
          --     },
          --     dashboard.section.tasks,
          --   },
          --   opts = { spacing = 1 },
          -- },
          {
            type = "group",
            val = dashboard.section.buttons.val, -- 快捷菜单
            opts = { spacing = 1 },
          },
        },
        opts = {
          layout = "horizontal",
        },
      },
      dashboard.section.footer,
    }

    -- 4. 底部启动时间统计 (对应 snacks 的 startup)
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      desc = "Add Alpha dashboard footer",
      once = true,
      callback = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
        dashboard.section.footer.val = {
          " ",
          " ",
          " ",
          " Loaded " .. stats.count .. " plugins  in " .. ms .. " ms ",
        }
        dashboard.section.footer.opts.hl = "DashboardFooter"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)
  end,
}

