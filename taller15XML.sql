create table autor (
    id serial primary key,
    nombre varchar(255) not null,
    nacionalidad varchar(100),
    fecha_nacimiento date
);


create table libros (
    id serial primary key,
    libro xml,
    titulo varchar(255) not null,
    autor_id int references autor(id),
    isbn varchar(20) not null unique,
    anio int,
    stock int,
    prestado boolean default false,
    estado varchar(15) check (estado in ('disponible', 'no_disponible')) default 'disponible'
);




INSERT INTO autor (nombre, nacionalidad, fecha_nacimiento) VALUES
('Paulo Coelho', 'Brasileño', '1947-08-24'),
('Robin Sharma', 'Canadiense', '1964-06-16'),
('J.J. Benítez', 'Español', '1946-01-07'),
('Gabriel García Márquez', 'Colombiano', '1927-03-06'),
('Isabel Allende', 'Chilena', '1942-08-02'),
('Mario Vargas Llosa', 'Peruano', '1936-03-28');




create or replace procedure guardar_libro(
    p_isbn in varchar,
    p_titulo in varchar,
    p_autor_id in int,
    p_anio in int,
    p_stock in int,
    p_prestado in boolean,
    p_estado in varchar
)
language plpgsql
as $$

declare
    v_libro xml;
begin
    if exists (select 1 from libros where isbn = p_isbn) then
        raise exception 'El ISBN ya existe.';
    end if;

    v_libro := '
        <libro>
            <isbn>' || p_isbn || '</isbn>
            <titulo>' || p_titulo || '</titulo>
            <autor_id>' || p_autor_id || '</autor_id>
            <anio>' || p_anio || '</anio>
            <stock>' || p_stock || '</stock>
            <prestado>' || p_prestado || '</prestado>
            <estado>' || p_estado || '</estado>
        </libro>';

    insert into libros (libro,titulo, autor_id,isbn, anio, stock, prestado, estado)
    values (v_libro, p_titulo, p_autor_id, p_isbn,p_anio, p_stock, p_prestado, p_estado);
end;
$$;

create or replace procedure actualizar_libro(
    p_isbn in varchar,
    p_titulo in varchar,
    p_autor_id in int,
    p_anio in int,
    p_stock in int,
    p_prestado in boolean,
    p_estado in varchar
)
language plpgsql
as $$
declare
	v_libro xml;

begin
    v_libro := '
        <libro>
            <isbn>' || p_isbn || '</isbn>
            <titulo>' || p_titulo || '</titulo>
            <autor_id>' || p_autor_id || '</autor_id>
            <anio>' || p_anio || '</anio>
            <stock>' || p_stock || '</stock>
            <prestado>' || p_prestado || '</prestado>
            <estado>' || p_estado || '</estado>
        </libro>';

    update libros
    set 
		libro = v_libro,
		autor_id = p_autor_id,
        anio = p_anio,
        stock = p_stock,
        prestado = p_prestado,
        estado = p_estado
    where isbn = p_isbn;
   

    if not found then
    	raise exception 'No se encontró el libro con el ISBN proporcionado.';
    end if;
   
   	raise notice 'Libro actualizado con éxito.';
end;
$$;



create or replace function obtener_autor_libro_por_isbn(
    p_isbn in varchar
) 
returns varchar
language plpgsql
as $$
declare
	v_autor varchar[];
begin
    select xpath('/libro/autor_id/text()', libro)::varchar[]
    into v_autor
    from libros
    where isbn = p_isbn;

    if v_autor is null or array_length(v_autor, 1) = 0 then
        return null;
    else
        return v_autor[1];
    end if;
end;
$$;

create or replace function obtener_libro_por_anios(
    p_anio in int
) 
returns setof xml

language plpgsql
as $$
begin
    return query 
    select libro
    from libros
    where xpath('/libro/anio/text()', libro)::text::int = p_anio;
end;
$$;



create or replace function obtener_autor_libro_por_titulo(
    p_titulo in varchar
) 
returns xml
language plpgsql
as $$
declare
    v_autor_id int;
    v_autor_xml xml;
begin
    select xpath('/libro/autor_id/text()', libro)::text::int
    into v_autor_id
    from libros
    where xpath('/libro/titulo/text()', libro)::text = p_titulo;

    if v_autor_id is null then
        return null;
    end if;

    select xmlforest(
                nombre as "nombre", 
                nacionalidad as "nacionalidad", 
                fecha_nacimiento as "fecha_nacimiento"
           ) 
    into v_autor_xml
    from autor
    where id = v_autor_id;

    if v_autor_xml is null then
        return null;
    else
        return v_autor_xml;
    end if;
end;
$$;



create or replace procedure guardar_libro(
    p_isbn in varchar,
    p_titulo in varchar,
    p_autor_id in int,
    p_anio in int,
    p_stock in int,
    p_prestado in boolean,
    p_estado in varchar
)


call guardar_libro('978A123456', 'El Alquimista', 1, 1988, 30, false, 'disponible');
select * from libros;

CALL actualizar_libro('978A123456', 'El Alquimista', 1, 1990, 25, false, 'disponible');
select * from libros;

SELECT obtener_autor_libro_por_isbn('978A123456');

SELECT * FROM obtener_libro_por_anios(1988);

SELECT obtener_autor_libro_por_titulo('El Alquimista');





select * from libros;

