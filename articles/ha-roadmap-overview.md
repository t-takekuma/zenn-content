---
title: "【HA計画】ロードマップと到達基準"
emoji: "🧭"
type: "tech"
topics: ["ha","roadmap","portfolio"]
published: true
---

## 目的
TBW

## ストリーム図
```mermaid
flowchart TB
  subgraph A[NW疎通]
    A1[A1 VLAN/ACL] --> A2[A2 Tunnel/SSH ZT] --> A3[A3 Ops Rules]
  end
  subgraph B[アプリケーション]
    B1[B1 Compose最小] --> B2[B2 ログ可視化] --> B3[B3 認証・操作ログ]
  end
  subgraph C[IoT制御]
    C1[C1 センサー収集] --> C2[C2 AC制御] --> C3[C3 グローバルIP監視]
  end
