# Vim like
percol.import_keymap({
    "C-n" : lambda percol: percol.command.select_next(),
    "C-p" : lambda percol: percol.command.select_previous(),
    "C-d" : lambda percol: percol.command.select_next_page(),
    "C-u" : lambda percol: percol.command.select_previous_page(),
    "C-m" : lambda percol: percol.finish(),
})

percol.view.__class__.PROMPT = property(
    lambda self:
    ur"<bold><blue>QUERY </blue>[a]:</bold> %q" if percol.model.finder.case_insensitive
    else ur"<bold><green>QUERY </green>[A]:</bold> %q"
)
percol.view.prompt_replacees["F"] = lambda self, **args: self.model.finder.get_name()
percol.view.RPROMPT = ur"(%F) [%i/%I]"
