import os
from unittest import mock
import pytest

from .. import helloworld


@pytest.fixture
def client():
    helloworld.application.config['TESTING'] = True
    client = helloworld.application.test_client()
    yield client


def test_home_200_pod_ip_not_availabe(client):
    """Test home page returns a 200"""
    home = client.get('/')
    assert b'Hello World!' in home.data
    assert b'Not Available' in home.data


@mock.patch.dict(os.environ, {
    'POD_IP': '127.0.0.1', 'POD_NAME': 'foo', 'POD_NAMESPACE': 'bar'})
def test_home_200_pod_ip_availabe(client):
    """Test home page returns a 200 with pod IP if available"""
    home = client.get('/')
    assert b'Hello World!' in home.data
    assert b'127.0.0.1' in home.data
    assert b'foo' in home.data
    assert b'bar' in home.data


def test_health_200(client):
    """Test health page returns a 200
    """
    health = client.get('/health')
    assert b'200 OK!' in health.data
