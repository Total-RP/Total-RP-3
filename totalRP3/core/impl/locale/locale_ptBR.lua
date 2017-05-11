----------------------------------------------------------------------------------
-- Total RP 3
-- Brazilian Portuguese locale
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

local LOCALE = {
	locale = "ptBR",
	localeText = "Brazilian Portuguese",
    localeContent =
    --@localization(locale="ptBR", format="lua_table", handle-unlocalized="ignore")@
    --@do-not-package@
    {
        ["ABOUT_TITLE"] = "Sobre",
        ["BINDING_NAME_TRP3_TOGGLE"] = "Mostrar/ocultar tela principal",
        ["BINDING_NAME_TRP3_TOOLBAR_TOGGLE"] = "Mostrar/ocultar barra de ferramentas",
        ["BW_COLOR_CODE"] = "Código de cor",
        ["BW_COLOR_CODE_ALERT"] = "Código hexadecimal incorreto!",
        ["BW_COLOR_CODE_TT"] = "Você pode colar um código de cor hexadecimal de 6 caracteres aqui e pressionar Enter.",
        ["CM_ACTIONS"] = "Ações",
        ["CM_APPLY"] = "Aplicar",
        ["CM_CANCEL"] = "Cancelar",
        ["CM_CENTER"] = "Centro",
        ["CM_CLASS_DEATHKNIGHT"] = "Cavaleiro da Morte",
        ["CM_CLASS_DRUID"] = "Druida",
        ["CM_CLASS_HUNTER"] = "Caçador",
        ["CM_CLASS_MAGE"] = "Mago",
        ["CM_CLASS_MONK"] = "Monge",
        ["CM_CLASS_PALADIN"] = "Paladino",
        ["CM_CLASS_PRIEST"] = "Sacerdote",
        ["CM_CLASS_ROGUE"] = "Ladino",
        ["CM_CLASS_SHAMAN"] = "Xamã",
        ["CM_CLASS_UNKNOWN"] = "Desconhecido",
        ["CM_CLASS_WARLOCK"] = "Bruxo",
        ["CM_CLASS_WARRIOR"] = "Guerreiro",
        ["CM_CLICK"] = "Clique",
        ["CM_COLOR"] = "Cor",
        ["CM_CTRL"] = "Ctrl",
        ["CM_DOUBLECLICK"] = "Duplo-click",
        ["CM_DRAGDROP"] = "Arrastar & soltar",
        ["CM_EDIT"] = "Editar",
        ["CM_IC"] = "IC",
        ["CM_ICON"] = "Ícone",
        ["CM_IMAGE"] = "Imagem",
        ["CM_L_CLICK"] = "Clique-esquerdo",
        ["CM_LEFT"] = "Esquerda",
        ["CM_LINK"] = "Link",
        ["CM_LOAD"] = "Carregar",
        ["CM_MOVE_DOWN"] = "Mover para baixo",
        ["CM_MOVE_UP"] = "Mover para cima",
        ["CM_NAME"] = "Nome",
        ["CM_OOC"] = "OOC",
        ["CM_OPEN"] = "Aberto",
        ["CM_PLAY"] = "Reproduzir",
        ["CM_R_CLICK"] = "Clique-direito",
        ["CM_REMOVE"] = "Remover",
        ["CM_RESIZE"] = "Redimensionar",
        ["CM_RESIZE_TT"] = "Arraste para redimensionar a janela.",
        ["CM_RIGHT"] = "Direita",
        ["CM_SAVE"] = "Salvar",
        ["CM_SELECT"] = "Selecionar",
        ["CM_SHIFT"] = "Shift",
        ["CM_SHOW"] = "Exibir",
        ["CM_STOP"] = "Parar",
        ["CM_TWEET"] = "Enviar um tweet",
        ["CM_TWEET_PROFILE"] = "Mostrar url do perfil",
        ["CM_UNKNOWN"] = "Desconhecido",
        ["CM_VALUE"] = "Valor",
        ["CO_ANCHOR_BOTTOM"] = "Baixo",
        ["CO_ANCHOR_BOTTOM_LEFT"] = "Baixo-esquerda",
        ["CO_ANCHOR_BOTTOM_RIGHT"] = "Baixo-direita",
        ["CO_ANCHOR_CURSOR"] = "Exibir no cursor",
        ["CO_ANCHOR_LEFT"] = "Esquerda",
        ["CO_ANCHOR_RIGHT"] = "Direita",
        ["CO_ANCHOR_TOP"] = "Cima",
        ["CO_ANCHOR_TOP_LEFT"] = "Cima-esquerda",
        ["CO_ANCHOR_TOP_RIGHT"] = "Cima-direita",
        ["CO_CHAT"] = "Configurações de conversa",
        ["CO_CHAT_INSERT_FULL_RP_NAME"] = "Insira nomes de RP sobre Shift+clique",
        ["CO_CHAT_MAIN"] = "Configurações principais de conversa",
        ["CO_CHAT_MAIN_COLOR"] = "Usar cores personalizadas para nomes",
        ["CO_CHAT_MAIN_EMOTE"] = "Detectar emotes",
        ["CO_CHAT_MAIN_EMOTE_PATTERN"] = "Padrão de detecção de emote",
        ["CO_CHAT_MAIN_EMOTE_USE"] = "Usar detecção de emote",
        ["CO_CHAT_MAIN_EMOTE_YELL"] = "Sem emote em grito",
        ["CO_CHAT_MAIN_EMOTE_YELL_TT"] = "Não mostrar *emote* ou <emote> em gritos.",
        ["CO_CHAT_MAIN_NAMING"] = "Método de nomes",
        ["CO_CHAT_MAIN_NAMING_1"] = "Manter nomes originais",
        ["CO_CHAT_MAIN_NAMING_2"] = "Usar nomes personalizados",
        ["CO_CHAT_MAIN_NAMING_3"] = "Nome + sobrenome",
        ["CO_CHAT_MAIN_NAMING_4"] = "Título curto + Nome + Apelido",
        ["CO_CHAT_MAIN_NPC"] = "Detectar fala de PnJ",
        ["CO_CHAT_MAIN_NPC_PREFIX"] = "Padrão de detecção de fala de PnJ",
        ["CO_CHAT_MAIN_NPC_PREFIX_TT"] = [=[Se uma conversa nos canais SAY, EMOTE, GRUPO ou RAIDE começar com este prefixo, será interpretado como uma fala de PnJ.

|cff00ff00Padrão : "|| "
(sem aspas e com espaço após a barra)]=],
        ["CO_CHAT_MAIN_NPC_USE"] = "Usar detecção de conversa de PnJ",
        ["CO_CHAT_MAIN_OOC"] = "Detecção de OOC",
        ["CO_CHAT_MAIN_OOC_COLOR"] = "Cor de OOC",
        ["CO_CHAT_MAIN_OOC_PATTERN"] = "Padrão de detecção de OOC",
        ["CO_CHAT_MAIN_OOC_USE"] = "Detecção de OOC",
        ["CO_CHAT_USE"] = "Canais de conversa usados",
        ["CO_CHAT_USE_SAY"] = "Canal Say",
        ["CO_CONFIGURATION"] = "Configurações",
        ["CO_GENERAL"] = "Configurações gerais",
        ["CO_GENERAL_BROADCAST"] = "Usar canal de anúncio",
        ["CO_GENERAL_BROADCAST_C"] = "Nome do canal de anúncio",
        ["CO_GENERAL_BROADCAST_TT"] = "O canal de anúncio é usado para muitas funções. Desabilitá-lo irá desabilitar todas as funções como posição de personagens no mapa, sons locais, acesso a sinalizações...",
        ["CO_GENERAL_CHANGELOCALE_ALERT"] = [=[Recarregar a interface para mudar a linguagem para %s agora?

Se não recarregar, a linguagem será alterada na próxima vez que conectar.]=],
        ["CO_GENERAL_COM"] = "Comunicação",
        ["CO_GENERAL_HEAVY"] = "Alerta de perfil pesado",
        ["CO_GENERAL_HEAVY_TT"] = "Receber alerta quando o tamanho total de seu perfil exceder um valor aceitável.",
        ["CO_GENERAL_LOCALE"] = "Local do addon",
        ["CO_GENERAL_MISC"] = "Diversos",
        ["CO_GENERAL_NEW_VERSION"] = "Alerta de atualização",
        ["CO_GENERAL_NEW_VERSION_TT"] = "Receber alerta quando uma nova versão estiver disponível.",
        ["CO_GENERAL_TT_SIZE"] = "Tamanho do texto da tela de informações",
        ["CO_GENERAL_UI_ANIMATIONS"] = "Animações de interface",
        ["CO_GENERAL_UI_ANIMATIONS_TT"] = "Ativar animações de interface",
        ["CO_GENERAL_UI_SOUNDS"] = "Sons de interface",
        ["CO_GENERAL_UI_SOUNDS_TT"] = "Ativar sons da interface (quando abrir janelas, mudar abas, clicar em botões).",
        ["CO_GLANCE_LOCK"] = "Travar barra",
        ["CO_GLANCE_LOCK_TT"] = "Evita arrastar a barra",
        ["CO_GLANCE_MAIN"] = "Barra de \"à primeira vista\"",
        ["CO_GLANCE_PRESET_TRP2"] = "Usar posições ao estilo do Total RP 2",
        ["CO_GLANCE_PRESET_TRP2_BUTTON"] = "Usar",
        ["CO_GLANCE_PRESET_TRP2_HELP"] = "Atalho para a barra de configuração no estilo TRP2: à direita da janela alvo.",
        ["CO_GLANCE_PRESET_TRP3"] = "Usar posições estilo Total RP 3",
        ["CO_GLANCE_PRESET_TRP3_HELP"] = "Atalho para barra de configuração no estilo TRP3: abaixo da janela alvo.",
        ["CO_GLANCE_RESET_TT"] = "Recolocar a barra de posição para baixo-esquerda da tela guia.",
        ["CO_GLANCE_TT_ANCHOR"] = "Ponto de referência para janela de informações",
        ["CO_LOCATION"] = "Configurações de localização",
        ["CO_LOCATION_ACTIVATE"] = "Habilitar localização de personagens",
        ["CO_LOCATION_ACTIVATE_TT"] = "Habilita o sistema de localização de personagens, permitindo que você busque por outros usuários do Total RP no mapa do mundo e permitindo que eles o encontrem.",
        ["CO_LOCATION_DISABLE_OOC"] = "Desabilitar localização quando OOC",
        ["CO_LOCATION_DISABLE_OOC_TT"] = "Você não irá responder a pedidos de localização de outros jogadores quando seu status de RP estiver em Não Interpretando",
        ["CO_LOCATION_DISABLE_PVP"] = "Desabilitar localização quando marcado para JvJ",
        ["CO_LOCATION_DISABLE_PVP_TT"] = [=[Você não irá responder a pedidos de localização de outros jogadores quando estiver marcado para JvJ.

Esta opção é particularmente útil em reinos de JvJ onde jogadores da outra facção podem abusar o sistema de localização para rastreá-lo.]=],
        ["CO_MINIMAP_BUTTON"] = "Botão no minimapa",
        ["CO_MINIMAP_BUTTON_FRAME"] = "Janela de referência",
        ["CO_MINIMAP_BUTTON_RESET"] = "Reiniciar posições",
        ["CO_MINIMAP_BUTTON_RESET_BUTTON"] = "Reiniciar",
        ["CO_MINIMAP_BUTTON_SHOW_HELP"] = [=[Se você está usando outro addon para exibir o botão do minimapa do Total RP 3 (FuBar, Titan, Bazooka) você pode remover o botão do minimapa.

|cff00ff00Lembrete: Você pode abrir o Total RP 3 usando /trp3 switch main|r]=],
        ["CO_MINIMAP_BUTTON_SHOW_TITLE"] = "Exibir botão do minimapa",
        ["CO_MODULES"] = "Status dos módulos",
        ["CO_MODULES_DISABLE"] = "Desativar módulo",
        ["CO_MODULES_ENABLE"] = "Ativar módulo",
        ["CO_MODULES_ID"] = "ID do módulo: %s",
        ["CO_MODULES_SHOWERROR"] = "Exibir erros",
        ["CO_MODULES_STATUS"] = "Status: %s",
        ["CO_MODULES_STATUS_0"] = "Dependências ausentes",
        ["CO_MODULES_STATUS_1"] = "Carregado",
        ["CO_MODULES_STATUS_2"] = "Desabilitado",
        ["CO_MODULES_STATUS_3"] = "Requer atualização do Total RP 3",
        ["CO_MODULES_STATUS_4"] = "Erro na inicialização",
        ["CO_MODULES_STATUS_5"] = "Erro no carregamento",
        ["CO_MODULES_TT_DEP"] = "%s- %s (versão %s)|r",
        ["CO_MODULES_TT_DEPS"] = "Dependências",
        ["CO_MODULES_TT_ERROR"] = [=[|cffff0000Erro:|r
%s]=],
        ["CO_MODULES_TT_NONE"] = "Sem dependências",
        ["CO_MODULES_TT_TRP"] = "%sPara Total RP 3 versão mínima %s.|r",
        ["CO_MODULES_TUTO"] = [=[Um módulo é uma característica independente que pode ser ativada ou desativada.

Status possíveis:
|cff00ff00Carregado:|r O módulo está disponível e carregado.
|cff999999Desabilitado:|r O módulo está desabilitado.
|cffff9900Dependências em falta:|r Alguns itens essenciais não foram carregados.
|cffff9900Atualização do TRP necessária:|r O módulo precisa da versão mais recente do TRP3.
|cffff0000Erro ao carregar ou iniciar:|r O carregamento do módulo apresentou problemas. O módulo possivelmente gerará erros.!

|cffff9900Quando um módulo é desabilitado, é necessário recarregar a interface.]=],
        ["CO_MODULES_VERSION"] = "Versão: %s",
        ["CO_MSP"] = "Protocolo Mary Sue",
        ["CO_MSP_T3"] = "Usar apenas modelo 3",
        ["CO_MSP_T3_TT"] = "Mesmo se escolher outro modelo \"sobre\", o modelo 3 será sempre usado para compatibilidade MSP.",
        ["CO_REGISTER"] = "Configuração de registros",
        ["CO_REGISTER_ABOUT_VOTE"] = "Habilitar sistema de votação",
        ["CO_REGISTER_ABOUT_VOTE_TT"] = "Ativa o sistema de votação, permitindo votar (\"curtir\" ou \"não curtir\") outras descrições, e permitir o mesmo para seu perfil.",
        ["CO_REGISTER_AUTO_ADD"] = "Adicionar novos jogadores automaticamente",
        ["CO_REGISTER_AUTO_ADD_TT"] = "Adiciona automaticamente novos jogadores ao registro.",
        ["CO_REGISTER_AUTO_PURGE"] = "Expurgar diretório automaticamente",
        ["CO_REGISTER_AUTO_PURGE_0"] = "Desativar expurgo",
        ["CO_REGISTER_AUTO_PURGE_1"] = "Depois de %s dia(s)",
        ["CO_REGISTER_AUTO_PURGE_TT"] = [=[Automaticamente remover do diretório os perfis de personagens que você não encontrou por um certo tempo. Você pode escolher o tempo até a exclusão.

|cff00ff00Note que perfis com uma relação com um dos seus personagens jamais serão expurgados.

|cffff9900Há um bug no WoW que perde todos os dados salvos quando atinge um certo limite. Recomendamos evitar desativar o sistema de expurgo.]=],
        ["CO_TARGETFRAME"] = "Configurações do frame alvo",
        ["CO_TARGETFRAME_ICON_SIZE"] = "Tamanho dos ícones",
        ["CO_TARGETFRAME_USE"] = "Mostrar condições",
        ["CO_TARGETFRAME_USE_1"] = "Sempre",
        ["CO_TARGETFRAME_USE_2"] = "Apenas quando IC",
        ["CO_TARGETFRAME_USE_3"] = "Nunca (desabilitado)",
        ["CO_TARGETFRAME_USE_TT"] = "Determina em quais condições o frame alvo deve ser mostrado quando selecionado.",
        ["CO_TOOLBAR"] = "Configurações de frame",
        ["CO_TOOLBAR_CONTENT"] = "Configurações de barra de ferramentas",
        ["CO_TOOLBAR_CONTENT_CAPE"] = "Alternar visualização de capa",
        ["CO_TOOLBAR_CONTENT_HELMET"] = "Alternar visualização de elmo",
        ["CO_TOOLBAR_CONTENT_RPSTATUS"] = "Status do personagem (IC/OOC)",
        ["CO_TOOLBAR_CONTENT_STATUS"] = "Status do jogador (AFK/DND)",
        ["CO_TOOLBAR_ICON_SIZE"] = "Tamanho dos ícones",
        ["CO_TOOLBAR_MAX"] = "Número máximo de ícones por linha",
        ["CO_TOOLBAR_MAX_TT"] = "Use o valor 1 para mostrar a barra verticalmente!",
        ["CO_TOOLBAR_SHOW_ON_LOGIN"] = "Exibir barra de ferramentas no login",
        ["CO_TOOLBAR_SHOW_ON_LOGIN_HELP"] = "Se você não quer que a barra de ferramentas seja exibida no login, você pode desativar esta opção.",
        ["CO_TOOLTIP"] = "Configurações de tooltip",
        ["CO_TOOLTIP_ANCHOR"] = "Ponto âncora",
        ["CO_TOOLTIP_ANCHORED"] = "Tela ancorada",
        ["CO_TOOLTIP_CHARACTER"] = "Tooltip de personagens",
        ["CO_TOOLTIP_CLIENT"] = "Mostrar cliente",
        ["CO_TOOLTIP_COLOR"] = "Mostrar cores personalizadas",
        ["CO_TOOLTIP_COMBAT"] = "Esconder durante combate",
        ["CO_TOOLTIP_COMMON"] = "Configurações comuns",
        ["CO_TOOLTIP_CONTRAST"] = "Aumentar o contraste de cor",
        ["CO_TOOLTIP_CURRENT"] = "Mostrar informação \"atual\"",
        ["CO_TOOLTIP_CURRENT_SIZE"] = "Tamanho da informação \"atual\"",
        ["CO_TOOLTIP_FT"] = "Mostrar título completo",
        ["CO_TOOLTIP_GUILD"] = "Mostrar informações da guilda",
        ["CO_TOOLTIP_HIDE_ORIGINAL"] = "Esconder tooltip original",
        ["CO_TOOLTIP_ICONS"] = "Mostrar ícones",
        ["CO_TOOLTIP_IN_CHARACTER_ONLY"] = "Ocultar quando fora do personagem",
        ["CO_TOOLTIP_MAINSIZE"] = "Tamanho da fonte principal",
        ["CO_TOOLTIP_NOTIF"] = "Mostrar notificações",
        ["CO_TOOLTIP_NOTIF_TT"] = "A linha de notificações é a linha contendo a versão do client, o marcador de não lido e o marcador de \"À primeira vista\".",
        ["CO_TOOLTIP_OWNER"] = "Mostrar dono",
        ["CO_TOOLTIP_PETS"] = "Janela de informações de companheiros",
        ["CO_TOOLTIP_PETS_INFO"] = "Mostrar informações de companheiros",
        ["CO_TOOLTIP_PROFILE_ONLY"] = "Usar apenas se o alvo possuir um perfil",
        ["CO_TOOLTIP_RACE"] = "Mostrar raça, classe e nível",
        ["CO_TOOLTIP_REALM"] = "Mostrar reino",
        ["CO_TOOLTIP_RELATION"] = "Mostrar cor de relacionamento",
        ["CO_TOOLTIP_RELATION_TT"] = "Ajustar a borda da tela de informações do personagem para a cor do relacionamento",
        ["CO_TOOLTIP_SPACING"] = "Mostrar espaçamento",
        ["CO_TOOLTIP_SPACING_TT"] = "Coloca espaços para deixar a tela de informações mais leve, no estilo do MyRoleplay",
        ["CO_TOOLTIP_SUBSIZE"] = "Tamanho de fonte secundária",
        ["CO_TOOLTIP_TARGET"] = "Mostrar alvo",
        ["CO_TOOLTIP_TERSIZE"] = "Tamanho de fonte terciária",
        ["CO_TOOLTIP_TITLE"] = "Mostrar título",
        ["CO_TOOLTIP_USE"] = "Usar tela de informações de personagens/companheiros",
        ["CO_WIM"] = "Canais de |cffff9900sussurro estão desativados.",
        ["CO_WIM_TT"] = "Você está usando |cff00ff00WIM|r, a manipulação de canais de sussurro está desativada para fins de compatibilidade",
        ["COM_LIST"] = "Lista de comandos:",
        ["COM_RESET_RESET"] = "A posição das telas foi reiniciada!",
        ["COM_RESET_USAGE"] = "Uso: |cff00ff00/trp3 reset frames|r para reiniciar todas as posições das telas.",
        ["COM_SWITCH_USAGE"] = "Uso: |cff00ff00/trp3 switch main|r para mudar para tela principal ou |cff00ff00/trp3 switch toolbar|r para mudar a barra de ferramentas.",
        ["DB_ABOUT"] = "Sobre o Total RP 3",
        ["DB_HTML_GOTO"] = "Clique para abrir",
        ["DB_MORE"] = "Mais módulos",
        ["DB_NEW"] = "O que há de novo?",
        ["DB_STATUS"] = "Estados",
        ["DB_STATUS_CURRENTLY"] = "Atualmente (IC)",
        ["DB_STATUS_CURRENTLY_COMMON"] = "Esses estados vão ser mostrados na tela de informações do seu personagem. Mantenha-os claros e breves uma vez que |cffff9900 por padrão usuários do TRP3 só verão os primeiros 140 caracteres!",
        ["DB_STATUS_CURRENTLY_OOC"] = "Outras informações (OOC)",
        ["DB_STATUS_CURRENTLY_OOC_TT"] = "Aqui você pode indicar algo importante sobre você, como um jogador, ou qualquer coisa fora do seu personagem.",
        ["DB_STATUS_CURRENTLY_TT"] = "Aqui você pode indicar algo importante sobre seu personagem.",
        ["DB_STATUS_RP"] = "Estado do personagem",
        ["DB_STATUS_RP_EXP"] = "Roleplayer experiente",
        ["DB_STATUS_RP_EXP_TT"] = [=[Mostra que você é um roleplayer experiente.
Não mostrará nenhum ícone específico na sua tela de informações.]=],
        ["DB_STATUS_RP_IC"] = "Interpretando",
        ["DB_STATUS_RP_IC_TT"] = [=[Isso significa que você está atualmente interpretando seu personagem.
Todas as suas ações vão ser vistas como sendo o seu personagem a fazê-las.]=],
        ["DB_STATUS_RP_OOC"] = "Não interpretando",
        ["DB_STATUS_RP_OOC_TT"] = [=[Você não está interpretando seu personagem.
Suas ações não podem ser associadas a ele/ela.]=],
        ["DB_STATUS_RP_VOLUNTEER"] = "Roleplayer voluntário",
        ["DB_STATUS_RP_VOLUNTEER_TT"] = [=[Esta seleção mostrará um ícone na sua tela de informações, indicando
a roleplayers iniciantes que você está disposto a ajudá-los.]=],
        ["DB_STATUS_XP"] = "Estado de roleplayer",
        ["DB_STATUS_XP_BEGINNER"] = "Roleplayer novato",
        ["DB_STATUS_XP_BEGINNER_TT"] = [=[Esta seleção mostrará um ícone na sua tela de informações, indicando
aos outros que você é um roleplayer iniciante.]=],
        ["DB_TUTO_1"] = [=[|cffffff00O estado do personagem|r indica se você está atualmente interpretando seu personagem ou não.

|cffffff00O estado do roleplayer|r permite que você mostre que é um iniciante ou um veterano disposto a ajudar novatos.

|cff00ff00Essas informações serão exibidas na tela de informações do seu personagem.]=],
        ["DTBK_AFK"] = "Total RP 3 - LDT/NI",
        ["DTBK_CLOAK"] = "Total RP 3 - Capa",
        ["DTBK_HELMET"] = "Total RP 3 - Elmo",
        ["DTBK_LANGUAGES"] = "Total RP 3 - Linguagens",
        ["DTBK_RP"] = "Total RP 3 - IC/OOC",
        ["GEN_VERSION"] = "Versão: %s (Build %s)",
        ["GEN_WELCOME_MESSAGE"] = "Obrigado por usar o Total RP 3 (v %s) ! Divirta-se !",
        ["MAP_BUTTON_NO_SCAN"] = "Escaneamento não disponível",
        ["MAP_BUTTON_SCANNING"] = "Escaneando",
        ["MAP_BUTTON_SUBTITLE"] = "Clique para mostrar escaneamentos disponíveis",
        ["MAP_SCAN_CHAR"] = "Escanear por personagens",
        ["MAP_SCAN_CHAR_TITLE"] = "Personagens",
        ["MATURE_FILTER_EDIT_DICTIONARY"] = "Editar dicionário personalizado",
        ["MATURE_FILTER_EDIT_DICTIONARY_ADD_BUTTON"] = "Adicionar",
        ["MATURE_FILTER_EDIT_DICTIONARY_ADD_TEXT"] = "Adicionar uma nova palavra ao dicionário",
        ["MATURE_FILTER_EDIT_DICTIONARY_BUTTON"] = "Editar",
        ["MATURE_FILTER_EDIT_DICTIONARY_DELETE_WORD"] = "Suprimir a palavra do dicionário personalizado",
        ["MATURE_FILTER_EDIT_DICTIONARY_EDIT_WORD"] = "Editar esta palavra",
        ["MATURE_FILTER_EDIT_DICTIONARY_TITLE"] = "Editor dicionário personalizado",
        ["MATURE_FILTER_TOOLTIP_WARNING"] = "Conteúdo adulto",
        ["MATURE_FILTER_WARNING_CONTINUE"] = "Continuar",
        ["MATURE_FILTER_WARNING_GO_BACK"] = "Voltar",
        ["MATURE_FILTER_WARNING_TITLE"] = "Conteúdo adulto",
        ["MM_SHOW_HIDE_MAIN"] = "Exibir/esconder a janela principal",
        ["MM_SHOW_HIDE_MOVE"] = "Mover botão",
        ["MM_SHOW_HIDE_SHORTCUT"] = "Exibir/esconder a barra de ferramentas",
        ["NEW_VERSION_TITLE"] = "Nova atualização disponível",
        ["NPC_TALK_SAY_PATTERN"] = "diz:",
        ["NPC_TALK_WHISPER_PATTERN"] = "sussurra:",
        ["NPC_TALK_YELL_PATTERN"] = "grita:",
        ["PATTERN_ERROR"] = "Erro no padrão",
        ["PATTERN_ERROR_TAG"] = "Erro no padrão : tag texto não fechada",
        ["PR_CO_BATTLE"] = "Mascote de batalha",
        ["PR_CO_COUNT"] = "%s mascotes/montarias vinculadas a este perfil.",
        ["PR_CO_EMPTY"] = "Sem perfil de companheiro",
        ["PR_CO_MASTERS"] = "Mestres",
        ["PR_CO_MOUNT"] = "Montaria",
        ["PR_CO_NEW_PROFILE"] = "Novo perfil de companheiro",
        ["PR_CO_PET"] = "Mascote",
        ["PR_CO_PROFILE_DETAIL"] = "Este perfil está atualmente vinculado a",
        ["PR_CO_PROFILE_HELP"] = [=[Um perfil contém toda informação sobre uma |cffffff00"mascote"|r como um |cff00ff00personagem de roleplay|r.

Um perfil de companheiro pode ser conectado a:
- Uma mascote de batalha |cffff9900(apenas se houver sido renomeado)|r
- Um ajudante de caçador
- Um lacaio de bruxo
- Um elemental de mago
- Um carniçal de cavaleiro da morte |cffff9900(ver abaixo)|r

Assim como perfis de personagens, um |cff00ff00perfil de companheiro|r pode ser conectado a |cffffff00várias mascotes|r, e uma |cffffff00mascote|r pode trocar facilmente de um perfil para outro.

|cffff9900Carniçais:|r Como carniçais recebem um novo nome cada vez que são conjurados, você terá que reconectar o perfil ao carniçal para todos os nomes possíveis.]=],
        ["PR_CO_PROFILE_HELP2"] = [=[Clique aqui para criar um novo perfil de companheiro.

|cff00ff00Para conectar um perfil a uma mascote (ajudante de caçador, lacaio de bruxo ...), simplesmente conjure a mascote, selecione-a e use a tela de seleção para conectá-la a um perfil existente (ou crie um novo).|r]=],
        ["PR_CO_PROFILEMANAGER_DELETE_WARNING"] = [=[Você tem certeza que quer deletar o perfil de companheiro %s?
Esta ação não pode ser desfeita e toda informação do TRP3 conectada a este perfil será destruída!]=],
        ["PR_CO_PROFILEMANAGER_DUPP_POPUP"] = [=[Por favor insira um nome para o novo perfil.
O nome não pode estar vazio.

Esta duplicação não mudará suas mascotes/montarias vinculadas a %s.]=],
        ["PR_CO_PROFILEMANAGER_EDIT_POPUP"] = [=[Por favor insira um novo nome para este perfil.
O nome não pode estar vazio.

Mudar o nome não afetará qualquer conexão entre este perfil e suas mascotes/montarias.]=],
        ["PR_CO_PROFILEMANAGER_TITLE"] = "Perfis de companheiros",
        ["PR_CO_UNUSED_PROFILE"] = "Este perfil não está atualmente vinculado a nenhuma mascote ou montaria.",
        ["PR_CO_WARNING_RENAME"] = [=[|cffff0000Aviso:|r é altamente recomendado que você renomeie sua mascote antes de conectá-la a um perfil.

Conectá-la assim mesmo?]=],
        ["PR_CREATE_PROFILE"] = "Criar perfil",
        ["PR_DELETE_PROFILE"] = "Deletar perfil",
        ["PR_DUPLICATE_PROFILE"] = "Duplicar perfil",
        ["PR_EXPORT_IMPORT_TITLE"] = "Exportação/importação de perfil",
        ["PR_EXPORT_PROFILE"] = "Exportação de perfil",
        ["PR_IMPORT"] = "Importar",
        ["PR_IMPORT_CHAR_TAB"] = "Importador de personagens",
        ["PR_IMPORT_EMPTY"] = "Nenhum perfil importável",
        ["PR_IMPORT_IMPORT_ALL"] = "Importar todos",
        ["PR_IMPORT_PETS_TAB"] = "Importador de companheiros",
        ["PR_IMPORT_PROFILE"] = "Importaçao de perfil",
        ["PR_IMPORT_WILL_BE_IMPORTED"] = "Serão importados",
        ["PR_PROFILE"] = "Perfil",
        ["PR_PROFILE_CREATED"] = "Perfil %s criado.",
        ["PR_PROFILE_DELETED"] = "Perfil %s deletado.",
        ["PR_PROFILE_DETAIL"] = "Este perfil está atualmente vinculado a estes personagens do WoW.",
        ["PR_PROFILE_HELP"] = [=[Um perfil contém toda informação sobre um |cffffff00"personagem"|r como um |cff00ff00personagem de roleplay|r.

Um |cffffff00"personagem do WoW"|r real pode ser vinculado a apenas um perfil de cada vez, mas pode trocar de um para outro quando quiser.

Você também pode vincular vários |cffffff00"personagens do WoW"|r ao mesmo |cff00ff00perfil|r !]=],
        ["PR_PROFILE_LOADED"] = "O perfil %s está carregado.",
        ["PR_PROFILE_MANAGEMENT_TITLE"] = "Gerenciamento de perfil",
        ["PR_PROFILEMANAGER_ACTIONS"] = "Ações",
        ["PR_PROFILEMANAGER_ALREADY_IN_USE"] = "O nome de perfil %s não está disponível.",
        ["PR_PROFILEMANAGER_COUNT"] = "%s personagem(s) do WoW vinculados a este perfil.",
        ["PR_PROFILEMANAGER_CREATE_POPUP"] = [=[Por favor insira um nome para o novo perfil.
O nome não pode estar vazio.]=],
        ["PR_PROFILEMANAGER_CURRENT"] = "Perfil atual",
        ["PR_PROFILEMANAGER_DELETE_WARNING"] = [=[Você tem certeza que quer deletar o perfil %s?
Esta ação não pode ser desfeita e toda informação do TRP3 conectada a este perfil (Informações de personagem, inventário, diário de missões, estados aplicados ...) será destruída !]=],
        ["PR_PROFILEMANAGER_DUPP_POPUP"] = [=[Por favor insira um nome para o novo perfil.
O nome não pode estar vazio.

Esta duplicação não mudará a conexão ao personagem %s.]=],
        ["PR_PROFILEMANAGER_EDIT_POPUP"] = [=[Por favor insira um novo nome para este perfil %s.
Este nome não pode estar vazio.

Mudar o nome não vai mudar nenhuma conexão entre este perfil e seus personagens.]=],
        ["PR_PROFILEMANAGER_RENAME"] = "Renomear perfil",
        ["PR_PROFILEMANAGER_SWITCH"] = "Selecionar perfil",
        ["PR_PROFILEMANAGER_TITLE"] = "Perfis de personagens",
        ["PR_PROFILES"] = "Perfis",
        ["PR_UNUSED_PROFILE"] = "Este perfil não está atualmente conectado a nenhum personagem do WoW.",
        ["REG_COMPANION"] = "Companheiro",
        ["REG_COMPANION_BOUND_TO"] = "Vinculado a ...",
        ["REG_COMPANION_BOUND_TO_TARGET"] = "Alvo",
        ["REG_COMPANION_BOUNDS"] = "Vínculos",
        ["REG_COMPANION_BROWSER_BATTLE"] = "Navegador de mascote de batalha",
        ["REG_COMPANION_BROWSER_MOUNT"] = "Navegador de montarias",
        ["REG_COMPANION_INFO"] = "Informação",
        ["REG_COMPANION_LINKED"] = "O(a) companheiro(a) %s está agora conectado(a) ao perfil %s.",
        ["REG_COMPANION_LINKED_NO"] = "O(a) companheiro(a) %s não está mais conectado(a) a nenhum perfil.",
        ["REG_COMPANION_NAME"] = "Nome",
        ["REG_COMPANION_NAME_COLOR"] = "Cor do nome",
        ["REG_COMPANION_PAGE_TUTO_C_1"] = "Consultar",
        ["REG_COMPANION_PAGE_TUTO_E_1"] = [=[Esta é a |cff00ff00informação principal do seu companheiro|r.

Toda essa informação vai aparecer na |cffff9900tela de informações do seu companheiro|r.]=],
        ["REG_COMPANION_PAGE_TUTO_E_2"] = [=[Esta é a |cff00ff00descrição do seu companheiro|r.

Ela não é limitada a uma |cffff9900descrição física|r. Sinta-se livre para indicar partes da sua |cffff9900história|r ou detalhes sobre sua |cffff9900personalidade|r.

Há muitas maneiras de personalizar a descrição.
Você pode escolher uma |cffffff00textura de fundo|r para a descrição. Você também pode usar as ferramentas de formatação para acessar vários parâmetros de layout como |cffffff00tamanhos, cores e alinhamentos de texto|r.
Estas ferramentas também permitem que você insira |cffffff00imagens, ícones ou links para websites externos|r.]=],
        ["REG_COMPANION_PROFILES"] = "Perfis de companheiros",
        ["REG_COMPANION_TARGET_NO"] = "Seu alvo não é um ajudante, lacaio, carniçal, elemental de mago ou mascote de batalha renomeado válido.",
        ["REG_COMPANION_TF_BOUND_TO"] = "Selecione um perfil",
        ["REG_COMPANION_TF_CREATE"] = "Criar novo perfil",
        ["REG_COMPANION_TF_NO"] = "Sem perfil",
        ["REG_COMPANION_TF_OPEN"] = "Abrir página",
        ["REG_COMPANION_TF_OWNER"] = "Dono: %s",
        ["REG_COMPANION_TF_PROFILE"] = "Perfil de companheiro",
        ["REG_COMPANION_TF_PROFILE_MOUNT"] = "Perfil de montaria",
        ["REG_COMPANION_TF_UNBOUND"] = "Desconectar de perfil",
        ["REG_COMPANION_TITLE"] = "Título",
        ["REG_COMPANION_UNBOUND"] = "Desvincular de ...",
        ["REG_COMPANIONS"] = "Companheiros",
        ["REG_DELETE_WARNING"] = "Você tem certeza que quer deletar o perfil de %s?",
        ["REG_IGNORE_TOAST"] = "Personagem ignorado",
        ["REG_LIST_ACTIONS_MASS"] = "Ação nos %s perfis selecionados",
        ["REG_LIST_ACTIONS_MASS_IGNORE"] = "Ignorar perfis",
        ["REG_LIST_ACTIONS_MASS_IGNORE_C"] = [=[Esta ação irá adicionar |cff00ff00%s personagem(s)|r à lista de ignorados.

Você pode opcionalmente inserir o motivo abaixo. Essa é uma nota pessoal, que servirá como um lembrete.]=],
        ["REG_LIST_ACTIONS_MASS_REMOVE"] = "Remover perfis",
        ["REG_LIST_ACTIONS_MASS_REMOVE_C"] = "Esta ação removerá |cff00ff00%s perfis selecionados|r.",
        ["REG_LIST_ACTIONS_PURGE"] = "Expurgar registro",
        ["REG_LIST_ACTIONS_PURGE_ALL"] = "Remover todos os perfis",
        ["REG_LIST_ACTIONS_PURGE_ALL_C"] = [=[Este expurgo irá remover todos os perfis e personagens conectados do diretório.

|cff00ff00%s personagens.]=],
        ["REG_LIST_ACTIONS_PURGE_ALL_COMP_C"] = [=[Este expurgo irá remover todos os companheiros do diretório.

|cff00ff00%s companheiros.]=],
        ["REG_LIST_ACTIONS_PURGE_COUNT"] = "%s perfis serão removidos.",
        ["REG_LIST_ACTIONS_PURGE_EMPTY"] = "Sem perfis para expurgar.",
        ["REG_LIST_ACTIONS_PURGE_IGNORE"] = "Perfis de personagens ignorados.",
        ["REG_LIST_ACTIONS_PURGE_IGNORE_C"] = [=[Este expurgo irá remover todos os perfis conectados a um personagem do WoW ignorado.

|cff00ff00%s]=],
        ["REG_LIST_ACTIONS_PURGE_TIME"] = "Perfis não vistos por 1 mês",
        ["REG_LIST_ACTIONS_PURGE_TIME_C"] = [=[Este expurgo irá remover todos os perfis que não foram vistos por um mês.

|cff00ff00%s]=],
        ["REG_LIST_ACTIONS_PURGE_UNLINKED"] = "Perfis não vinculados a um personagem",
        ["REG_LIST_ACTIONS_PURGE_UNLINKED_C"] = [=[Este expurgo irá remover todos os perfis que não estão conectados a um personagem do WoW.

|cff00ff00%s]=],
        ["REG_LIST_ADDON"] = "Tipo de perfil",
        ["REG_LIST_CHAR_EMPTY"] = "Sem personagem",
        ["REG_LIST_CHAR_EMPTY2"] = "Nenhum personagem se encaixa na sua seleção",
        ["REG_LIST_CHAR_FILTER"] = "Personagens: %s / %s",
        ["REG_LIST_CHAR_IGNORED"] = "Ignorado",
        ["REG_LIST_CHAR_SEL"] = "Personagem selecionado",
        ["REG_LIST_CHAR_TITLE"] = "Lista de personagens",
        ["REG_LIST_CHAR_TT"] = "Clique para mostrar página",
        ["REG_LIST_CHAR_TT_CHAR"] = "Personagens do WoW vinculados:",
        ["REG_LIST_CHAR_TT_CHAR_NO"] = "Não vinculado a nenhum personagem",
        ["REG_LIST_CHAR_TT_DATE"] = [=[Data visto pela última vez: |cff00ff00%s|r
Local visto pela última vez: |cff00ff00%s|r]=],
        ["REG_LIST_CHAR_TT_GLANCE"] = "À primeira vista",
        ["REG_LIST_CHAR_TT_IGNORE"] = "Personagens ignorados",
        ["REG_LIST_CHAR_TT_NEW_ABOUT"] = "Descrição não lida",
        ["REG_LIST_CHAR_TT_RELATION"] = [=[Relação:
|cff00ff00%s]=],
        ["REG_LIST_CHAR_TUTO_ACTIONS"] = "Esta coluna permite que você selecione múltiplos personagens e faça uma ação em todos eles.",
        ["REG_LIST_CHAR_TUTO_FILTER"] = [=[Você pode filtrar a lista de personagens.

O |cff00ff00filtro de nome|r irá realizar uma busca nos nomes completos dos perfis (nome + sobrenome) mas também em quaisquer personagens do WoW vinculados.

O |cff00ff00filtro de guilda|r irá buscar por nomes de guilda em personagens do WoW vinculados.

O |cff00ff00filtro de apenas no reino|r mostrará apenas perfis vinculados a um personagem do WoW no seu reino atual.]=],
        ["REG_LIST_CHAR_TUTO_LIST"] = [=[A primeira coluna mostra o nome do personagem.

A segunda coluna mostra a relação entre estes personagens e seu personagem atual.

A última coluna é para vários marcadores. (ignorado ..etc.)]=],
        ["REG_LIST_FILTERS"] = "Filtros",
        ["REG_LIST_FILTERS_TT"] = [=[|cffffff00Clique:|r Aplicar filtros
|cffffff00Clique direito:|r Limpar filtros]=],
        ["REG_LIST_FLAGS"] = "Marcadores",
        ["REG_LIST_GUILD"] = "Guilda do personagem",
        ["REG_LIST_IGNORE_EMPTY"] = "Sem personagens ignorados",
        ["REG_LIST_IGNORE_TITLE"] = "Lista de ignorados",
        ["REG_LIST_IGNORE_TT"] = [=[Motivo:
|cff00ff00%s

|cffffff00Clique para remover da lista de ignorados]=],
        ["REG_LIST_NAME"] = "Nome do personagem",
        ["REG_LIST_NOTIF_ADD"] = "Novo perfil descoberto para |cff00ff00%s",
        ["REG_LIST_NOTIF_ADD_CONFIG"] = "Novo perfil descoberto",
        ["REG_LIST_NOTIF_ADD_NOT"] = "Este perfil não existe mais.",
        ["REG_LIST_PET_MASTER"] = "Nome do mestre",
        ["REG_LIST_PET_NAME"] = "Nome do companheiro",
        ["REG_LIST_PET_TYPE"] = "Tipo do companheiro",
        ["REG_LIST_PETS_EMPTY"] = "Sem companheiro",
        ["REG_LIST_PETS_EMPTY2"] = "Nenhum companheiro se encaixa na sua seleção",
        ["REG_LIST_PETS_FILTER"] = "Companheiros: %s / %s",
        ["REG_LIST_PETS_TITLE"] = "Lista de companheiros",
        ["REG_LIST_PETS_TOOLTIP"] = "Foi visto em",
        ["REG_LIST_PETS_TOOLTIP2"] = "Foi visto com",
        ["REG_LIST_REALMONLY"] = "Apenas neste reino",
        ["REG_MSP_ALERT"] = [=[|cffff0000AVISO

Você não pode ter simultaneamente mais de um addon usando o Protocolo Mary Sue, pois entrariam em conflito.|r

Atualmente carregado: |cff00ff00%s

|cffff9900Logo o suporte a PMS para o Total RP3 será desativado.|r

Se você não quer que TRP3 seja seu addon de PMS e não quer mais ver este alerta, você pode desativar o módulo de Protocolo Mary Sue nas Opções do TRP3 -> Status de módulo.]=],
        ["REG_PLAYER"] = "Personagem",
        ["REG_PLAYER_ABOUT"] = "Sobre",
        ["REG_PLAYER_ABOUT_ADD_FRAME"] = "Adicionar uma janela",
        ["REG_PLAYER_ABOUT_EMPTY"] = "Sem descrição",
        ["REG_PLAYER_ABOUT_HEADER"] = "Nota título",
        ["REG_PLAYER_ABOUT_MUSIC"] = "Tema do personagem",
        ["REG_PLAYER_ABOUT_MUSIC_LISTEN"] = "Tocar tema",
        ["REG_PLAYER_ABOUT_MUSIC_REMOVE"] = "De-selecionar tema",
        ["REG_PLAYER_ABOUT_MUSIC_SELECT"] = "Selecionar tema do personagem",
        ["REG_PLAYER_ABOUT_MUSIC_SELECT2"] = "Selecionar tema",
        ["REG_PLAYER_ABOUT_MUSIC_STOP"] = "Parar tema",
        ["REG_PLAYER_ABOUT_NOMUSIC"] = "|cffff9900Sem tema",
        ["REG_PLAYER_ABOUT_P"] = "Nota parágrafo",
        ["REG_PLAYER_ABOUT_REMOVE_FRAME"] = "Remover esta janela",
        ["REG_PLAYER_ABOUT_SOME"] = "Algum texto ...",
        ["REG_PLAYER_ABOUT_T1_YOURTEXT"] = "Seu texto aqui",
        ["REG_PLAYER_ABOUT_TAGS"] = "Ferramentas de formatação",
        ["REG_PLAYER_ABOUT_UNMUSIC"] = "|cffff9900Tema desconhecido",
        ["REG_PLAYER_ABOUT_VOTE_DOWN"] = "Eu não gosto deste conteúdo",
        ["REG_PLAYER_ABOUT_VOTE_NO"] = [=[Nenhum personagem conectado a este perfil parece estar online.
Você quer forçar o Total RP 3 a enviar seu voto assim mesmo ?]=],
        ["REG_PLAYER_ABOUT_VOTE_SENDING"] = "Enviando seu voto a %s ...",
        ["REG_PLAYER_ABOUT_VOTE_SENDING_OK"] = "Seu voto foi enviado a %s !",
        ["REG_PLAYER_ABOUT_VOTE_TT"] = "Seu voto é totalmente anônimo e só pode ser visto por este jogador.",
        ["REG_PLAYER_ABOUT_VOTE_TT2"] = "Você só pode votar se o jogador estiver online.",
        ["REG_PLAYER_ABOUT_VOTE_UP"] = "Eu gosto deste conteúdo.",
        ["REG_PLAYER_ABOUT_VOTES"] = "Estatísticas",
        ["REG_PLAYER_ABOUT_VOTES_R"] = [=[|cff00ff00%s curtir este conteúdo
|cffff0000%s descurtir este conteúdo]=],
        ["REG_PLAYER_ABOUTS"] = "Sobre %s",
        ["REG_PLAYER_ADD_NEW"] = "Criar novo",
        ["REG_PLAYER_AGE"] = "Idade",
        ["REG_PLAYER_AGE_TT"] = [=[Aqui você pode indicar quão velho seu personagem é.

Há várias formas de fazer isso:|c0000ff00
- Ou usar anos
- Ou um adjetivo (Jovem, Maduro, Adulto, Venerável, etc.)]=],
        ["REG_PLAYER_ALERT_HEAVY_SMALL"] = [=[|cffff0000O tamanho total do seu perfil é bem grande.
|cffff9900Você devia reduzi-lo.]=],
        ["REG_PLAYER_BIRTHPLACE"] = "Local de nascimento",
        ["REG_PLAYER_BIRTHPLACE_TT"] = [=[Aqui você pode indicar o local de nascimento do seu personagem. Isso pode ser uma região, uma zona ou até mesmo um continente. Você decide o quão preciso quer ser.

|c00ffff00Você pode usar o botão à direita para facilmente colocar sua localidade atual como local de nascimento.]=],
        ["REG_PLAYER_BKG"] = "Layout de fundo",
        ["REG_PLAYER_BKG_TT"] = "Isso representa o fundo gráfico para usar para seu layout de Características.",
        ["REG_PLAYER_CARACT"] = "Características",
        ["REG_PLAYER_CHANGE_CONFIRM"] = [=[Você pode ter mudanças não-salvas.
Você quer mudar de página assim mesmo ?
|cffff9900Todas as mudanças serão perdidas.]=],
        ["REG_PLAYER_CHARACTERISTICS"] = "Características",
        ["REG_PLAYER_CLASS"] = "Classe",
        ["REG_PLAYER_CLASS_TT"] = [=[Esta é a classe personalizada do seu personagem.

|cff00ff00Por exemplo :|r
Cavaleiro, Pirotecnista, Necromante, Atirador de elite, Arcanista ...]=],
        ["REG_PLAYER_COLOR_CLASS"] = "Cor da classe",
        ["REG_PLAYER_COLOR_CLASS_TT"] = [=[Isso também determina a cor do nome.

]=],
        ["REG_PLAYER_COLOR_TT"] = [=[|cffffff00Clique:|r Selecionar uma cor
|cffffff00Clique-direito:|r Descartar cor]=],
        ["REG_PLAYER_CURRENT"] = "Atualmente",
        ["REG_PLAYER_CURRENT_OOC"] = "Esta é uma informação OOC",
        ["REG_PLAYER_CURRENTOOC"] = "Atualmente (OOC)",
        ["REG_PLAYER_EYE"] = "Cor dos olhos",
        ["REG_PLAYER_EYE_TT"] = [=[Aqui você pode indicar a cor dos olhos do seu personagem.

Pense que, mesmo que o rosto do seu personagem esteja sempre escondido, vale a pena mencionar, só por garantia.]=],
        ["REG_PLAYER_FIRSTNAME"] = "Nome",
        ["REG_PLAYER_FIRSTNAME_TT"] = [=[Este é o nome do seu personagem. Este é um campo obrigatório, então se você não especificar um nome, o nome padrão do personagem (|cffffff00%s|r)  será utilizado.

Você pode usar um |c0000ff00apelido |r!]=],
        ["REG_PLAYER_FULLTITLE"] = "Título completo",
        ["REG_PLAYER_FULLTITLE_TT"] = [=[Aqui você pode escrever o título completo do seu personagem. Ele pode ser uma versão maior do Título ou um título completamente diferente.

Porém, você pode querer evitar repetições, no caso de não haver informação adicional para mencionar.]=],
        ["REG_PLAYER_GLANCE"] = "À primeira vista",
        ["REG_PLAYER_GLANCE_BAR_DELETED"] = "Preset de grupo |cffff9900%s|r deletado.",
        ["REG_PLAYER_GLANCE_BAR_EMPTY"] = "O nome da predefinição não pode estar vazio.",
        ["REG_PLAYER_GLANCE_BAR_LOAD"] = "Predefinição de grupo",
        ["REG_PLAYER_GLANCE_BAR_LOAD_SAVE"] = "Predefinições de grupo",
        ["REG_PLAYER_GLANCE_BAR_NAME"] = [=[Insira o nome da predefinição.

|cff00ff00Nota: Se o nome já estiver em uso por outra predefinição de grupo, este outro grupo será substituído.]=],
        ["REG_PLAYER_GLANCE_BAR_SAVE"] = "Salvar grupo como predefinição",
        ["REG_PLAYER_GLANCE_BAR_SAVED"] = "Predefinição de grupo |cff00ff00%s|r foi criada.",
        ["REG_PLAYER_GLANCE_BAR_TARGET"] = "Predefinições de \"À primeira vista\"",
        ["REG_PLAYER_GLANCE_CONFIG"] = [=[|cff00ff00"À primeira vista"|r é um conjunto de slots que você pode usar para definir informações importantes sobre este personagem.

Você pode usar estas ações nos slots:
|cffffff00Clique:|r configurar slot
|cffffff00Duplo-clique:|r alternar ativação do slot
|cffffff00Clique-direito:|r presets de slot
|cffffff00Arrastar e soltar:|r reordenar slots]=],
        ["REG_PLAYER_GLANCE_EDITOR"] = "Editor de vista: Slot %s",
        ["REG_PLAYER_GLANCE_PRESET"] = "Carregar uma predefinição",
        ["REG_PLAYER_GLANCE_PRESET_ADD"] = "Criada predefinição |cff00ff00%s|r.",
        ["REG_PLAYER_GLANCE_PRESET_ALERT1"] = "Você deve inserir uma categoria de predefinição.",
        ["REG_PLAYER_GLANCE_PRESET_CATEGORY"] = "Categoria de predefinição",
        ["REG_PLAYER_GLANCE_PRESET_CREATE"] = "Criar predefinição",
        ["REG_PLAYER_GLANCE_PRESET_GET_CAT"] = [=[%s

Por favor insira o nome da categoria para essa predefinição.]=],
        ["REG_PLAYER_GLANCE_PRESET_NAME"] = "Nome da predefinição",
        ["REG_PLAYER_GLANCE_PRESET_REMOVE"] = "Removida predefinição |cff00ff00%s|r.",
        ["REG_PLAYER_GLANCE_PRESET_SAVE"] = "Salvar informação como predefinição",
        ["REG_PLAYER_GLANCE_PRESET_SAVE_SMALL"] = "Salvar como predefinição",
        ["REG_PLAYER_GLANCE_PRESET_SELECT"] = "Selecionar uma predefinição",
        ["REG_PLAYER_GLANCE_TITLE"] = "Atribuir nome",
        ["REG_PLAYER_GLANCE_UNUSED"] = "Slot não-utilizado",
        ["REG_PLAYER_GLANCE_USE"] = "Ativar este slot",
        ["REG_PLAYER_HEIGHT"] = "Altura",
        ["REG_PLAYER_HEIGHT_TT"] = [=[Esta é a altura do seu personagem.
Há várias maneiras de mostrar isso:|c0000ff00
- Um número preciso: 170 cm, 6'5" ...
- Um qualificativo: Alto, baixo ...]=],
        ["REG_PLAYER_HERE"] = "Designar posição",
        ["REG_PLAYER_HERE_HOME_PRE_TT"] = [=[Coordenadas do mapa de moradia atuais:
|cff00ff00%s|r.]=],
        ["REG_PLAYER_HERE_HOME_TT"] = [=[|cffffff00Clique|r: Usar as coordenadas atuais como a posição de moradia.
|cffffff00Clique-direito|r: Descartar sua posição de moradia.]=],
        ["REG_PLAYER_HERE_TT"] = "|cffffff00Clique|r: Designar para sua posição atual",
        ["REG_PLAYER_HISTORY"] = "História",
        ["REG_PLAYER_ICON"] = "Ícone do personagem",
        ["REG_PLAYER_ICON_TT"] = "Selecione uma representação gráfica para seu personagem.",
        ["REG_PLAYER_IGNORE"] = "Ignorar personagens conectados (%s)",
        ["REG_PLAYER_IGNORE_WARNING"] = [=[Você quer ignorar estes personagens ?

|cffff9900%s

|rVocê pode inserir o motivo abaixo. Isto é uma nota pessoal e servirá como lembrete.]=],
        ["REG_PLAYER_LASTNAME"] = "Sobrenome",
        ["REG_PLAYER_LASTNAME_TT"] = "Este é o nome de família do seu personagem.",
        ["REG_PLAYER_LEFTTRAIT"] = "Atributo da esquerda",
        ["REG_PLAYER_MISC_ADD"] = "Adicionar um campo adicional",
        ["REG_PLAYER_MORE_INFO"] = "Informação adicional",
        ["REG_PLAYER_MSP_HOUSE"] = "Nome de Casa",
        ["REG_PLAYER_MSP_MOTTO"] = "Lema",
        ["REG_PLAYER_MSP_NICK"] = "Apelido",
        ["REG_PLAYER_NAMESTITLES"] = "Nomes e títulos",
        ["REG_PLAYER_NO_CHAR"] = "Sem características",
        ["REG_PLAYER_PEEK"] = "Outros",
        ["REG_PLAYER_PHYSICAL"] = "Descrição Física",
        ["REG_PLAYER_PSYCHO"] = "Traços de personalidade",
        ["REG_PLAYER_PSYCHO_Acete"] = "Asceta",
        ["REG_PLAYER_PSYCHO_ADD"] = "Adicionar um traço de personalidade",
        ["REG_PLAYER_PSYCHO_ATTIBUTENAME_TT"] = "Nome do atributo",
        ["REG_PLAYER_PSYCHO_Bonvivant"] = "Bon vivant",
        ["REG_PLAYER_PSYCHO_CHAOTIC"] = "Caótico",
        ["REG_PLAYER_PSYCHO_Chaste"] = "Casto",
        ["REG_PLAYER_PSYCHO_Conciliant"] = "Parágono",
        ["REG_PLAYER_PSYCHO_Couard"] = "Covarde",
        ["REG_PLAYER_PSYCHO_CREATENEW"] = "Criar um traço",
        ["REG_PLAYER_PSYCHO_Cruel"] = "Brutal",
        ["REG_PLAYER_PSYCHO_CUSTOM"] = "Traço personalizado",
        ["REG_PLAYER_PSYCHO_Egoiste"] = "Egoísta",
        ["REG_PLAYER_PSYCHO_Genereux"] = "Altruísta",
        ["REG_PLAYER_PSYCHO_Impulsif"] = "Impulsivo",
        ["REG_PLAYER_PSYCHO_Indulgent"] = "Clemente",
        ["REG_PLAYER_PSYCHO_LEFTICON_TT"] = "Determinar o ícone do atributo esquerdo.",
        ["REG_PLAYER_PSYCHO_Loyal"] = "Leal",
        ["REG_PLAYER_PSYCHO_Luxurieux"] = "Luxurioso",
        ["REG_PLAYER_PSYCHO_Misericordieux"] = "Gentil",
        ["REG_PLAYER_PSYCHO_MORE"] = "Adicionar um ponto a \"%s\"",
        ["REG_PLAYER_PSYCHO_PERSONAL"] = "Traços pessoais",
        ["REG_PLAYER_PSYCHO_Pieux"] = "Supersticioso",
        ["REG_PLAYER_PSYCHO_POINT"] = "Adicionar um ponto",
        ["REG_PLAYER_PSYCHO_Pragmatique"] = "Renegado",
        ["REG_PLAYER_PSYCHO_Rationnel"] = "Racional",
        ["REG_PLAYER_PSYCHO_Reflechi"] = "Cauteloso",
        ["REG_PLAYER_PSYCHO_Rencunier"] = "Vingativo",
        ["REG_PLAYER_PSYCHO_RIGHTICON_TT"] = "Determinar o ícone do atributo da direita",
        ["REG_PLAYER_PSYCHO_Sincere"] = "Verdadeiro",
        ["REG_PLAYER_PSYCHO_SOCIAL"] = "Traços sociais",
        ["REG_PLAYER_PSYCHO_Trompeur"] = "Enganoso",
        ["REG_PLAYER_PSYCHO_Valeureux"] = "Valoroso",
        ["REG_PLAYER_RACE"] = "Raça",
        ["REG_PLAYER_RACE_TT"] = "Aqui vai a raça do seu personagem. Não tem que ser restrita às raças jogáveis. Há muitas raças em Warcraft que podem assumir formas comuns...",
        ["REG_PLAYER_REGISTER"] = "Informação de diretório",
        ["REG_PLAYER_RESIDENCE"] = "Residência",
        ["REG_PLAYER_RESIDENCE_SHOW"] = "Coordenadas de residência",
        ["REG_PLAYER_RESIDENCE_SHOW_TT"] = [=[|cff00ff00%s

|rClique para mostrar no mapa]=],
        ["REG_PLAYER_RESIDENCE_TT"] = [=[Aqui você pode indicar onde seu personagem normalmente vive. Pode ser seu endereço residencial ou um lugar onde ele pode ser encontrado.
Note que se seu personagem é um errante ou até mesmo sem-teto, você terá que mudar a informação de acordo.

|c00ffff00Você pode usar o botão à direita para facilmente registrar sua localidade atual como sua Residência]=],
        ["REG_PLAYER_RIGHTTRAIT"] = "Atributo da direita",
        ["REG_PLAYER_SHOWMISC"] = "Exibir janela de Outros",
        ["REG_PLAYER_SHOWMISC_TT"] = [=[Marque se quiser exibir campos personalizados para seu personagem.

Se não quiser mostrar campos personalizados, mantenha essa caixa desmarcada e a janela de miscelânea ficará completamente escondida.]=],
        ["REG_PLAYER_SHOWPSYCHO"] = "Exibir janela de personalidade",
        ["REG_PLAYER_SHOWPSYCHO_TT"] = [=[Marque se quiser usar a descrição de personalidade.

Se não quiser indicar a personalidade do seu personagem desta forma, mantenha esta caixa desmarcada e a janela de personalidade ficará completamente escondida.]=],
        ["REG_PLAYER_STYLE_ASSIST"] = "Assistência de roleplay",
        ["REG_PLAYER_STYLE_BATTLE"] = "Resolução de batalha roleplay",
        ["REG_PLAYER_STYLE_BATTLE_1"] = "PVP do World of Warcraft",
        ["REG_PLAYER_STYLE_BATTLE_2"] = "Batalha de dados do TRP",
        ["REG_PLAYER_STYLE_BATTLE_3"] = "Batalha por /roll",
        ["REG_PLAYER_STYLE_BATTLE_4"] = "Batalha por emotes",
        ["REG_PLAYER_STYLE_DEATH"] = "Aceitar morte do personagem",
        ["REG_PLAYER_STYLE_EMPTY"] = "Nenhum atributo de roleplay compartilhado",
        ["REG_PLAYER_STYLE_FREQ"] = "Frequência de RolePlay",
        ["REG_PLAYER_STYLE_FREQ_1"] = "O tempo todo, sem OOC",
        ["REG_PLAYER_STYLE_FREQ_2"] = "A maior parte do tempo",
        ["REG_PLAYER_STYLE_FREQ_3"] = "Média",
        ["REG_PLAYER_STYLE_FREQ_4"] = "Casual",
        ["REG_PLAYER_STYLE_FREQ_5"] = "OOC o tempo todo, não é um personagem de RP",
        ["REG_PLAYER_STYLE_GUILD"] = "Filiação à guilda",
        ["REG_PLAYER_STYLE_GUILD_IC"] = "Filiação IC",
        ["REG_PLAYER_STYLE_GUILD_OOC"] = "Filiação OOC",
        ["REG_PLAYER_STYLE_HIDE"] = "Não mostrar",
        ["REG_PLAYER_STYLE_INJURY"] = "Aceitar ferimento do personagem",
        ["REG_PLAYER_STYLE_PERMI"] = "Com permissão do jogador",
        ["REG_PLAYER_STYLE_ROMANCE"] = "Aceitar romance com personagem",
        ["REG_PLAYER_STYLE_RPSTYLE"] = "Estilo de roleplay",
        ["REG_PLAYER_STYLE_RPSTYLE_SHORT"] = "Estilo de RP",
        ["REG_PLAYER_STYLE_WOWXP"] = "Experiência de World of Warcraft",
        ["REG_PLAYER_TITLE"] = "Título",
        ["REG_PLAYER_TITLE_TT"] = [=[O título do seu personagem é o título pelo qual seu personagem normalmente é chamado. Evite títulos longos, os quais você deve colocar em "título completo" logo abaixo.

Exemplos de |c0000ff00títulos apropriados |r:
|c0000ff00- Condessa,
- Marquês,
- Magus,
- Lorde,
- etc.
|rExemplos de |cffff0000títulos inapropriados|r:
|cffff0000- Condessa dos Pântanos do Norte,
- Magus da Torre de Ventobravo,
- Diplomata do Governo Draenei,
- etc.]=],
        ["REG_PLAYER_TRP2_PIERCING"] = "Piercings",
        ["REG_PLAYER_TRP2_TATTOO"] = "Tatuagens",
        ["REG_PLAYER_TRP2_TRAITS"] = "Fisionomia",
        ["REG_PLAYER_TUTO_ABOUT_COMMON"] = [=[|cff00ff00Tema do personagem:|r
Você pode escolher um |cffffff00tema|r para seu personagem. Pense nele como uma |cffffff00música ambiente para ler a descrição do seu personagem|r.

|cff00ff00Fundo:|r
Isto é uma |cffffff00textura de fundo|r para a descrição do seu personagem.

|cff00ff00Modelo:|r
O modelo escolhido define o |cffffff00layout geral e possibilidades de escrita|r para sua descrição.
|cffff9900Apenas o modelo escolhido é visível aos outros, então você não precisa preencher todos.|r
Uma vez que um modelo for escolhido, você pode abrir este tutorial novamente para mais ajuda sobre cada modelo.]=],
        ["REG_PLAYER_TUTO_ABOUT_MISC_1"] = [=[Esta seção possui |cffffff005 slots|r onde você pode descrever |cff00ff00as mais importantes informações sobre seu personagem|r.

Esses slots estarão visíveis na sua |cffffff00"barra de À primeira vista"|r quando alguém selecionar seu personagem.

|cff00ff00Dica: Você pode arrastar e soltar os slots para reordená-los.|r
Também funciona na |cffffff00"barra À primeira vista"|r!]=],
        ["REG_PLAYER_TUTO_ABOUT_MISC_3"] = "Esta seção contém |cffffff00uma lista de marcadores|r para responder muitas |cffffff00perguntas comuns que as pessoas poderiam fazer a respeito de você, seu personagem e a maneira como você o interpreta|r.",
        ["REG_PLAYER_TUTO_ABOUT_T1"] = [=[Este molde permite que você |cff00ff00estruture livremente sua descrição|r.

A descrição não precisa se limitar à |cffff9900descrição física|r do seu personagem. Sinta-se livre para indicar partes da sua |cffff9900história|r ou detalhes sobre sua |cffff9900personalidade|r.

Com este molde você pode usar as ferramentas de formatação para acessar vários parâmetros de molde como |cffffff00tamanhos, cores e alinhamentos de texto|r.

Essas ferramentas também o permitem inserir |cffffff0imagens, ícones ou links para websites externos|r.]=],
        ["REG_PLAYER_TUTO_ABOUT_T2"] = [=[Este molde é mais estruturado e consiste de |cff00ff00uma lista de janelas independentes|r.

Cada janela é caracterizada por um |cffffff00ícone, um fundo e um texto|r. Note que você pode usar marcadores de texto nessas janelas, como os marcadores de texto colorido e ícones.

A descrição não precisa ser limitada à |cffff9900descrição física|r do seu personagem. Sinta-se livre para indicar partes da sua |cffff9900história|r ou detalhes sobre a sua |cffff9900personalidade|r.]=],
        ["REG_PLAYER_TUTO_ABOUT_T3"] = [=[Este molde é cortado em 3 seções: |cff00ff00Descrição física, personalidade e história|r.

Você não precisa preencher todas as janelas, |cffff9900se você deixar uma janela vazia ela não será exibida na sua descrição|r.

Cada janela é caracterizada por um |cffffff00ícone, um fundo e um texto|r. Note que você pode usar marcadores de texto nessas janelas, como os marcadores de texto colorido e ícones.]=],
        ["REG_PLAYER_WEIGHT"] = "Forma do corpo",
        ["REG_PLAYER_WEIGHT_TT"] = [=[Esta é a forma do corpo do seu personagem.
Por exemplo, ele pode ser |c0000ff00esbelto, gordo ou musculoso...|r. Ou ele pode simplesmente ser comum !]=],
        ["REG_REGISTER"] = "Diretório",
        ["REG_REGISTER_CHAR_LIST"] = "Lista de personagens",
        ["REG_RELATION"] = "Relação",
        ["REG_RELATION_BUSINESS"] = "Negócios",
        ["REG_RELATION_BUSINESS_TT"] = "%s e %s estão em uma relação de negócios.",
        ["REG_RELATION_BUTTON_TT"] = [=[Relação: %s
|cff00ff00%s

|cffffff00Clique para exibir todas as ações possíveis]=],
        ["REG_RELATION_FAMILY"] = "Família",
        ["REG_RELATION_FAMILY_TT"] = "%s possui laços de sangue com %s.",
        ["REG_RELATION_FRIEND"] = "Amigável",
        ["REG_RELATION_FRIEND_TT"] = "%s considera %s um(a) amigo(a).",
        ["REG_RELATION_LOVE"] = "Amor",
        ["REG_RELATION_LOVE_TT"] = "%s está apaixonado(a) por %s !",
        ["REG_RELATION_NEUTRAL"] = "Neutro",
        ["REG_RELATION_NEUTRAL_TT"] = "%s não sente nada em particular em relação a %s.",
        ["REG_RELATION_NONE"] = "Nenhuma",
        ["REG_RELATION_NONE_TT"] = "%s não conhece %s.",
        ["REG_RELATION_TARGET"] = "|cffffff00Clique: |rMudar relação",
        ["REG_RELATION_UNFRIENDLY"] = "Antipático",
        ["REG_RELATION_UNFRIENDLY_TT"] = "%s claramente não gosta de %s.",
        ["REG_TT_GUILD"] = "%s de |cffff9900%s",
        ["REG_TT_GUILD_IC"] = "Membro IC",
        ["REG_TT_GUILD_OOC"] = "Membro OOC",
        ["REG_TT_IGNORED"] = "< Personagem está ignorado >",
        ["REG_TT_IGNORED_OWNER"] = "< Dono está ignorado >",
        ["REG_TT_LEVEL"] = "Nível %s %s",
        ["REG_TT_NOTIF"] = "Descrição não-lida",
        ["REG_TT_REALM"] = "Reino: |cffff9900%s",
        ["REG_TT_TARGET"] = "Alvo: |cffff9900%s",
        ["SCRIPT_ERROR"] = "Error no script.",
        ["TB_AFK_MODE"] = "Ausente",
        ["TB_DND_MODE"] = "Não perturbe",
        ["TB_GO_TO_MODE"] = "Mudar para modo %s",
        ["TB_LANGUAGE"] = "Linguagem",
        ["TB_LANGUAGES_TT"] = "Mudar linguagem",
        ["TB_NORMAL_MODE"] = "Normal",
        ["TB_RPSTATUS_OFF"] = "Personagem: |cffff0000Não interpretando",
        ["TB_RPSTATUS_ON"] = "Personagem: |cff00ff00Interpretando",
        ["TB_RPSTATUS_TO_OFF"] = "Alternar para |cffff0000não interpretando",
        ["TB_RPSTATUS_TO_ON"] = "Alternar para |cff00ff00interpretando",
        ["TB_STATUS"] = "Jogador",
        ["TB_SWITCH_CAPE_1"] = "Exibir capa",
        ["TB_SWITCH_CAPE_2"] = "Esconder capa",
        ["TB_SWITCH_CAPE_OFF"] = "Capa: |cffff0000Escondida",
        ["TB_SWITCH_CAPE_ON"] = "Capa: |cff00ff00Exibida",
        ["TB_SWITCH_HELM_1"] = "Exibir elmo",
        ["TB_SWITCH_HELM_2"] = "Esconder elmo",
        ["TB_SWITCH_HELM_OFF"] = "Elmo: |cffff0000Escondido",
        ["TB_SWITCH_HELM_ON"] = "Elmo: |cff00ff00Exibido",
        ["TB_SWITCH_PROFILE"] = "Mudar para outro perfil",
        ["TB_SWITCH_TOOLBAR"] = "Mudar barra de ferramentas",
        ["TB_TOOLBAR"] = "Barra de ferramentas",
        ["TF_IGNORE"] = "Ignorar jogador",
        ["TF_IGNORE_CONFIRM"] = [=[Você tem certeza que quer ignorar esta ID ?

|cffffff00%s|r

|cffff7700Você pode inserir abaixo o motivo. Isso é uma nota pessoal, não será visível aos outros e servirá como lembrete.]=],
        ["TF_IGNORE_NO_REASON"] = "Sem motivo",
        ["TF_IGNORE_TT"] = "|cffffff00Clique:|r Ignorar jogador",
        ["TF_OPEN_CHARACTER"] = "Mostrar página do personagem",
        ["TF_OPEN_COMPANION"] = "Mostrar página do companheiro",
        ["TF_OPEN_MOUNT"] = "Exibir página de montarias",
        ["TF_PLAY_THEME"] = "Tocar tema do personagem",
        ["TF_PLAY_THEME_TT"] = [=[|cffffff00Clique:|r Tocar |cff00ff00%s
|cffffff00Duplo-clique:|r Parar tema]=],
        ["UI_BKG"] = "Fundo %s",
        ["UI_CLOSE_ALL"] = "Fechar tudo",
        ["UI_COLOR_BROWSER"] = "Navegador de cores",
        ["UI_COLOR_BROWSER_SELECT"] = "Selecionar cor",
        ["UI_COMPANION_BROWSER_HELP"] = "Selecionar uma mascote de batalha",
        ["UI_COMPANION_BROWSER_HELP_TT"] = [=[|cffffff00Aviso: |rApenas mascotes de batalha nomeadas podem ser vinculadas a um perfil.

|cff00ff00Esta seção lista apenas estas mascotes.]=],
        ["UI_FILTER"] = "Filtrar",
        ["UI_ICON_BROWSER"] = "Navegador de ícones",
        ["UI_ICON_BROWSER_HELP"] = "Copiar ícone",
        ["UI_ICON_BROWSER_HELP_TT"] = [=[Enquanto esta janela estiver aberta você pode usar |cffffff00ctrl + clique|r em um ícone para copiar seu nome.

Isso funciona:|cff00ff00
- Em qualquer item nas suas bolsas
- Em qualquer ícone no livro de habilidades]=],
        ["UI_ICON_SELECT"] = "Selecionar ícone",
        ["UI_IMAGE_BROWSER"] = "Navegador de imagens",
        ["UI_IMAGE_SELECT"] = "Selecionar imagem",
        ["UI_LINK_TEXT"] = "Seu texto aqui",
        ["UI_LINK_URL"] = "http://sua.url.aqui",
        ["UI_LINK_WARNING"] = [=[Aqui está a URL do link.
Você pode copiar/colar no seu navegador da web.
|cffff0000!! Aviso !!|r
O Total RP não é responsável por links que levem a conteúdo nocivo.
]=],
        ["UI_MUSIC_BROWSER"] = "Navegador de músicas",
        ["UI_MUSIC_SELECT"] = "Selecionar música",
        ["UI_TUTO_BUTTON"] = "Modo tutorial",
        ["UI_TUTO_BUTTON_TT"] = "Clique para ativar/desativar o modo tutorial"
    }
    --@end-do-not-package@
};

TRP3_API.locale.registerLocale(LOCALE);