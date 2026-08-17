import sys
from pathlib import Path

from lxml import etree

SCHEMA_PATH = Path(__file__).parents[2] / "totalRP3" / "totalRP3.xsd"


def main() -> int:
    schema = etree.XMLSchema(etree.parse(SCHEMA_PATH))
    failed = False

    for filename in sys.argv[1:]:
        try:
            document = etree.parse(filename)
            schema.assertValid(document)
        except (etree.XMLSyntaxError, etree.DocumentInvalid) as error:
            print(f"{filename}: {error}", file=sys.stderr)
            failed = True

    return int(failed)


if __name__ == "__main__":
    raise SystemExit(main())
