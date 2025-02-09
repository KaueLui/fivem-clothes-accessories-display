local open = false

local Keys = {
    ["ESC"] = 322
}

-- Definir o idioma atual. Pode ser alterado para "pt" ou "en" conforme a necessidade
-- Set the current language. Can be changed to "pt" or "en" as needed
local idioma = "pt" 

-- Tabela de traduções

local traducoes = {
    pt = {
        cabeca = "Cabeça",
        mascara = "Máscara",
        cabelo = "Cabelo",
        mao = "Mão",
        calca = "Calça",
        mochila = "Mochila",
        sapato = "Sapato",
        acessorio = "Acessório",
        camisa = "Camisa",
        colete = "Colete",
        adesivo = "Adesivo",
        jaqueta = "Jaqueta",
        prop_chapeu = "Chapéu",
        prop_oculos = "Óculos",
        prop_brinco = "Brinco",
        prop_relogio = "Relógio",
        prop_anel = "Anel",
        mostrar_roupas = "Mostrando roupas",
        mostrar_props = "Mostrando acessórios",
        fechar = "Fechar"
    },
    en = {
        cabeca = "Head",
        mascara = "Mask",
        cabelo = "Hair",
        mao = "Hand",
        calca = "Pants",
        mochila = "Backpack",
        sapato = "Shoes",
        acessorio = "Accessory",
        camisa = "Shirt",
        colete = "Vest",
        adesivo = "Sticker",
        jaqueta = "Jacket",
        prop_chapeu = "Hat",
        prop_oculos = "Glasses",
        prop_brinco = "Earrings",
        prop_relogio = "Watch",
        prop_anel = "Ring",
        mostrar_roupas = "Showing clothes",
        mostrar_props = "Showing accessories",
        fechar = "Close"
    }
}

-- Função para obter a tradução do idioma atual
local function traduzir(chave)
    return traducoes[idioma][chave] or chave
end

-- Mapeamento dos slots para os nomes das peças de roupa
local nomeDasPecas = {
    [0] = traduzir("cabeca"),
    [1] = traduzir("mascara"),
    [2] = traduzir("cabelo"),
    [3] = traduzir("mao"),
    [4] = traduzir("calca"),
    [5] = traduzir("mochila"),
    [6] = traduzir("sapato"),
    [7] = traduzir("acessorio"),
    [8] = traduzir("camisa"),
    [9] = traduzir("colete"),
    [10] = traduzir("adesivo"),
    [11] = traduzir("jaqueta")
}

-- Mapeamento para os props (chapéus, brincos, etc.)
local nomeDosProps = {
    [0] = traduzir("prop_chapeu"),
    [1] = traduzir("prop_oculos"),
    [2] = traduzir("prop_brinco"),
    [6] = traduzir("prop_relogio"),
    [7] = traduzir("prop_anel")
}

RegisterCommand("roupa", function()
    local ped = PlayerPedId()
    local roupas = {}
    local props = {}

    -- Loop para obter roupas
    for i = 0, 11 do
        local nomePeca = nomeDasPecas[i]
        if nomePeca then
            local drawableId = GetPedDrawableVariation(ped, i)
            if drawableId ~= -1 then  -- Verificar se há uma peça equipada
                table.insert(roupas, { nome = nomePeca, id = drawableId })
            end
        end
    end

    -- Loop para obter os props
    for i = 0, 7 do
        local nomeProp = nomeDosProps[i]
        local propId = GetPedPropIndex(ped, i)
        if nomeProp and propId ~= -1 then
            table.insert(props, { nome = nomeProp, id = propId })
        end
    end

    -- Enviar dados para a NUI (interface)
    SendNUIMessage({
        action = "show",
        roupas = roupas,
        props = props
    })

    -- Ativar o cursor e mostrar a UI
    SetNuiFocus(true, true)
    open = true
end)

-- Fechar a UI quando pressionar o botão (pela NUI)
RegisterNUICallback("fechar", function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hide" })
    open = false
end)

-- Detecção da tecla ESCAPE (fechar a UI)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, Keys["ESC"]) then
            if open then
                SetNuiFocus(false, false)
                SendNUIMessage({ action = "hide" })
                open = false
            end
        end
    end
end)
