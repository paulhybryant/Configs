/^-/ {
  sum += $5
  ++filenum
}

END {
  if (filenum > 0) {
    split("B KB MB GB TB PB", type)
    for(i = 5; y < 1; i--)
      y = sum / (2**(10*i))
    printf("Total (files only) %.1f %s, %d files.\n", y, type[i+2], filenum)
  }
}
