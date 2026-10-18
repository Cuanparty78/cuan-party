#!/usr/bin/env python3
"""Fail CI if ZEGO libraries or reflection-called Java methods are stripped.

This is a packaging check, not a substitute for voice testing on a device.
DEX layout: https://source.android.com/docs/core/runtime/dex-format
"""
import argparse
import re
import struct
import sys
import zipfile


def dex_methods(data):
    if not data.startswith(b"dex\n") or data[7] != 0:
        raise ValueError("Invalid DEX header")

    def uint(offset):
        return struct.unpack_from("<I", data, offset)[0]

    def uleb(offset):
        value = 0
        for shift in range(0, 35, 7):
            byte = data[offset]
            offset += 1
            value |= (byte & 127) << shift
            if byte < 128:
                return value, offset
        raise ValueError("Invalid ULEB128")

    strings = []
    for i in range(uint(56)):
        offset = uint(uint(60) + 4 * i)
        _, offset = uleb(offset)
        end = data.index(b"\0", offset)
        # The identifiers checked below are ASCII; other MUTF-8 strings need
        # not be interpreted by this verifier.
        strings.append(data[offset:end].decode("utf-8", errors="replace"))
    types = [strings[uint(uint(68) + 4 * i)] for i in range(uint(64))]
    method_ids = []
    for i in range(uint(88)):
        owner, _, name = struct.unpack_from("<HHI", data, uint(92) + 8 * i)
        method_ids.append((types[owner], strings[name]))
    defined = set()
    for i in range(uint(96)):
        offset = uint(uint(100) + 32 * i + 24)
        if not offset:
            continue
        counts = []
        for _ in range(4):
            count, offset = uleb(offset)
            counts.append(count)
        for _ in range(counts[0] + counts[1]):
            _, offset = uleb(offset)
            _, offset = uleb(offset)
        for count in counts[2:]:
            index = 0
            for _ in range(count):
                delta, offset = uleb(offset)
                index += delta
                _, offset = uleb(offset)
                _, offset = uleb(offset)
                defined.add(method_ids[index])
    return defined


def verify(path):
    with zipfile.ZipFile(path) as apk:
        names = set(apk.namelist())
        for abi in ("arm64-v8a", "armeabi-v7a"):
            name = f"lib/{abi}/libZegoExpressEngine.so"
            if name not in names or apk.getinfo(name).file_size == 0:
                raise ValueError(f"Missing ZEGO native library: {name}")
        dex_files = sorted(n for n in names if re.fullmatch(r"classes(?:\d+)?\.dex", n))
        if not dex_files:
            raise ValueError("No DEX files in APK")
        methods = set()
        for name in dex_files:
            methods.update(dex_methods(apk.read(name)))
        owner = "Lim/zego/zego_express_engine/internal/ZegoExpressEngineMethodHandler;"
        required = ("createEngineWithProfile", "loginRoom", "logoutRoom",
                    "startPublishingStream", "startPlayingStream", "muteMicrophone")
        missing = [name for name in required if (owner, name) not in methods]
        if missing:
            raise ValueError("ZEGO reflection methods missing: " + ", ".join(missing))
    print("ZEGO APK packaging verified: ARM libraries and reflection methods retained.")
    print("Device voice testing is still required.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("apk")
    args = parser.parse_args()
    try:
        verify(args.apk)
    except (ValueError, OSError, zipfile.BadZipFile, IndexError, struct.error) as error:
        print(f"ZEGO APK verification failed: {error}", file=sys.stderr)
        sys.exit(1)
