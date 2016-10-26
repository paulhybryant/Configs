BEGIN {
  FS="|"
}
{
  if ( NF < 44 ) {
    print
    print NR
  }
}
