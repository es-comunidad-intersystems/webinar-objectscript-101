Class demo.FuncionesFecha
{

/// Description
ClassMethod EjemploFechas() As %Status
{
    write $ZTIMESTAMP, ! // UTC
    write $HOROLOG, ! // Fecha / Hora del Sistema
    write $ZDATE($HOROLOG,3), !
    write $ZDATETIME($HOROLOG,3), !
    write $ZDATEH("2000-01-01",3), !
    write $ZDATETIMEH("2000-01-01 10:02:03",3), !
}

}
