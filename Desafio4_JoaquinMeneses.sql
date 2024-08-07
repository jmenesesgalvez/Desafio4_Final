-- Active: 1722994876962@@127.0.0.1@5432@postgres@public
CREATE DATABASE desafio4_jmenega;

#1. Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves primarias, foráneas y tipos de datos.

CREATE TABLE Peliculas (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    año INTEGER
);

CREATE TABLE Tags (
    id INTEGER PRIMARY KEY,
    tag VARCHAR(32) NOT NULL
);

CREATE TABLE Peliculas_Tags (
    pelicula_id INTEGER,
    tag_id INTEGER,
    PRIMARY KEY (pelicula_id, tag_id),
    FOREIGN KEY (pelicula_id) REFERENCES Peliculas(id),
    FOREIGN KEY (tag_id) REFERENCES Tags(id)
);

#2. Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la segunda película debe tener 2 tags asociados.
-- Insertar 5 películas
INSERT INTO Peliculas (id, nombre, año) VALUES 
(1, 'Bob Sponja', 2004),
(2, 'El Padrino', 1972),
(3, 'Toy Story', 1995),
(4, 'Pinocho', 1940),
(5, 'Forrest Gump', 1994);

-- Insertar 5 tags
INSERT INTO Tags (id, tag) VALUES 
(1, 'Animacion'),
(2, 'Gansteres'),
(3, 'Comedia'),
(4, 'Infantil'),
(5, 'Drama');

-- Asociar tags con las películas

INSERT INTO Peliculas_Tags (pelicula_id, tag_id) VALUES 
(1, 1),
(1, 3),
(1, 4);

-- El Padrino con 2 tags
INSERT INTO Peliculas_Tags (pelicula_id, tag_id) VALUES 
(2, 2),
(2, 5);


#3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.
SELECT 
    p.nombre,
    COALESCE(COUNT(pt.tag_id), 0) AS tag_count
FROM 
    Peliculas p
LEFT JOIN 
    Peliculas_Tags pt ON p.id = pt.pelicula_id
GROUP BY 
    p.id, p.nombre
ORDER BY 
    p.nombre;

#4. Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y foráneas y tipos de datos.
-- Crear la tabla Preguntas
CREATE TABLE Preguntas (
    id INTEGER PRIMARY KEY,
    pregunta VARCHAR(255) NOT NULL,
    respuesta_correcta VARCHAR(255)
);

-- Crear la tabla Respuestas
CREATE TABLE Respuestas (
    id INTEGER PRIMARY KEY,
    respuesta VARCHAR(255) NOT NULL,
    usuario_id INTEGER,
    pregunta_id INTEGER,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (pregunta_id) REFERENCES Preguntas(id)
);

-- Crear la tabla Usuarios
CREATE TABLE Usuarios (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    edad INTEGER
);

#5. Agrega 5 usuarios y 5 preguntas.
INSERT INTO Usuarios (id, nombre, edad) VALUES 
(1, 'Mateo', 19),
(2, 'Piera', 38),
(3, 'Joaquin', 38),
(4, 'Hugo', 66),
(5, 'Rommy', 62);

INSERT INTO Preguntas (id, pregunta, respuesta_correcta) VALUES 
(1, 'Cuantos minutos tiene 1 dia ?', '1440'),
(2, 'Cuantos habitantes tiene la tierra ?', '8126311158'),
(3, 'Cuando llego el hombre a la luna ?', '21-07-1969'),
(4, 'Cuantos municipios hay en Chile?', '346 Municipios'),
(5, 'Cual es el nombre de los 5 Continentes ?','America, Asia, Oceania, Africa, Europa');

INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id)
VALUES
(1, '1440', 5, 1),
(2, '1440', 4, 1),
(3, '1490', 3, 1),
(4, '900', 2, 1),
(5, '2340', 1, 1),
(6, '8126311158', 3, 2),
(7, 'Muchos', 5, 2),
(8, '1000', 4, 2),
(9, 'No se', 2, 2),
(10, '812630000', 1, 2),
(11, '21-07-1970', 1, 3),
(12, '21-12-1969', 2, 3),
(13, 'paso', 3, 3),
(14, 'no a llegado', 4, 3),
(15, '31-07-1969', 5, 3),
(16, '50 Municipios', 1, 4),
(17, '600 Municipios', 2, 4),
(18, '340 Municipios', 3, 4),
(19, '100 Municipios', 4, 4),
(20, '846 Municipios', 5, 4),
(21, 'America, Asia, Oceania', 1, 5),
(22, 'Paso', 2, 5),
(23, 'America, Asia, Oceania, Africa, Antartida', 3, 5),
(24, 'Chile, Argentina, Brasil', 4, 5),  -- Corregido "Argntina"
(25, 'America, Asia, Oceania, Africa, Oceania', 5, 5);



#a. La primera pregunta debe estar respondida correctamente dos veces, por dos usuarios diferentes.

#b. La segunda pregunta debe estar contestada correctamente solo por un usuario.

#c. Las otras tres preguntas deben tener respuestas incorrectas
#Contestada correctamente significa que la respuesta indicada en la tabla respuestas es exactamente igual al texto indicado en la tabla de preguntas.

#6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).
SELECT r.usuario_id, COUNT(CASE WHEN r.respuesta = p.respuesta_correcta THEN 1 ELSE NULL END) AS total_respuestas_correctas
FROM respuestas r
LEFT JOIN preguntas p ON r.pregunta_id = p.id
GROUP BY r.usuario_id
ORDER BY r.usuario_id;


#7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente.
SELECT p.id AS pregunta_id, 
       COUNT(DISTINCT CASE WHEN r.respuesta = p.respuesta_correcta THEN r.usuario_id ELSE NULL END) AS total_usuarios_correctos
FROM preguntas p
LEFT JOIN respuestas r ON p.id = r.pregunta_id
GROUP BY p.id
ORDER BY p.id;

#8. Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la implementación borrando el primer usuario.

#9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.
ALTER TABLE Usuarios
ADD CONSTRAINT chk_edad CHECK (edad >= 18);

#10. Altera la tabla existente de usuarios agregando el campo email. Debe tener la restricción de ser único.
ALTER TABLE usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;






