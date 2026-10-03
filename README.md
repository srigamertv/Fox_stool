# Fox_stool

Banquinho portátil para RedM. O jogador senta usando o comando ou um item do inventário.

## 🔥 Funcionalidades

- 🪑 Cria um banquinho portátil e coloca o personagem sentado.
- ⌨️ Comando `/banquinho`.
- 🎒 Item utilizável `banquinho`.
- 🔁 Use novamente para remover o banquinho.
- ✅ VORP, RSG e uso standalone por comando.

## 📦 Compatibilidade

- RedM
- VORP + `vorp_inventory`
- RSG Core + `rsg-inventory`
- Standalone para uso por comando
- `Config.Framework = 'auto'` detecta VORP/RSG automaticamente

## 🧠 Como funciona

Use `/banquinho` ou o item `banquinho` para sentar. Use novamente para levantar e remover o prop.

## 🛠️ Instalação

1. Copie a pasta `Fox_stool` para `resources`.
2. Adicione no `server.cfg`:

```cfg
ensure Fox_stool
```

3. Para VORP, cadastre o item `banquinho` na tabela/configuração de itens do `vorp_inventory`.
4. No RSG, o recurso adiciona a definição do item automaticamente ao `Shared.Items` caso ela ainda não exista. Se quiser uma imagem, coloque `banquinho.png` na pasta de imagens do seu inventário.

## ⚙️ Configuração

```lua
Config.Framework = 'auto' -- auto / vorp / rsg / standalone

Config.Command = {
    enabled = true,
    name = 'banquinho'
}

Config.Item = {
    enabled = true,
    name = 'banquinho',
    consume = false,
    closeInventory = true
}
```

## ✍️ Créditos

Desenvolvido e adaptado por **SR.IGAMER TV | FOX**.

Recurso gratuito e open-source para a comunidade RedM.

<!-- Adicione aqui o Video Preview do YouTube quando tiver o link. -->

<br>

**MINHA LOJA:**
<div>
  <a href="https://discord.gg/ySk8WVzY5n" target="_blank"><img src="https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white" target="_blank"></a>
</div>

<br>

**Siga-nos:**
<div>
  <a href="https://www.youtube.com/@SRIGAMERTV" target="_blank"><img src="https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white" target="_blank"></a>
  <a href="https://www.instagram.com/sr.igamer_tv" target="_blank"><img src="https://img.shields.io/badge/-Instagram-%23E4405F?style=for-the-badge&logo=instagram&logoColor=white" target="_blank"></a>
  <a href="https://discord.gg/kh2KTGvaVX" target="_blank"><img src="https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white" target="_blank"></a>
</div>

<br>

**Entrar-contato:**
<div>
  <a href="mailto:kelvinsom22kb@gmail.com"><img src="https://img.shields.io/badge/-Gmail-%23333?style=for-the-badge&logo=gmail&logoColor=white" target="_blank"></a>
</div>


## 🛡️ Licença

Distribuído sob a licença MIT. Consulte o arquivo `LICENSE`.
