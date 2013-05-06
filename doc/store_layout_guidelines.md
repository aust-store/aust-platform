## Requisitos

Entrega por layout:

* 1 PSD com a página principal, com pastas (layers) nomeadas. No caso de menus
que aparecem com um clique, deixa pasta invisível. Não devem estar presentes
pastas (layers) não utilizados.
* Arquivo PN de cada página e estado. No caso de interações de menus, usar um
PNG para cada estado.
* Demais páginas em PSD.

Páginas a serem entregues:

* Página principal
* Página de detalhes de produto
* Página de carrinho de compras
* Página interna "Quem somos" com simples texto de 3-4 parágrafos. Servirá de
base para outras páginas.


## 1. Elementos Universais

Estes são elementos que aparecem em todas as páginas, como link para o carrinho
de compras e página de contato, por exemplo.

### 1.1 Status do Carrinho

Deve aparecer em todas as páginas da loja, e deve conter a quantidade de itens
no carrinho de compras.

As seguintes telas devem ser desenvolvidas:

* quando o carrinho de compras está vazio
* quando o carrinho com itens não está vazio

### 1.2 Sessão do usuário

Mensagem que indica que o usuário está logado ou não.

As seguintes telas devem ser desenvolvidas:

* quando o usuário está logado
* quando o usuário não está logado

### 1.3 Menus de navegação geral

Possui link de navegação às páginas de maior interesse, os quais deve incluir:

* Página principal
* Contato/Atendimento
* Quem Somos
* Minha Conta

### 1.4 Menu de navegação de categorias de produtos

Produtos são divididos em categorias. Devemos mostrar estas categorias ao usuário
e permitir que ele escolha qual delas ele deseja ver os itens.

Categorias possuem formato de árvore, como a seguir:

```
Roupa
  |
  |-- Camisas
  |-- Camisetas
   \- Calças
Móveis
  |--Cadeiras
  |    |-- Cozinha
  |     \- Escritório
   \- Mesas
```

Caso o menu seja visível o tempo todo, talvez seja melhor mostrar apenas 1 ou 2
níveis da árvore. Caso o menu seja vísivel na página principal, mas não em
páginas internas, uma solução é mostrar um botão que ao ser clicado, abre um
DIV com as categorias como menu de contexto, assim como sites como Submarino e
Amazon fazem.

O importante é que as categorias devem ser acessíveis a partir de todas as
páginas.

Ex. 1:

![](http://img35.imageshack.us/img35/9483/storemainpage1.jpg)

Aqui, as categorias são visíveis na página.

Ex. 2

![](http://img838.imageshack.us/img838/2126/storemainpage2contextca.jpg)

Aqui, as categorias são visíveis apenas se o usuário clicar num botão grande
para vê-las.

### 1.5 Banners

* em todas as páginas, banners laterais (geralmente na direita) devem aparecer.
A largura destes banners é de 200px.
* na página principal, deve ser possível acrescentar um banner acima da
listagem
* na página principal, deve ser possível acrescentar um banner abaixo da
listagem

Quanto aos banners superiores e inferiores, veja o exemplo:

![](http://img707.imageshack.us/img707/5787/storemainpage1horizonta.jpg)

### 1.6 Chat

O chat serve para o dono da loja poder conversar com clientes que estão
acessando a mesma. Criar os seguintes mockups:

* quando o chat aberto, considerando o que aparece no chat
* quando o chat fechado
* quando sem chat

### 1.7 Rodapé

Deve conter:

* link de contato/atendimento
* link quem somos
* outros (links gerenciados, acrescentados e removidos pelo administrador)
* telefone 1
* telefone 2
* endereço
* imagens de: site blindado, internet segura, certisign etc (ver Submarino)

### 1.8 Palavras-chave

Palavras-chave são aquelas palavras mais usadas no campo de pesquisa. Veja
submarino.com.br, no final da página, para um exemplo. Também conhecido como
_word cloud_.

Deve ser criado um mockup mostrando a presença deste elemento e outro sem este
elemento.

### 1.9 Pesquisa

Campo de pesquisa no topo do site.

### 1.10 Recomendações de produtos

Semelhante ao Amazon, aparece um título como "Pessoas que escolheram X também
gostaram de Y", e abaixo uma lista de produtos.

## 2 Página principal

### 2.1 Listagem de produtos

Cada produto deve conter:

* Nome
* Preço
* Preço com desconto
* Parcelamento
* Botão "Adicionar ao carrinho"
* Imagem 170px por 127px

12 produtos serão mostrados na página principal.

### 2.2 Destaque (banner principal)

É simplesmente um banner rotativo composto por várias imagens. Deve-se
desenvolver o layout dos botões que permitem o usuário selecionar outro banner.

## 3 Detalhes do produto

* título
* Merchandising: esta é uma frase de efeito que o administrador configura e
geralmente aparece abaixo do título com o propósito de convencer o usuário
a comprar o produto
* Descrição
* Imagem de capa (350px por 251px), mesma da página principal
* Thumbnails (60x45), imagens menores que ao serem clicadas, são mostradas com
zoom
* Preço
* Detalhes de parcelamento
* Preço com desconto
* Botão Comprar/Adicionar ao carrinho de compras
* Botão adicionar à lista de desejos
* Breadcrumb trails (categorias aninhadas, ex.: Tênis -> Esportes -> Corrida)

## 4 Carrinho de compras

### 4.1 Listagem de produtos

* Título
* Mini-descrição
* Quantidade
* Remover
* Total

### 4.2 Frete

* campo para entrar o CEP
* Radio button com PAC e SEDEX

### 4.3 Recomendações

Semelhante ao Amazon, aparece um título como "Pessoas que escolheram X também
gostaram de Y", e abaixo uma lista de produtos.
