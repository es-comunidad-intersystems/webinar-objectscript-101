/// Clase Empleado
/// Un empleado es una persona...a veces
Class demo2.Empleado Extends demo2.Persona
{

Property Cargo As %String;

Property Responsable As demo2.Persona;

Relationship Departamento As demo2.Departamento [ Cardinality = one, Inverse = Empleados ];

Storage Default
{
<Data name="EmpleadoDefaultData">
<Subscript>"Empleado"</Subscript>
<Value name="1">
<Value>Cargo</Value>
</Value>
<Value name="2">
<Value>Responsable</Value>
</Value>
<Value name="3">
<Value>Departamento</Value>
</Value>
</Data>
<DefaultData>EmpleadoDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
