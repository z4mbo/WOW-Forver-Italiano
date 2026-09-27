"""Upload a reviewed beta ZIP to an existing CurseForge WoW project.

Requires the project's numeric ID and an author API token in the
CURSEFORGE_API_TOKEN environment variable. The token is never written to disk
or printed. See the official CurseForge Upload API documentation.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import sys
import urllib.error
import urllib.request
import uuid


ROOT = Path(__file__).resolve().parents[1]
VERSION = "0.5.0-beta"
ZIP = ROOT / "dist" / f"WOWForverItaliano-{VERSION}.zip"
CHANGELOG = ROOT / "docs" / f"curseforge-changelog-{VERSION.removesuffix('-beta')}.it.md"


def api_token():
    token = os.environ.get("CURSEFORGE_API_TOKEN")
    if token:
        return token
    if sys.platform == "win32":
        try:
            import winreg
            with winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Environment") as key:
                token, _ = winreg.QueryValueEx(key, "CURSEFORGE_API_TOKEN")
        except (OSError, ImportError):
            return None
    return token


def multipart(metadata, zip_path):
    boundary = "wfi-" + uuid.uuid4().hex
    payload = json.dumps(metadata, ensure_ascii=False).encode("utf-8")
    archive = zip_path.read_bytes()
    parts = [
        f"--{boundary}\r\nContent-Disposition: form-data; name=\"metadata\"\r\n"
        "Content-Type: application/json; charset=utf-8\r\n\r\n".encode("utf-8")
        + payload + b"\r\n",
        (f"--{boundary}\r\nContent-Disposition: form-data; name=\"file\"; "
         f"filename=\"{zip_path.name}\"\r\nContent-Type: application/zip\r\n\r\n").encode("utf-8")
        + archive + b"\r\n",
        f"--{boundary}--\r\n".encode("ascii"),
    ]
    return boundary, b"".join(parts)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-id", type=int, help="numeric CurseForge project ID")
    parser.add_argument("--dry-run", action="store_true", help="verify the ZIP and metadata without uploading")
    args = parser.parse_args()
    if args.project_id is not None and args.project_id < 1:
        parser.error("project ID must be positive")
    if not args.dry_run and args.project_id is None:
        parser.error("--project-id is required for upload")
    if not ZIP.is_file() or not CHANGELOG.is_file():
        parser.error("build the beta ZIP and changelog first")
    metadata = {
        "changelog": CHANGELOG.read_text(encoding="utf-8"),
        "changelogType": "markdown",
        "displayName": f"WOW Forver - Italiano {VERSION}",
        "gameVersionNames": ["1.60.1"],
        "releaseType": "beta",
    }
    digest = hashlib.sha256(ZIP.read_bytes()).hexdigest()
    if args.dry_run:
        print(json.dumps({"zip": str(ZIP), "bytes": ZIP.stat().st_size,
                          "sha256": digest, "metadata": metadata},
                         ensure_ascii=False, indent=2))
        return
    token = api_token()
    if not token:
        parser.error("set CURSEFORGE_API_TOKEN in the process or Windows user environment")
    boundary, body = multipart(metadata, ZIP)
    url = f"https://wow.curseforge.com/api/projects/{args.project_id}/upload-file"
    request = urllib.request.Request(url, body, headers={
        "X-Api-Token": token,
        "Content-Type": f"multipart/form-data; boundary={boundary}",
        "Accept": "application/json",
        "User-Agent": "WOWForverItaliano/0.5.0-beta",
    }, method="POST")
    try:
        with urllib.request.urlopen(request, timeout=120) as response:
            result = json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as error:
        raise SystemExit(f"CurseForge upload failed: HTTP {error.code} {error.reason}") from None
    except urllib.error.URLError as error:
        raise SystemExit(f"CurseForge upload failed: {error.reason}") from None
    if not isinstance(result, dict) or not isinstance(result.get("id"), int):
        raise SystemExit("CurseForge response did not contain a file ID")
    print(json.dumps({"project_id": args.project_id, "file_id": result["id"],
                      "sha256": digest}, ensure_ascii=False))


if __name__ == "__main__":
    main()
