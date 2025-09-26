return {
    'rcarriga/nvim-notify',
    lazy = false,
    opts = {
        fps = 60,
        timeout = 4000,
    },
    config = function(_, opts)
        local notify = require('notify')
        notify.setup(opts)
        vim.notify = notify
    end
}
