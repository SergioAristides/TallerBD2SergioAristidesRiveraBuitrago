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
    v_autor_nombre varchar(255);
    v_autor_nacionalidad varchar(100);
    v_autor_fecha_nacimiento date;
    v_autor_xml xml;
begin
    if exists (select 1 from xmlt.libros where isbn = p_isbn) then
        raise exception 'El ISBN ya existe';
    end if;
	
	select nombre, nacionalidad, fecha_nacimiento
    into v_autor_nombre, v_autor_nacionalidad, v_autor_fecha_nacimiento
    from xmlt.autor
    where id = p_autor_id;

    v_autor_xml := 
        '<autor>' ||
            '<id>' || p_autor_id || '</id>' ||
            '<nombre>' || v_autor_nombre || '</nombre>' ||
            '<nacionalidad>' || v_autor_nacionalidad || '</nacionalidad>' ||
            '<fecha_nacimiento>' || v_autor_fecha_nacimiento::text|| '</fecha_nacimiento>' ||
        '</autor>';
	
    v_libro := 
        '<libro>' ||
            '<isbn>' || p_isbn || '</isbn>' ||
            '<titulo>' || p_titulo || '</titulo>' ||
            v_autor_xml ||
            '<anio>' || p_anio || '</anio>' ||
            '<stock>' || p_stock || '</stock>' ||
            '<prestado>' || p_prestado || '</prestado>' ||
            '<estado>' || p_estado || '</estado>' ||
        '</libro>';

    insert into xmlt.libros (libro,titulo, autor_id,isbn, anio, stock, prestado, estado)
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
    v_autor_nombre varchar(255);
    v_autor_nacionalidad varchar(100);
    v_autor_fecha_nacimiento date;
    v_autor_xml xml;

begin
	select nombre, nacionalidad, fecha_nacimiento
    into v_autor_nombre, v_autor_nacionalidad, v_autor_fecha_nacimiento
    from xmlt.autor
    where id = p_autor_id;

    v_autor_xml := 
        '<autor>' ||
            '<id>' || p_autor_id || '</id>' ||
            '<nombre>' || v_autor_nombre || '</nombre>' ||
            '<nacionalidad>' || v_autor_nacionalidad || '</nacionalidad>' ||
            '<fecha_nacimiento>' || v_autor_fecha_nacimiento::text|| '</fecha_nacimiento>' ||
        '</autor>';

    v_libro := 
        '<libro>' ||
            '<isbn>' || p_isbn || '</isbn>' ||
            '<titulo>' || p_titulo || '</titulo>' ||
            v_autor_xml ||
            '<anio>' || p_anio || '</anio>' ||
            '<stock>' || p_stock || '</stock>' ||
            '<prestado>' || p_prestado || '</prestado>' ||
            '<estado>' || p_estado || '</estado>' ||
        '</libro>';

    update xmlt.libros
    set 
		libro = v_libro,
		autor_id = p_autor_id,
        anio = p_anio,
        stock = p_stock,
        prestado = p_prestado,
        estado = p_estado
    where isbn = p_isbn;
   

    if not found then
    	raise exception 'No se encontro el libro con el ISBN proporcionado';
    end if;
   
   	raise notice 'Libro actualizado con exito.';
end;
$$;



create or replace function obtener_autor_libro_por_isbne(p_isbn varchar)
returns xml
language plpgsql
as $$
declare
    v_autor_xml xml;
begin
    select 
        '<autor>' ||
            '<id>' || a.id || '</id>' ||
            '<nombre>' || a.nombre || '</nombre>' ||
            '<nacionalidad>' || a.nacionalidad || '</nacionalidad>' ||
            '<fecha_nacimiento>' || a.fecha_nacimiento::text || '</fecha_nacimiento>' ||
        '</autor>'
    into v_autor_xml
    from xmlt.libros l
    join xmlt.autor a on l.autor_id = a.id
    where l.isbn = p_isbn;

    if v_autor_xml is null then
        raise exception 'No se encontro el autor para el ISBN proporcionado';
    end if;

    return v_autor_xml;
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
    from xmlt.libros
    where xpath('/libro/anio/text()', libro)::text[] is not null
    and (xpath('/libro/anio/text()', libro))[1]::text::int = p_anio;
end;
$$;




create or replace function obtener_autor_libro_por_titulo(p_titulo varchar)
returns xml
language plpgsql
as $$
declare
    v_autor_xml xml;
begin
    select 
        '<autor>' ||
            '<id>' || a.id || '</id>' ||
            '<nombre>' || a.nombre || '</nombre>' ||
            '<nacionalidad>' || a.nacionalidad || '</nacionalidad>' ||
            '<fecha_nacimiento>' || a.fecha_nacimiento::text || '</fecha_nacimiento>' ||
        '</autor>'
    into v_autor_xml
    from xmlt.libros l
    join xmlt.autor a on l.autor_id = a.id
    where l.titulo = p_titulo;

    if v_autor_xml is null then
        raise exception 'No se encontro el autor para el ISBN proporcionado.';
    end if;

    return v_autor_xml;
end;
$$;




call guardar_libro('978A123456', 'El Alquimista', 1, 1988, 30, false, 'disponible');
call guardar_libro('978B123456', 'El monje que vendio su ferrari 1', 2, 2008, 60, false, 'disponible');
call guardar_libro('978C123456', 'cien años de soledad', 4, 1985, 98, false, 'disponible');

select * from libros;

call actualizar_libro('978A123456', 'El Alquimista', 1, 1990, 23, false, 'disponible');

select * from libros;

select obtener_autor_libro_por_isbne('978A123456');

select obtener_libro_por_anios(1988);

select obtener_autor_libro_por_titulo('El Alquimista');

