# Prison Management Database System

> Database Systems course project, The British University in Egypt, 2022. Microsoft SQL Server (T-SQL).

A relational database for running a prison. It covers inmates, crimes, cells and halls, staff and guards, visitors, transport, equipment, supplies and activities. The project starts from an ER model and goes through relational mapping, a full schema with integrity constraints, sample data and analytical queries.

## Highlights
| | |
|---|---|
| Tables | **22** |
| Primary keys / foreign keys | 22 / **21** |
| Sample rows (`INSERT`) | 155 |
| SQL | ~1,060 lines |
| Query techniques | multi-table joins, nested `IN`/`EXISTS`/`ALL` subqueries, correlated subqueries, `GROUP BY` / `HAVING` |

## Data model
- **Core entities:** `Prisoner`, `Crime`, `Cell`, `Hall`, `Staff`, `Guard`, `Visitor`, `Visit`, `Equipment`, `Supplies`, `Food`, `Activity`, `Control_Room`, `Prison_Gate`, `Trasportation`, `Remand`.
- **Relationship (bridge) tables for M:N relationships:** `Supervise`, `Manage`, `Utilize`, `Require`, `Transport_by`.
- **Multivalued attribute:** `staff_Phone`, split into its own table during ER-to-relational mapping.

Diagrams: [ERD](docs/erd.pdf) · [Relational schema](docs/relational_schema.pdf)

## Example queries
Staff earning more than the average salary:
```sql
SELECT Staff_Id AS 'Staff ID', F_Name + ' ' + L_Name AS 'Employee Name', Salary
FROM Staff
WHERE Salary > ALL (SELECT AVG(Salary) FROM Staff);
```

Staff who share a shift start time with a colleague (correlated subquery):
```sql
SELECT Staff_Id, F_Name + ' ' + L_Name AS 'Employee Name',
       m.M_starttime AS 'Shift start', m.M_endtime AS 'Shift end', Remand_No
FROM Staff, Remand, Manage m
WHERE m.S_ID = Staff_Id AND Remand_No = R_no
  AND m.M_starttime IN (SELECT s.M_starttime FROM Manage s
                        WHERE s.M_starttime = m.M_starttime AND s.S_ID != Staff_Id);
```

## Run it
1. Open `sql/prison_management.sql` in **SQL Server Management Studio** or Azure Data Studio.
2. Execute the whole script. It safely drops any existing `Prison` database, re-creates it, switches to it (`USE Prison`), builds the 22 tables, loads the sample data and runs the queries.

Sample personal data in the script (names, emails, phone numbers) is fictional or anonymised.

## Possible extensions
Views for common reports, stored procedures for admissions and transfers, triggers for cell-capacity checks, `CHECK` constraints and indexing for the query workload.

## License

Released under the [MIT License](LICENSE).
