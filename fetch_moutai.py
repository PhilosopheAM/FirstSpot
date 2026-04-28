import akshare as ak
import json
import os

def fetch_and_save_moutai_data():
    print("Fetching Moutai (600519) daily data...")
    # Fetch daily data for Moutai
    df = ak.stock_zh_a_hist(symbol="600519", period="daily", start_date="20250101", end_date="20260428", adjust="qfq")
    
    # Convert to list of dicts
    data = []
    for _, row in df.iterrows():
        data.append({
            "date": str(row["日期"]),
            "open": float(row["开盘"]),
            "close": float(row["收盘"]),
            "high": float(row["最高"]),
            "low": float(row["最低"]),
            "volume": float(row["成交量"]),
            "amount": float(row["成交额"])
        })
    
    # Save to mock data folder
    os.makedirs("testapp/assets/mock_data", exist_ok=True)
    with open("testapp/assets/mock_data/600519_daily.json", "w", encoding="utf-8") as f:
        json.dump({"symbol": "600519", "data": data}, f, ensure_ascii=False, indent=2)
    print("Saved to testapp/assets/mock_data/600519_daily.json")

if __name__ == "__main__":
    fetch_and_save_moutai_data()
