module uim.sqlite.table;

import uim.sqlite;

class DSLTTable {
	this(Database aDatabase) {
		_db = aDatabase;
	}
	this(Database aDatabase, string tableName) {
		this(_db);
		_tableName = tableName;
	}

	mixin(OProperty!("Database", "db"));
	mixin(OProperty!("string", "tableName"));
}

