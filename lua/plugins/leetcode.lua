return {
  	{
	    "kawre/leetcode.nvim",
	    build = ":TSUpdate html", -- 若有nvim-treesitter则执行
	    dependencies = {
	        "nvim-lua/plenary.nvim",
	        "MunifTanjim/nui.nvim",
	    },
	    opts = {
	        lang = "golang", -- 默认编程语言
                 cn = { -- leetcode.cn
                      enabled = true, ---@type boolean
                      translator = true, ---@type boolean
                      translate_problems = true, ---@type boolean
              },
	    },
	}
}
