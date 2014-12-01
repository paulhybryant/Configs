/^-/ {sum += $5}
{print}

END {
  if (sum > 0) {
    split("B KB MB GB TB PB", type)
    for(i = 5; y < 1; i--)
      y = sum / (2**(10*i))
    printf("total %.1f %s (not including sub directories).\n", y, type[i+2])
  }
}
