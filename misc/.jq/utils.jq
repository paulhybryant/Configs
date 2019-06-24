# example: echo '{"foo": "bar"}' | jq 'include "utils"; . | hello'
def hello: {"hello": "world", "input": .};
def hello2: {"depth": 0, "input": .};
def hello3: ., if .input.foo == null then empty else {"depth": (.depth+1), "input": .input.foo}, hello3 end;
# .ncx.navMap | recurse(.navPoint[]?) | .navLabel.text
