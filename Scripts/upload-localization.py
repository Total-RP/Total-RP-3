#!/usr/bin/env python3

import argparse
import json
import os
from pathlib import Path

import requests
from luaparser import ast, astnodes


def find_table_assignment(variable_name: str, statements: list[astnodes.Statement]) -> tuple[astnodes.Name, astnodes.Table] | None:
    """
    Extracts the first statement from the given list that represents an
    assignment of a table constructor literal to a named variable, returning
    a tuple of the assigned variable name and the table constructor expression.

    If no table constructor assignment to the named variable is present in the
    given list of statements, None is returned.
    """

    for stmt in statements:
        if not isinstance(stmt, astnodes.Assign):
            continue

        for target, value in zip(stmt.targets, stmt.values):
            if isinstance(target, astnodes.Name) and target.id == variable_name and isinstance(value, astnodes.Table):
                return (target, value)

    return None


def convert_to_table_additions(target: astnodes.Name, value: astnodes.Table) -> astnodes.Block:
    """
    Converts a table constructor literal ('{ foo = "bar", ...}') to a block of
    table assignment statements.
    """

    body: list[astnodes.Statement] = []

    for field in value.fields:
        key = astnodes.String(field.key.id) if isinstance(field.key, astnodes.Name) else field.key

        index = astnodes.Index(key, target, notation=astnodes.IndexNotation.SQUARE)
        body.append(astnodes.Assign([index], [field.value]))

    return astnodes.Block(body)


def generate_curseforge_translations(path: Path) -> str:
    """
    Generates a translations table from the given source file path, returning a
    string that is suitable for use with the CF localization import API.
    """

    with path.open('r', encoding='utf8') as f:
        chunk = ast.parse(f.read())
        assignment = find_table_assignment('L', chunk.body.body)

        if not assignment:
            raise RuntimeError(f'Failed to find translations in file: {path}')

        additions = convert_to_table_additions(*assignment)
        return ast.to_lua_source(additions)


# fmt: off
parser = argparse.ArgumentParser(prog='upload-localization.py', description='Uploads source localization strings to CurseForge.')
parser.add_argument('filename', help='Path to the enUS localization file.', nargs='?', default=Path('totalRP3/Locales/enUS.lua'), type=Path)
parser.add_argument('-d', '--delete-missing-phrases', help='Mark missing phrases as deleted.', action='store_true')
parser.add_argument('-n', '--dry-run', help='Do not submit localization strings to CurseForge; only print them.', action='store_true')
parser.add_argument('-p', '--project-id', help='CurseForge project ID', default='75973')
args = parser.parse_args()
# fmt: on

translations = generate_curseforge_translations(args.filename)

if args.dry_run:
    print(translations)
    exit(0)

r = requests.post(
    f'https://wow.curseforge.com/api/projects/{args.project_id}/localization/import',
    headers={
        'X-Api-Token': os.getenv('CF_API_KEY'),
    },
    files={
        'metadata': (None, json.dumps({
            'language': 'enUS',
            'missing-phrase-handling': 'DeletePhrase' if args.delete_missing_phrases else 'DoNothing',
        })),
        'localizations': (None, translations),
    }
)

r.raise_for_status()
