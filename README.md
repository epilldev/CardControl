# 💳 CardControl

Controle seus cartões, acompanhe seus gastos e mantenha sua vida financeira organizada em um único lugar

---

## ✨ Visão Geral

O CardControl é um aplicativo iOS desenvolvido em SwiftUI que permite gerenciar cartões de crédito, acompanhar despesas e visualizar indicadores financeiros de forma simples e intuitiva.

O projeto foi criado com foco em experiência do usuário, arquitetura limpa e boas práticas de desenvolvimento iOS.

---

## 🚀 Principais Recursos

* 🔐 Login com Google
* 💳 Cadastro de cartões de crédito
* 📊 Dashboard financeiro
* 💸 Controle de gastos por cartão
* 📈 Limite utilizado e disponível
* 🕒 Histórico de transações
* ☁️ Integração com Firebase Authentication
* 📱 Interface moderna em SwiftUI

---

## 🏗️ Arquitetura

O projeto segue o padrão **MVVM (Model-View-ViewModel)**.

```text
Views
 ↓
ViewModels
 ↓
Services
 ↓
Persistence (Core Data)
```

### Estrutura

```text
CardControl
├── Models
├── Views
├── ViewModels
├── Services
├── Persistence
└── Resources
```

---

## 🛠️ Tecnologias

| Tecnologia     | Finalidade              |
| -------------- | ----------------------- |
| SwiftUI        | Interface               |
| MVVM           | Arquitetura             |
| Firebase Auth  | Autenticação            |
| Google Sign-In | Login                   |
| Core Data      | Persistência            |
| Combine        | Gerenciamento de estado |

---

## 📱 Principais Telas

### Splash Screen

Tela inicial da aplicação.

### Login

Autenticação segura utilizando conta Google.

### Dashboard

Resumo financeiro consolidado.

### Cartões

Gerenciamento completo dos cartões cadastrados.

### Histórico

Consulta de movimentações e despesas.

---

## 🔒 Segurança

A autenticação é realizada através do Firebase Authentication utilizando Google Sign-In.

Nenhuma senha é armazenada localmente pelo aplicativo.

---

## 🎯 Objetivos do Projeto

* Aplicar conceitos de SwiftUI
* Utilizar arquitetura MVVM
* Integrar autenticação com Firebase
* Implementar persistência com Core Data
* Construir uma experiência moderna para controle financeiro

---
