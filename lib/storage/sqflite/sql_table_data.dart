class SqlTable {
  static final String stocks = """
    CREATE TABLE stocks (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, 
    code TEXT,
    name TEXT);
    """;
}
