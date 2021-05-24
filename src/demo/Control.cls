Class demo.Control
{

/// Description
ClassMethod EjemploIf(a As %Integer)
{
    if a=1 {
        write "a es 1",!
    } elseif a=2 {
        write "a es 2",!
    } else {
        write "En otro caso",!
    }

    set b = $CASE(a,1:"b es uno",2:"b es dos",:"b es otro")
    write b, !

    set c = $SELECT(a=1:"c es uno",a=2:"c es dos",1:"c es otro")
    write c, !
}

/// Description
ClassMethod EjemploBucle(hasta As %Integer)
{
    set iterador = 1
    while iterador < hasta {
        write "ejecución "_iterador,!
        // do $i(iterador)
        set iterador = iterador + 1
    }

    do {
        write "ejecución "_iterador,!
        set iterador = iterador - 1
    } While (iterador>0)

    for iterador=1:2:10 {
        write "ejecución For "_iterador,!
    }
}

/// Quit versus return
ClassMethod quit1() As %Integer
{
    for iterador=1:1:10 {
        write "ejecución For "_iterador,!
        if (iterador=5) quit
    }
    write "aun no terminamos",!
    return 0
}

}
