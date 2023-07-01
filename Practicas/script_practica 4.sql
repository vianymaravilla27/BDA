CREATE TABLE personas (
RFC CHAR(13) PRIMARY KEY,
Nombre VARCHAR(30) NOT NULL,
Apellidos VARCHAR(30) NOT NULL,
CV XMLType);

INSERT INTO personas VALUES ('PELJ900304JJ6', 'Juan', 'Pérez López', XMLType('<curriculum_vitae><empleos><empleo><empresa>Fábricas de Cartón</empresa><periodo>junio/2011-enero/2017</periodo></empleo><empleo><empresa>Comercializadora Internacional</empresa><periodo>marzo/2017-febrero/2020</periodo></empleo></empleos><formacion><secundaria>Heroes de Nacozari</secundaria><medio_superior><escuela>Escuela preparatoria No.5 </escuela><comprobante>certificado</comprobante></medio_superior></formacion></curriculum_vitae>'));
INSERT INTO personas VALUES ('CACM871109LI8', 'Martha', 'Carbajal Carbajal', XMLType('<curriculum_vitae><empleos><empleo><empresa>Comercializadora de Ropa del Centro </empresa><periodo>abril/2010-enero/2011</periodo></empleo> <empleo><empresa>Refacciones para Autobuses S.A.</empresa><periodo>febrero/2011-febrero/2012</periodo></empleo></empleos><formacion><secundaria>Independencia</secundaria><medio_superior><escuela>Vocacional No. 3 </escuela><comprobante>certificado</comprobante></medio_superior><superior><escuela>Escuela Internacional de Comercio C.V.</escuela><comprobante>titulo profesional</comprobante></superior></formacion></curriculum_vitae>'));
INSERT INTO personas VALUES ('CALJ851211K9O', 'Juan Manuel', 'Camacho López', XMLType('<curriculum_vitae><empleos><empleo><empresa>Banca de Desarrollo Empresarial </empresa><periodo>diciembre/2005-mayo/2009</periodo></empleo> <empleo><empresa>Asesores Fiscales S.A.</empresa><periodo>julio/2009-marzo/2012</periodo></empleo></empleos><formacion><secundaria>Marruecos</secundaria><medio_superior><escuela>Escuela Comercial y Contable </escuela><comprobante>certificado</comprobante></medio_superior></formacion></curriculum_vitae>'));
INSERT INTO personas VALUES ('MEGR910508PY3', 'Rodrigo', 'Medina García', XMLType('<curriculum_vitae><empleos><empleo><empresa>Armadora de Motores Nacionales </empresa><periodo>abril/2010-junio/2012</periodo></empleo></empleos><formacion><secundaria>Vasco de Quiroga</secundaria></formacion></curriculum_vitae>'));
COMMIT;
SELECT * FROM personas;
SELECT XMLColattval(p.apellidos) FROM personas p;
SELECT p.nombre || ' ' || p.apellidos AS persona, EXTRACT(p.cv, '//empresa').getstringval() AS RESULT FROM personas p WHERE p.nombre LIKE '%Martha%';
SELECT p.nombre || ' ' || p.apellidos AS persona, EXTRACTVALUE(p.cv,'//empresa[contains(.,"S.A.")]') AS RESULT FROM personas p;
SELECT p.nombre || ' ' || p.apellidos AS persona, EXTRACTVALUE(p.cv, '//empresa[contains(.,"S.A.")]') AS RESULT FROM personas p WHERE EXISTSNODE(p.cv, '//empresa[contains(.,"S.A.")]') = 1;
SELECT p.nombre || ' ' || p.apellidos AS persona, EXTRACT(p.cv, '//medio_superior/escuela/text() | //superior/escuela/text()').getstringval() AS RESULT FROM personas p WHERE EXISTSNODE(p.cv, '//medio_superior/comprobante | //superior/comprobante') = 1;
SELECT p.nombre || ' ' || p.apellidos AS persona, EXTRACT(p.cv, '//empleos/empleo/empresa/text()').getstringval() AS RESULT FROM personas p WHERE EXISTSNODE(p.cv, '//empleos[count(empleo)>1]') = 1;
SELECT p.rfc, p.nombre || ' ' || p.apellidos AS persona, EXTRACT(p.cv, '//comprobante').getstringval() AS RESULT FROM personas p WHERE p.nombre LIKE '%Martha%';
UPDATE personas p SET p.cv = updateXML(p.cv, '//medio_superior/comprobante', '<comprobante>diploma</comprobante>') WHERE p.rfc = 'CACM871109LI8';
SELECT p.rfc, p.nombre || ' ' || p.apellidos AS persona, EXTRACT(p.cv, '//comprobante').getstringval() AS RESULT FROM personas p WHERE p.nombre LIKE '%Martha%';
UPDATE personas p SET p.cv = deleteXML(p.cv, '//medio_superior/comprobante["diploma"]') WHERE p.rfc = 'CACM871109LI8';
SELECT p.rfc, p.nombre || ' ' || p.apellidos AS persona, EXTRACT(p.cv, '//comprobante').getstringval() AS RESULT FROM personas p WHERE p.nombre LIKE '%Martha%';
CREATE TABLE empleados_xml OF XMLType;
SELECT TABLE_NAME FROM USER_XML_TABLES;
CREATE OR REPLACE DIRECTORY REPOSITORIO AS 'c:\repositorio'; 
INSERT INTO empleados_xml VALUES (XMLType(BFILENAME('REPOSITORIO', 'empleados.xml'), NLS_CHARSET_ID('AL32UTF16')));
SET PAGESIZE 500;
SET LINESIZE 300;
SET LONG 2000;
COLUMN RESULT FORMAT A300;
SELECT * FROM empleados_xml;
SELECT XMLRoot(e.OBJECT_VALUE, VERSION '1.0', STANDALONE YES) FROM empleados_xml e;
SELECT EXTRACT(e.OBJECT_VALUE, '/empleados/empleado/paterno').getstringval() AS res FROM empleados_xml e;
SELECT EXTRACTVALUE(e.OBJECT_VALUE, '/empleados/empleado[@id=101]/paterno') AS res FROM empleados_xml e;
SELECT EXTRACT(e.OBJECT_VALUE, '/empleados/empleado[sexo="F"]/nombre').getstringval() FROM empleados_xml e;
SELECT EXTRACT(e.OBJECT_VALUE, '/empleados/empleado[sexo="F"]/nombre').getstringval() FROM empleados_xml e WHERE existsNode(OBJECT_VALUE, '//proy') = 1;
SELECT EXTRACT(e.OBJECT_VALUE, '//empleado[sexo="F" and edad>="30"]/nombre').getstringval() FROM empleados_xml e;
SELECT XMLSerialize(DOCUMENT e.OBJECT_VALUE AS CLOB) AS XML FROM empleados_xml e;


--------------------------- Esta es la sentencia buena (43) -------------------------------------
DECLARE
res BOOLEAN;
empsxmlstring VARCHAR(4000) := '';
deptsxmlstring VARCHAR(4000) := '';
begin
empsxmlstring := empsxmlstring || '<?xml version="1.0"?><empleados><empleado NSS="777888999" departamento="3"><nombre>Jesús</nombre><apellido>López</apellido><fecha_nac>1973-04-04</fecha_nac><direccion>Calle Venus 45, col. Irrigación,Ecatepec,89765</direccion><genero>M</genero><salario>50000</salario><titulo>Ingeniero</titulo><fecha_ingreso>2000-04-05</fecha_ingreso></empleado>';
empsxmlstring := empsxmlstring || '<empleado NSS="222333444 " Jefe="777888999" departamento="3"><nombre>Guadalupe</nombre><apellido>Oñate</apellido><fecha_nac>1969-11-24</fecha_nac><direccion>Av.Revolución 348, col. Fuentes, San Ignacio, 67656</direccion><genero>F</genero><salario>25000</salario><titulo>Licenciado</titulo><fecha_ingreso>2000-04-07</fecha_ingreso></empleado>';
empsxmlstring := empsxmlstring || '<empleado NSS="444555666" Jefe="111222333" departamento="1"><nombre>Julia</nombre><apellido>Regalado</apellido><fecha_nac>1975-07-30</fecha_nac><direccion>Calle cielo 76, col. Independencia, Tepeji, 34256</direccion><genero>F</genero><salario>28000</salario><titulo>Ingeniero</titulo><fecha_ingreso>2001-06-28</fecha_ingreso></empleado>';
empsxmlstring := empsxmlstring || '<empleado NSS="555666777" Jefe="777888999" departamento="3"><nombre>Mario</nombre><apellido>Medina</apellido><fecha_nac>1977-10-01</fecha_nac><direccion>Av.Politécnico 650, col. Profesiones, CDMX, 09765</direccion><genero>M</genero><salario>20000</salario><titulo>Licenciado</titulo><fecha_ingreso>2100-05-30</fecha_ingreso></empleado>';
empsxmlstring := empsxmlstring || '<empleado NSS="333444555" departamento="2"><nombre>Rogelio</nombre><apellido>Calzada</apellido><fecha_nac>1965-03-25</fecha_nac><direccion>Av.Independencia 123, col. Fuentes, San Ignacio, 56565</direccion><genero>M</genero><salario>39000</salario><titulo>Licenciado</titulo><fecha_ingreso>2000-04-05</fecha_ingreso></empleado>';
empsxmlstring := empsxmlstring || '<empleado NSS="666777888" Jefe="111222333" departamento="1"><nombre>Bruce</nombre><apellido>Bolaños</apellido><fecha_nac>1963-08-07</fecha_nac><direccion>Mar Mediterráneo 56, col. Lomas Lindas, CDMX, 09879</direccion><genero>M</genero><salario>24000</salario><titulo>Licenciado</titulo><fecha_ingreso>2100-12-17</fecha_ingreso></empleado>';
empsxmlstring := empsxmlstring || '<empleado NSS="999000111" Jefe="333444555" departamento="2"><nombre>Laura</nombre><apellido>Méndez</apellido><fecha_nac>1982-02-20</fecha_nac><direccion>Av.Montevideo 98, col. Ampliación Hidalgo, Texcoco, 45679</direccion><genero>F</genero><salario>18000</salario><titulo>Ingeniero</titulo><fecha_ingreso>2100-12-20</fecha_ingreso></empleado>';
empsxmlstring := empsxmlstring || '<empleado NSS="111222333" departamento="1"><nombre>Sandra</nombre><apellido>Guzmán</apellido><fecha_nac>1970-11-27</fecha_nac><direccion>Av.Siempreviva 444, col. San Mateo, Ecatepec, 89740</direccion><genero>F</genero><salario>45000</salario><titulo>Ingeniero</titulo><fecha_ingreso>2000-04-05</fecha_ingreso></empleado>';
empsxmlstring := empsxmlstring || '<empleado NSS="888999000" Jefe="333444555" departamento="2"><nombre>Guadalupe</nombre><apellido>Hidalgo</apellido><fecha_nac>1985-03-19</fecha_nac><direccion>Av.Miguel Hidalgo 56, col. Independencia, Tepeji, 87981</direccion><genero>F</genero><salario>27000</salario><titulo>Ingeniero</titulo><fecha_ingreso>2001-10-11</fecha_ingreso></empleado></empleados>';
deptsxmlstring := deptsxmlstring || '<?xml version="1.0"?><departamentos><departamento numero="1" Jefe="111222333"><nombre>Sistemas</nombre><fecha_inicio>2003-03-08</fecha_inicio><fecha_fin></fecha_fin></departamento><departamento numero="2" Jefe="333444555"><nombre>Ventas</nombre><fecha_inicio>2001-11-11</fecha_inicio><fecha_fin></fecha_fin></departamento><departamento numero="3" Jefe="777888999"><nombre>Administración</nombre><fecha_inicio>2000-07-03</fecha_inicio><fecha_fin></fecha_fin></departamento></departamentos>';
res := DBMS_XDB.createResource('/public/empleados.xml', empsxmlstring);
res := DBMS_XDB.createResource('/public/departamentos.xml', deptsxmlstring);
end;
/
COMMIT;

--------------------------------------- Aqui termina la sentencia 43 ---------------------------------------------------------------------------------

SELECT XMLQuery('for $e in doc("/public/empleados.xml")/empleados/empleado let $d := doc("/public/departamentos.xml")//departamento[@numero = $e/@departamento]/nombre return <empleado nombre="{$e/nombre}" departamento="{$d}"/>' RETURNING CONTENT) AS RESULT FROM DUAL;
SELECT XMLQuery('for $e in doc("/public/empleados.xml")/empleados/empleado let $d := doc("/public/departamentos.xml")//departamento[@numero = $e/@departamento]/nombre where $e/salario > 10000 order by $e/@NSS return <empleado nombre="{$e/nombre} {$e/apellido}"/>' RETURNING CONTENT) AS RESULT FROM DUAL;
SELECT XMLQuery('for $d in doc("/public/departamentos.xml")/departamentos/departamento/@numero let $e := doc("/public/empleados.xml")/empleados/empleado[@departamento = $d] where count($e) > 1 order by avg($e/salario) descending return <departamento>{$d}<conteo>{count($e)}</conteo><promediosal>{round(avg($e/salario))}</promediosal></departamento>' RETURNING CONTENT) AS RESULT FROM DUAL;
SELECT XMLQuery('for $e in doc("/public/empleados.xml")/empleados/empleado let $d := doc("/public/departamentos.xml")//departamento[@numero = $e/@departamento]/nombre where $e/salario > 30000 order by $e/@NSS return <empleado NSS="{$e/@NSS}" nombre="{$e/nombre} {$e/apellido}" salario="{$e/salario}"/>' RETURNING CONTENT) AS RESULT FROM DUAL;
BEGIN
DBMS_XDB.deleteResource('/public/empleados.xml');
DBMS_XDB.deleteResource('/public/departamentos.xml');
END;
/
COMMIT;
