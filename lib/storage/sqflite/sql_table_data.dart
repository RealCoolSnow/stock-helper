class SqlTable {
  static const List<String> TABLES = [NAME_STOCKS];
  static const String NAME_STOCKS = "stocks";
  static final String stocks = """
    CREATE TABLE stocks (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, 
    code TEXT,
    name TEXT);
    """;
}
