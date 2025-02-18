return {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
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
