#!/usr/bin/env python3
"""Zenn / Qiita の人気記事を日次スナップショット保存する。cron 想定。

data/YYYY-MM-DD.json に保存。同日再実行は上書き。
"""
import datetime as dt
import json
import pathlib
import urllib.parse
import urllib.request

OUT = pathlib.Path(__file__).parent / "data"
UA = {"User-Agent": "my-obsidian-trend-archive"}


def get(url):
    with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=30) as r:
        return json.load(r)


def zenn():
    # order=daily が zenn.dev のトレンド順
    arts = get("https://zenn.dev/api/articles?order=daily&count=30")["articles"]
    return [
        {
            "title": a["title"],
            "url": "https://zenn.dev" + a["path"],
            "likes": a["liked_count"],
            "published_at": a["published_at"],
        }
        for a in arts
    ]


def qiita():
    # 公式APIにトレンド無し。直近3日 + stocks>=10 を likes 降順で代用
    since = (dt.date.today() - dt.timedelta(days=3)).isoformat()
    q = urllib.parse.quote(f"created:>={since} stocks:>=10")
    items = get(f"https://qiita.com/api/v2/items?per_page=100&query={q}")
    items.sort(key=lambda i: -i["likes_count"])
    return [
        {
            "title": i["title"],
            "url": i["url"],
            "likes": i["likes_count"],
            "published_at": i["created_at"],
        }
        for i in items[:30]
    ]


if __name__ == "__main__":
    OUT.mkdir(exist_ok=True)
    snap = {}
    for name, fn in (("zenn", zenn), ("qiita", qiita)):
        try:
            snap[name] = fn()
        except Exception as e:  # 片方落ちてももう片方は保存
            snap[name] = {"error": repr(e)}
    path = OUT / f"{dt.date.today().isoformat()}.json"
    path.write_text(json.dumps(snap, ensure_ascii=False, indent=1))
    print(path)
