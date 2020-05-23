import logging
import os

import pytest
from pytest import fixture
from selenium import webdriver as driver
from selenium.webdriver.chrome.options import Options

from test_cases.config import Config


@fixture(scope='function')
def browser(headless):
    chrome_options = Options()
    if headless:
        chrome_options.add_argument("--headless")
        chrome_options.add_argument("--disable-gpu")
        chrome_options.add_argument("--no-sandbox")
    brow = driver.Chrome(chrome_options=chrome_options)
    yield brow
    brow.quit()


# Disables extraneous logging during test run
@fixture(scope='session', autouse=True)
def disable_logging(request):
    logging.disable(logging.CRITICAL)

    def teardown():
        logging.disable(logging.NOTSET)

    request.addfinalizer(teardown)


# Exposing these values through fixtures results in cleaner, more readable code
@fixture
def headless(request):
    return request.config.getoption("--headless")


@fixture(scope='session')
def env(request):
    return request.config.getoption("--env")


@fixture
def test_config(env):
    """Generates a Config object and adds run-time credentials to avoid persisting sensitive data"""
    
    config = Config(env)
    return config
