'''[3] % of CVEs with EPSS > threshold
Threshold       % above
------------------------
0.00            100.00%
0.05             10.10%
0.10              6.81%
0.15              5.30%
0.20              4.40%
0.25              3.72%
0.30              3.25%
0.35              2.88%
0.40              2.59%
0.45              2.34%
0.50              2.12%
0.55              1.91%
0.60              1.70%
0.65              1.51%
0.70              1.31%
0.75              1.11%
0.80              0.87%
0.85              0.63%
0.90              0.40%
0.95              0.00%
1.00              0.00%
------------------------'''

import requests

BASE_URL = "https://api.first.org/data/v1/epss"


def fetch_all():
    offset = 0
    limit = 10000
    rows = []

    while True:
        url = f"{BASE_URL}?limit={limit}&offset={offset}"
        print(f"Fetching offset={offset}")

        r = requests.get(url, timeout=120)
        r.raise_for_status()

        data = r.json().get("data", [])
        if not data:
            break

        rows.extend(data)

        print(f"  got {len(data)} rows (total={len(rows)})")

        if len(data) < limit:
            break

        offset += limit

    return rows


def main():
    print("[1] Downloading EPSS data")
    rows = fetch_all()

    print(f"[2] Total CVEs: {len(rows):,}")

    epss_values = [float(r["epss"]) for r in rows]
    total = len(epss_values)

    print("\n[3] % of CVEs with EPSS > threshold\n")
    print(f"{'Threshold':<12} {'% above':>10}")
    print("-" * 24)

    thresholds = [i * 0.05 for i in range(21)]  # 0.00 to 1.00

    for x in thresholds:
        above = sum(v > x for v in epss_values)
        pct = (above / total * 100) if total else 0

        print(f"{x:<12.2f} {pct:>9.2f}%")

    print("-" * 24)


if __name__ == "__main__":
    main()
