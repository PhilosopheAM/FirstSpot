import urllib.request
import json
import os
from datetime import datetime, timedelta
import random

def fetch_and_save_moutai_data():
    print("Generating mock Moutai (600519) daily data...")
    
    data = []
    current_date = datetime(2025, 1, 1)
    end_date = datetime(2026, 4, 28)
    
    base_price = 1650.0
    
    while current_date <= end_date:
        if current_date.weekday() < 5: # Monday to Friday
            # Random walk
            change = random.uniform(-0.02, 0.02)
            open_price = base_price * (1 + random.uniform(-0.005, 0.005))
            close_price = base_price * (1 + change)
            high_price = max(open_price, close_price) * (1 + random.uniform(0, 0.01))
            low_price = min(open_price, close_price) * (1 - random.uniform(0, 0.01))
            
            data.append({
                "date": current_date.strftime("%Y-%m-%d"),
                "open": round(open_price, 2),
                "close": round(close_price, 2),
                "high": round(high_price, 2),
                "low": round(low_price, 2),
                "volume": random.randint(10000, 50000),
                "amount": random.randint(10000000, 50000000)
            })
            base_price = close_price
            
        current_date += timedelta(days=1)
    
    # Save to mock data folder
    os.makedirs("testapp/assets/mock_data", exist_ok=True)
    with open("testapp/assets/mock_data/600519_daily.json", "w", encoding="utf-8") as f:
        json.dump({"symbol": "600519", "data": data}, f, ensure_ascii=False, indent=2)
    print("Saved to testapp/assets/mock_data/600519_daily.json")

if __name__ == "__main__":
    fetch_and_save_moutai_data()