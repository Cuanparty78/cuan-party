#!/usr/bin/env python3
"""Patch large generated UI in CI until it is split into maintainable files."""
from pathlib import Path

path = Path("lib/luxury_app.dart")
source = path.read_text(encoding="utf-8")
old = """                                      error is FirebaseFunctionsException && error.code == 'not-found'
                                        ? 'Pengiriman gift membutuhkan Firebase Cloud Functions aktif. Coin tidak dipotong.'
                                        : error is FirebaseFunctionsException
                                          ? error.message ?? 'Gift gagal dikirim. Coba kembali.'
                                          : 'Koneksi terputus. Coba kirim gift kembali.');"""
new = """                                      error is GiftBackendException
                                        ? error.message
                                        : error is FirebaseFunctionsException
                                          ? error.message ?? 'Gift gagal dikirim. Coba kembali.'
                                          : 'Gagal menghubungi backend. Periksa status gift sebelum mengulang.');"""
assert source.count(old) == 1, "Gift UI error handler changed: investigate before build"
path.write_text(source.replace(old, new, 1), encoding="utf-8")
print("Cloudflare gift errors will be shown to users; mock coin transfer stays disabled.")
