[← Back to projects](../README.md)

# Project 5: Dynamic Chat Room Backend

## Goal

Build a backend-only chat system without Phoenix:

```text
Create room
Join room
Broadcast message
Leave room
Close room when empty
```

## Focus Areas

- DynamicSupervisor
- Registry
- GenServer per room
- Process lifecycle
- Message broadcasting
- PubSub-style design

## Suggested Architecture

```text
Chat.Application
└── Chat.Supervisor
    ├── Chat.RoomSupervisor
    └── Chat.Registry
```

## Key Lesson

This project teaches how to design an OTP system, not just how to write a single GenServer.
