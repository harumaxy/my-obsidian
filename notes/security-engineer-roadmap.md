---
title: セキュリティエンジニア 学習ロードマップ
description: Web出身者がセキュリティエンジニア(AppSec)になる最短ルート。教材、資格、2025-2026年のベストプラクティス
# permalink:  # don't use
aliases:
  - security-engineer-roadmap
tags:
  - security
  - appsec
  - roadmap
draft: false
date: 2026-10-10
---

## きっかけ

しまぶーのIT大学の動画。情報漏えい多発 → セキュリティ予算増 → セキュリティエンジニア需要増、という話。
原因は攻撃側が AI で攻撃力アップ。防御側は変わらない。

## セキュリティエンジニアとは

- Web エンジニアの延長で入れる。でも守る対象は Web だけではない
  - 社内ネットワーク、端末、IoT、組み込み、OT、クラウド設定、サプライチェーン
- 職種というより横断領域。だから学習パス曖昧
- 主な職種
  - AppSec: Web 出身の最短。コードレビュー、診断、セキュア設計
  - 脆弱性診断 / ペンテスター: 攻撃者視点。診断会社が入口
  - クラウド / インフラセキュリティ: IAM、ネットワーク分離、シークレット管理
  - SOC / CSIRT: 監視、ログ分析、インシデント対応
  - 研究 / マルウェア解析: 低レイヤ寄り、難しい

## 名乗って良い基準

公式ライン無し。目安:
- 脆弱性の原因を自分で再現して説明できる
- リスクの大きさと現実的な修正案を出せる
- 診断 / レビューを一人で回して結果に責任持てる

「XSS 知ってる」では足りない。「攻撃者はこう動く、だからここ直す」まで言えたら OK。

## AI にやらせればよくない？

半分正解。AI が検出・下書き、人間が判断・承認。

- AI 任せにできない理由
  - 責任の所在。「AI が大丈夫と言った」は通らない
  - ビジネスロジックの穴(他人の注文が見える、割引二重適用)は仕様を知る人間じゃないと気づきにくい
  - 自信満々に「安全です」と言う。検証できないと信じるしかない
  - 攻撃側も AI 使う
  - AI エージェント自体が新しい攻撃面(プロンプトインジェクション、シークレット漏洩、権限過大)
- 価値の中心が「ツールを回す作業」から「AI の出力を見抜く目」に移る
- 基礎を知らないと AI の「問題なし」を疑えない

## 最短ルート

1. 土台: 徳丸本 + PortSwigger Academy を並行
2. 実践: Juice Shop、HTB / TryHackMe
3. 広げる: クラウド、API、脅威モデリング、AI エージェント
4. 証明: BSCP、必要なら支援士

前提知識: HTTP、認証認可(OAuth, JWT, session)、暗号基礎(TLS, ハッシュ, 署名)、Linux、TCP/IP, DNS

## 教材

### 無料

- PortSwigger Web Security Academy
  - 無料。解説とラボ一体。最優先
- OWASP
  - Top 10: 全体像
  - Cheat Sheet Series: 防御の実装リファレンス
  - WSTG: 診断手順書
  - ASVS: 検証基準
- IPA「安全なウェブサイトの作り方」: 日本語公式。無料

### GitHub

- `juice-shop/juice-shop`: 脆弱 Web アプリ。攻撃練習の定番
- `digininja/DVWA`: 古典的な脆弱アプリ
- `OWASP/CheatSheetSeries`: 防御知識
- `OWASP/wstg`: 診断手順
- `swisskyrepo/PayloadsAllTheThings`: ペイロード辞書
- `HackTricks-wiki/hacktricks`: ペンテスト手法総覧
- `enaqx/awesome-pentest`, `sbilly/awesome-security`: リンク集

### YouTube

- The Cyber Mentor: Practical Ethical Hacking 長尺講座が無料。crash course 枠
- IppSec: HTB 解説。攻撃者の思考
- LiveOverflow: 深掘り、低レイヤ
- PwnFunction: 脆弱性アニメ解説。入口向き

### 書籍

(版・O'Reilly 上の有無は未検証)

- 体系的に学ぶ 安全なWebアプリケーションの作り方(徳丸本): 日本語必読
  - 第2版は2018年刊。第3版は執筆中(8年ぶり改訂)、発売日未定
  - 第3版の新章予定: セキュリティ要件、ブラウザセキュリティ(SOP, CORS, CSP)、レースコンディション、HTTP リクエストスマグリング
  - 第2版で始めてよい。第3版出たら乗り換え
- Web Security for Developers (Malcolm McDonald, No Starch): 開発者視点の入門
- Bug Bounty Bootcamp (Vickie Li, No Starch): 診断手順
- Real-World Bug Hunting (Peter Yaworski): 実例集
- Threat Modeling (Adam Shostack): 設計段階の防御。AI レビュー時代に価値上がる
- Container Security (Liz Rice, O'Reilly): クラウド / コンテナに広げる段階
- Security Engineering (Ross Anderson): 体系書。辞書扱い。著者サイトで無料公開
- Web Application Hacker's Handbook は古い。優先度低

### 練習環境

- Hack The Box / TryHackMe(最初は THM が易しい)
- picoCTF: 無料 CTF 入門
- Juice Shop + Burp Suite Community を手元で

## 資格の判断

- BSCP(Burp Suite Certified Practitioner): 価値高い。最初に取る
  - 受験料 99 ドル/回。購入後 12 ヶ月有効
  - Burp Suite Professional のサブスクが別途必要(Community では不可)
  - 実技試験で Web 診断スキルをそのまま証明
- 情報処理安全確保支援士: 日本の転職 / 案件で効く。名称独占
  - 実務スキル証明は弱い
  - 年1回のオンライン講習 2万円(非課税、6時間、2026年度 IPA 資料)
  - 初年度登録費用 約2.75万円(民間ブログ試算、IPA 公式値ではない)
  - 3年ごとの実践講習・更新料は未確認
  - SIer / コンサル狙いなら取る。AppSec で実力勝負なら後回し
- OSCP: ペンテスト国際資格。費用 20万円以上、難しい。AppSec には過剰
- CISSP: 管理職寄り、実務経験要件あり。今は不要
- CEH: 知名度あるが技術評価は低め
- Security+: 基礎体系化。日本では知名度低い
- AWS Security Specialty: クラウドセキュリティに進むなら価値あり

## 2025-2026 ベストプラクティス

### OWASP Top 10:2025 (確認済み)

1. Broken Access Control
2. Security Misconfiguration
3. Software Supply Chain Failures (新設)
4. Cryptographic Failures
5. Injection
6. Insecure Design
7. Authentication Failures
8. Software or Data Integrity Failures
9. Security Logging and Alerting Failures
10. Mishandling of Exceptional Conditions (新設)

- 公式解説文はプレビュー段階
- 2021年版前提の記事は古い。サプライチェーンが3位に

### OWASP ASVS 5.0.0

- 2025-05-30 リリース。約350要件 / 17章(v4 は 286要件 / 14章)
- フロントエンドセキュリティ、セルフコンテインドトークン(JWT等)に専用節
- パスワード規定は NIST SP 800-63 に整合
- v4 紹介記事は古い

### 実践項目

(Top 10 以外は二次情報。実装前に MDN / npm docs / W3C で裏取り)

- 認可: deny by default、サーバ側で毎回検証。IDOR とビジネスロジック不備は AI が見逃しやすい
- サプライチェーン: 依存ピン留め、署名 / provenance 検証、SBOM(SPDX / CycloneDX)、SLSA。`npm audit signatures`
- 認証: パスキー(FIDO2 / WebAuthn)優先。SMS OTP は復旧用のみ
- ブラウザ防御
  - strict CSP + Report-Only で段階導入
  - Trusted Types で DOM-XSS 対策(Baseline 化の時期は要確認)
  - SRI、HSTS、`nosniff`、Permissions-Policy
- 例外処理: fail-closed
- AI 生成コード
  - SAST、依存スキャン、シークレットスキャンを CI に入れる
  - 全コード人間レビューは崩れる。ガードレールを自動化、人間は認可と設計に集中
  - 「AI 生成コード通過率55%」は出典未検証。傾向としてのみ扱う
- AI エージェント自体のセキュリティ
  - OWASP Top 10 for Agentic Applications 2026(2025-12-09 公開、ASI01〜ASI10)
  - OWASP LLM Top 10 とセットで読む。MCP やエージェント基盤使うなら両方適用
  - AI エージェントにシークレットを渡さない

## 限界

- 二次情報の数値(通過率、Trusted Types 対応状況)は未検証
- 書籍の実在・O'Reilly 上の有無は未確認
- 求人市場の需要は裏取りしていない

## 参考

- [OWASP Top 10:2025 日本語](https://owasp.org/Top10/2025/ja/)
- [OWASP Top 10 2025 (Fastly)](https://www.fastly.com/blog/new-2025-owasp-top-10-list-what-changed-what-you-need-to-know)
- [OWASP Top 10: Broken access control still tops (The Register)](https://www.theregister.com/2025/11/11/new_owasp_top_ten_broken/)
- [What's new in ASVS 5.0 (SoftwareMill)](https://softwaremill.com/whats-new-in-asvs-5-0/)
- [OWASP ASVS project](https://owasp.org/projects/asvs?tab=main)
- [OWASP Top 10 for Agentic Applications 2026](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026)
- [徳丸本 第3版 解説 (@IT)](https://atmarkit.itmedia.co.jp/ait/articles/2608/28/news018.html)
- [BSCP FAQ (PortSwigger)](https://portswigger.net/web-security/certification/frequently-asked-questions)
- [IPA 2026年度オンライン講習](https://www.ipa.go.jp/jinzai/riss/rcu1hd000000n7ob-att/online_2026.pdf)
- [登録費用の試算 (kotora.jp)](https://www.kotora.jp/c/147055-2/)
- [Front-End Security Best Practices 2026 (CloudSEK)](https://www.cloudsek.com/knowledge-base/front-end-security-best-practices)
- [AppSec 2026 動向 (SecureFlag)](https://blog.secureflag.com/2026/01/27/whats-next-for-application-security/)
- 元動画: https://www.youtube.com/watch?v=RfX62ntECx4 (しまぶーのIT大学)
