----------------------------------------------------------------------------------
-- Total RP 3
-- Spanish locale
-- ---------------------------------------------------------------------------
-- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
-- Translation by Alnih from WikiErrantes, many thanks to him.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----------------------------------------------------------------------------------

local LOCALE = {
	locale = "esES",
	localeText = "Español",
    localeContent =
    --@localization(locale="esES", format="lua_table", handle-unlocalized="ignore")@
    --@do-not-package@
    {
        ["ABOUT_TITLE"] = "Acerca de",
        ["BINDING_NAME_TRP3_TOGGLE"] = "Mostrar/ocultar la ventana principal",
        ["BINDING_NAME_TRP3_TOOLBAR_TOGGLE"] = "Mostrar/ocultar barra de herramientas",
        ["BROADCAST_10"] = "|cffff9900Ya estás en 10 canales. TRP3 no intentará conectar de nuevo con el canal de emisión pero no podrás usar algunas características como la localización de jugadores en el mapa.",
        ["BROADCAST_PASSWORD"] = [=[|cffff0000Hay una contraseña para el canal de emisión (%s).
|cffff9900TRP3 no intentará conectarse de nuevo pero no podrás usar algunas características como la localización de jugadores en el mapa.
|cff00ff00Puedes deshabilitar o cambiar de canal de emisión en la configuración general de TRP3.]=],
        ["BROADCAST_PASSWORDED"] = [=[|cffff0000El usuario |r%s|cffff0000 ha puesto contraseña para el canal de emisión (%s).
|cffff9900Si no conoces la contraseña, no podrás usar algunas características como la localización de personajes en el mapa.]=],
        ["BW_COLOR_CODE"] = "Código de color",
        ["BW_COLOR_CODE_ALERT"] = "¡Código hexadecimal erróneo!",
        ["BW_COLOR_CODE_TT"] = "Pega un código de color hexadecimal de 6 cifras aquí y presiona enter.",
        ["CM_ACTIONS"] = "Acciones",
        ["CM_ALT"] = "Alt",
        ["CM_APPLY"] = "Aplicar",
        ["CM_CANCEL"] = "Cancelar",
        ["CM_CENTER"] = "Centro",
        ["CM_CLASS_DEATHKNIGHT"] = "Caballero de la muerte",
        ["CM_CLASS_DRUID"] = "Druida",
        ["CM_CLASS_HUNTER"] = "Cazador",
        ["CM_CLASS_MAGE"] = "Mago",
        ["CM_CLASS_MONK"] = "Monje",
        ["CM_CLASS_PALADIN"] = "Paladín",
        ["CM_CLASS_PRIEST"] = "Sacerdote",
        ["CM_CLASS_ROGUE"] = "Pícaro",
        ["CM_CLASS_SHAMAN"] = "Chamán",
        ["CM_CLASS_UNKNOWN"] = "Desconocido",
        ["CM_CLASS_WARLOCK"] = "Brujo",
        ["CM_CLASS_WARRIOR"] = "Guerrero",
        ["CM_CLICK"] = "Clic",
        ["CM_COLOR"] = "Color",
        ["CM_CTRL"] = "Ctrl",
        ["CM_DOUBLECLICK"] = "Doble clic.",
        ["CM_DRAGDROP"] = "Arrastrar y soltar",
        ["CM_EDIT"] = "Editar",
        ["CM_IC"] = "ER",
        ["CM_ICON"] = "Icono",
        ["CM_IMAGE"] = "Imagen",
        ["CM_L_CLICK"] = "Clic izquierdo",
        ["CM_LEFT"] = "Izquierda",
        ["CM_LINK"] = "Link",
        ["CM_LOAD"] = "Cargar",
        ["CM_M_CLICK"] = "Click botón central",
        ["CM_MOVE_DOWN"] = "Mover hacia abajo",
        ["CM_MOVE_UP"] = "Mover hacia arriba",
        ["CM_NAME"] = "Nombre",
        ["CM_OOC"] = "FdR",
        ["CM_OPEN"] = "Abrir",
        ["CM_PLAY"] = "Reproducir",
        ["CM_R_CLICK"] = "Clic derecho",
        ["CM_REMOVE"] = "Eliminar",
        ["CM_RESIZE"] = "Cambiar el tamaño",
        ["CM_RESIZE_TT"] = "Arrastrar para cambiar el tamaño del marco.",
        ["CM_RIGHT"] = "Derecha",
        ["CM_SAVE"] = "Guardar",
        ["CM_SELECT"] = "Seleccionar",
        ["CM_SHIFT"] = "Shift",
        ["CM_SHOW"] = "Mostrar",
        ["CM_STOP"] = "Parar",
        ["CM_TWEET"] = "Enviar tuit",
        ["CM_TWEET_PROFILE"] = "Mostrar url del perfil",
        ["CM_UNKNOWN"] = "Desconocido",
        ["CM_VALUE"] = "Valor",
        ["CO_ANCHOR_BOTTOM"] = "Abajo",
        ["CO_ANCHOR_BOTTOM_LEFT"] = "Abajo a la izquierda",
        ["CO_ANCHOR_BOTTOM_RIGHT"] = "Abajo a la derecha",
        ["CO_ANCHOR_CURSOR"] = "Mostrar en el cursor",
        ["CO_ANCHOR_LEFT"] = "Izquierda",
        ["CO_ANCHOR_RIGHT"] = "Derecha",
        ["CO_ANCHOR_TOP"] = "Parte superior",
        ["CO_ANCHOR_TOP_LEFT"] = "Parte superior izquierda",
        ["CO_ANCHOR_TOP_RIGHT"] = "Parte superior derecha",
        ["CO_CHAT"] = "Chat",
        ["CO_CHAT_INSERT_FULL_RP_NAME"] = "Insertar nombres de rol con shift+clic",
        ["CO_CHAT_INSERT_FULL_RP_NAME_TT"] = "Insertar el nombre completo de rol de un jugador cuando se haga shift+clic en su nombre en la ventana de chat.",
        ["CO_CHAT_MAIN"] = "Ajustes del chat principal",
        ["CO_CHAT_MAIN_COLOR"] = "Usar colores para los nombres",
        ["CO_CHAT_MAIN_EMOTE"] = "Detección de emociones",
        ["CO_CHAT_MAIN_EMOTE_PATTERN"] = "Patrón de detección de emociones",
        ["CO_CHAT_MAIN_EMOTE_USE"] = "Usar detección de emociones",
        ["CO_CHAT_MAIN_EMOTE_YELL"] = "Emociones sin gritos",
        ["CO_CHAT_MAIN_EMOTE_YELL_TT"] = "No mostrar *emote* o <emote> en gritos.",
        ["CO_CHAT_MAIN_NAMING"] = "Visualización del nombre",
        ["CO_CHAT_MAIN_NAMING_1"] = "Mantener nombre original",
        ["CO_CHAT_MAIN_NAMING_2"] = "Usar nombre personalizado",
        ["CO_CHAT_MAIN_NAMING_3"] = "Nombre + apellido",
        ["CO_CHAT_MAIN_NAMING_4"] = "Título corto + nombre + apellidos",
        ["CO_CHAT_MAIN_NPC"] = "Detección de diálogo de PNJ",
        ["CO_CHAT_MAIN_NPC_PREFIX"] = "Patrón detección de diálogo PNJ",
        ["CO_CHAT_MAIN_NPC_PREFIX_TT"] = [=[Si un mensaje enviado por el canal empieza con los prefijos /decir, /emote, /grupo o /banda, se interpreta como un diálogo de PNJ.

|cff00ff00Por defecto: "|| "
(Sin el " y con un espacio después del I)]=],
        ["CO_CHAT_MAIN_NPC_USE"] = "Usar detección de diálogo de PNJ",
        ["CO_CHAT_MAIN_OOC"] = "Detección de FdR",
        ["CO_CHAT_MAIN_OOC_COLOR"] = "Color de FdR",
        ["CO_CHAT_MAIN_OOC_PATTERN"] = "Patrón de detección de FdR",
        ["CO_CHAT_MAIN_OOC_USE"] = "Usar detección de FdR",
        ["CO_CHAT_USE"] = "Canales de chat usados",
        ["CO_CHAT_USE_SAY"] = "Canal /decir",
        ["CO_CONFIGURATION"] = "Ajustes",
        ["CO_GENERAL"] = "Ajustes generales",
        ["CO_GENERAL_BROADCAST"] = "Usar canal de emisión",
        ["CO_GENERAL_BROADCAST_C"] = "Nombre del canal de emisión",
        ["CO_GENERAL_BROADCAST_TT"] = "El canal de emisión se usa para una serie de características. Desactivarlo deshabilita características como la ubicación en el mapa, sonidos difundidos a nivel local, el acceso a escondrijos y carteles, etc.",
        ["CO_GENERAL_CHANGELOCALE_ALERT"] = [=[¿Deseas actualizar ahora la interfaz con el fin de cambiar el idioma a %s?

Si no es así, el idioma se cambiará en la próxima conexión.]=],
        ["CO_GENERAL_COM"] = "Comunicación",
        ["CO_GENERAL_HEAVY"] = "Alerta de perfil sobrecargado",
        ["CO_GENERAL_HEAVY_TT"] = "Mostrar un aviso cuando el tamaño total del perfil exceda un valor razonable.",
        ["CO_GENERAL_LOCALE"] = "Idioma",
        ["CO_GENERAL_MISC"] = "Varios",
        ["CO_GENERAL_NEW_VERSION"] = "Alerta de actualización",
        ["CO_GENERAL_NEW_VERSION_TT"] = "Mostrar un aviso cuando una nueva versión esté disponible.",
        ["CO_GENERAL_TT_SIZE"] = "Información sobre herramientas del tamaño del texto",
        ["CO_GENERAL_UI_ANIMATIONS"] = "Animaciones de IU",
        ["CO_GENERAL_UI_ANIMATIONS_TT"] = "Activar las animaciones de IU.",
        ["CO_GENERAL_UI_SOUNDS"] = "Sonidos de IU",
        ["CO_GENERAL_UI_SOUNDS_TT"] = "Activar el sonido de IU (al abrir las ventanas, pestañas, clics de botones).",
        ["CO_GLANCE_LOCK"] = "Anclar barra",
        ["CO_GLANCE_LOCK_TT"] = "Ancla la barra para evitar que sea arrastrada.",
        ["CO_GLANCE_MAIN"] = "Barra de \"a primera vista\"",
        ["CO_GLANCE_PRESET_TRP2"] = "Usar estilo de posición del TRP2",
        ["CO_GLANCE_PRESET_TRP2_BUTTON"] = "Usar",
        ["CO_GLANCE_PRESET_TRP2_HELP"] = "Acceso directo de configuración en el estilo TRP2: a la derecha del marco de objetivo del WoW.",
        ["CO_GLANCE_PRESET_TRP3"] = "Usar estilo de posición del TRP 3",
        ["CO_GLANCE_PRESET_TRP3_HELP"] = "Acceso directo a la configuración del estilo TRP3: a la parte inferior del marco de objetivo del TRP3.",
        ["CO_GLANCE_RESET_TT"] = "Cambiar la posición a la parte inferior izquierda de la barra del marco de anclaje.",
        ["CO_GLANCE_TT_ANCHOR"] = "Punto de anclaje",
        ["CO_LOCATION"] = "Ajustes de rastreo",
        ["CO_LOCATION_ACTIVATE"] = "Activar ubicación del personaje",
        ["CO_LOCATION_ACTIVATE_TT"] = "Habilitar el sistema de localización del personaje, permitiéndote buscar a otros usuarios de Total RP en el mapamundi y permitiéndoles encontrarte.",
        ["CO_LOCATION_DISABLE_OOC"] = "Desactivar rastreo en modo FdR",
        ["CO_LOCATION_DISABLE_OOC_TT"] = "No aparecerás en la solicitud de localización de otros personajes cuando estés Fuera de Personaje.",
        ["CO_LOCATION_DISABLE_PVP"] = "Desactivar rastreo en modo JcJ",
        ["CO_LOCATION_DISABLE_PVP_TT"] = [=[No aparecerás en la solicitud de localización de otros personajes cuando estés con el JcJ activado.

Esta opción es útil en los reinos JcJ donde los jugadores de la facción contraria pueden usar este sistema para localizarte.]=],
        ["CO_MINIMAP_BUTTON"] = "Botón de minimapa",
        ["CO_MINIMAP_BUTTON_FRAME"] = "Marco de anclaje",
        ["CO_MINIMAP_BUTTON_RESET"] = "Restablecer posición",
        ["CO_MINIMAP_BUTTON_RESET_BUTTON"] = "Restablecer",
        ["CO_MINIMAP_BUTTON_SHOW_HELP"] = [=[Si estás usando otro addon para mostrar el icono en el minimapa del Total RP 3 (FuBar, Titan, Bazooka) puedes quitar el botón del minimapa.

|cff00ff00Recordatorio : Puedes abrir Total RP 3 usando /trp3 switch main|r]=],
        ["CO_MINIMAP_BUTTON_SHOW_TITLE"] = "Mostrar botón de minimapa",
        ["CO_MODULES"] = "Módulos",
        ["CO_MODULES_DISABLE"] = "Desactivar módulo",
        ["CO_MODULES_ENABLE"] = "Habilitar módulo",
        ["CO_MODULES_ID"] = "ID del módulo: %s",
        ["CO_MODULES_SHOWERROR"] = "Mostrar error",
        ["CO_MODULES_STATUS"] = "Estado: %s",
        ["CO_MODULES_STATUS_0"] = "Dependencias faltantes",
        ["CO_MODULES_STATUS_1"] = "Cargado",
        ["CO_MODULES_STATUS_2"] = "Inhabilitado",
        ["CO_MODULES_STATUS_3"] = "Total RP 3 requiere una actualizanción",
        ["CO_MODULES_STATUS_4"] = "Error en la inicialización",
        ["CO_MODULES_STATUS_5"] = "Error en el inicio",
        ["CO_MODULES_TT_DEP"] = "%s- %s (versión %s)|r",
        ["CO_MODULES_TT_DEPS"] = "Dependencias",
        ["CO_MODULES_TT_ERROR"] = [=[|cffff0000Error:|r
%s]=],
        ["CO_MODULES_TT_NONE"] = "No hay dependencias",
        ["CO_MODULES_TT_TRP"] = "%sPara Total RP 3 build %s mínima.|r",
        ["CO_MODULES_TUTO"] = [=[Un módulo es una característica independiente que se puede activar o desactivar.

Estados posibles:
|cff00ff00Cargado:|r El módulo está habilitado y cargado.
|cff999999Inhabilitado:|r El módulo está inhabilitado.
|cffff9900Dependencias faltantes:|r Algunas dependencias no se han cargado.
|cffff9900TRP requiere una actualizanción:|r El módulo requiere una versión más reciente del TRP3.
|cffff0000Error en la inicialización o en el inicio:|r La secuencia de carga del módulo ha fallado. ¡Es probable que el módulo crea errores!

|cffff9900Al desactivar un módulo, es necesario un reinicio de interfaz de usuario.]=],
        ["CO_MODULES_VERSION"] = "Versión: %s",
        ["CO_MSP"] = "Protocolo Mary Sue",
        ["CO_MSP_T3"] = "Usar sólo la plantilla 3",
        ["CO_MSP_T3_TT"] = "Incluso si usted elige una diferente plantilla para \"acerca de\", la plantilla 3 siempre se utilizará para la compatibilidad con PMS.",
        ["CO_REGISTER"] = "Registro",
        ["CO_REGISTER_ABOUT_VOTE"] = "Usar sistema de votación",
        ["CO_REGISTER_ABOUT_VOTE_TT"] = "Activar el sistema de votación permitirá que votes (\"me gusta\" o \"no me gusta\") en las descripciones de los usuarios y que puedan votar en la tuya propia.",
        ["CO_REGISTER_AUTO_ADD"] = "Autoañadir nuevos jugadores",
        ["CO_REGISTER_AUTO_ADD_TT"] = "Añadir automáticamente en el registro a los jugadores que te encuentres.",
        ["CO_REGISTER_AUTO_PURGE"] = "Purga automática",
        ["CO_REGISTER_AUTO_PURGE_0"] = "Purga desactivada",
        ["CO_REGISTER_AUTO_PURGE_1"] = "Después de %s día(s)",
        ["CO_REGISTER_AUTO_PURGE_TT"] = [=[Eliminar automáticamente del directorio los perfiles de personajes con los que no te has cruzado en determinado tiempo. Puedes aplazarlo antes de eliminar.

|cff00ff00Ten en cuenta que los perfiles que tengan alguna relación con tus personajes no serán eliminados.

|cffff9900Hay un error en WoW que pierde toda la información guardada al llegar a cierto límite. Recomendamos encarecidamente evitar deshabilitar el sistema de purga.]=],
        ["CO_TARGETFRAME"] = "Ajustes del marco de objetivo",
        ["CO_TARGETFRAME_ICON_SIZE"] = "Tamaño del icono",
        ["CO_TARGETFRAME_USE"] = "Mostrar condiciones",
        ["CO_TARGETFRAME_USE_1"] = "Siempre",
        ["CO_TARGETFRAME_USE_2"] = "Sólo ER",
        ["CO_TARGETFRAME_USE_3"] = "Nunca (Deshabilitar)",
        ["CO_TARGETFRAME_USE_TT"] = "Determina en que condiciones se mostrará el marco de objetivo.",
        ["CO_TOOLBAR"] = "Ajustes del marco",
        ["CO_TOOLBAR_CONTENT"] = "Ajustes de la barra de herramientas",
        ["CO_TOOLBAR_CONTENT_CAPE"] = "Botón de capa",
        ["CO_TOOLBAR_CONTENT_HELMET"] = "Botón de yelmo",
        ["CO_TOOLBAR_CONTENT_RPSTATUS"] = "Estado del personaje (ER/FdR)",
        ["CO_TOOLBAR_CONTENT_STATUS"] = "Estado del jugador (AUS/NM)",
        ["CO_TOOLBAR_ICON_SIZE"] = "Tamaño de iconos",
        ["CO_TOOLBAR_MAX"] = "Iconos máximos por línea",
        ["CO_TOOLBAR_MAX_TT"] = "¡Se establece en 1 si deseas la barra en posición vertical!",
        ["CO_TOOLBAR_SHOW_ON_LOGIN"] = "Mostrar barra de herramientas al iniciar sesión",
        ["CO_TOOLBAR_SHOW_ON_LOGIN_HELP"] = "Si no quieres que la barra de herramientas se muestre al iniciar sesión, desactiva esta opción.",
        ["CO_TOOLTIP"] = "Herramientas",
        ["CO_TOOLTIP_ANCHOR"] = "Punto de anclaje",
        ["CO_TOOLTIP_ANCHORED"] = "Marco anclado",
        ["CO_TOOLTIP_CHARACTER"] = "Herramientas del personaje",
        ["CO_TOOLTIP_CLIENT"] = "Mostrar cliente",
        ["CO_TOOLTIP_COLOR"] = "Mostrar colores personalizados",
        ["CO_TOOLTIP_COMBAT"] = "Ocultar durante el combate",
        ["CO_TOOLTIP_COMMON"] = "Ajustes comunes",
        ["CO_TOOLTIP_CONTRAST"] = "Aumentar el contraste de color",
        ["CO_TOOLTIP_CONTRAST_TT"] = "Habilitar esta opción permitirá a Total RP 3 modificar los colores personalizados para hacer el texto más legible si el color es demasiado oscuro.",
        ["CO_TOOLTIP_CURRENT"] = "Mostrar información actual",
        ["CO_TOOLTIP_CURRENT_SIZE"] = "Longitud máxima de información actual",
        ["CO_TOOLTIP_FT"] = "Mostrar título completo",
        ["CO_TOOLTIP_GUILD"] = "Mostrar hermandad",
        ["CO_TOOLTIP_HIDE_ORIGINAL"] = "Ocultar marco original",
        ["CO_TOOLTIP_ICONS"] = "Mostrar iconos",
        ["CO_TOOLTIP_IN_CHARACTER_ONLY"] = "Ocultar cuando estés Fuera de Personaje",
        ["CO_TOOLTIP_MAINSIZE"] = "Tamaño del texto principal",
        ["CO_TOOLTIP_NOTIF"] = "Mostrar notificaciones",
        ["CO_TOOLTIP_NOTIF_TT"] = "La línea de notificaciones es la línea que contiene la versión del cliente, el marcador de descripción no leída y el marcador de \"a primera vista\".",
        ["CO_TOOLTIP_OWNER"] = "Mostrar propietario",
        ["CO_TOOLTIP_PETS"] = "Herramienta de compañeros",
        ["CO_TOOLTIP_PETS_INFO"] = "Mostrar información de compañeros",
        ["CO_TOOLTIP_PROFILE_ONLY"] = "Utilizar sólo de tener un perfil",
        ["CO_TOOLTIP_RACE"] = "Mostrar raza, clase y nivel",
        ["CO_TOOLTIP_REALM"] = "Mostrar reino",
        ["CO_TOOLTIP_RELATION"] = "Mostrar el color de la relación",
        ["CO_TOOLTIP_RELATION_TT"] = "Establece el color del borde del personaje según su relación contigo.",
        ["CO_TOOLTIP_SPACING"] = "Mostrar espacios",
        ["CO_TOOLTIP_SPACING_TT"] = "Coloca espacios entre la información del personaje para diferenciar mejor los apartados.",
        ["CO_TOOLTIP_SUBSIZE"] = "Tamaño del texto secundario",
        ["CO_TOOLTIP_TARGET"] = "Mostrar objetivo",
        ["CO_TOOLTIP_TERSIZE"] = "Tamaño del texto terciario",
        ["CO_TOOLTIP_TITLE"] = "Mostrar título",
        ["CO_TOOLTIP_USE"] = "Usar herramientas de personajes/compañeros",
        ["CO_WIM"] = "|cffff9900El canal de susurro está desactivado.",
        ["CO_WIM_TT"] = "Estás usando |cff00ff00WIM|r, el uso del canal de susurro está deshabilitado por motivos de compatibilidad.",
        ["COM_LIST"] = "Lista de comandos:",
        ["COM_RESET_RESET"] = "¡La posición de los elementos de la interfaz han sido restablecidos!",
        ["COM_RESET_USAGE"] = "Uso: |cff00ff00/trp3 reset frames|r para restablecer todas las posiciones de los elementos de interfaz.",
        ["COM_STASH_DATA"] = [=[|cffff0000¿Estás seguro de que quieres ir acumulando tu información del Total RP 3?|r

Tus perfiles, los de tus compañeros y configuración se acumulará temporalmente y tu interfaz se cargará sin información, como si hubieras instalado Total RP 3 de nuevo.
|cff00ff00Utiliza el mismo comando de nuevo (|cff999999/trp3 stash|cff00ff00) para restaurar la información.|r]=],
        ["COM_SWITCH_USAGE"] = "Uso: |cff00ff00/trp3 switch main|r para mostrar u ocultar la ventana principal o |cff00ff00/trp3 switch toolbar|r para mostrar u ocultar la barra de herramientas.",
        ["DB_ABOUT"] = "Acerca de Total RP 3",
        ["DB_HTML_GOTO"] = "Haz clic para abrir",
        ["DB_MORE"] = "Más módulos",
        ["DB_NEW"] = "¿Qué hay nuevo?",
        ["DB_STATUS"] = "Estado",
        ["DB_STATUS_CURRENTLY"] = "Actualmente (ER)",
        ["DB_STATUS_CURRENTLY_COMMON"] = "Estos estados se mostrarán en la descripción de tu personaje. ¡Se claro y breve! |cffff9900Los jugadores con TRP3 sólo verán un máximo de 140 caracteres.",
        ["DB_STATUS_CURRENTLY_OOC"] = "Otra información (FdR)",
        ["DB_STATUS_CURRENTLY_OOC_TT"] = "Aquí puedes indicar algo importante sobre ti, como jugador, o cualquier cosa no relacionada con tu personaje.",
        ["DB_STATUS_CURRENTLY_TT"] = "Aquí puedes indicar cualquier cosa importante sobre tu personaje.",
        ["DB_STATUS_RP"] = "Estado del personaje",
        ["DB_STATUS_RP_EXP"] = "Jugador expermientado",
        ["DB_STATUS_RP_EXP_TT"] = [=[Muestra que eres un jugador de rol experimentado.
No se mostrará ningún icono en la descripción.]=],
        ["DB_STATUS_RP_IC"] = "En rol",
        ["DB_STATUS_RP_IC_TT"] = [=[Actualmente estás interpretando a tu personaje.
Todas tus acciones se interpretará como que las hace tu personaje.]=],
        ["DB_STATUS_RP_OOC"] = "Fuera de rol",
        ["DB_STATUS_RP_OOC_TT"] = [=[Actualmente no estás interpretando a tu personaje.
Tus acciones no se asociarán a tu personaje.]=],
        ["DB_STATUS_RP_VOLUNTEER"] = "Jugador voluntario",
        ["DB_STATUS_RP_VOLUNTEER_TT"] = [=[Seleccionarlo mostrará un icono en la descripción, lo que indica
a nuevos jugadores de rol que estás dispuesto a ayudarlos.]=],
        ["DB_STATUS_XP"] = "Estado del jugador",
        ["DB_STATUS_XP_BEGINNER"] = "Jugador principiante",
        ["DB_STATUS_XP_BEGINNER_TT"] = [=[Seleccionarlo mostrará un icono en la descripción, lo que indica
a otros jugadores de rol que eres un principiante.]=],
        ["DB_TUTO_1"] = [=[|cffffff00El estado del personaje|r indica si actualmente estás interpretando a tu personaje.

|cffffff00El estado del jugador|r indica si eres un jugador de rol principiante o un veterano dispuesto a ayudar.

|cff00ff00Esta información se colocará en la descripción de tu personaje.]=],
        ["DICE_HELP"] = "Tira un dado o varios dados separados por espacios, ejemplo: 1d6, 2d12 3d20 ...",
        ["DICE_ROLL"] = "%s tira |cffff9900%sx d%s|r y obtiene |cff00ff00%s|r.",
        ["DICE_ROLL_T"] = "%s %s tira |cffff9900%sx d%s|r y obtiene |cff00ff00%s|r.",
        ["DICE_TOTAL"] = "%s Total de |cff00ff00%s|r de la tirada.",
        ["DICE_TOTAL_T"] = "%s %s tuvo un total de |cff00ff00%s|r de la tirada.",
        ["DTBK_AFK"] = "Total RP 3 - AUS/NM",
        ["DTBK_CLOAK"] = "Total RP 3 - Capa",
        ["DTBK_HELMET"] = "Total RP 3 - Yelmo",
        ["DTBK_LANGUAGES"] = "Total RP 3 - Idiomas",
        ["DTBK_RP"] = "Total RP 3 - ER/FdR",
        ["GEN_VERSION"] = "Versión: %s (Build %s)",
        ["GEN_WELCOME_MESSAGE"] = "Gracias por usar Total RP 3 (v %s). ¡Diviértete!",
        ["MAP_BUTTON_NO_SCAN"] = "Rastreo no disponible",
        ["MAP_BUTTON_SCANNING"] = "Rastreando",
        ["MAP_BUTTON_SUBTITLE"] = "Haz clic para mostrar los rastreos disponibles",
        ["MAP_SCAN_CHAR"] = "Buscar personajes",
        ["MAP_SCAN_CHAR_TITLE"] = "Personajes",
        ["MATURE_FILTER_ADD_TO_WHITELIST"] = "Añadir este perfil a la |cfffffffflista blanca adulta|r",
        ["MATURE_FILTER_ADD_TO_WHITELIST_OPTION"] = "Añadir a la |cfffffffflista blanca adulta|r",
        ["MATURE_FILTER_ADD_TO_WHITELIST_TEXT"] = [=[Confirma que quieres añadir %s a la |cfffffffflista blanca adulta|r.

El contenido de estos perfiles ya no permanecerá oculto.]=],
        ["MATURE_FILTER_ADD_TO_WHITELIST_TT"] = "Añadir este perfil a la |cfffffffflista blanca adulta|r y revelar su contenido adulto.",
        ["MATURE_FILTER_EDIT_DICTIONARY"] = "Editar diccionario personalizado",
        ["MATURE_FILTER_EDIT_DICTIONARY_ADD_BUTTON"] = "Añadir",
        ["MATURE_FILTER_EDIT_DICTIONARY_ADD_TEXT"] = "Añadir nueva palabra al diccionario",
        ["MATURE_FILTER_EDIT_DICTIONARY_BUTTON"] = "Editar",
        ["MATURE_FILTER_EDIT_DICTIONARY_DELETE_WORD"] = "Eliminar palabra del diccionario personalizado",
        ["MATURE_FILTER_EDIT_DICTIONARY_EDIT_WORD"] = "Editar esta palabra",
        ["MATURE_FILTER_EDIT_DICTIONARY_TITLE"] = "Editor del diccionario personalizado",
        ["MATURE_FILTER_EDIT_DICTIONARY_TT"] = "Editar el diccionario personalizado usado para el filtro de perfiles adultos.",
        ["MATURE_FILTER_FLAG_PLAYER"] = "Marcar como adulto",
        ["MATURE_FILTER_FLAG_PLAYER_OPTION"] = "Marcar como adulto",
        ["MATURE_FILTER_FLAG_PLAYER_TEXT"] = [=[Confirma que quieres marcar el perfil de %s como contenido adulto. El contenido de este perfil quedará oculto.

|cffffff00Opcional:|r Indica las palabras ofensivas que encontraste en este perfil (separadas por un espacio) para añadirlas al filtro.]=],
        ["MATURE_FILTER_FLAG_PLAYER_TT"] = "Marcar este perfil como contenido adulto. El contenido del perfil quedará oculto.",
        ["MATURE_FILTER_OPTION"] = "Filtrar perfiles adultos",
        ["MATURE_FILTER_OPTION_TT"] = [=[Marca esta opción para habilitar el filtrado de perfiles adultos. Total RP 3 escaneará nuevos perfiles cuando se reciban a través de palabras clave reportadas como adultas y marcará el perfil como adulto si encuentra dicha palabra.

Un perfil adulto tendrá la información oculta y tendrás que confirmar que deseas ver el perfil la primera vez que lo abras.]=],
        ["MATURE_FILTER_REMOVE_FROM_WHITELIST"] = "Eliminar este perfil de la |cfffffffflista blanca adulta|r",
        ["MATURE_FILTER_REMOVE_FROM_WHITELIST_OPTION"] = "Eliminar de la |cfffffffflista blanca adulta|r",
        ["MATURE_FILTER_REMOVE_FROM_WHITELIST_TEXT"] = [=[Confirma que quieres eliminar a %s de la |cfffffffflista blanca adulta|r.

El contenido de los perfiles volverá a ocultarse.]=],
        ["MATURE_FILTER_REMOVE_FROM_WHITELIST_TT"] = "Eliminar este perfil de la |cfffffffflista blanca adulta|r y ocultar de nuevo su contenido adulto.",
        ["MATURE_FILTER_TITLE"] = "Filtro de perfiles adultos",
        ["MATURE_FILTER_TOOLTIP_WARNING"] = "Contenido adulto",
        ["MATURE_FILTER_TOOLTIP_WARNING_SUBTEXT"] = "Este perfil de personaje contiene contenido adulto. Usa el botón de la barra de acciones para mostrar si realmente deseas...",
        ["MATURE_FILTER_WARNING_CONTINUE"] = "Continuar",
        ["MATURE_FILTER_WARNING_GO_BACK"] = "Atrás",
        ["MATURE_FILTER_WARNING_TEXT"] = [=[Tienes el filtro de contenido adulto de Total RP 3 habilitado.

Este perfil se ha marcado como contenido adulto.

¿Estás seguro de querer ver este perfil?]=],
        ["MATURE_FILTER_WARNING_TITLE"] = "Contenido adulto",
        ["MM_SHOW_HIDE_MAIN"] = "Mostrar/ocultar marco principal",
        ["MM_SHOW_HIDE_MOVE"] = "Mover botón",
        ["MM_SHOW_HIDE_SHORTCUT"] = "Mostrar/ocultar barra de herramientas",
        ["NEW_VERSION"] = [=[|cff00ff00Hay una nueva versión de Total RP 3 (v %s) disponible.

|cffffff00Recomendamos encarecidamente mantenerlo actualizado.|r

Este mensaje sólo aparecerá una vez por sesión y puede ser deshabilitado en los ajustes (Ajustes generales => Varios).]=],
        ["NEW_VERSION_TITLE"] = "Nueva versión disponible",
        ["NPC_TALK_BUTTON_TT"] = "Abre el marco de diálogos de PNJ el cual permite realizar diálogos y emociones de PNJ.",
        ["NPC_TALK_CHANNEL"] = "Canal:",
        ["NPC_TALK_COMMAND_HELP"] = "Abre el cuadro de diálogo de PNJ.",
        ["NPC_TALK_ERROR_EMPTY_MESSAGE"] = "El mensaje no puede estar vacío.",
        ["NPC_TALK_MESSAGE"] = "Mensaje",
        ["NPC_TALK_NAME"] = "Nombre de PNJ",
        ["NPC_TALK_SAY_PATTERN"] = "dice:",
        ["NPC_TALK_SEND"] = "Enviar",
        ["NPC_TALK_TITLE"] = "Diálogos de PNJ",
        ["NPC_TALK_WHISPER_PATTERN"] = "susurra:",
        ["NPC_TALK_YELL_PATTERN"] = "grita:",
        ["PATTERN_ERROR"] = "Error en el patrón",
        ["PATTERN_ERROR_TAG"] = "Error en patrón : etiqueta de texto sin cerrar.",
        ["PR_CO_BATTLE"] = "Compañero",
        ["PR_CO_COUNT"] = "%s mascota/montura ligada a este perfil.",
        ["PR_CO_EMPTY"] = "Sin compañeros",
        ["PR_CO_MASTERS"] = "Dueño",
        ["PR_CO_MOUNT"] = "Montura",
        ["PR_CO_NEW_PROFILE"] = "Nuevo compañero",
        ["PR_CO_PET"] = "Mascota",
        ["PR_CO_PROFILE_DETAIL"] = "Este perfil está ligado actualmente a",
        ["PR_CO_PROFILE_HELP"] = [=[Un perfil contiene toda la información acerca de una |cffffff00"mascota"|r como un |cff00ff00personaje de rol|r.

Un perfil de compañero puede estar vinculado a:
-Los compañeros |cffff9900(sólo si se ha cambiado el nombre)|r
-Las mascotas del cazador
-Los demonios del brujo
-Los elementales del mago
-Los no-muertos del caballero de la muerte |cffff9900(Ver abajo)|r

Al igual que los perfiles de los personajes, un |cff00ff00perfil de compañero|r puede estar vinculado a |cffffff00várias mascotas|r, y una |cffffff00mascota|r puede cambiar fácilmente de un perfil a otro.

|cffff9900No-muertos:|r como los no-muertos obtienen un nombre diferente cada vez que son invocados, se tendrá que vincular el perfil para todos los nombres posibles del no-muerto.]=],
        ["PR_CO_PROFILE_HELP2"] = [=[Haz clic aquí para crear un nuevo perfil de compañero.

|cff00ff00Para vincular un perfil con una mascota, invoca a la mascota, selecciónala y utiliza el marco de destino para vincularlo al perfil existente (o crear uno nuevo):|r]=],
        ["PR_CO_PROFILEMANAGER_DELETE_WARNING"] = [=[¿Estás seguro de que deseas eliminar el perfil del compañero %s?
¡Esta acción no se podrá deshacer y toda la información del perfil TRP3 será destruida!]=],
        ["PR_CO_PROFILEMANAGER_DUPP_POPUP"] = [=[Por favor, introduce el nombre del nuevo perfil.
El nombre no puede mostrarse vacío.

Esta duplicación no afectará a las mascotas/monturas relacionadas con %s.]=],
        ["PR_CO_PROFILEMANAGER_EDIT_POPUP"] = [=[Por favor, introduce el nuevo nombre para el perfil %s.
El nombre no puede mostrarse vacío.

Cambiar este nombre no afectará al vínculo entre este perfil y tus monturas/mascotas.]=],
        ["PR_CO_PROFILEMANAGER_TITLE"] = "Perfil de compañeros",
        ["PR_CO_UNUSED_PROFILE"] = "Este perfil actualmente no está ligado a ninguna mascota o montura.",
        ["PR_CO_WARNING_RENAME"] = [=[|cffff0000Advertencia;|r se recomienda encarecidamente renombrar a la mascota antes de vincularla a un perfil.|r

¿Quieres enlazarla de todas formas?]=],
        ["PR_CREATE_PROFILE"] = "Crear perfil",
        ["PR_DELETE_PROFILE"] = "Borrar perfil",
        ["PR_DUPLICATE_PROFILE"] = "Duplicar perfil",
        ["PR_EXPORT_IMPORT_HELP"] = [=[Puedes exportar e importar perfiles usando las opciones en el menú desplegable.

Usa la opción |cffffff00Exportar perfil|r para generar un texto conteniendo la información serializada del perfil. Puedes copiar el texto usando Control+C (o Comando+C en un Mac) y pegarlo en otra parte como seguridad. cffff0000Por favor, ten en cuenta que algunas herramientas de texto avanzadas como Microsoft Word reformateará algunos caracteres especiales como comillas, alterando la información. Utiliza herramientas de texto simples como Notepad.|r)

Usa la opción |cffffff00Importar perfil|r para pegar la información de una exportación previa dentro de un perfil existente. La información existente será reemplazada por las que pegues. No puedes importar información directamente de tu perfil seleccionado.]=],
        ["PR_EXPORT_IMPORT_TITLE"] = "Exportar/importar perfil",
        ["PR_EXPORT_NAME"] = "Serie para el perfil %s (tamaño %0.2f kB)",
        ["PR_EXPORT_PROFILE"] = "Exportar perfil",
        ["PR_EXPORT_TOO_LARGE"] = [=[El perfil es demasiado grande y no puede ser exportado.

Tamaño del perfil: %0.2f kB
Máx.: 20 kB]=],
        ["PR_IMPORT"] = "Importar",
        ["PR_IMPORT_CHAR_TAB"] = "Importar personajes",
        ["PR_IMPORT_EMPTY"] = "Sin perfiles importables",
        ["PR_IMPORT_IMPORT_ALL"] = "Importar todos",
        ["PR_IMPORT_PETS_TAB"] = "Importar compañeros",
        ["PR_IMPORT_PROFILE"] = "Importar perfil",
        ["PR_IMPORT_PROFILE_TT"] = "Pegar aquí serie de perfil",
        ["PR_IMPORT_WILL_BE_IMPORTED"] = "Se importarán",
        ["PR_PROFILE"] = "Perfil",
        ["PR_PROFILE_CREATED"] = "El perfil %s ha sido creado.",
        ["PR_PROFILE_DELETED"] = "El perfil %s ha sido eliminado.",
        ["PR_PROFILE_DETAIL"] = "Este perfil actualmente está vinculado a estos personajes de WoW",
        ["PR_PROFILE_HELP"] = [=[Un perfil contiene toda la información de un |cffffff00"personaje"|r como un |cff00ff00personaje de rol|r.

Un |cffffff00"personaje del WoW"|r sólo puede ser vinculado a un solo perfil a la vez, pero puedes cambiar de uno a otro en cualquier momento.

¡También puedes vincular varios |cffffff00"personajes"|r al mismo |cff00ff00perfil|r!]=],
        ["PR_PROFILE_LOADED"] = "El perfil %s se ha cargado.",
        ["PR_PROFILE_MANAGEMENT_TITLE"] = "Administración de perfiles",
        ["PR_PROFILEMANAGER_ACTIONS"] = "Acciones",
        ["PR_PROFILEMANAGER_ALREADY_IN_USE"] = "El nombre del perfil %s no está disponible.",
        ["PR_PROFILEMANAGER_COUNT"] = "%s personaje vinculado a este perfil.",
        ["PR_PROFILEMANAGER_CREATE_POPUP"] = [=[Por favor, introduce un nombre para el nuevo perfil.
El nombre no puede mostrarse vacío.]=],
        ["PR_PROFILEMANAGER_CURRENT"] = "Perfil actual",
        ["PR_PROFILEMANAGER_DELETE_WARNING"] = [=[¿Seguro que deseas eliminar el perfil %s?
¡Esta acción no se podrá deshacer y toda la información del perfil TRP3 (información del personaje, inventario, registro de misiones, estados aplicados...) será destruida!]=],
        ["PR_PROFILEMANAGER_DUPP_POPUP"] = [=[Por favor introduce el nombre para el nuevo perfil.
El nombre no puede mostrarse vacío.

Este duplicado no cambiará las vinculaciones del personaje a %s.]=],
        ["PR_PROFILEMANAGER_EDIT_POPUP"] = [=[Por favor, introduce un nuevo nombre para el perfil %s.
El nombre no puede mostrarse vacío.

Cambiar el nombre no afectará al vinculo entre este perfil y tus personajes.]=],
        ["PR_PROFILEMANAGER_IMPORT_WARNING"] = "¿Reemplazar todo el contenido del perfil %s con la información importada?",
        ["PR_PROFILEMANAGER_IMPORT_WARNING_2"] = [=[Aviso: la serie de este perfil se ha hecho de una versión antigua de TRP3.
Puede causar incompatibilidades.

¿Deseas reemplazar todo el contenido del perfil %s con la información importada?]=],
        ["PR_PROFILEMANAGER_RENAME"] = "Renombrar perfil",
        ["PR_PROFILEMANAGER_SWITCH"] = "Seleccionar perfil",
        ["PR_PROFILEMANAGER_TITLE"] = "Perfiles de personajes",
        ["PR_PROFILES"] = "Perfiles",
        ["PR_UNUSED_PROFILE"] = "Este perfil actualmente no está vinculado a ningún personaje de WoW.",
        ["REG_COMPANION"] = "Compañero",
        ["REG_COMPANION_BOUND_TO"] = "Vincular a...",
        ["REG_COMPANION_BOUND_TO_TARGET"] = "Objetivo",
        ["REG_COMPANION_BOUNDS"] = "Vínculos",
        ["REG_COMPANION_BROWSER_BATTLE"] = "Buscador de compañeros",
        ["REG_COMPANION_BROWSER_MOUNT"] = "Buscador de monturas",
        ["REG_COMPANION_INFO"] = "Información",
        ["REG_COMPANION_LINKED"] = "El compañero %s ahora está ligado al perfil %s.",
        ["REG_COMPANION_LINKED_NO"] = "El compañero %s ya no está ligado a ningún perfil.",
        ["REG_COMPANION_NAME"] = "Nombre",
        ["REG_COMPANION_NAME_COLOR"] = "Color del nombre",
        ["REG_COMPANION_PAGE_TUTO_C_1"] = "Consultar",
        ["REG_COMPANION_PAGE_TUTO_E_1"] = [=[Esta es la |cff00ff00información principal del compañero|r.

Toda esta información aparecerá en la |cffff9900descripción de compañero|r.]=],
        ["REG_COMPANION_PAGE_TUTO_E_2"] = [=[Esta es la |cff00ff00descripción del compañero|r.

No se limita a la |cffff9900descripción física|r. Siéntete libre de indicar parte de su |cffff9900trasfondo|r o detalles de su |cffff9900carácter|r.

Hay muchas maneras de personalizar la descripción.
Puedes elegir el |cffffff00fondo del texto|r para la descripción. También puedes utilizar las herramientas de formato para acceder a varios parámetros de diseño como el |cffffff00tamaño del texto, color y posicionamiento|r.
Esta herramienta también permite insertar |cffffff00imágenes, iconos o enlaces externos de sitios web|r.]=],
        ["REG_COMPANION_PROFILES"] = "Perfiles de compañeros",
        ["REG_COMPANION_TARGET_NO"] = "To objetivo no es una mascota, necrófago, elemental de mago o compañero renombrado válido.",
        ["REG_COMPANION_TF_BOUND_TO"] = "Selecciona un perfil",
        ["REG_COMPANION_TF_CREATE"] = "Crea un nuevo perfil",
        ["REG_COMPANION_TF_NO"] = "Sin perfil",
        ["REG_COMPANION_TF_OPEN"] = "Abrir página",
        ["REG_COMPANION_TF_OWNER"] = "Dueño: %s",
        ["REG_COMPANION_TF_PROFILE"] = "Perfil de compañero",
        ["REG_COMPANION_TF_PROFILE_MOUNT"] = "Perfil de montura",
        ["REG_COMPANION_TF_UNBOUND"] = "Desvincular perfil",
        ["REG_COMPANION_TITLE"] = "Título",
        ["REG_COMPANION_UNBOUND"] = "Desvincular de...",
        ["REG_COMPANIONS"] = "Compañeros",
        ["REG_DELETE_WARNING"] = "¿Seguro que quieres eliminar el perfil %s?",
        ["REG_IGNORE_TOAST"] = "Personaje ignorado",
        ["REG_LIST_ACTIONS_MASS"] = "Acción sobre los %s perfiles seleccionados.",
        ["REG_LIST_ACTIONS_MASS_IGNORE"] = "Ignorar perfiles",
        ["REG_LIST_ACTIONS_MASS_IGNORE_C"] = [=[Esta acción añadirá al |cff00ff00%s personaje|r a la lista de ignorados.

Opcionalmente, puede rellenar la razón de ser ignorado abajo. Esta nota es personal, servirá como recordatorio.]=],
        ["REG_LIST_ACTIONS_MASS_REMOVE"] = "Eliminar perfiles",
        ["REG_LIST_ACTIONS_MASS_REMOVE_C"] = "Esta acción eliminará los |cff00ff00%s perfiles seleccionado(s)|r.",
        ["REG_LIST_ACTIONS_PURGE"] = "Purgar registro",
        ["REG_LIST_ACTIONS_PURGE_ALL"] = "Eliminar todos los perfiles",
        ["REG_LIST_ACTIONS_PURGE_ALL_C"] = [=[Esta purga eliminará todos los perfiles vinculados desde el directorio.

|cff00ff00%s personajes.]=],
        ["REG_LIST_ACTIONS_PURGE_ALL_COMP_C"] = [=[Esta purga eliminará todos los compañeros del directorio.

|cff00ff00%s compañeros.]=],
        ["REG_LIST_ACTIONS_PURGE_COUNT"] = "%s perfiles serán eliminados.",
        ["REG_LIST_ACTIONS_PURGE_EMPTY"] = "No hay perfiles para purgar.",
        ["REG_LIST_ACTIONS_PURGE_IGNORE"] = "Perfiles de personajes ignorados",
        ["REG_LIST_ACTIONS_PURGE_IGNORE_C"] = [=[Esta purga eliminará a todos los perfiles vinculados a un personaje de WoW ignorado.

|cff00ff00%s]=],
        ["REG_LIST_ACTIONS_PURGE_TIME"] = "Perfiles no vistos desde hace 1 mes",
        ["REG_LIST_ACTIONS_PURGE_TIME_C"] = [=[Esta purga eliminará a todos los personajes no vistos desde hace un mes.

|cff00ff00%s]=],
        ["REG_LIST_ACTIONS_PURGE_UNLINKED"] = "Perfiles no vinculados a un personaje",
        ["REG_LIST_ACTIONS_PURGE_UNLINKED_C"] = [=[Esta purga eliminará todos los perfiles no vinculados a un personaje de WoW.

|cff00ff00%s]=],
        ["REG_LIST_ADDON"] = "Tipo de perfil",
        ["REG_LIST_CHAR_EMPTY"] = "Sin personajes",
        ["REG_LIST_CHAR_EMPTY2"] = "Ningún personaje corresponde a tu selección",
        ["REG_LIST_CHAR_FILTER"] = "Personajes: %s / %s",
        ["REG_LIST_CHAR_IGNORED"] = "Ignorado",
        ["REG_LIST_CHAR_SEL"] = "Personaje selecionado",
        ["REG_LIST_CHAR_TITLE"] = "Lista de personajes",
        ["REG_LIST_CHAR_TT"] = "Haz clic para visualizar la página",
        ["REG_LIST_CHAR_TT_CHAR"] = "Personaje(s) de WoW ligado(s):",
        ["REG_LIST_CHAR_TT_CHAR_NO"] = "No está vinculado a ningún personaje",
        ["REG_LIST_CHAR_TT_DATE"] = [=[Última vez que fue visto: |cff00ff00%s|r
Último lugar donde fue visto: |cff00ff00%s|r
]=],
        ["REG_LIST_CHAR_TT_GLANCE"] = "A primera vista",
        ["REG_LIST_CHAR_TT_IGNORE"] = "Personaje(s) ignorado(s)",
        ["REG_LIST_CHAR_TT_NEW_ABOUT"] = "Descripción no leída",
        ["REG_LIST_CHAR_TT_RELATION"] = [=[Relación:
|cff00ff00%s]=],
        ["REG_LIST_CHAR_TUTO_ACTIONS"] = "Esta columna te permite seleccionar múltiples personajes y realizar una acción en conjunto.",
        ["REG_LIST_CHAR_TUTO_FILTER"] = [=[Puedes filtrar la lista de personajes.

El |cff00ff00filtro de nombre|r realizará una búsqueda del nombre completo del perfil (nombre + apellido) y de cualquier personaje de WoW vinculado.

El |cff00ff00filtro de hermandad|r buscará a los personajes de WoW vinculados a la hermandad.

El |cff00ff00filtro de sólo del este reino|r mostrará sólo los perfiles de los personajes del reino actual.]=],
        ["REG_LIST_CHAR_TUTO_LIST"] = [=[La primera columna muestra el nombre del personaje.

La segunda columna muestra la relación entre esos personajes y el tuyo.

La última columna es para varias señales. (ignorados, etc...)]=],
        ["REG_LIST_FILTERS"] = "Filtros",
        ["REG_LIST_FILTERS_TT"] = [=[|cffffff00Clic:|r Aplicar filtros
|cffffff00Clic-derecho:|r Limpiar filtros]=],
        ["REG_LIST_FLAGS"] = "Señales",
        ["REG_LIST_GUILD"] = "Hermandad",
        ["REG_LIST_IGNORE_EMPTY"] = "No hay personajes ignorados",
        ["REG_LIST_IGNORE_TITLE"] = "Lista de ignorados",
        ["REG_LIST_IGNORE_TT"] = [=[Razón:
|cff00ff00%s

|cffffff00Haz clic para eliminar de la lista de ignorados]=],
        ["REG_LIST_NAME"] = "Nombre del personaje",
        ["REG_LIST_NOTIF_ADD"] = "Nuevo perfil descubierto: |cff00ff00%s",
        ["REG_LIST_NOTIF_ADD_CONFIG"] = "Nuevo perfil descubierto",
        ["REG_LIST_NOTIF_ADD_NOT"] = "Este perfil ya no existe.",
        ["REG_LIST_PET_MASTER"] = "Nombre del dueño",
        ["REG_LIST_PET_NAME"] = "Nombre del compañero",
        ["REG_LIST_PET_TYPE"] = "Tipo",
        ["REG_LIST_PETS_EMPTY"] = "No hay compañeros",
        ["REG_LIST_PETS_EMPTY2"] = "Ningún compañero se corresponde a tu selección",
        ["REG_LIST_PETS_FILTER"] = "Compañeros: %s / %s",
        ["REG_LIST_PETS_TITLE"] = "Lista de compañeros",
        ["REG_LIST_PETS_TOOLTIP"] = "Se ha visto en",
        ["REG_LIST_PETS_TOOLTIP2"] = "Se ha visto con",
        ["REG_LIST_REALMONLY"] = "Sólo de este reino",
        ["REG_MSP_ALERT"] = [=[|cffff0000ADVERTENCIA

No se puede tener más de un addon utilizando el Protocolo Mary Sue, ya que podrían entrar en conflicto.|r

Actualmente cargado: |cff00ff00%s

|cffff9900Por lo tanto, se desactivará el apoyo PMS para el Total RP3|r

Si no quieres que el TRP3 sea tu PMS y no quieres ver esta alerta de nuevo, puedes desactivarlo en el módulo Protocolo Mary Sue en ajustes de Total RP3 en -> Estado del módulo.]=],
        ["REG_PLAYER"] = "Personaje",
        ["REG_PLAYER_ABOUT"] = "Acerca de",
        ["REG_PLAYER_ABOUT_ADD_FRAME"] = "Añadir un marco",
        ["REG_PLAYER_ABOUT_EMPTY"] = "Sin descripción",
        ["REG_PLAYER_ABOUT_HEADER"] = "Etiqueta del título",
        ["REG_PLAYER_ABOUT_MUSIC"] = "Tema del personaje",
        ["REG_PLAYER_ABOUT_MUSIC_LISTEN"] = "Reproducir tema",
        ["REG_PLAYER_ABOUT_MUSIC_REMOVE"] = "Deseleccionar tema",
        ["REG_PLAYER_ABOUT_MUSIC_SELECT"] = "Seleccionar tema del personaje",
        ["REG_PLAYER_ABOUT_MUSIC_SELECT2"] = "Seleccionar tema",
        ["REG_PLAYER_ABOUT_MUSIC_STOP"] = "Detener tema",
        ["REG_PLAYER_ABOUT_NOMUSIC"] = "|cffff9900Sin tema",
        ["REG_PLAYER_ABOUT_P"] = "Etiqueta del parágrafo",
        ["REG_PLAYER_ABOUT_REMOVE_FRAME"] = "Eliminar este marco",
        ["REG_PLAYER_ABOUT_SOME"] = "Escribir texto aquí...",
        ["REG_PLAYER_ABOUT_T1_YOURTEXT"] = "Texto aquí",
        ["REG_PLAYER_ABOUT_TAGS"] = "Herramientas de formato",
        ["REG_PLAYER_ABOUT_UNMUSIC"] = "|cffff9900Tema desconocido",
        ["REG_PLAYER_ABOUT_VOTE_DOWN"] = "No me gusta este contenido",
        ["REG_PLAYER_ABOUT_VOTE_NO"] = [=[No hay personajes conectados vinculados a este perfil.
¿Deseas mandar el voto de todas formas?]=],
        ["REG_PLAYER_ABOUT_VOTE_SENDING"] = "Enviando tu voto a %s...",
        ["REG_PLAYER_ABOUT_VOTE_SENDING_OK"] = "¡Tu voto ha sido enviado a %s!",
        ["REG_PLAYER_ABOUT_VOTE_TT"] = "Tu voto es totalmente anónimo y sólo puede ser visto por este jugador.",
        ["REG_PLAYER_ABOUT_VOTE_TT2"] = "Puedes votar sólo si el jugador está conectado.",
        ["REG_PLAYER_ABOUT_VOTE_UP"] = "Me gusta este contenido",
        ["REG_PLAYER_ABOUT_VOTES"] = "Estadísticas",
        ["REG_PLAYER_ABOUT_VOTES_R"] = [=[|cff00ff00%s Me gusta
|cffff0000%s No me gusta]=],
        ["REG_PLAYER_ABOUTS"] = "Acerca de %s",
        ["REG_PLAYER_ADD_NEW"] = "Crear nuevo",
        ["REG_PLAYER_AGE"] = "Edad",
        ["REG_PLAYER_AGE_TT"] = [=[Aquí puedes indicar la edad de tu personaje.

Hay varias maneras de hacer esto:|c0000ff00
- Bien usando años,
- O un adjetivo (joven, maduro, adulto, venerado, etc.).]=],
        ["REG_PLAYER_ALERT_HEAVY_SMALL"] = [=[|cffff0000El tamaño total de tu perfil es demasiado extenso.
|cffff9900Debes reducirlo.]=],
        ["REG_PLAYER_BIRTHPLACE"] = "Lugar de nacimiento",
        ["REG_PLAYER_BIRTHPLACE_TT"] = [=[Aquí puedes indicar el lugar de nacimiento de tu personaje. Puede ser una región, una zona o incluso un continente. Tú decides lo preciso que quieres ser.

|c00ffff00Puedes usar el botón de la derecha para poner tu ubicación actual como lugar de nacimiento.]=],
        ["REG_PLAYER_BKG"] = "Diseño de fondo",
        ["REG_PLAYER_BKG_TT"] = "Representa el fondo visual a elegir para tu diseño de Características.",
        ["REG_PLAYER_CARACT"] = "Características",
        ["REG_PLAYER_CHANGE_CONFIRM"] = [=[Tienes datos que no han sido guardados
¿Quieres cambiar de página de todas formas?
|cffff9900Perderás todos los cambios.]=],
        ["REG_PLAYER_CHARACTERISTICS"] = "Características",
        ["REG_PLAYER_CLASS"] = "Clase",
        ["REG_PLAYER_CLASS_TT"] = [=[Esta es la clase de tu personaje.

|cff00ff00Por ejemplo:|r
Caballero, piromante, nigromante, tirador de élite, arcanista...]=],
        ["REG_PLAYER_COLOR_CLASS"] = "Color de clase",
        ["REG_PLAYER_COLOR_CLASS_TT"] = "Esto determina el color en que se visualizará la clase.",
        ["REG_PLAYER_COLOR_TT"] = [=[|cffffff00Clic:|r Seleccionar color
|cffffff00Clic derecho:|r Descartar color]=],
        ["REG_PLAYER_CURRENT"] = "Actualmente",
        ["REG_PLAYER_CURRENT_OOC"] = "Esto es información FdR",
        ["REG_PLAYER_CURRENTOOC"] = "Actualmente (FdR)",
        ["REG_PLAYER_EYE"] = "Color de ojos",
        ["REG_PLAYER_EYE_TT"] = [=[Aquí puedes indicar el color de ojos de tu personaje.

Ten en cuenta que, aunque tu rostro esté constantemente oculto, vale la pena mencionarlo, por si acaso.]=],
        ["REG_PLAYER_FIRSTNAME"] = "Nombre",
        ["REG_PLAYER_FIRSTNAME_TT"] = [=[Este es el nombre de tu personaje. Este es un campo obligatorio a rellenar, por lo que si no se especifica un nombre se usará el nombre por defecto (|cffffff00%s|r).

¡Puedes utilizar un |c0000ff00apodo|r!]=],
        ["REG_PLAYER_FULLTITLE"] = "Título completo",
        ["REG_PLAYER_FULLTITLE_TT"] = [=[Aquí puedes escribir el título completo de tu personaje. Puede ser una versión más larga del título u otro título completo.

Sin embargo, es posible que quieras evitar repeticiones, en caso de que no haya información adicional que mencionar.]=],
        ["REG_PLAYER_GLANCE"] = "A primera vista",
        ["REG_PLAYER_GLANCE_BAR_DELETED"] = "Grupo prestablecido |cffff9900%s|r eliminado.",
        ["REG_PLAYER_GLANCE_BAR_EMPTY"] = "El nombre del predeterminado no puede estar vacío.",
        ["REG_PLAYER_GLANCE_BAR_LOAD"] = "Grupo restablecido",
        ["REG_PLAYER_GLANCE_BAR_LOAD_SAVE"] = "Grupo predeterminado",
        ["REG_PLAYER_GLANCE_BAR_NAME"] = [=[Por favor introduce el nombre del predeterminado.

|cff00ff00Nota: Si el nombre ya está siendo usado por otro grupo, será remplazado por este grupo. ]=],
        ["REG_PLAYER_GLANCE_BAR_SAVE"] = "Guardar grupo como predeterminado.",
        ["REG_PLAYER_GLANCE_BAR_SAVED"] = "Grupo predeterminado |cff00ff00%s|r ha sido creado",
        ["REG_PLAYER_GLANCE_BAR_TARGET"] = "\"A primera vista\" predeterminado",
        ["REG_PLAYER_GLANCE_CONFIG"] = [=[|cff00ff00"A primera vista"|r es una serie de ranuras que puedes usar para añadir información importante sobre este personaje.

Puedes usar estas acciones en dichas ranuras:
|cffffff00Clic:|r configurar ranura
|cffffff00Doble clic:|r activar/desactivar ranura
|cffffff00Clic derecho:|r ranuras prestablecidas
|cffffff00Arrastrar y soltar:|r reordenar ranuras]=],
        ["REG_PLAYER_GLANCE_EDITOR"] = "Editor visual: Ranura %s",
        ["REG_PLAYER_GLANCE_PRESET"] = "Cargar predeterminado",
        ["REG_PLAYER_GLANCE_PRESET_ADD"] = "Creado prestablecido |cff00ff00%s|r.",
        ["REG_PLAYER_GLANCE_PRESET_ALERT1"] = "Por favor, introduce una categoría y un nombre",
        ["REG_PLAYER_GLANCE_PRESET_CATEGORY"] = "Categoría",
        ["REG_PLAYER_GLANCE_PRESET_CREATE"] = "Crear prestablecido",
        ["REG_PLAYER_GLANCE_PRESET_GET_CAT"] = [=[%s

Por favor introduce el nombre para este prestablecido.]=],
        ["REG_PLAYER_GLANCE_PRESET_NAME"] = "Nombre",
        ["REG_PLAYER_GLANCE_PRESET_REMOVE"] = "Eliminar prestablecido |cff00ff00%s|r.",
        ["REG_PLAYER_GLANCE_PRESET_SAVE"] = "Guardar información como predeterminado",
        ["REG_PLAYER_GLANCE_PRESET_SAVE_SMALL"] = "Guardar como predeterminado",
        ["REG_PLAYER_GLANCE_PRESET_SELECT"] = "Seleccionar predeterminado",
        ["REG_PLAYER_GLANCE_TITLE"] = "Nombre del atributo",
        ["REG_PLAYER_GLANCE_UNUSED"] = "Ranura no utilizada",
        ["REG_PLAYER_GLANCE_USE"] = "Activar esta ranura",
        ["REG_PLAYER_HEIGHT"] = "Altura",
        ["REG_PLAYER_HEIGHT_TT"] = [=[Esta es la altura de tu personaje.
Hay varias maneras de hacer esto:|c0000ff00
- Numérico: 1,70m, 6'5''...
- Un calificativo: alto, bajo...]=],
        ["REG_PLAYER_HERE"] = "Obtener posición",
        ["REG_PLAYER_HERE_HOME_PRE_TT"] = [=[Actual posición de la residencia:
|cff00ff00%s|r.]=],
        ["REG_PLAYER_HERE_HOME_TT"] = [=[|cffffff00Clic|r: Usar la posición actual como tu residencia.
|cffffff00Clic-derecho|r: Elimina la posición de la residencia.]=],
        ["REG_PLAYER_HERE_TT"] = "Haz clic para obtener tu posición actual",
        ["REG_PLAYER_HISTORY"] = "Trasfondo",
        ["REG_PLAYER_ICON"] = "Icono del personaje",
        ["REG_PLAYER_ICON_TT"] = "Selecciona una representación gráfica para tu personaje.",
        ["REG_PLAYER_IGNORE"] = "Ignorar personajes vinculados (%s)",
        ["REG_PLAYER_IGNORE_WARNING"] = [=[¿Quieres ignorar a estos personajes?

|cffff9900%s

|rOpcionalmente puedes escribir la razón a continuación. Esta nota personal servirá como recordatorio.]=],
        ["REG_PLAYER_LASTNAME"] = "Apellido",
        ["REG_PLAYER_LASTNAME_TT"] = "Este es el apellido de tu personaje.",
        ["REG_PLAYER_LEFTTRAIT"] = "Atributo izquierdo",
        ["REG_PLAYER_MISC_ADD"] = "Añadir un campo adicional",
        ["REG_PLAYER_MORE_INFO"] = "Información adicional",
        ["REG_PLAYER_MSP_HOUSE"] = "Nombre de la Casa",
        ["REG_PLAYER_MSP_MOTTO"] = "Lema",
        ["REG_PLAYER_MSP_NICK"] = "Apodo",
        ["REG_PLAYER_NAMESTITLES"] = "Nombre y títulos",
        ["REG_PLAYER_NO_CHAR"] = "Sin características",
        ["REG_PLAYER_PEEK"] = "Varios",
        ["REG_PLAYER_PHYSICAL"] = "Descripción física",
        ["REG_PLAYER_PSYCHO"] = "Rasgos de personalidad",
        ["REG_PLAYER_PSYCHO_Acete"] = "Asceta",
        ["REG_PLAYER_PSYCHO_ADD"] = "Añadir un rasgo de personalidad",
        ["REG_PLAYER_PSYCHO_ATTIBUTENAME_TT"] = "Nombre del atributo",
        ["REG_PLAYER_PSYCHO_Bonvivant"] = "Vividor",
        ["REG_PLAYER_PSYCHO_CHAOTIC"] = "Caótico",
        ["REG_PLAYER_PSYCHO_Chaste"] = "Casto",
        ["REG_PLAYER_PSYCHO_Conciliant"] = "Ejemplar",
        ["REG_PLAYER_PSYCHO_Couard"] = "Cobarde",
        ["REG_PLAYER_PSYCHO_CREATENEW"] = "Crear un rasgo",
        ["REG_PLAYER_PSYCHO_Cruel"] = "Brutal",
        ["REG_PLAYER_PSYCHO_CUSTOM"] = "Rasgo personalizado",
        ["REG_PLAYER_PSYCHO_Egoiste"] = "Egoísta",
        ["REG_PLAYER_PSYCHO_Genereux"] = "Altruista",
        ["REG_PLAYER_PSYCHO_Impulsif"] = "Impulsivo",
        ["REG_PLAYER_PSYCHO_Indulgent"] = "Indulgente",
        ["REG_PLAYER_PSYCHO_LEFTICON_TT"] = "Establece el icono del atributo de la izquierda",
        ["REG_PLAYER_PSYCHO_Loyal"] = "Legal",
        ["REG_PLAYER_PSYCHO_Luxurieux"] = "Lujurioso",
        ["REG_PLAYER_PSYCHO_Misericordieux"] = "Pacífico",
        ["REG_PLAYER_PSYCHO_MORE"] = "Añadir un punto de \"%s\"",
        ["REG_PLAYER_PSYCHO_PERSONAL"] = "Características personales",
        ["REG_PLAYER_PSYCHO_Pieux"] = "Devoto",
        ["REG_PLAYER_PSYCHO_POINT"] = "Añadir un punto",
        ["REG_PLAYER_PSYCHO_Pragmatique"] = "Renegado",
        ["REG_PLAYER_PSYCHO_Rationnel"] = "Racional",
        ["REG_PLAYER_PSYCHO_Reflechi"] = "Reflexivo",
        ["REG_PLAYER_PSYCHO_Rencunier"] = "Vengativo",
        ["REG_PLAYER_PSYCHO_RIGHTICON_TT"] = "Establece el icono del atributo de la derecha.",
        ["REG_PLAYER_PSYCHO_Sincere"] = "Sincero",
        ["REG_PLAYER_PSYCHO_SOCIAL"] = "Características sociales",
        ["REG_PLAYER_PSYCHO_Trompeur"] = "Embustero",
        ["REG_PLAYER_PSYCHO_Valeureux"] = "Valeroso",
        ["REG_PLAYER_RACE"] = "Raza",
        ["REG_PLAYER_RACE_TT"] = "Aquí va la raza de tu personaje. No está restringido a las razas jugables. Hay muchas razas del Warcraft que pueden asumir formas comunes...",
        ["REG_PLAYER_REGISTER"] = "Información del directorio",
        ["REG_PLAYER_RESIDENCE"] = "Residencia",
        ["REG_PLAYER_RESIDENCE_SHOW"] = "Coordenadas de residencia",
        ["REG_PLAYER_RESIDENCE_SHOW_TT"] = [=[|cff00ff00%s

|rClic para mostrar en el mapa]=],
        ["REG_PLAYER_RESIDENCE_TT"] = [=[Aquí puedes indicar donde vive el personaje normalmente. Esta podría ser su dirección personal (su casa) o el lugar donde se hospeda.
Ten en cuenta que si tu personaje es un vagabundo, tendrás que cambiar la información.

|c00ffff00Puedes utilizar el botón de la derecha para fijar la posición actual como residencia.]=],
        ["REG_PLAYER_RIGHTTRAIT"] = "Atributo derecho",
        ["REG_PLAYER_SHOWMISC"] = "Mostrar marco de varios",
        ["REG_PLAYER_SHOWMISC_TT"] = [=[Márcalo si quieres mostrar los campos personalizados para tu personaje.

Si no quieres mostrar los campos personalizados, mantén esta casilla sin marcar y se mantendrá totalmente oculta.]=],
        ["REG_PLAYER_SHOWPSYCHO"] = "Mostrar el marco de personalidad",
        ["REG_PLAYER_SHOWPSYCHO_TT"] = [=[Marca si quieres utilizar la descripción del personaje.

Si no quieres mostrar la personalidad del personaje mediante este método, mantén esta casilla sin marcar y se mantendrá totalmente oculta.]=],
        ["REG_PLAYER_STYLE_ASSIST"] = "Asistencia de rol",
        ["REG_PLAYER_STYLE_BATTLE"] = "Resolución de batallas de rol",
        ["REG_PLAYER_STYLE_BATTLE_1"] = "World of warcraft JcJ",
        ["REG_PLAYER_STYLE_BATTLE_2"] = "Batallas a dados TRP",
        ["REG_PLAYER_STYLE_BATTLE_3"] = "Batalla a dados",
        ["REG_PLAYER_STYLE_BATTLE_4"] = "Batalla a emotes",
        ["REG_PLAYER_STYLE_DEATH"] = "Aceptación de muerte",
        ["REG_PLAYER_STYLE_EMPTY"] = "Sin atributos de rol compartidos",
        ["REG_PLAYER_STYLE_FREQ"] = "Frecuencia de rol",
        ["REG_PLAYER_STYLE_FREQ_1"] = "Todo el tiempo",
        ["REG_PLAYER_STYLE_FREQ_2"] = "La mayoría de las veces",
        ["REG_PLAYER_STYLE_FREQ_3"] = "La mitad del tiempo",
        ["REG_PLAYER_STYLE_FREQ_4"] = "A veces",
        ["REG_PLAYER_STYLE_FREQ_5"] = "No es un personaje de rol",
        ["REG_PLAYER_STYLE_GUILD"] = "Miembro de hermandad",
        ["REG_PLAYER_STYLE_GUILD_IC"] = "Miembro ER",
        ["REG_PLAYER_STYLE_GUILD_OOC"] = "Miembro FdR",
        ["REG_PLAYER_STYLE_HIDE"] = "No mostrar",
        ["REG_PLAYER_STYLE_INJURY"] = "Aceptación de heridas",
        ["REG_PLAYER_STYLE_PERMI"] = "Con el permiso del jugador",
        ["REG_PLAYER_STYLE_ROMANCE"] = "Aceptación de romances",
        ["REG_PLAYER_STYLE_RPSTYLE"] = "Estilo de rol",
        ["REG_PLAYER_STYLE_RPSTYLE_SHORT"] = "Estilo ER",
        ["REG_PLAYER_STYLE_WOWXP"] = "Experiencia en World of Warcraft",
        ["REG_PLAYER_TITLE"] = "Título",
        ["REG_PLAYER_TITLE_TT"] = [=[El título de tu personaje es el título con el que tu personaje es llamado normalmente. Evita colocar títulos largos, para ello se ha de utilizar el título completo.

Ejemplos de |c0000ff00títulos apropiados|r:
|c0000ff00- Condesa,
- Marqués,
- Mago,
- Señor,
- etc.
|rEjemplo de |cffff0000títulos inapropiados|r:
|cffff0000- Condesa de las Marismas del Norte,
- Mago de la Torre de Ventormenta,
- Diplomático de los draenei,
- etc.]=],
        ["REG_PLAYER_TRP2_PIERCING"] = "Piercings",
        ["REG_PLAYER_TRP2_TATTOO"] = "Tatuajes",
        ["REG_PLAYER_TRP2_TRAITS"] = "Fisionomía",
        ["REG_PLAYER_TUTO_ABOUT_COMMON"] = [=[|cff00ff00Tema del personaje:|r
Puedes elegir un |cffffff00tema|r para tu personaje. Piensa en ello como una |cffffff00música de ambientación para la lectura de la descripción de tu personaje.

|cff00ff00Fondo:|r
Este es el |cffffff00tipo de fondo|r para la descripción de tu personaje.

|cff00ff00Plantilla:|r
La plantilla elegida define |cffffff00las posibilidades del diseño y escritura generales|r para tu descripción.
|cffff9900Sólo la plantilla seleccionada se verá, no hace falta rellenar todas.|r
Una vez elegida la plantilla puedes volver a abrir este tutorial para tener más ayuda sobre cada plantilla.]=],
        ["REG_PLAYER_TUTO_ABOUT_MISC_1"] = [=[Esta selección te ofrece |cffffff005 ranuras|r con las que se puede describir |cff00ff00las piezas más importantes de tu personaje|r.

Estas ranuras serán visibles en |cffffff00"A primera vista"|r cuando alguien seleccione a tu personaje.

|cff00ff00Sugerencia: Puedes arrastrar y soltar ranuras para reorganizarlas.|r
¡Esto también funciona en la |cffffff00barra de "A primera vista"|r!]=],
        ["REG_PLAYER_TUTO_ABOUT_MISC_3"] = "Esta sección contiene |cffffff00una lista de notas|r para responder muchas |cffffff00preguntas comunes que la gente podría preguntarse acerca de ti, sobre tu personaje y la forma en que deseas interpretarlo|r.",
        ["REG_PLAYER_TUTO_ABOUT_T1"] = [=[Esta plantilla te permite |cff00ff00estructurar libremente tu descripción|r.

La descripción no tiene que limitarse a la |cffff9900descripción física|r de tu personaje. Siéntete libre para indicar parte de su |cffff9900trasfondo|r o detalles sobre su |cffff9900personalidad|r.

Con esta plantilla se pueden utilizar las herramientas de formato para acceder a varios parámetros de diseño como el |cffffff00tamaño del texto, color o alineacioness|r.
Esta herramienta también permite insertar |cffffff00imágenes, iconos o links externos de sitios webs|r.]=],
        ["REG_PLAYER_TUTO_ABOUT_T2"] = [=[Esta plantilla es más estructurada y consiste en |cff00ff00una lista de marcos independientes|r.

Cada marco se caracteriza por un |cffffff00icono, un fondo y un texto|r. Ten en cuenta que puedes utilizar algunas etiquetas de texto en estos recuadros, como el color y las etiquetas de icono de texto.

La descripción no tiene que limitarse a la descripción física|r de tu personaje. Siéntete libre para indicar parte de tu |cffff9900trasfondo|r o detalles sobre tu |cffff9900personalidad|r.]=],
        ["REG_PLAYER_TUTO_ABOUT_T3"] = [=[Esta plantilla está separada en 3 secciones: |cff00ff00Descripción física, personalidad y trasfondo|r.

No hace falta llenar todos los cuadros, |cffff9900si dejas un cuadro vacío no se mostrará en tu descripción|r.

Cada cuadro se caracteriza por un |cffffff00icono, un fondo y un texto|r. Ten en cuenta que puedes utilizar algunas etiquetas de texto en estos cuadros, como el color y las etiquetas de iconos de texto.]=],
        ["REG_PLAYER_WEIGHT"] = "Complexión",
        ["REG_PLAYER_WEIGHT_TT"] = [=[Esta es la complexión de tu personaje.
Por ejemplo podría ser |c0000ff00delgado, gordo o musculoso...|r ¡O simplemente podría ser normal!]=],
        ["REG_REGISTER"] = "Directorio",
        ["REG_REGISTER_CHAR_LIST"] = "Lista de personajes",
        ["REG_RELATION"] = "Relación",
        ["REG_RELATION_BUSINESS"] = "Negocios",
        ["REG_RELATION_BUSINESS_TT"] = "%s y %s tienen una relación de negocios.",
        ["REG_RELATION_BUTTON_TT"] = [=[Relación: %s
|cff00ff00%s

|cffffff00Haz clic para mostrar las acciones posibles]=],
        ["REG_RELATION_FAMILY"] = "Familia",
        ["REG_RELATION_FAMILY_TT"] = "%s tiene un lazo de sangre con %s.",
        ["REG_RELATION_FRIEND"] = "Amigo",
        ["REG_RELATION_FRIEND_TT"] = "%s es amigo de %s.",
        ["REG_RELATION_LOVE"] = "Amor",
        ["REG_RELATION_LOVE_TT"] = "¡%s está enamorado de %s!",
        ["REG_RELATION_NEUTRAL"] = "Conocido",
        ["REG_RELATION_NEUTRAL_TT"] = "%s conoce a %s.",
        ["REG_RELATION_NONE"] = "Ninguno",
        ["REG_RELATION_NONE_TT"] = "%s no conoce a %s.",
        ["REG_RELATION_TARGET"] = "|cffffff00Clic: |rCambiar relación",
        ["REG_RELATION_UNFRIENDLY"] = "Enemigo",
        ["REG_RELATION_UNFRIENDLY_TT"] = "%s está enemistado con %s.",
        ["REG_TT_GUILD"] = "%s de |cffff9900%s",
        ["REG_TT_GUILD_IC"] = "Miembro ER",
        ["REG_TT_GUILD_OOC"] = "Miembro FdR",
        ["REG_TT_IGNORED"] = "<Personaje ignorado>",
        ["REG_TT_IGNORED_OWNER"] = "<Propietario ignorado>",
        ["REG_TT_LEVEL"] = "Nivel %s %s",
        ["REG_TT_NOTIF"] = "Descripción no leida",
        ["REG_TT_REALM"] = "Reino: |cffff9900%s",
        ["REG_TT_TARGET"] = "Objetivo: |cffff9900%s",
        ["SCRIPT_ERROR"] = "Error en el script.",
        ["SCRIPT_UNKNOWN_EFFECT"] = "Error de script, FX desconocido",
        ["TB_AFK_MODE"] = "Ausente",
        ["TB_DND_MODE"] = "Ocupado",
        ["TB_GO_TO_MODE"] = "Cambiar a modo %s",
        ["TB_LANGUAGE"] = "Idioma",
        ["TB_LANGUAGES_TT"] = "Cambiar idioma",
        ["TB_NORMAL_MODE"] = "Normal",
        ["TB_RPSTATUS_OFF"] = "Personaje: |cffff0000Fuera de Rol",
        ["TB_RPSTATUS_ON"] = "Personaje: |cff00ff00En Rol",
        ["TB_RPSTATUS_TO_OFF"] = "Cambiar a |cffff0000Fuera de Rol",
        ["TB_RPSTATUS_TO_ON"] = "Cambiar a |cff00ff00En Rol",
        ["TB_STATUS"] = "Jugador",
        ["TB_SWITCH_CAPE_1"] = "Mostrar capa",
        ["TB_SWITCH_CAPE_2"] = "Ocultar capa",
        ["TB_SWITCH_CAPE_OFF"] = "Capa: |cffff0000Oculta",
        ["TB_SWITCH_CAPE_ON"] = "Capa: |cff00ff00Visble",
        ["TB_SWITCH_HELM_1"] = "Mostrar yelmo",
        ["TB_SWITCH_HELM_2"] = "Ocultar yelmo",
        ["TB_SWITCH_HELM_OFF"] = "Yelmo: |cffff0000Oculto",
        ["TB_SWITCH_HELM_ON"] = "Yelmo: |cff00ff00Visible",
        ["TB_SWITCH_PROFILE"] = "Cambiar de perfil",
        ["TB_SWITCH_TOOLBAR"] = "Cambiar barra de herramientas",
        ["TB_TOOLBAR"] = "Barra de herramientas",
        ["TF_IGNORE"] = "Ignorar jugador",
        ["TF_IGNORE_CONFIRM"] = [=[¿Estás seguro que deseas ignorar esta ID?

|cffffff00%s|r

|cffff7700Opcionalmente puedes escribir debajo la razón por la que le quieres ignorar. Esta es una nota personal, no será visible por otros y servirá como recordatorio.]=],
        ["TF_IGNORE_NO_REASON"] = "No hay razón",
        ["TF_IGNORE_TT"] = "|cffffff00Clic:|r Ignorar jugador",
        ["TF_OPEN_CHARACTER"] = "Mostrar página del personaje",
        ["TF_OPEN_COMPANION"] = "Mostrar página del compañero",
        ["TF_OPEN_MOUNT"] = "Mostrar página de montura",
        ["TF_PLAY_THEME"] = "Reproducir el tema del personaje",
        ["TF_PLAY_THEME_TT"] = [=[|cffffff00Clic:|r Tocar |cff00ff00%s
|cffffff00Clic-derecho:|r Parar tema]=],
        ["THANK_YOU_1"] = [=[{h1:c}Total RP 3{/h1}
{p:c}{col:6eff51}Versión %s (build %s){/col}{/p}
{p:c}{link*http://totalrp3.info*TotalRP3.info} — {twitter*TotalRP3*@TotalRP3} {/p}

{h2}{icon:INV_Eng_gizmo1:20} Creado por{/h2}
- Renaud "{twitter*EllypseCelwe*Ellypse}" Parize
- Sylvain "{twitter*Telkostrasz*Telkostrasz}" Cossement


{h2}{icon:THUMBUP:20} Reconocimientos{/h2}
{col:ffffff}Ellypse's Patreon supporters:{/col}
- Connor "{twitter*Saelorable*Sælorable}" Macleod
- Nikradical
- Ilsyra

{col:ffffff}Nuestro equpo PR pre-alpha:{/col}
- Saelora
- Erzan
- Calian
- Kharess
- Alnih
- 611

{col:ffffff}Gracias a todos nuestros amigos por su apoyo todos estos años:{/col}
- Para Telkos: Kharess, Kathryl, Marud, Solona, Stretcher, Lisma...
- Para Ellypse: The guilds Maison Celwë'Belore, Mercenaires Atal'ai, y más particularmente Erzan, Elenna, Caleb, Siana and Adaeria

{col:ffffff}Por ayudarnos a crear la hermandad Total RP en Kirin Tor (EU):{/col}
- Azane
- Hellclaw
- Leylou
]=],
        ["UI_BKG"] = "Fondo %s",
        ["UI_CLOSE_ALL"] = "Cerrar todo",
        ["UI_COLOR_BROWSER"] = "Buscador de color",
        ["UI_COLOR_BROWSER_SELECT"] = "Seleccionar color",
        ["UI_COMPANION_BROWSER_HELP"] = "Seleccionar compañero",
        ["UI_COMPANION_BROWSER_HELP_TT"] = [=[|cffffff00Advertencia: |rSólo los compañeros renombrados pueden vincularse a un perfil..

|cff00ff00Esta sección sólo muestra a estos compañeros.]=],
        ["UI_FILTER"] = "Filtro",
        ["UI_ICON_BROWSER"] = "Buscador de icono",
        ["UI_ICON_BROWSER_HELP"] = "Copiar icono",
        ["UI_ICON_BROWSER_HELP_TT"] = [=[Mientras este marco esté abierto puedes hacer |cffffff00ctrl + clic|r en un icono para copiar su nombre.

Esto funcionará en:|cff00ff00
- Cualquier objeto de tu mochila
- Cualquier icono del libro de hechizos|r]=],
        ["UI_ICON_SELECT"] = "Seleccionar icono",
        ["UI_IMAGE_BROWSER"] = "Buscador de imagen",
        ["UI_IMAGE_SELECT"] = "Seleccionar imagen",
        ["UI_LINK_TEXT"] = "Tu texto aquí",
        ["UI_LINK_URL"] = "http://tu.url.aquí",
        ["UI_LINK_WARNING"] = [=[Aquí está el enlace URL.
Puedes copiar/pegar desde tu navegador web.

|cffff0000¡¡Atención!!|r
Total RP no es responsable de los enlaces que conducen a contenidos nocivos.]=],
        ["UI_MUSIC_BROWSER"] = "Buscador de tema",
        ["UI_MUSIC_SELECT"] = "Seleccionar tema",
        ["UI_TUTO_BUTTON"] = "Modo tutorial",
        ["UI_TUTO_BUTTON_TT"] = "Haz clic para activar/desactivar el modo tutorial"
    }
    --@end-do-not-package@
};

TRP3_API.locale.registerLocale(LOCALE);