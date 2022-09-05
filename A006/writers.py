import datetime
import json
import os
from typing import List

class DataTypeNotSupportedForIngestionException(Exception):
    def __init__(self, data):
        self.data = data
        self.message = f"Data type {type(data)} is not supported for ingestion"
        super().__init__(self.message)

class DataWriter:

    def __init__(self, coin: str, api: str) -> None:
        self.api = api
        self.coin = coin
        now = datetime.datetime.now()
        current_time = now.strftime("%H_%M_%S")
        self.filename = f"{self.api}/{self.coin}/{str(datetime.datetime.now().date()) + current_time}.json"

    def _write_row(self, row: str) -> None:
        os.makedirs(os.path.dirname(self.filename), exist_ok=True)
        with open(self.filename, "a") as f:
            f.write(row)

    def write(self, data: [List, dict]):
        if isinstance(data, dict):
            self._write_row(json.dumps(data) + "\n")
        elif isinstance(data, List):
            for element in data:
                self.write(element)
        else:
            raise DataTypeNotSupportedForIngestionException(data)

    

# data = DaySummaryApi("BTC").get_data(date=datetime.date(2021, 6, 20))
# writer = DataWriter('day_summary.json')
# writer.write(data)

# data = TradesApi("BTC").get_data()
# writer = DataWriter('trades.json')
# writer.write(data)
