#!/usr/bin/awk -f

function eval(code) {
    input=sprintf("%s", code)
    cmd=sprintf("awk 'BEGIN {%s}'", input)
    errorlevel=system(cmd)
    return errorlevel
}

BEGIN {
    #Example
    s="print 10+10"
    print eval(s)
}
