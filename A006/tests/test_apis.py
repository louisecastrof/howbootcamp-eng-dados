import datetime
import pytest
from apis import DaySummaryApi, TradesApi

class TestDaySummaryApi:
    @pytest.mark.parametrize(
        "coin, date, expected",
        [
            ("BTC", datetime.date(2021, 6, 21), "https://www.mercadobitcoin.net/api/BTC/day-summary/2021/6/21"),
            ("ETH", datetime.date(2021, 6, 21), "https://www.mercadobitcoin.net/api/ETH/day-summary/2021/6/21"),
            ("ETH", datetime.date(2019, 1, 2), "https://www.mercadobitcoin.net/api/ETH/day-summary/2019/1/2")
        ]
    )
    def test_get_endpoint(self, coin, date, expected):
        api = DaySummaryApi(coin=coin)
        actual = api._get_endpoint(date=date)
        assert actual == expected

class TestTradesApi:
    @pytest.mark.parametrize(
        "coin, date_from, date_to, expected",
        [ 
            ("TEST", datetime.datetime(2019, 1, 1), datetime.datetime(2019, 1, 2), "https://www.mercadobitcoin.net/api/TEST/trades/1546300800/1546387200")
        ]
    )
    def test_get_endpoint(self, coin, date_from, date_to, expected):
        actual = TradesApi(coin=coin)._get_endpoint(date_from=date_from, date_to=date_to)
        assert actual == expected

    @pytest.mark.parametrize(
        "date, expected",
        [ 
            #sistema do linux com timezone diferente, validar o timezone do pc antes de colocar 1546308000
            (datetime.datetime(2019, 1, 1), 1546300800),
            (datetime.datetime(2019, 1, 2), 1546387200),
            (datetime.datetime(2021, 6, 12), 1623456000),
            (datetime.datetime(2021, 6, 12, 0, 0, 5), 1623456005),
            (datetime.datetime(2019, 6, 15), 1560556800)
        ]
    )
    def test_get_unix_epoch(self, date, expected):
        # actual = TradesApi(coin='TEST')._get_unix_epoch(date)
        actual = datetime.datetime(2019, 1, 1).timestamp()
        assert actual == expected
