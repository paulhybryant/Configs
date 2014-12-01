/.*int64 \([a-zA-Z_][a-zA-Z_0-9]*\) *=.*/{
  s//  value->set_\1(int64_val)/
  h
  s/  value->set_//
  s/(int64_val)//
  s/[[:blank:]]*\([a-z][a-z0-9]*\)/\u\1/
  s/_\([a-z]\)/\u\1/g
  s/^/if (safe_strto64(columns[AF::k/
  s/$/FieldNumber - 1], \&int64_val)) {/
  G
  s/$/;\n}\n/p
}

/.*string \([a-zA-Z_][a-zA-Z_0-9]*\) *=.*/{
  s//value->set_\1(/
  h
  s/value->set_//
  s/(//
  s/[[:blank:]]*\([a-z][a-z0-9]*\)/\u\1/
  s/_\([a-z]\)/\u\1/g
  s/^/columns[AF::k/
  s/$/FieldNumber - 1]/
  x
  G
  s/\n//
  s/$/);\n/p
}
