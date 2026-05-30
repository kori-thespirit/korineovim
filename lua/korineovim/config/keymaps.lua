vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move this line below in visual mode' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move this line above in visual mode' })


-- Navigate split view
vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = 'Move to lower window'})
vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = 'Move to upper window'})
vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = 'Move to left window'})
vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = 'Move to right window'})

-- Resize split windows 
vim.keymap.set("n", "<c-up>","<c-w>+", { desc = 'Expand horizontal of current window'})
vim.keymap.set("n", "<c-down>","<c-w>-", { desc = 'Shrink horizontal line of current window'})
vim.keymap.set("n", "<c-left>","<c-w>>", { desc = 'Expand vertical of current window'})
vim.keymap.set("n", "<c-right>","<c-w><", { desc = 'Shrink vertical line of current window'})

vim.keymap.set("n", "<S-h>",":bprev<CR>", { desc = 'To previous buffer'})
vim.keymap.set("n", "<S-l>",":bnext<CR>", { desc = 'To next buffer'})
-- Buffer manipulator
vim.keymap.set("n", "<leader>bd",":ls<CR>:bdelete", { desc = 'List buffers to delete'})
vim.keymap.set("n", "<leader>bl",":ls<CR>:b", { desc = 'List buffers to switch'})

-- Terminal manipulator
vim.keymap.set("n", "<leader>tu",":terminal<CR>", { desc = 'Open terminal above'})
vim.keymap.set("n", "<leader>tb",":below terminal<CR>", { desc = 'Open terminal below'})
vim.keymap.set("n", "<leader>tr",":vertical rightbelow terminal<CR>", { desc = 'Open terminal on the left'})
vim.keymap.set("n", "<leader><Tab>t",":tab terminal<CR>", { desc = 'Open terminal in the new tab'})

-- Tab window manipulation
vim.keymap.set("n", "<leader><Tab>o",":tabnew<CR>", { desc = 'Open new tab'})
vim.keymap.set("n", "<leader><Tab>h",":tabprevious<CR>", { desc = 'Switch to previous tab'})
vim.keymap.set("n", "<leader><Tab>l",":tabnext<CR>", { desc = 'Switch to next tab'})
vim.keymap.set("n", "<leader><Tab>x",":tabclose<CR>", { desc = 'Close current tab'})
vim.keymap.set("n", "<leader><Tab>0",":tabfirst<CR>", { desc = 'Move to first tab'})
vim.keymap.set("n", "<leader><Tab>$",":tablast<CR>", { desc = 'Move to tab last'})
vim.keymap.set("n", "<leader>vb","<c-v><CR>", { desc = 'Visual Block mode'})
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>\\2/",":%s/\\///g<CR>", { desc = 'Convert \\ to / path'})
vim.keymap.set("n", "<leader>p","a \\<Esc>v\"0p", { desc = 'Add a space then yanked text at the end of the word'})
vim.keymap.set("n", "<leader>P","\"0Pa <Esc>", { desc = 'Add a space then yanked text at the begining of line'})
vim.keymap.set("n", "<leader>,","a, \\<Esc>v\"0p", { desc = 'Add a comma and space before pasting the yanked text'})
-- " Move the cursor to the new line below before pasting the yanked text
vim.keymap.set("n", "<leader>*20",":let @* = @0<CR>", { desc = 'Copy from persistent register(0) to clipboard register (*)'})
vim.keymap.set("n", "<leader>02*",":let @0 = @*<CR>", { desc = 'Copy from clipboard register (*) to persistent register(0)'})
vim.keymap.set("n", "p","]p", { desc = 'Paste text auto indent below'})
vim.keymap.set("n", "P","[p", { desc = 'Paste text auto indent above'})
-- nnoremap <leader><Enter>p o<Esc>0"0p
-- nnoremap  :let @0 = @*<CR>
-- "" Copy from persistent register(0) to clipboard register (*)
-- nnoremap <leader>02* :let @* = @0<CR>

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlights text when yanking",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
