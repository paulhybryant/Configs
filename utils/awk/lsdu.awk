/^-/ {
  sum += $5
  ++filenum
  print
}

END {
  if (filenum > 0) {
    split("B KB MB GB TB PB", type)
    for(i = 5; y < 1; i--)
      y = sum / (2**(10*i))
    printf("total %.1f %s, %d files.\n", y, type[i+2], filenum)
  }
}
