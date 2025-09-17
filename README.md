# Management

Sistema completo de gestão empresarial desenvolvido em Flutter, com arquitetura modular, design moderno e banco de dados local. Gerencie clientes, produtos e vendas com uma experiência fluida e responsiva.

---

## Módulos Atuais

- **Clientes**  
  Cadastro completo com CPF/CNPJ, endereço com busca de CEP, validações, ordenação e filtros dinâmicos.

- **Produtos**  
  Suporte a múltiplas unidades com valores e estoque por unidade. Formulário moderno e visual detalhado.

- **Vendas**  
  Venda com múltiplos itens, cliente vinculado, condições e formas de pagamento, status de venda e resumo por abas.

- **Dashboard**  
  Visão geral com cards de resumo, gráficos interativos por status da venda e totalizadores do mês.

---

## Estrutura do Projeto

```plaintext
lib/
├── core/
│   ├── components/         # Componentes reutilizáveis
│   ├── constants/          # Nomes de rotas, assets e constantes globais
│   ├── router/             # GoRouter configurado
│   ├── services/           # Serviços (Toast, Banco de Dados, etc.)
│   ├── themes/             # Temas claros/escuros, cores e estilos
├── modules/
│   ├── customer/           # Módulo de clientes
│   ├── product/            # Módulo de produtos
│   ├── sale/               # Módulo de vendas
│   ├── dashboard/          # Dashboard e gráficos
├── shared/                 # Utilitários compartilhados (utils, enums, formatadores)
├── main.dart
```

---

## Recursos Técnicos

- Flutter 3.22+
- Navegação com `go_router`
- Estado com `provider`
- Banco local com `sqflite`
- Injeção com `ProxyProvider`
- Suporte a temas claros/escuros com toggle
- Layout moderno com cards, seções, ícones e responsividade
- Migrations controladas e centralizadas
- Arquitetura modular baseada em MVC

---

## Instalação

1. **Clone o repositório**

```bash
git clone https://github.com/seuusuario/management.git
cd management
```

2. **Instale as dependências**

```bash
flutter pub get
```

3. **Execute o app**

```bash
flutter run
```

---

## Desenvolvido por

- Marcos Vinicius Hellmann Delfino  
- Arquitetura: Flutter + Provider + SQFlite + MVC  
- UI/UX personalizada com layout moderno, animações sutis e boas práticas de acessibilidade.

---

## Próximos passos

- Multi Tenant com controle de usuários
- Gráficos avançados de vendas por período
- Geração de relatórios em PDF

---

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).