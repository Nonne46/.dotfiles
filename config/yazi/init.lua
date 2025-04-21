require("bunny"):setup({
	hops = {
		{ key = "r", path = "/" },
		{ key = "t", path = "/tmp" },
		{ key = { "h", "h" }, path = "~", desc = "Home" },
		{ key = { "h", "m" }, path = "~/Music", desc = "Music" },
		{ key = { "h", "d" }, path = "~/Downloads/", desc = "Downloads" },
		{ key = "c", path = "~/.config", desc = "Config files" },
		{ key = { "l", "s" }, path = "~/.local/share", desc = "Local share" },
		{ key = { "l", "b" }, path = "~/.local/bin", desc = "Local bin" },

		{ key = { "a" }, path = "/media/g/temp/РС/avaaa/", desc = "Avaaa" },

		-- Mounts
		{ key = { "m", "c" }, path = "/media/c", desc = "C drive" },
		{ key = { "m", "e" }, path = "/media/e", desc = "E drive" },
		{ key = { "m", "g" }, path = "/media/g", desc = "G drive" },
		{ key = { "m", "h" }, path = "/media/h", desc = "H drive" },
		{ key = { "m", "t" }, path = "/media/tamikuru_nfs", desc = "Tamikuru NFS" },
	},
	desc_strategy = "path",
	notify = false,
	fuzzy_cmd = "fzf",
})
