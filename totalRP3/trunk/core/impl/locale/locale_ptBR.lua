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
	localeContent = {
		ABOUT_TITLE = "Sobre",
		BINDING_NAME_TRP3_TOGGLE = "Mostrar/ocultar tela principal", -- Needs review
		BINDING_NAME_TRP3_TOOLBAR_TOGGLE = "Mostrar/ocultar barra de ferramentas",
		BW_COLOR_CODE = "Código de cor",
		BW_COLOR_CODE_ALERT = "Código hexadecimal incorreto!",
		BW_COLOR_CODE_TT = "Você pode colar um código de cor hexadecimal de 6 caracteres aqui e pressionar Enter.",
		CM_ACTIONS = "Ações",
		CM_APPLY = "Aplicar",
		CM_CANCEL = "Cancelar",
		CM_CENTER = "Centro",
		CM_CLASS_DEATHKNIGHT = "Cavaleiro da Morte",
		CM_CLASS_DRUID = "Druida",
		CM_CLASS_HUNTER = "Caçador",
		CM_CLASS_MAGE = "Mago",
		CM_CLASS_MONK = "Monge",
		CM_CLASS_PALADIN = "Paladino",
		CM_CLASS_PRIEST = "Sacerdote",
		CM_CLASS_ROGUE = "Ladino",
		CM_CLASS_SHAMAN = "Xamã",
		CM_CLASS_UNKNOWN = "Desconhecido",
		CM_CLASS_WARLOCK = "Bruxo",
		CM_CLASS_WARRIOR = "Guerreiro",
		CM_CLICK = "Clique",
		CM_COLOR = "Cor",
		CM_CTRL = "Ctrl",
		CM_DRAGDROP = "Arrastar & soltar",
		CM_EDIT = "Editar",
		CM_IC = "IC", -- Needs review
		CM_ICON = "Ícone",
		CM_IMAGE = "Imagem",
		CM_L_CLICK = "Clique-esquerdo",
		CM_LEFT = "Esquerda",
		CM_LINK = "Link",
		CM_LOAD = "Carregar",
		CM_MOVE_DOWN = "Mover para baixo",
		CM_MOVE_UP = "Mover para cima",
		CM_NAME = "Nome",
		CM_OOC = "OOC", -- Needs review
		CM_OPEN = "Aberto",
		CM_PLAY = "Reproduzir",
		CM_R_CLICK = "Clique-direito",
		CM_REMOVE = "Remover",
		CM_RIGHT = "Direita",
		CM_SAVE = "Salvar",
		CM_SELECT = "Selecionar",
		CM_SHIFT = "Shift",
		CM_SHOW = "Mostrar",
		CM_STOP = "Parar",
		CM_UNKNOWN = "Desconhecido",
		CM_VALUE = "Valor", -- Needs review
		CO_ANCHOR_BOTTOM = "Baixo", -- Needs review
		CO_ANCHOR_BOTTOM_LEFT = "Baixo-esquerda", -- Needs review
		CO_ANCHOR_BOTTOM_RIGHT = "Baixo-direita", -- Needs review
		CO_ANCHOR_LEFT = "Esquerda", -- Needs review
		CO_ANCHOR_RIGHT = "Direita", -- Needs review
		CO_ANCHOR_TOP = "Cima", -- Needs review
		CO_ANCHOR_TOP_LEFT = "Cima-esquerda", -- Needs review
		CO_ANCHOR_TOP_RIGHT = "Cima-direita", -- Needs review
		CO_CHAT = "Configurações de conversa", -- Needs review
		CO_CHAT_MAIN = "Configurações principais de conversa", -- Needs review
		CO_CHAT_MAIN_COLOR = "Usar cores personalizadas para nomes", -- Needs review
		CO_CHAT_MAIN_EMOTE = "Detectar emotes", -- Needs review
		CO_CHAT_MAIN_EMOTE_PATTERN = "Padrão de detecção de emote", -- Needs review
		CO_CHAT_MAIN_EMOTE_USE = "Usar detecção de emote", -- Needs review
		CO_CHAT_MAIN_EMOTE_YELL = "Sem emote em grito", -- Needs review
		CO_CHAT_MAIN_EMOTE_YELL_TT = "Não mostrar *emote* ou <emote> em gritos.", -- Needs review
		CO_CHAT_MAIN_NAMING = "Método de nomes", -- Needs review
		CO_CHAT_MAIN_NAMING_1 = "Manter nomes originais", -- Needs review
		CO_CHAT_MAIN_NAMING_2 = "Usar nomes personalizados", -- Needs review
		CO_CHAT_MAIN_NAMING_3 = "Nome + sobrenome", -- Needs review
		CO_CHAT_MAIN_NPC = "Detectar fala de PnJ", -- Needs review
		CO_CHAT_MAIN_NPC_PREFIX = "Padrão de detecção de fala de PnJ", -- Needs review
		CO_CHAT_MAIN_NPC_PREFIX_TT = [=[Se uma conversa nos canais SAY, EMOTE, GRUPO ou RAIDE começar com este prefixo, será interpretado como uma fala de PnJ.

|cff00ff00Padrão : "|| "
(sem aspas e com espaço após a barra)]=], -- Needs review
		CO_CHAT_MAIN_NPC_USE = "Usar detecção de conversa de PnJ", -- Needs review
		CO_CHAT_MAIN_OOC = "Detecção de OOC", -- Needs review
		CO_CHAT_MAIN_OOC_COLOR = "Cor de OOC", -- Needs review
		CO_CHAT_MAIN_OOC_PATTERN = "Padrão de detecção de OOC", -- Needs review
		CO_CHAT_MAIN_OOC_USE = "Detecção de OOC", -- Needs review
		CO_CHAT_USE = "Canais de conversa usados", -- Needs review
		CO_CHAT_USE_SAY = "Canal Say", -- Needs review
		CO_CONFIGURATION = "Configurações", -- Needs review
		CO_GENERAL = "Configurações gerais", -- Needs review
		CO_GENERAL_BROADCAST = "Usar canal de anúncio", -- Needs review
		CO_GENERAL_BROADCAST_C = "Nome do canal de anúncio", -- Needs review
		CO_GENERAL_BROADCAST_TT = "O canal de anúncio é usado para muitas funções. Desabilitá-lo irá desabilitar todas as funções como posição de personagens no mapa, sons locais, acesso a sinalizações...", -- Needs review
		CO_GENERAL_CHANGELOCALE_ALERT = [=[Recarregar a interface para mudar a linguagem para %s agora?

Se não recarregar, a linguagem será alterada na próxima vez que conectar.]=], -- Needs review
		CO_GENERAL_COM = "Comunicação", -- Needs review
		CO_GENERAL_HEAVY = "Alerta de perfil pesado", -- Needs review
		CO_GENERAL_HEAVY_TT = "Receber alerta quando o tamanho total de seu perfil exceder um valor aceitável.", -- Needs review
		CO_GENERAL_LOCALE = "Local do addon", -- Needs review
		CO_GENERAL_MISC = "Diversos", -- Needs review
		CO_GENERAL_NEW_VERSION = "Alerta de atualização", -- Needs review
		CO_GENERAL_NEW_VERSION_TT = "Receber alerta quando uma nova versão estiver disponível.", -- Needs review
		CO_GENERAL_TT_SIZE = "Tamanho do texto da tela de informações", -- Needs review
		CO_GENERAL_UI_ANIMATIONS = "Animações de interface", -- Needs review
		CO_GENERAL_UI_ANIMATIONS_TT = "Ativar animações de interface", -- Needs review
		CO_GENERAL_UI_SOUNDS = "Sons de interface", -- Needs review
		CO_GENERAL_UI_SOUNDS_TT = "Ativar sons da interface (quando abrir janelas, mudar abas, clicar em botões).", -- Needs review
		CO_GLANCE_LOCK = "Travar barra", -- Needs review
		CO_GLANCE_LOCK_TT = "Evita arrastar a barra", -- Needs review
		CO_GLANCE_MAIN = "Barra de \"à primeira vista\"", -- Needs review
		CO_GLANCE_PRESET_TRP2 = "Usar posições ao estilo do Total RP 2", -- Needs review
		CO_GLANCE_PRESET_TRP2_BUTTON = "Usar", -- Needs review
		CO_GLANCE_PRESET_TRP2_HELP = "Atalho para a barra de configuração no estilo TRP2: à direita da janela alvo.", -- Needs review
		CO_GLANCE_PRESET_TRP3 = "Usar posições estilo Total RP 3", -- Needs review
		CO_GLANCE_PRESET_TRP3_HELP = "Atalho para barra de configuração no estilo TRP3: abaixo da janela alvo.", -- Needs review
		CO_GLANCE_RESET_TT = "Recolocar a barra de posição para baixo-esquerda da tela guia.", -- Needs review
		CO_GLANCE_TT_ANCHOR = "Ponto de referência para janela de informações", -- Needs review
		CO_MINIMAP_BUTTON = "Botão no minimapa", -- Needs review
		CO_MINIMAP_BUTTON_FRAME = "Janela de referência", -- Needs review
		CO_MINIMAP_BUTTON_RESET = "Reiniciar posições", -- Needs review
		CO_MINIMAP_BUTTON_RESET_BUTTON = "Reiniciar", -- Needs review
		COM_LIST = "Lista de comandos:", -- Needs review
		CO_MODULES = "Status dos módulos", -- Needs review
		CO_MODULES_DISABLE = "Desativar módulo", -- Needs review
		CO_MODULES_ENABLE = "Ativar módulo", -- Needs review
		CO_MODULES_ID = "ID do módulo: %s", -- Needs review
		CO_MODULES_SHOWERROR = "Mostrar erros", -- Needs review
		CO_MODULES_STATUS = "Status: %s", -- Needs review
		CO_MODULES_STATUS_0 = "Dependências ausentes", -- Needs review
		CO_MODULES_STATUS_1 = "Carregado", -- Needs review
		CO_MODULES_STATUS_2 = "Desabilitado", -- Needs review
		CO_MODULES_STATUS_3 = "Requer atualização do Total RP 3", -- Needs review
		CO_MODULES_STATUS_4 = "Erro na inicialização", -- Needs review
		CO_MODULES_STATUS_5 = "Erro no carregamento", -- Needs review
		CO_MODULES_TT_DEP = [=[
%s- %s (versão %s)|r]=], -- Needs review
		CO_MODULES_TT_DEPS = "Dependências", -- Needs review
		CO_MODULES_TT_ERROR = [=[

|cffff0000Erro:|r
%s]=], -- Needs review
		CO_MODULES_TT_NONE = "Sem dependências", -- Needs review
		CO_MODULES_TT_TRP = "%sPara Total RP 3 versão mínima %s.|r", -- Needs review
		CO_MODULES_TUTO = [=[Um módulo é uma característica independnete que pode ser ativada ou desativada.

Status possíveis:
|cff00ff00Carregado:|r O módulo está disponível e carregado.
|cff999999Desabilitado:|r O módulo está desabilitado.
|cffff9900Dependências em falta:|r Alguns itens essenciais não foram carregados.
|cffff9900Atualização do TRP necessária:|r O módulo precisa da versão mais recente do TRP3.
|cffff0000Erro ao carregar ou iniciar:|r O carregamento do módulo apresentou problemas. O módulo possivelmente gerará erros.!

|cffff9900Quando um módulo é desabilitado, é necessário recarregar a interface.]=], -- Needs review
		CO_MODULES_VERSION = "Versão: %s", -- Needs review
		COM_RESET_RESET = "A posição das telas foi reiniciada!", -- Needs review
		COM_RESET_USAGE = "Uso: |cff00ff00/trp3 reset frames|r para reiniciar todas as posições das telas.", -- Needs review
		CO_MSP = "Protocolo Mary Sue", -- Needs review
		CO_MSP_T3 = "Usar apenas template 3", -- Needs review
		CO_MSP_T3_TT = "Mesmo se escolher outro template \"sobre\", o template 3 será sempre usado para compatibilidade MSP.", -- Needs review
		COM_SWITCH_USAGE = "Uso: |cff00ff00/trp3 switch main|r para mudar para tela principal ou |cff00ff00/trp3 switch toolbar|r para mudar a barra de ferramentas.", -- Needs review
		CO_REGISTER = "Configuração de registros", -- Needs review
		CO_REGISTER_ABOUT_VOTE = "Habilitar sistema de votação", -- Needs review
		CO_REGISTER_ABOUT_VOTE_TT = "Ativa o sistema de votação, permitindo votar (\"curtir\" ou \"não curtir\") outras descrições, e permitir o mesmo para seu perfil.", -- Needs review
		CO_REGISTER_AUTO_ADD = "Adicionar novos jogadores automaticamente", -- Needs review
		CO_REGISTER_AUTO_ADD_TT = "Adiciona automaticamente novos jogadores ao registro.", -- Needs review
		CO_TARGETFRAME = "Configurações do frame alvo", -- Needs review
		CO_TARGETFRAME_ICON_SIZE = "Tamanho dos ícones", -- Needs review
		CO_TARGETFRAME_USE = "Mostrar condições", -- Needs review
		CO_TARGETFRAME_USE_1 = "Sempre", -- Needs review
		CO_TARGETFRAME_USE_2 = "Apenas quando IC", -- Needs review
		CO_TARGETFRAME_USE_3 = "Nunca (desabilitado)", -- Needs review
		CO_TARGETFRAME_USE_TT = "Determina em quais condições o frame alvo deve ser mostrado quando selecionado.", -- Needs review
		CO_TOOLBAR = "Configurações de frame", -- Needs review
		CO_TOOLBAR_CONTENT = "Configurações de barra de ferramentas", -- Needs review
		CO_TOOLBAR_CONTENT_CAPE = "Alternas visualização de capa", -- Needs review
		CO_TOOLBAR_CONTENT_HELMET = "Alternas visualização de elmo", -- Needs review
		CO_TOOLBAR_CONTENT_RPSTATUS = "Status do personagem (IC/OOC)", -- Needs review
		CO_TOOLBAR_CONTENT_STATUS = "Status do jogador (AFK/DND)", -- Needs review
		CO_TOOLBAR_ICON_SIZE = "Tamanho dos ícones", -- Needs review
		CO_TOOLBAR_MAX = "Número máximo de ícones por linha", -- Needs review
		CO_TOOLBAR_MAX_TT = "User o valor 1 para mostrar a barra verticalmente!", -- Needs review
		CO_TOOLTIP = "Configurações de tooltip", -- Needs review
		CO_TOOLTIP_ANCHOR = "Ponto âncora", -- Needs review
		CO_TOOLTIP_ANCHORED = "Tela ancorada", -- Needs review
		CO_TOOLTIP_CHARACTER = "Tooltip de personagens", -- Needs review
		CO_TOOLTIP_CLIENT = "Mostrar cliente", -- Needs review
		CO_TOOLTIP_COMBAT = "Esconder durante combate", -- Needs review
		CO_TOOLTIP_COMMON = "Configurações comuns", -- Needs review
		CO_TOOLTIP_CURRENT = "Mostrar informação \"atual\"", -- Needs review
		CO_TOOLTIP_CURRENT_SIZE = "Tamanho da informação \"atual\"", -- Needs review
		CO_TOOLTIP_FT = "Mostrar título completo", -- Needs review
		CO_TOOLTIP_GUILD = "Mostrar informações da guilda", -- Needs review
		CO_TOOLTIP_HIDE_ORIGINAL = "Esconder tooltip original", -- Needs review
		CO_TOOLTIP_ICONS = "Mostrar ícones", -- Needs review
		CO_TOOLTIP_MAINSIZE = "Tamanho da fonte principal", -- Needs review
		CO_TOOLTIP_NOTIF = "Mostrar notificações", -- Needs review
		CO_TOOLTIP_NOTIF_TT = "A linha de notificações é a linha contendo a versão do client, o marcador de não lido e o marcador de \"a primeira vista\".", -- Needs review
		CO_TOOLTIP_OWNER = "Mostrar dono", -- Needs review
		GEN_WELCOME_MESSAGE = "Obrigado por usar o Total RP 3 (v %s) ! Divirta-se !",
	}
};

TRP3_API.locale.registerLocale(LOCALE);