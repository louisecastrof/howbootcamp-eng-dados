from abc import ABC, abstractmethod
import datetime
import json
from typing import List

import requests
import logging

#print(requests.get("https://www.mercadobitcoin.net/api/BTC/day-summary/2021/6/22").json())
logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

class MercadoBitcoinApi(ABC):

    def __init__(self, coin: str) -> None:
        self.coin = coin
        self.base_endpoint = "https://www.mercadobitcoin.net/api"

    @abstractmethod
    def _get_endpoint(self, **kwargs) -> str:
        #return f"{self.base_endpoint}/{self.coin}/day-summary/2021/6/21"
        pass

    def get_data(self, **kwargs) -> dict:
        endpoint = self._get_endpoint(**kwargs)
        logger.info(f"Getting data from endpoint: {endpoint}")
        response = requests.get(endpoint)
        response.raise_for_status()
        return response.json()



# print(MercadoBitcoinApi(coin='BTC').get_data())

# print(MercadoBitcoinApi(coin='LTC').get_data())
# class BTCApi(MercadoBitcoinApi):
#     def _get_endpoint(self) -> str:
#         return "a"

# BTCApi(coin='BTC')

class DaySummaryApi(MercadoBitcoinApi):
    type = 'day-summary'

    def _get_endpoint(self, date: datetime.date) -> str:
        return f"{self.base_endpoint}/{self.coin}/{self.type}/{date.year}/{date.month}/{date.day}"

# print(DaySummaryApi(coin='BTC').get_data(date=datetime.date(2021, 6, 21)))

class TradesApi(MercadoBitcoinApi):
    type = "trades"

    def _get_unix_epoch(self, date: datetime.datetime) -> int:
        return int(date.timestamp())

    def _get_endpoint(self, date_from: datetime.datetime = None, date_to: datetime.datetime = None) -> str:

        if date_from and not date_to:
            unix_date_from = self._get_unix_epoch(date_from)
            endpoint = f'{self.base_endpoint}/{self.coin}/{self.type}/{unix_date_from}'

        elif date_from and date_to:
            unix_date_from = self._get_unix_epoch(date_from)
            unix_date_to = self._get_unix_epoch(date_to)
            endpoint = f'{self.base_endpoint}/{self.coin}/{self.type}/{unix_date_from}/{unix_date_to}'

        else: 
            endpoint = f'{self.base_endpoint}/{self.coin}/{self.type}'

        return endpoint

# print(TradesApi("BTC").get_data())
# print(TradesApi("BTC").get_data(date_from=datetime.datetime(2021, 6, 2)))
# print(TradesApi("BTC").get_data(date_from=datetime.datetime(2021, 6, 2), date_to=datetime.datetime(2021, 6, 3)))

class DataTypeNotSupportedForIngestionException(Exception):
    def __init__(self, data):
        self.data = data
        self.message = f"Data type {type(data)} is not supported for ingestion"
        super().__init__(self.message)

class DataWriter:

    def __init__(self, filename: str) -> None:
        self.filename = filename

    def _write_row(self, row: str) -> None:
        with open(self.filename, "a") as f:
            f.write(row)

    def write(self, data: [List, dict]) -> None:
        if isinstance(data, dict):
            self._write_row(json.dumps(data) + '\n')
        elif isinstance(data, List):
            for element in data:
                self.write(element)
        else:
            raise DataTypeNotSupportedForIngestionException(data)

    

data = DaySummaryApi("BTC").get_data(date=datetime.date(2021, 6, 20))
writer = DataWriter('day_summary.json')
writer.write(data)

data = TradesApi("BTC").get_data()
writer = DataWriter('trades.json')
writer.write(data)

