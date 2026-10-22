import subprocess
import sys
from pathlib import Path

import pytest
import truststore

from typesafe_sdk._core.client.aio import client as aio_client

# Stresses `wrap_bio()` on the default async client's shared SSL context from many threads, as AnyIO does
# during concurrent TLS setup. Unlocked context configuration aborts the interpreter natively, so the
# stress runs in a subprocess. See https://github.com/typesafe-ai/typesafe-sdk-python/issues/20.
_STRESS = """
import ssl
import threading

from typesafe_sdk import AsyncTypeSafeClient

ctx = AsyncTypeSafeClient(api_key="test")._http_client._transport._pool._ssl_context


def worker():
    for _ in range(300):
        ctx.wrap_bio(ssl.MemoryBIO(), ssl.MemoryBIO(), server_hostname="api.typesafe.ai")


threads = [threading.Thread(target=worker) for _ in range(16)]
for thread in threads:
    thread.start()
for thread in threads:
    thread.join()
"""


def test_default_async_ssl_context_survives_concurrent_wrap_bio() -> None:
    for _ in range(3):
        result = subprocess.run(  # noqa: S603 - Fixed interpreter and test-owned script.
            [sys.executable, "-X", "faulthandler", "-c", _STRESS], capture_output=True, text=True, check=False
        )
        assert result.returncode == 0, result.stderr


@pytest.mark.parametrize("truststore_version,locked", [("0.10.4", True), ("0.10.5", False), ("0.11.0", False)])
def test_wrap_bio_lock_only_on_affected_truststore(monkeypatch: pytest.MonkeyPatch, truststore_version: str, locked: bool) -> None:
    monkeypatch.setattr(truststore, "__version__", truststore_version)
    assert ("wrap_bio" in vars(aio_client._ssl_context())) is locked


def test_wrap_bio_lock_skipped_for_stdlib_context(monkeypatch: pytest.MonkeyPatch, tmp_path: Path) -> None:
    monkeypatch.setenv("SSL_CERT_DIR", str(tmp_path))
    monkeypatch.setattr(truststore, "__version__", "0.10.4")
    assert "wrap_bio" not in vars(aio_client._ssl_context())
