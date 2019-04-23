/* POWERED BY SEBASTIAN BONATO */

/* CREACION DE LAS DIFERENTES TABLAS */
CREATE TYPE tipoSector AS ENUM('Administracion','ServicioHabitacion','Recepcionista','Botones');
CREATE TABLE empleado (
	dni INTEGER NOT NULL,
	nombre VARCHAR(30) NOT NULL,
	apellido VARCHAR(30) NOT NULL,
	sector tipoSector,
	domicilio VARCHAR(30) NOT NULL,
	telefono INTEGER NOT NULL,
	mail VARCHAR NOT NULL,
	salario FLOAT NOT NULL,
	fechaA DATE NOT NULL,
	fechaB DATE,
	CONSTRAINT pk_id_empleado PRIMARY KEY(dni)
	
);

CREATE TABLE prenda (
	id_prenda INTEGER NOT NULL,
	stock INTEGER NOT NULL,
	fechaAlta DATE NOT NULL,
	fechaBaja DATE,
	CONSTRAINT pk_id_prenda PRIMARY KEY(id_prenda),
	CONSTRAINT fk_stock FOREIGN KEY(stock) REFERENCES stock(id_stock)
);

CREATE TABLE tipoPrenda(
	id_tipoPrenda INTEGER NOT NULL,
	prenda VARCHAR(30) NOT NULL,
	CONSTRAINT pk_tipoPrenda PRIMARY KEY(id_tipoPrenda)
);

CREATE TABLE genero(
	id_genero INTEGER NOT NULL,
	genero VARCHAR(30) NOT NULL,
	CONSTRAINT pk_id_genero PRIMARY KEY(id_genero)

);

CREATE TABLE talle (
	id_talle INTEGER NOT NULL,
	talle VARCHAR(30) NOT NULL,
	CONSTRAINT pk_id_talle PRIMARY KEY(id_talle)
);

CREATE TYPE tipoUbicacion AS ENUM('Lavanderia', 'Planchado', 'GuardaRopa');
CREATE TABLE ubicacion(
	id_ubicacion INTEGER NOT NULL,
	ubicacionActual tipoUbicacion,
	fecha DATE NOT NULL,
	hora TIME NOT NULL,
	empleadoRet INTEGER,
	empleadoDev INTEGER,
	CONSTRAINT pk_id_ubicacion PRIMARY KEY(id_ubicacion),
	CONSTRAINT fk_empleadoRet FOREIGN KEY(empleadoRet) REFERENCES empleado (dni),
	CONSTRAINT fk_empleadoDev FOREIGN KEY(empleadoDev) REFERENCES empleado (dni)
);

CREATE TABLE stock(
	id_stock INTEGER NOT NULL,
	cantidad INTEGER NOT NULL,
	cantidadMin INTEGER NOT NULL,
	genero INTEGER NOT NULL,
	talle INTEGER NOT NULL,
	tipoPrenda INTEGER NOT NULL,
	CONSTRAINT pk_id_stock PRIMARY KEY(id_stock),
	CONSTRAINT fk_id_genero FOREIGN KEY (genero) REFERENCES genero(id_genero),
	CONSTRAINT fk_id_talle FOREIGN KEY (talle) REFERENCES talle(id_talle),
	CONSTRAINT fk_id_tipoPrenda FOREIGN KEY(tipoPrenda) REFERENCES tipoPrenda(id_tipoPrenda)
	
);

CREATE TABLE nota(
	id_nota SERIAL NOT NULL,
	descripcion VARCHAR NOT NULL,
	stock INTEGER NOT NULL,
	fecha timestamp without time zone NOT NULL,
	CONSTRAINT pk_id_nota PRIMARY KEY(id_nota),
	CONSTRAINT fk_stock FOREIGN KEY(stock) REFERENCES stock(id_stock)
);

CREATE TABLE registro(
	id_registro INTEGER NOT NULL,
	motivoBaja VARCHAR(30) NOT NULL,
	prenda INTEGER  NOT NULL,
	CONSTRAINT pk_id_registro PRIMARY KEY(id_registro),	
	CONSTRAINT fk_prenda FOREIGN KEY (prenda) REFERENCES prenda(id_prenda)
);

CREATE TABLE prendaAsignada(
	id_prendaAsignada INTEGER NOT NULL,
	empleado INTEGER NOT NULL,
	prenda INTEGER NOT NULL,
	fechaRetiro DATE NOT NULL,
	horaRetiro TIME NOT NULL,
	empleadoRec INTEGER NOT NULL,
	empleadoDev INTEGER NOT NULL,
	fechaDevolucion DATE,
	HoraDevolucion DATE,
	CONSTRAINT pk_id_prendaAsignada PRIMARY KEY (id_prendaAsignada),
	CONSTRAINT fk_id_empleado FOREIGN KEY (empleado) REFERENCES empleado(dni),
	CONSTRAINT fk_id_prenda FOREIGN KEY (prenda) REFERENCES prenda(id_prenda)
);

/* CARGA DE DATOS EN LAS DIFERENTES TABLAS */

INSERT INTO talle VALUES(1,'S');
INSERT INTO talle VALUES(2,'L');
INSERT INTO talle VALUES(3,'X');
INSERT INTO talle VALUES(4,'M');
INSERT INTO talle VALUES(5,'XL');
INSERT INTO talle VALUES(6,'XS');
INSERT INTO talle Values(7,'XXL');

INSERT INTO genero VALUES(1,'F');
INSERT INTO genero VALUES(2,'M');
INSERT INTO genero VALUES(3,'U');

INSERT INTO tipoPrenda VALUES(1,'Pantalon');
INSERT INTO tipoPrenda VALUES(2,'Camisa');
INSERT INTO tipoPrenda VALUES(3,'Saco');
INSERT INTO tipoPrenda VALUES(4,'Pollera');

INSERT INTO empleado VALUES(3922,'Sebastian','Bonato','Administracion','Herrera',3442780,'sebabonato12@gmail.com',4000,'10/01/2018'); 
INSERT INTO empleado VALUES(3921,'Lucas','Areguati','Botones','San Jose',3442780,'sebabonato12@gmail.com',4000,'10/01/2018'); 
INSERT INTO empleado VALUES(3923,'Alexis Mara','Santos','Recepcionista','CDU',3442780,'sebabonato12@gmail.com',4000,'10/01/2018'); 
INSERT INTO empleado VALUES(3925,'Walter','Bel','Recepcionista','CDU',3442780,'belwalterv@gmail.com',6000,'22/01/2018'); 
INSERT INTO empleado VALUES(3928,'Roman','Riquelme','Botones','BS AS',3442780,'roman@gmail.com',7000,'10/01/2019'); 

INSERT INTO stock VALUES(1,10,5,1,1,3);
INSERT INTO stock VALUES(2,10,5,3,3,2);
INSERT INTO stock VALUES(3,10,2,3,2,1);
INSERT INTO stock VALUES(4,10,7,1,2,1);
INSERT INTO stock VALUES(5,10,7,3,2,2);
INSERT INTO stock VALUES(6,10,7,3,3,2);
INSERT INTO stock VALUES(7,10,7,3,3,1);
INSERT INTO stock VALUES(8,4,5,3,3,1);
INSERT INTO stock VALUES(9,0,5,3,3,1);

INSERT INTO prenda VALUES(1,2,'01/02/13');
INSERT INTO prenda VALUES(2,1,'05/02/13');
INSERT INTO prenda VALUES(3,3,'03/02/23');
INSERT INTO prenda VALUES(4,4,'04/02/23');
INSERT INTO prenda VALUES(5,1,'02/02/23');
INSERT INTO prenda VALUES(6,4,'08/02/23');
INSERT INTO prenda VALUES(7,1,'02/02/23');
INSERT INTO prenda VALUES(8,8,'05/02/23');
INSERT INTO prenda VALUES(9,9,'05/02/23');
INSERT INTO prenda VALUES(10,9,'05/02/23','06/02/23');

prendaAsignada(id_prendaAsignada,empleado,prenda,fechaRetiro,HoraRetiro,empleadoRec,empleadoDev,fechaDev,HoraDev)

INSERT INTO prendaAsignada VALUES(1,3922,5,'1/04/2019','02:03:04',3922,3922);







/*TRIGGER DE STOCK */

CREATE OR REPLACE FUNCTION func_e() RETURNS TRIGGER AS $funcemp$
DECLARE 
cantidad INTEGER;
BEGIN
	IF NEW.cantidad <= OLD.cantidadMin THEN
		INSERT INTO nota VALUES(DEFAULT,'STOCK MINIMO',OLD.id_stock,NOW());
	END IF;
RETURN NEW;
END; $funcemp$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_e AFTER INSERT OR UPDATE ON stock
FOR EACH ROW EXECUTE PROCEDURE func_e();


								
/* CONSULTAS
								
Cantidad de prendas discriminadas por talle.
Cantidad de prendas con stock por debajo del mínimo.
Prendas asignadas a un empleado y aún no devueltas.
Cantidad de prendas rotas entre fechas por tipo y talle.
Cantidad de prendas asignadas.
Cantidad de prendas en stock.
Cantidad de prendas vacantes.
								
*/
								
/* A) */
								
SELECT  TL.talle,COUNT(TL.talle)
FROM stock S, talle TL
WHERE S.talle = TL.id_talle AND TL.talle = 'S' 
group by TL.talle
having count(TL.talle)>0 								
UNION
SELECT  TL.talle,COUNT(TL.talle)
FROM stock S, talle TL
WHERE S.talle = TL.id_talle AND TL.talle = 'L'
group by TL.talle
having count(TL.talle)>0
UNION 
SELECT  TL.talle,COUNT(TL.talle)
FROM stock S, talle TL
WHERE S.talle = TL.id_talle AND TL.talle = 'M'
group by TL.talle
having count(TL.talle)>0	
UNION 
SELECT  TL.talle,COUNT(TL.talle)
FROM stock S, talle TL
WHERE S.talle = TL.id_talle AND TL.talle = 'X'
group by TL.talle
having count(TL.talle)>0	
								
/* B) */		
								
SELECT COUNT(*) 
FROM stock S, prenda PR
WHERE PR.stock = S.id_stock AND S.cantidad <= S.cantidadMiN;
								
/* D) */
								
SELECT COUNT(*)
FROM prenda PR
WHERE PR.fechaBaja IS NOT NULL
								
/* F) */
								
SELECT COUNT (*)
FROM stock S, prenda PR
WHERE PR.stock = S.id_stock AND S.cantidad >= 1;
								
								
SELECT *
FROM stock

UPDATE stock SET cantidad = 4
WHERE id_stock = 3;


SELECT *
FROM nota

SELECT DISTINCT TA.talle, TP.prenda, GE.genero
FROM talle TA, tipoprenda TP, genero GE
WHERE TA.id_talle = 1;

					
/* STORED PROCEDURES "FUNCIONES" */
					
									
/* STORED PROCEDURES DEL EJERCICIO A */
								
CREATE function cantidad_tipoTalle(t_tipoTalle Varchar)
returns INT AS
$func$
BEGIN
    return (
    select COUNT(TL.talle)
    from talle TL, stock S
    where (TL.talle = t_tipoTalle AND S.talle = TL.id_talle)
    group by TL.talle
    having count(TL.talle)>0)	;									
END;
$func$ language plpgsql;				
								

SELECT cantidad_tipoTalle('S');
					

					
/* STORED PROCEDURES DEL EJERCICIO B */
					
CREATE function prenda_stock_minimo(t_tipoTalle Varchar, t_prenda VARCHAR)
returns INT AS
$funcStock$
BEGIN
    return (
    	SELECT COUNT (*)
		FROM stock S, prenda PR, talle TL, tipoPrenda TP
		WHERE PR.stock = S.id_stock AND S.cantidad <= S.cantidadMiN 
			  AND S.talle = TL.id_talle AND TL.talle = t_tipoTalle AND S.tipoPrenda = TP.id_tipoPrenda 
			  AND TP.prenda = t_prenda
		);									
end;
$funcStock$ language plpgsql;							

SELECT * FROM prenda_stock_minimo('XL','Camisa');							


	
