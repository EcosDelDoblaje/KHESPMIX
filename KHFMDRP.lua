-- Variables
local ListaDeSalas
local TextoMundo
local TiempoFotograma = 0
local PuedeEjecutar = true

-- Constantes
local GAME_ID_VALIDO = 0xAF71841E
local ENGINE_TYPE_VALIDO = "BACKEND"
local ENGINE_VERSION_MINIMA = 5
local MENU_PRINCIPAL = 0xFF

-- Inicializa el script
local function Inicializar()
    if GAME_ID == GAME_ID_VALIDO and ENGINE_TYPE == ENGINE_TYPE_VALIDO then
        InitializeRPC("1334277597416128513")
    else
        ConsolePrint("Juego inválido. Este script solo funciona con KHFM PC (versión global).", 3)
        PuedeEjecutar = false
    end
end

-- Función de inicialización
function _OnInit()
    ConsolePrint("===================================")
    ConsolePrint("====== Kingdom Hearts FM DRP ======")
    ConsolePrint("======   KH:Spanish Mix ++   ======")
    ConsolePrint("===================================")
    print("")

    if ENGINE_VERSION < ENGINE_VERSION_MINIMA then
        ConsolePrint("Versión incorrecta de LuaEngine. ¡Usa al menos la versión 5!", 3)
    end

    Inicializar()

    -- Inicializar variables
    Dificultad = {"Principiante", "Normal", "Experto"}
    Mundos = {
        "corazon", "islasdestino", "castillodisney", "ciudaddepaso", "paisdelasmaravillas",
        "selvaprofunda", "bosque100acres", "", "agrabah", "atlantica", "halloweentown",
        "coliseo", "monstruo", "nuncajamas", "", "bastionhueco", "findelmundo"
    }
    ListaMundos = {
        [0x00] = {"Descenso al Corazón", {"Desembarco", "Plataforma de Cenicienta", "Plataforma de Alicia",
         "Despertar", "Despertar", "Islas del Destino", "Islas del Destino"}},
        [0x01] = {"Islas del Destino", {"Orilla", "Cabaña junto al Mar", "Cueva", "Orilla", "Cabaña junto al Mar", "Orilla",
         "Cabaña junto al Mar", "Lugar Secreto", "Restos de la Isla", "Habitación de Sora", "Lugar Secreto",
         "Lugar Secreto"}},
        [0x02] = {"Castillo Disney", {"Cámara del Audiencia", "Columnata", "Biblioteca", "Patio",
         "Escalera en Espiral", "Hangar Gummi", "Área Exterior de la Escalera en Espiral",
         "Camino a los Cruces", "Mundo del Castillo de Disney"}},
        [0x03] = {"Ciudad de Paso", {"1er Distrito", "2do Distrito", "3er Distrito", "Casa Vacía",
         "Callejón", "Sala Verde", "Sala Roja", "Pasillo", "Casa Mística", "Tienda de Artículos",
         "Tienda de Accesorios", "Taller de Artículos", "Casa de Geppetto", "Guarida de los Dalmatas",
         "Comedor", "Sala de Estar", "Sala de Piano", "Tienda de Gadgets", "Casa de Merlin", "Estudio del Mago",
         "Laboratorio del Mago", "???", "Canal Secreto", "???", "3er Distrito", "Casa Pequeña"}},
        [0x04] = {"País de las Maravillas", {"Madriguera del Conejo", "Sala Extraña", "Sala Extraña",
         "Castillo de la Reina", "Bosque de Lotos", "Bosque de Lotos", "Sala Extraña", "Sala Extraña",
         "Sala Extraña", "Jardín de la Fiesta del Té"}},
        [0x05] = {"Selva Profunda", {"Casa del Árbol", "Campamento", "Soto de Bambú", "Selva: Lianas",
         "Selva: Lianas 2", "Laguna de los Hipopótamos", "Árboles Escaladores", "Cima de los Árboles",
         "Selva: Túnel", "Cueva de la Cascada", "Cueva de los Corazones", "Selva: Acantilado", "Campamento",
         "Soto de Bambú", "Campamento: Carpa", "Mini Juego: Serpiente Verde", "Mini Juego: Túnel Splash",
         "Mini Juego: Espiral de Jade", "Mini Juego: Caída de Pánico", "Mini Juego: Cueva de Sombras"}},
        [0x06] = {"Bosque de los 100 Acres", {"Casa de Pooh", "Habitación de Pooh", "Casa de Conejo",
         "Habitación de Conejo", "Árbol de Miel", "Bosque: Colina", "Bosque: Prado", "Zona de Rebote",
         "Sendero Fangoso", "Bosque: Colina", "Bosque de los 100 Acres"}},
        [0x08] = {"Agrabah", {"Desierto", "Desierto: Cueva", "Agrabah: Plaza", "Agrabah: Callejón", 
         "Agrabah: Bazar", "Agrabah: Calle Principal", "Puertas del Palacio", "Agrabah: Almacén",
         "Cueva: Entrada", "Cueva: Pasillo", "Pasillo Sin Fin", "Sala del Tesoro", "Cámara de Reliquias",
         "Cámara Oscura", "Cámara Silenciosa", "Sala Secreta", "Cámara de la Lámpara", "Cueva: Núcleo",
         "Casa de Aladdín", "Agrabah"}},
        [0x09] = {"Atlántica", {"Atlántica", "Gruta Tranquila", "Profundidades Calmas", "Garganta Submarina",
         "Cueva Submarina", "Jardín Submarino", "Barco Hundido", "Debajo de la Cubierta", "Barco Hundido",
         "Guarida de las Mareas", "Rincón de la Cueva", "Abismo de las Mareas", "Guarida de Úrsula", "Gruta de Ariel",
         "Palacio de Tritón", "Trono de Tritón", "Batalla contra Úrsula"}},
        [0x0A] = {"Ciudad de Halloween", {"Plaza de la Guillotina", "Entrada del Laboratorio", "Cementerio",
         "Colina de la Luna", "Puente", "Osario", "Mansión de Oogie", "Cámara de Tortura", "Ruinas de la Mansión",
         "Sala de Juegos Malévola", "Laboratorio de Investigación", "Puerta de la Guillotina", "Cementerio"}},
        [0x0B] = {"Coliseo del Olimpo", {"Puertas del Coliseo", "Coliseo: Vestíbulo", "Coliseo: Arena",
         "Puertas Principales", "???", "Coliseo: Arena", "Coliseo: Arena"}},
        [0x0C] = {"Monstruo", {"Monstruo: Boca", "Monstruo: Boca", "Monstruo: Estómago", "Monstruo: Garganta",
         "Monstruo: Intestinos", "Monstruo: Cámara 1", "Monstruo: Cámara 2", "Monstruo: Cámara 3",
         "Monstruo: Cámara 4", "Monstruo: Cámara 5", "Monstruo: Cámara 6"}},
        [0x0D] = {"Nunca Jamás", {"Barco: Sótano", "Barco: Sótano", "Barco: Sótano", "Barco: Congelador",
         "Barco: Cocina", "Barco: Cabina", "Cabina del Capitán", "Barco: Sótano", "Barco Pirata", "Torre del Reloj"}},
        [0x0E] = {"Bastión Hueco", {"Cascadas Ascendentes", "Puertas del Castillo", "Gran Cresta", "Alta Torre",
         "Hall de Entrada", "Biblioteca", "Parada del Ascensor", "Nivel Base", "Canal Secreto", "Canal Secreto",
         "Mazmorras", "Capilla del Castillo", "Capilla del Castillo", "Capilla del Castillo", "Gran Salón",
         "Profundidades Oscuras", "Capilla del Castillo"}},
        [0x0F] = {"Bastión Hueco", {"Cascadas Ascendentes", "Puertas del Castillo", "Gran Cresta", "Alta Torre",
         "Hall de Entrada", "Biblioteca", "Parada del Ascensor", "Nivel Base", "Canal Secreto", "Canal Secreto",
         "Mazmorras", "Capilla del Castillo", "Capilla del Castillo", "Capilla del Castillo", "Gran Salón",
         "Profundidades Oscuras", "Capilla del Castillo"}},
        [0x10] = {"Fin del Mundo", {"Puerta a la Oscuridad", "Dimensión Final", "Dimensión Final", "Dimensión Final",
         "Dimensión Final", "Dimensión Final", "Dimensión Final", "Dimensión Final", "Dimensión Final",
         "Dimensión Final", "Dimensión Final", "Dimensión Final", "Dimensión Final", "Esfera Oscura", "Gran Grieta",
         "Mundo Terminus", "Mundo Terminus(Ciudad de Paso)", "Mundo Terminus(Maravillas)",
         "Mundo Terminus(Coliseo del Olimpo)", "Mundo Terminus(Selva Profunda)",
         "Mundo Terminus(Agrabah)", "Mundo Terminus(Atlántica)", "Mundo Terminus(Ciudad de Halloween)",
         "Mundo Terminus(Nunca Jamás)", "Mundo Terminus(Bosque de los 100 Acres)",
         "Mundo Terminus(Bastión Hueco)", "Terrenos Malévolos", "Cráter Volcánico", "Mundos Vinculados",
         "Descanso Final", "Regreso a Casa", "Isla en Ruinas", "Puerta Final", "El Vacío", "Cráter", "Regreso a Casa",
         "El Vacío", "El Vacío", "El Vacío"}}
    }
end

-- Función que se ejecuta en cada fotograma
function _OnFrame()
    if not PuedeEjecutar then return end

    TiempoFotograma = TiempoFotograma + 1
    if TiempoFotograma < GetHertz() then return end
    TiempoFotograma = 0

    local TextoDetalle = "Nv. " .. ReadByte(0x2DE9364) .. " (" .. Dificultad[ReadByte(0x2DFF78C) + 1] .. ")"
    local IDMundo, IDSala = ReadByte(0x233FE94), ReadByte(0x233FE8C)

    TextoMundo, ListaDeSalas = ListaMundos[IDMundo] and ListaMundos[IDMundo][1] or "Mundo Desconocido", ListaMundos[IDMundo] and ListaMundos[IDMundo][2]
    local TextoEstado = "Ubicación desconocida"
    if ListaDeSalas and type(ListaDeSalas) == "table" and IDSala and IDSala + 1 <= #ListaDeSalas then
        TextoEstado = ListaMundos[IDMundo][1] .. " - " .. ListaDeSalas[IDSala + 1]
    end

    if IDMundo == MENU_PRINCIPAL then
        UpdateDetails("")
        UpdateState("Menú Principal")
        UpdateLImage("logo")
        UpdateSImage("")
    else
        UpdateDetails(TextoDetalle)
        UpdateState(TextoEstado)
        UpdateLImage(Mundos[IDMundo + 1] or "desconocido", TextoMundo)
        UpdateSImage("logo")
    end
    
end