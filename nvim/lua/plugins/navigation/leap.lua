return {
    'ggandor/leap.nvim',
    enabled = false,
    event = { 'LazyFileOpen', 'BufNewFile' },
    config = function()
        require('leap').create_default_mappings()
    end
}
