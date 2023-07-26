import sqlite3
import pandas as pd
import os
from pathlib import Path
from sqlalchemy import create_engine, inspect
import json
import sys

class DB:

    def __init__(self, dev=True):
        base = os.getenv(
            "AERODB_DIR") if not dev else "/home/aerotract/.sandbox"
        self.base = Path(base)

    # general helper functions

    def con(self, db="aerodb"):
        db = db + ".db"
        path = (self.base / db).as_posix()
        return sqlite3.connect(path)

    def engine(self, db="aerodb"):
        db = db + ".db"
        path = (self.base / db).as_posix()
        path = "sqlite:///" + path
        return create_engine(path)
    
    @classmethod
    def get_con(cls, db="aerodb", dev=True):
        return cls(dev=dev).con(db=db)

    @classmethod
    def get_eng(cls, db="aerodb", dev=True):
        return cls(dev=dev).engine(db=db)
    
class TableResults:

    def __init__(self, name, results):
        self.table_name = name
        self.data = results

class Table:

    def __init__(self, name, id_col):
        self.name = name
        self.id_col = id_col

    def describe(self):
        con = DB.get_con()
        eng = DB.get_eng()
        insp = inspect(eng)
        col_desc = insp.get_columns(self.name)
        return col_desc

    @property
    def columns(self):
        col_desc = self.describe()
        return [c["name"] for c in col_desc]
    
    def execute_query(self, query, params=None):
        if query is None or len(query) == 0:
            return [{}]
        data = pd.read_sql(query, DB.get_con(), params=params)
        return TableResults(self.name, data)
    
    def get_table(self):
        return self.execute_query(f"SELECT * FROM {self.name}")
    
    def build_query_placeholders(self, operator, match_val):
        operator = operator.upper()
        plc, params = None, None
        if operator == "=":
            plc = "?"
            params = (match_val,)
        elif operator == "IN":
            if not isinstance(match_val, list):
                match_val = [match_val]
            plc = ", ".join(["?"] * len(match_val))
            plc = f"({plc})"
            params = match_val
        elif operator == "LIKE":
            plc = "?"
            params = (F"%{match_val}",)
        elif operator == "BETWEEN":
            plc = "? AND ?"
            params = match_val
        return plc, params
    
    def where_table(self, search_col, operator, match_val, cols="*"):
        if isinstance(cols, list):
            cols = ", ".join(cols)
        if cols is None or len(cols) == 0:
            cols = "*"
        plc, params = self.build_query_placeholders(operator, match_val)
        query = f"SELECT {cols} FROM {self.name} WHERE {search_col} {operator} {plc}"
        return self.execute_query(query, params=params)
    
tables = [
    Table("clients", "CLIENT_ID"),
    Table("projects", "PROJECT_ID"),
    Table("stands", "STAND_PERSISTENT_ID"),
    Table("flights", "FLIGHT_ID"),
    Table("flight_ai", "AI_FLIGHT_ID"),
    Table("flight_files", "FILES_FLIGHT_ID")
]

def stand_reverse_lookup_preproc(lookups):
    res = []
    for x in lookups:
        if isinstance(x, str) and "," in x:
            x = x.split(",")
        if not isinstance(x, list):
            x = [x]
        res.extend(x)
    return res

reverse_lookup_map = {
    "clients": {},
    "projects": {
        "clients": {
            "col": "CLIENT_ID",
        },
        "stands": {
            "col": "STAND_PERSISTENT_IDS",
            "preproc": stand_reverse_lookup_preproc,
            "id_col": "STAND_PERSISTENT_ID"
        }
    },
    "stands": {
        "clients": {
            "col": "CLIENT_ID",
        }
    },
    "flights": {
        "clients": {
            "col": "CLIENT_ID",
        },
        "projects": {
            "col": "PROJECT_ID"
            },
        "stands": {
            "col": "STAND_PERSISTENT_ID"
        },
    },
    "flight_ai": {
        "flights": {
            "col": "FLIGHT_ID"
        },
    },
    "flight_files": {
        "flights": {
            "col": "FLIGHT_ID"
        },
    },
}

class ManagedDB:

    def __init__(self, tables, reverse_lookup_map):
        self.tables = {t.name: t for t in tables}
        self.rlmap = reverse_lookup_map

    def __getattr__(self, key):
        if key not in self.tables:
            raise AttributeError(f"{key} table not in tables")
        return self.tables[key]
    
    def reverse_lookup(self, results, reverse_table_name):
        reverse_meta = self.rlmap[results.table_name][reverse_table_name]
        reverse_key = reverse_meta["col"]
        results_lookup_vals = results.data[reverse_key].unique().tolist()
        preproc = reverse_meta.get("preproc", lambda x: x)
        results_lookup_vals = preproc(results_lookup_vals)
        reverse_table = self.tables[reverse_table_name]
        reverse_lookup_key = reverse_meta.get("id_col", reverse_key)
        return reverse_table.where_table(reverse_lookup_key, "IN", results_lookup_vals)

    def pipeline(self, initial_table_name, initial_query, reverse_tables):
        if not isinstance(reverse_tables, list):
            reverse_tables = [reverse_tables]
        initial_table = self.tables[initial_table_name]
        initial_tresult = initial_table.where_table(*initial_query)
        reverse_data = [initial_tresult]
        for i in range(len(reverse_tables)):
            results = reverse_data[i]
            reverse_table_name = reverse_tables[i]
            reverse_result = self.reverse_lookup(results, reverse_table_name)
            reverse_data.append(reverse_result)
        def out(rd):
            return [x.data.to_dict("records") for x in rd]
        return out(reverse_data)

if __name__ == "__main__":
    db = ManagedDB(tables, reverse_lookup_map)
    data = db.pipeline(
        "projects",
        ("PROJECT_ID", "IN", [101006, 101007]),
        ["stands"]
    )
    print(json.dumps(data, indent=4))