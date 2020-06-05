# sp_columns

| Column name       | Data type      | Description                                                  |
| ----------------- | -------------- | ------------------------------------------------------------ |
| TABLE_QUALIFIER   | sysname        | Object qualifier name. This field can be NULL.               |
| TABLE_OWNER       | sysname        | Object owner name. This field always returns a value.        |
| TABLE_NAME        | sysname        | Object name. This field always returns a value.              |
| COLUMN_NAME       | sysname        | Column name, for each column of the TABLE_NAME returned. This field always returns a value. |
| DATA_TYPE         | smallint       | Integer code for ODBC data type. If this is a data type that cannot be mapped to an ODBC type, it is NULL. The native data type name is returned in the TYPE_NAMEcolumn. |
| TYPE_NAME         | sysname        | String representing a data type. The underlying DBMS presents this data type name. |
| PRECISION         | int            | Number of significant digits. The return value for the PRECISION column is in base 10. |
| LENGTH            | int            | Transfer size of the data.1                                  |
| SCALE             | smallint       | Number of digits to the right of the decimal point.          |
| RADIX             | smallint       | Base for numeric data types.                                 |
| NULLABLE          | smallint       | Specifies nullability.  1 = NULL is possible.  0 = NOT NULL. |
| REMARKS           | varchar(254)   | This field always returns NULL.                              |
| COLUMN_DEF        | nvarchar(4000) | Default value of the column.                                 |
| SQL_DATA_TYPE     | smallint       | Value of the SQL data type as it appears in the TYPE field of the descriptor. This column is the same as the DATA_TYPE column, except for the datetime and SQL-92 intervaldata types. This column always returns a value. |
| SQL_DATETIME_SUB  | smallint       | Subtype code for datetime and SQL-92 interval data types. For other data types, this column returns NULL. |
| CHAR_OCTET_LENGTH | int            | Maximum length in bytes of a character or integer data type column. For all other data types, this column returns NULL. |
| ORDINAL_POSITION  | int            | Ordinal position of the column in the object. The first column in the object is 1. This column always returns a value. |
| IS_NULLABLE       | varchar(254)   | Nullability of the column in the object. ISO rules are followed to determine nullability. An ISO SQL-compliant DBMS cannot return an empty string.  YES = Column can include NULLS.  NO = Column cannot include NULLS.  This column returns a zero-length string if nullability is unknown.  The value returned for this column is different from the value returned for the NULLABLE column. |
| SS_DATA_TYPE      | tinyint        | SQL Server data type used by extended stored procedures. For more information, see [Data Types (Transact-SQL)](https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql). |