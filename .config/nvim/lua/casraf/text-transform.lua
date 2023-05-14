local function into_words(str)
  local words = {}
  local word = ""

  for i = 1, #str do
    local char = str:sub(i, i)
    -- split on uppercase letters
    if char:match("%u") then
      if word ~= "" then
        table.insert(words, word)
      end
      word = char
      -- split on underscores, hyphens, and spaces
    elseif char:match("[%_%-%s]") then
      if word ~= "" then
        table.insert(words, word)
      end
      word = ""
    else
      word = word .. char
    end
  end
  if word ~= "" then
    table.insert(words, word)
  end
  return words
end

function IntoWords(string) print(vim.inspect(into_words(string))) end

function CamelCase(string)
  local words = into_words(string)
  local camel_case = ""
  for i, word in ipairs(words) do
    if i == 1 then
      camel_case = camel_case .. word
    else
      camel_case = camel_case .. word:gsub("^%l", string.upper)
    end
  end
  return camel_case
end

function SnakeCase(string)
  local words = into_words(string)
  local snake_case = ""
  for i, word in ipairs(words) do
    if i == 1 then
      snake_case = snake_case .. word:lower()
    else
      snake_case = snake_case .. "_" .. word:lower()
    end
  end
  return snake_case
end

function PascalCase(string)
  local words = into_words(string)
  local pascal_case = ""
  for _, word in ipairs(words) do
    pascal_case = pascal_case .. word:gsub("^%l", string.upper)
  end
  return pascal_case
end

function KebabCase(string)
  local words = into_words(string)
  local kebab_case = ""
  for i, word in ipairs(words) do
    if i == 1 then
      kebab_case = kebab_case .. word:lower()
    else
      kebab_case = kebab_case .. "-" .. word:lower()
    end
  end
  return kebab_case
end

function DotCase(string)
  local words = into_words(string)
  local dot_case = ""
  for i, word in ipairs(words) do
    if i == 1 then
      dot_case = dot_case .. word:lower()
    else
      dot_case = dot_case .. "." .. word:lower()
    end
  end
  return dot_case
end

function TitleCase(string)
  local words = into_words(string)
  local title_case = ""
  for i, word in ipairs(words) do
    title_case = title_case .. word:gsub("^%l", string.upper)
    if i ~= #words then
      title_case = title_case .. " "
    end
  end
  return title_case
end

function ReplaceCurrentSelection(transform)
  local selection = vim.fn.getline("'<", "'>")
  local transformed = transform(selection)
  vim.fn.setline("'<", transformed)
end

function ReplaceCurrentWord(transform)
  local word = vim.fn.expand("<cword>")
  local transformed = transform(word)
  vim.cmd("normal ciw" .. transformed)
end

-- use input from current word in editor
vim.cmd('amenu Transforms.&camelCase :lua ReplaceCurrentWord(CamelCase)<CR>')
vim.cmd('amenu Transforms.&snake_case :lua ReplaceCurrentWord(SnakeCase)<CR>')
vim.cmd('amenu Transforms.&PascalCase :lua ReplaceCurrentWord(PascalCase)<CR>')
vim.cmd('amenu Transforms.&kebab-case :lua ReplaceCurrentWord(KebabCase)<CR>')
vim.cmd('amenu Transforms.&dot\\.case :lua ReplaceCurrentWord(DotCase)<CR>')
vim.cmd('amenu Transforms.&Title\\ Case :lua ReplaceCurrentWord(TitleCase)<CR>')

vim.keymap.set({"n", "v"}, "<leader>~", "<cmd>popup Transforms<CR>", { silent = true })
