module uim.sqlite.sql;

import std.stdio;
import std.string;
import std.conv;

import d2sqlite3;

bool has(Database db, string table, string where=null) {
	debug writeln("In has:\t", table, "/", where);
	return (count(db, table, where) > 0);
}

size_t count(Database db, string table, string[] where) {
	auto sql = count(table, where);
	debug writeln(sql);
	return db.execute(sql).oneValue!size_t;
}
string count(string table, string[] where) { return select(table, "count(*)", where.join(" AND ")); }

size_t count(Database db, string table, string where = null) {
	auto sql = count(table, where);
	debug writeln(sql);
	return db.execute(sql).oneValue!size_t;
}
string count(string table, string where = null) { return select(table, "count(*)", where); }

T avg(T)(Database db, string table, string col, string where = null) {
	auto sql = avg(table, col, where);
	debug writeln(sql); 
	return db.execute(sql).oneValue!T;
}
string avg(string table, string col, string where = null) { return select(table, "AVG("~col~")", where); }

T max(T)(Database db, string table, string col, string where = null) {
	auto sql = "SELECT max("~col~") FROM "~table;
	if (where) sql~=" WHERE "~where;
	debug writeln(sql); 
	return db.execute(sql).oneValue!T;
}
string max(string table, string col, string where = null) { return select(table, "MAX("~col~")", where); }

T min(T)(Database db, string table, string col, string where = null) {
	auto sql = min(table, col, where);
	debug writeln(sql); 
	return db.execute(sql).oneValue!T;
}
string min(string table, string col, string where = null) {
	auto sql = "SELECT min("~col~") FROM "~table;
	if (where) sql~=" WHERE "~where;
	return sql;
}

T one(T)(Database db, string table, string attr = "*", string where = null, string orderBy = null, size_t limit = 0) {
	auto sql = select(table, attr, where, null, limit);
	debug writeln(sql); 
	return db.execute(sql).oneValue!T; }
string one(string table, string attr = "*", string where = null, string orderBy = null, size_t limit = 0) {
	auto sql = select(table, attr, where, null, limit);
	debug writeln(sql); 
	return sql; }

auto select(Database db, string table, string attr = "*", string where = null, string orderBy = null, size_t limit = 0) {
	auto sql = select(table, attr, where, null, limit);
	debug writeln(sql);
	return db.execute(sql); }
auto select(string table, string attr = "*", string where = null, string orderBy = null, size_t limit = 0) {
	auto sql = "SELECT "~attr~" FROM "~table;
	if (where) sql~=" WHERE "~where;
	if (orderBy) sql~=" ORDER BY "~orderBy;
	if (limit) sql~=" LIMIT "~to!string(limit);
	return sql; }

void insert(Database db, string table, STRINGAA values) {
	auto keys = values.keys;
	string[] vs; vs.length = keys.length;
	foreach(index, k; keys) vs[index] = values[k]; 

	auto sql = insert(table, keys, vs);
	debug writeln(sql);
	db.execute(sql); 
}

string insert(string table, STRINGAA values) {
	auto keys = values.keys;
	string[] vs; vs.length = keys.length;
	foreach(index, k; keys) vs[index] = values[k]; 

	return insert(table, keys.join(","), vs.join(",")); }

void insert(Database db, string table, string[] fields, string[] values) {
	auto sql = insert(table, fields, values);
	debug writeln(sql);
	db.execute(sql); 
}

string insert(string table, string[] fields, string[] values) { 
	return insert(table, fields.join(","), values.join(",")); 
}

Database insert(Database db, string table, string fields, string values) {
	auto sql = insert(table, fields, values);
	debug writeln(sql);
	db.execute(sql); 
	return db;
}
string insert(string table, string fields, string values) { return "INSERT INTO "~table~" ("~fields~") VALUES("~values~")"; }

string update(string table, string set, string where = null) {
	auto sql = "UPDATE "~table~" SET "~set;
	if (where) sql ~= " WHERE "~where;
	return sql; }

Database update(Database db, string table, string set, string where = null) {
	auto sql = update(table, set, where);
	debug writeln(sql);
	db.run(sql); 
	return db;
}

unittest {
	//assert(countAll("oneTable") == "SELECT count(*) FROM oneTable");
	//assert(count("oneTable", "(a > b)") == "SELECT count(*) FROM oneTable WHERE (a > b)");
}
