---
title: Zero Trust for AI Agents
description: Anthropic eBook。エージェント向けZero Trust。3層フレームワーク、8フェーズ実装、防御運用
# permalink:  # don't use
aliases:
  - zero-trust-for-ai-agents
tags:
  - security
  - ai-agent
  - zero-trust
  - anthropic
draft: false
date: 2026-10-28
---

# Zero Trust for AI Agents

- 記事: https://claude.com/ja/resources/articles/zero-trust-for-ai-agents
- PDF: https://cdn.prod.website-files.com/6889473510b50328dbb70ae6/6a1611a04085d7cd3dadc924_Claude-eBook-Zero-Trust-for-AI-Agents-05182026.pdf
- Anthropic 公開 (2026-05)。36ページ。

## 一言

AI で exploit 速くなった。月単位 → 時間単位。エージェント入れる側、二重に危ない。
基盤が攻撃される + エージェント自体が自律で動く。
だから Zero Trust。「誰も信用しない、全部検証、侵害済み前提」。

## かんたん版

AI エージェント = 新人バイトに会社の鍵を全部渡すようなもの。
だから最初から「悪用される前提」で、持たせる権限を最小にする。

### なぜ今必要
- AI で攻撃も速くなった。脆弱性発見から悪用まで数ヶ月 → 数時間
- エージェントは人間の確認なしで動く。騙されると機械速度で被害
- 例: メールに白文字で「このデータ外部に送れ」。人間に見えない。AI は読んで従う (プロンプトインジェクション)

### 考え方 3 つ
1. 何も信用しない。社内からでも毎回確認
2. 侵害前提で作る。防ぐより、やられても被害小さく
3. 最小権限。仕事に要る分だけ渡す

判断基準: 「面倒にするだけ」か「不可能にする」か。レート制限は面倒止まり、疲れ知らずの AI 攻撃者に効かない。「そもそも権限ない」が本物。

### 仕事で使えること

開発・AI 利用
- API キー使い回さない、永続キー避ける。短命トークン + 実行時注入 (環境変数 / Vault)。コード直書きは grep されて終わり
- AI に渡す権限を絞る。DB は読取専用、メールは送信不可。Claude Code なら `settings.json` の権限設定
- AI が外部から読んだ内容 (Web、メール、PDF) は「命令」でなく「データ」扱い
- 危険操作 (削除、送金、外部送信) は人間承認
- MCP サーバー・拡張は「知らない人のコード」扱い。入れる前に中身確認。正規サービス偽装の悪性 MCP の実例あり
- 依存パッケージ減らす。同役割のライブラリは統合。AI に lockfile 読ませれば 1 時間で洗い出せる

運用・組織
- ログを残す。「どのエージェントが、何を、いつ」を追えるように。エージェント毎に別 ID
- 設定ファイルもコード扱い。Git 管理 + レビュー
- ロールバック手順を決めて、実際に試す。試してない手順は使えない
- Shadow AI (会社に黙って AI 利用) を放置しない。先に利用ルール

### 優先順位 (効果大きい順)
1. 静的 API キーやめて短命トークン
2. エージェント権限を最小に + 危険操作は承認制
3. ログ取って異常に気付ける状態

### 補足
- Anthropic が「Claude を企業で使うなら」前提で書いた資料。Claude Code 設定項目の宣伝も混ざる。考え方は他 AI ツールにも通用
- 個人開発なら「キー直書きしない」「AI に渡す権限を絞る」の 2 点で十分

## 設計テスト: impossible, not tedious

制御は攻撃を「不可能」にするか、「面倒」にするだけか。問う。

- 面倒だけ = 無力。レート制限、非標準ポート、SMS MFA、踏み台ホップ。
- エージェント攻撃者は忍耐無限、試行コストほぼゼロ。面倒は突破される。
- 生き残る: ハードウェア束縛 credential、短命トークン、暗号 ID、そもそも経路が存在しない構成。
- 迷ったら「絞る」より「能力を消す」。

## 用語

- **blast radius** = 侵害時の被害範囲。
- **least agency** (OWASP) = 最小権限のエージェント版。ツール毎に「何を・何回・どこで」を絞る。
  - DB ツール = 読取専用。メール要約 = send/delete 権限なし。

## Part I: エージェントの特徴

- 各ステップで人間承認なし → 操られたら機械速度で被害
- ツールアクセス (MCP 含む)。MCP スタック侵害 = データ盗難・コード実行
- 解釈の曖昧さを突かれる
- セッション跨ぎの記憶 → 新しい保護対象
- マルチエージェント → 1 台侵害で横展開
- 規制: 米国は連邦機関に 2027 年までに Zero Trust 義務。NIST SP 800-207、CISA、NSA ZIG、英 NCSC、豪 Home Affairs

## Part II: 脅威

### プロンプトインジェクション
- 直接: 指示上書き、Base64 等のエンコード、敵対的サフィックス
- 間接: Web ページ・メールに命令を埋める。ユーザーに見えない。LLM は情報と指示を確実に区別できない

### ツール悪用
- 権限内の誤用はアクセス制御で防げない
- tool poisoning: MCP のメタデータ改ざん
- rug pull: 正規ツールを後から悪性版にすり替え
- tool chaining: CRM + 外部メールで顧客データ流出。信頼済みバイナリ + 正規 credential、ホスト監視に映らない
- 実例: 正規メールサービス偽装の MCP サーバーが送信メール全コピー
- ループ増幅で課金スパイク

### ID・権限悪用
- unscoped privilege inheritance: 親が全権限を子にそのまま渡す
- confused deputy: 低権限エージェントが高権限エージェントを騙して実行させる
- memory-based privilege retention: キャッシュ済み secret で権限昇格

### サプライチェーン
- PyTorch dependency confusion (SSH 鍵流出)
- 悪性 AI モデル約 100 個 (ロード時 reverse shell)
- 汚染重み。**250 文書で 600M〜13B モデルにバックドア可。安全性訓練後も残る**

### メモリ汚染
- 永続記憶に悪性命令を注入 → 以後ずっと攻撃者の目的に奉仕
- RAG 汚染、共有コンテキスト汚染
- 長期ドリフト: 1 変更ずつは無害に見えて検知困難

## Part III: 3 層フレームワーク

- **Foundation**: 最低ライン。AI 加速攻撃で引上げ済み。摩擦だけの制御は不可
- **Enterprise**: 大半の組織の目標
- **Advanced**: 高規制・高リスクはここが基準
- 各層は積み上げ。将来は Advanced → Enterprise → Foundation と降りてくる

### 層別の中身 (Foundation / Enterprise / Advanced)

| カテゴリ | Foundation | Enterprise | Advanced |
| --- | --- | --- | --- |
| ID | 暗号 ID | X.509 証明書 + ライフサイクル管理 | HSM/TPM + リモートアテステーション |
| サービス認証 | 数分期限の短命トークン (OAuth) | mTLS + 証明書ピン留め | ハードウェア束縛 credential |
| 権限モデル | RBAC (deny-by-default) | ABAC | アクション毎の継続認可 |
| 権限スコープ | 静的最小権限 | タスク毎の動的昇格 | JIT/JEA 自動失効 |
| 隔離 | ID 基盤隔離 (NW 分割は補助) | コンテナ + gVisor | AMD SEV / Intel TDX / microVM |
| 監査ログ | 全ツール呼出記録 | 追記専用 + 完全性検証 | SIEM ストリーミング |
| トレース | リクエスト ID | OpenTelemetry 分散トレース | 完全な来歴チェーン |
| ベースライン | 手動定義 | 自動学習 | ドリフト検知付き継続更新 |
| 異常検知 | 閾値 + 自動一次トリアージ | 統計的 | ML |
| 自動対応 | トリアージエージェントが一次判断 | セッション停止・認証失効 | SOAR プレイブック |
| 入力検証 | スキーマ・長さ | 既知パターンフィルタ | Constitutional classifiers + spotlighting |
| 出力制御 | PII・credential スキャン | 意味解析 | 高リスク行為は人間承認 |
| 設定整合性 | Git 管理 | 署名付き設定 | イミュータブルイメージ + アテステーション |
| 復旧 | 文書化ロールバック | ヘルスチェック付き自動ロールバック | 自己修復 |
| ガバナンス | 利用ポリシー・Shadow AI 対策 | 部門横断 AI 委員会 | パイプライン組込みの自動ポリシー検査 |

### 強い主張
- 静的 API キーは Foundation でも不可。ローテーション付きでも「既知のギャップ」。grep で取れる credential は回してもコスト上がらない
- サンドボックスは信頼できない入力を扱うなら必須
- 自動化するのは記録・調査の雑務。封じ込め・開示・顧客対応の判断は人間
- 署名済み更新は自動適用、未署名は拒否。手動承認の遅延が今の主リスク
- 計測は dwell time (異常→人間が認知) と coverage (調査されたアラート割合) を最初に

## Part IV: 8 フェーズ実装

1. **要件整理**: 規制・目的・制約。関係者合意
2. **サプライチェーン**
   - AI-BOM (OWASP CycloneDX ML-BOM)
   - 全段階の暗号署名 + 実行時検証
   - ベンダー評価。FOSS もコードを見る
   - OpenSSF Scorecard で依存を自動採点
   - 依存の重複を frontier model で監査 (1 時間作業)
   - 到達可能性解析で修正対象を絞る
   - AI vendoring: 放置された小依存は必要部分だけ AI に再実装させる
   - MCP サーバーは検証後に自前ホスト + 自分で署名
3. **境界定義**: 承認・禁止アクション明文化、エスカレーション条件、スコープ制限
   - エージェント分割しても credential 共有なら分離にならない。各自に固有 ID・固有 credential
   - 封じ込め計画が摩擦頼みなら失敗する前提
4. **インジェクション対策**
   - 入力隔離。Microsoft の Spotlighting で間接注入成功率 50% 超 → 2% 未満
   - Constitutional classifiers で jailbreak 95% 遮断
   - 攻撃面の縮小 (触れる人・物を絞る)
5. **ツールアクセス**
   - allow-list (deny-by-default)。ツール側でも認証 (証明書 or ID 束縛の短命トークン)
   - 機能制限 (メールは読取のみ等)
   - 引数検証。エージェント側とツール側の両方
   - サンドボックス、サーキットブレーカー。レート制限は摩擦に過ぎない
   - 高リスク呼出は人間承認
6. **credential 保護**
   - 静的キー・埋込・共有 service account は侵害済み扱い
   - インスタンス毎に固有 credential。実行時注入 (Vault 等)
   - マルチエージェントは委譲を毎ステップ認可
   - JIT / ABAC は難しいが強力。部分導入でも価値あり
   - 人間認証は FIDO2/パスキー。SMS は不可
7. **メモリ保護**
   - セッション・ユーザー隔離
   - 取得毎に完全性検証 (ハッシュは別ログ、出典タグ付け)
   - TTL、バージョン管理 + 隔離 + ロールバック
8. **計測**: dwell time、coverage、検知速度 (重要系は 1 時間以内)、説明可能性、挙動ドリフト
   - 問い: エージェントが暴走したら 1 時間以内に気付けるか?

## Part V: 防御運用

- 人間は雑務から決断へ。証拠収集・相関・文書化を自動化、封じ込め・開示・顧客対応は人間
- アラートキュー先頭にモデル。全アラートに自動一次調査 (SIEM 読取専用)
- 導入手順: 誤検知多い 1 ルール選ぶ → 読取専用でモデル接続、構造化判定を出させる → 2 週間人間と一致率比較 → 許容なら次へ。一気に全自動化しない
- Agentic SOAR: プレイブック外の新事象にも適応。隔離、動的アクセス制御、セッション停止、認証失効を数秒で
- MITRE ATT&CK で検知カバレッジ可視化 (横移動・資格情報アクセス優先)。Atomic Red Team で 1 日検証
- 机上演習は「同週に CVE 5 件」で。緊急変更手順は事前合意。2 週間の変更承認サイクルはそれ自体がリスク
- 防御エージェントにも Zero Trust (最小権限、堅牢環境、高影響は人間承認、ログ・レビュー)

## Claude Code 対応 (pro-tip まとめ)

- 権限: deny-by-default、`settings.json` (`ask` 等)、managed settings、`allowManagedPermissionRulesOnly`
- 隔離: OS レベルの FS / ネットワーク sandbox、書込はプロジェクトディレクトリに限定
- hooks: `PreToolUse` で引数検証、`ConfigChange` で設定変更の監査・遮断
- 観測: OpenTelemetry メトリクス、`session.id` / `user.account_uuid` / `organization.id` を全イベントに付与
- credential: OS credential store、`apiKeyHelper` で外部 Vault から取得、MCP は OAuth 2.0 + 自動更新
- 入力: コマンドインジェクション検知、curl/wget はデフォルトブロック、Web 内容は別コンテキストで処理、外部通信は承認制
- サブエージェント: 親と同等権限まで持てる。外部から見て区別は OTel / JSONL transcript のみ
- 記憶: セッション隔離がデフォルト、`cleanupPeriodDays`、checkpoint で `/rewind`

## まとめ

- Foundation 底上げ: 短命トークン、暗号 ID、ID 基盤隔離、自動一次トリアージが入口要件
- 基本が強い組織 = AI スキャンで見つかるバグが元から少ない。侵害前提でエージェントを設計
- 規制 (HIPAA / FINRA / GDPR / FedRAMP / EU AI Act) は Zero Trust と整合
- 関連: ブログ「Preparing your security program for AI-accelerated offense」
