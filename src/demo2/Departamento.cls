/// Clase Departamento
Class demo2.Departamento Extends %Persistent
{

Property Nombre As %String;

Relationship Empleados As demo2.Empleado [ Cardinality = many, Inverse = Departamento ];

Storage Default
{
<Data name="DepartamentoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nombre</Value>
</Value>
</Data>
<DataLocation>^demo2.DepartamentoD</DataLocation>
<DefaultData>DepartamentoDefaultData</DefaultData>
<IdLocation>^demo2.DepartamentoD</IdLocation>
<IndexLocation>^demo2.DepartamentoI</IndexLocation>
<StreamLocation>^demo2.DepartamentoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
