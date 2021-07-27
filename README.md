# Footprints plugin for vim.
TODO: Readme

TODO: terminal colors

TODO: enabled by default param

Bug: :FootprintsDisable then :FootprintsEnable then :FootprintsDisable. it's not disabled
TODO: 
:for m in filter(getmatches(), { i, v -> l:v.group is? 'TODO' })
:  call matchdelete(m.id)
:endfor
