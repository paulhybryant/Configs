BEGIN {
  FS = ","
}

{
  temp=$opos
  $opos=$npos
  $npos=temp
}
{print}
